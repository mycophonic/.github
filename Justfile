# This file is the project's own.
# Add recipes leveraging provided `do` ready-made recipes, or create your own.
# The import must be kept: it mounts every shared limen task under `just do ...`.
import '.limen/just/main.just'

# The FIRST recipe defined here becomes `just`'s default.
lint: do::lint::default issue-forms
fix: do::fix::default
test:

# Validate the GitHub issue forms against the form schema.
#
# The one check the shared recipes cannot make: `do lint yaml` proves the files
# parse and are formatted, but a well-formed YAML file can still be an invalid
# issue form — and GitHub fails that silently, refusing to render the form
# rather than reporting an error. These templates are the organization-wide
# fallback, so a broken one breaks issue creation in every repository that has
# no templates of its own.
#
# Shell plus the aqua-pinned yq: no unpinned interpreter, and shellcheck lints
# the script like any other we ship.
issue-forms:
    @.github/workflows/validate-issue-forms.sh
