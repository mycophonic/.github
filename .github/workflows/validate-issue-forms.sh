#!/usr/bin/env bash
# Validate this repository's GitHub issue forms against the form schema.
#
# Scope is deliberately narrow. Everything else this repository needs checked is
# already covered by the shared tooling, and duplicating it here would be a
# second, worse implementation:
#
#   * YAML parses and is formatted      -> `just do lint yaml`   (yamlfmt)
#   * links resolve                     -> `just do lint links`  (lychee)
#   * the mandatory files are present   -> `just do lint limen`
#
# What none of them can see is that a *well-formed* YAML file is a *valid issue
# form*. That failure is silent and expensive: GitHub does not reject the file,
# it just refuses to render the form, and issue creation breaks for every
# repository in the organization that inherits it.
#
# Everything here runs on the aqua-pinned yq plus the shell the other recipes
# already use — no interpreter that is not pinned, and shellcheck lints it like
# any other script we ship.
#
# https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema
set -euo pipefail

templates="$(cd "$(dirname "${BASH_SOURCE[0]}")/../ISSUE_TEMPLATE" && pwd)"

# https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema#keys
form_types="markdown input textarea dropdown checkboxes"
needs_label="input textarea dropdown checkboxes"
needs_options="dropdown checkboxes"

failures=0

fail() {
    printf '  ✗ %s: %s\n' "$1" "$2" >&2
    failures=$((failures + 1))
}

# contains <space-separated-set> <word>
contains() {
    case " $1 " in
        *" $2 "*) return 0 ;;
        *) return 1 ;;
    esac
}

check_form() {
    local file="$1"
    local name key body_length index type id has_label has_value option_count seen_ids at

    name="$(basename "$file")"

    for key in name description body; do
        if [ "$(yq "has(\"${key}\")" "$file")" != "true" ]; then
            fail "$name" "missing required top-level key '${key}'"
        fi
    done

    body_length="$(yq '.body // [] | length' "$file")"
    if [ "$body_length" -eq 0 ]; then
        fail "$name" "'body' must be a non-empty list"

        return
    fi

    seen_ids=""

    # The string fields carry a one-letter prefix, stripped below. Without it an
    # absent id would be an empty column, and tab is an IFS *whitespace*
    # character: bash collapses a run of them into one separator, silently
    # shifting every later field left.
    while IFS=$'\t' read -r index type id has_label has_value option_count; do
        type="${type#t=}"
        id="${id#i=}"
        at="body[${index}]"

        if ! contains "$form_types" "$type"; then
            fail "$name" "${at} has invalid type '${type}' (expected one of: ${form_types})"

            continue
        fi

        if [ -n "$id" ]; then
            if contains "$seen_ids" "$id"; then
                fail "$name" "${at} reuses id '${id}'; ids must be unique within a form"
            fi
            seen_ids="${seen_ids} ${id}"
        fi

        if contains "$needs_label" "$type" && [ "$has_label" != "true" ]; then
            fail "$name" "${at} (${type}) is missing 'attributes.label'"
        fi

        if [ "$type" = "markdown" ] && [ "$has_value" != "true" ]; then
            fail "$name" "${at} (markdown) is missing 'attributes.value'"
        fi

        if contains "$needs_options" "$type" && [ "$option_count" -eq 0 ]; then
            fail "$name" "${at} (${type}) needs a non-empty 'attributes.options' list"
        fi
    done < <(
        yq -r '
            .body // [] | to_entries | .[] | [
                .key,
                ("t=" + (.value.type // "")),
                ("i=" + (.value.id // "")),
                ((.value.attributes.label // "") != ""),
                ((.value.attributes.value // "") != ""),
                (.value.attributes.options // [] | length)
            ] | @tsv
        ' "$file"
    )
}

check_config() {
    local file="$1"
    local name blank index has_name has_url has_about

    name="$(basename "$file")"

    blank="$(yq '.blank_issues_enabled // false | tag' "$file")"
    if [ "$blank" != "!!bool" ]; then
        fail "$name" "'blank_issues_enabled' must be a boolean, got ${blank}"
    fi

    while IFS=$'\t' read -r index has_name has_url has_about; do
        [ "$has_name" = "true" ] || fail "$name" "contact_links[${index}] is missing 'name'"
        [ "$has_url" = "true" ] || fail "$name" "contact_links[${index}] is missing 'url'"
        [ "$has_about" = "true" ] || fail "$name" "contact_links[${index}] is missing 'about'"
    done < <(
        yq -r '
            .contact_links // [] | to_entries | .[] | [
                .key,
                ((.value.name // "") != ""),
                ((.value.url // "") != ""),
                ((.value.about // "") != "")
            ] | @tsv
        ' "$file"
    )
}

main() {
    local count=0
    local file name parse_error

    # Preflight. Without it, a yq that cannot run at all (missing, or an aqua
    # policy that has not been authorized in this directory) surfaces once per
    # file as "is not valid YAML" — a toolchain problem wearing the costume of
    # content corruption, which is a genuinely expensive thing to debug.
    if ! yq --version >/dev/null 2>&1; then
        printf 'yq is not runnable: %s\n' "$(yq --version 2>&1 | head -n 1)" >&2

        return 1
    fi

    for file in "$templates"/*.yml "$templates"/*.yaml; do
        # The glob is literal when nothing matches it.
        [ -f "$file" ] || continue

        count=$((count + 1))
        name="$(basename "$file")"

        # yamlfmt already proves these parse; guard anyway so this script is
        # meaningful when run on its own.
        if ! parse_error="$(yq 'true' "$file" 2>&1 >/dev/null)"; then
            fail "$name" "does not parse as YAML: $(printf '%s' "$parse_error" | head -n 1)"

            continue
        fi

        if [ "$name" = "config.yml" ]; then
            check_config "$file"
        else
            check_form "$file"
        fi
    done

    if [ "$count" -eq 0 ]; then
        printf 'no issue forms found under %s\n' "$templates" >&2

        return 1
    fi

    if [ "$failures" -gt 0 ]; then
        printf '\n%d problem(s) found\n' "$failures" >&2

        return 1
    fi

    printf '%d issue form file(s) valid\n' "$count"
}

main "$@"
