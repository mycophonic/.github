# .github

This is the provisioning profile for the Mycophonic organization on GitHub.

It contains:

- `profile/README.md` — the organization profile page shown on https://github.com/mycophonic
- `.github/ISSUE_TEMPLATE/` — shared issue templates (bug, feature request, question) and their config
- `.github/PULL_REQUEST_TEMPLATE.md` — the default pull request body
- community health files applied org-wide:
  - `CODE_OF_CONDUCT.md`
  - `CONTRIBUTING.md` — the DCO terms, mandatory commit signing, and commit rules
  - `GOVERNANCE.md`
  - `SECURITY.md` — private vulnerability reporting
  - `SUPPORT.md`
  - `FUNDING.yml`

These defaults apply to every repository in the organization that does not provide its own.
GitHub only resolves them from a **public** `.github` repository, and only from the root,
`.github/` or `docs/`.

## Caveats worth knowing

- The org profile README is read from `profile/README.md` only — that path is not
  configurable and has no fallback.
- Issue templates are inherited **all or nothing**: GitHub's own wording is that if a
  repository has any files in its own `.github/ISSUE_TEMPLATE` folder, *none* of the
  contents of the default folder are used.
- `dependabot.yml`, `CODEOWNERS` and workflows are **not** inherited org-wide. Renovate
  covers dependency updates; `limen` distributes the canonical workflows by pinning them
  into each repository.
- A default `LICENSE` cannot be inherited either — the one here covers this repository only.

## Working on it

This repository is [`limen`](https://github.com/farcloser/limen)-enrolled, so the interface
is the shared one:

```
just lint      # limen, just, aqua, links, yaml, shell, dockerfile, commits, issue-forms
just fix
```

`just do lint <recipe>` runs a single check. The toolchain is pinned through aqua and
installed on first use; nothing needs to be set up by hand. Note that most *other*
repositories in this organization are not enrolled yet — `primordium` is, the rest still
use the plain Go toolchain.

### issue-forms

The one project-specific recipe. `do lint yaml` proves the templates parse and are
formatted, and `do lint links` (lychee) proves the links resolve — but neither can tell
that a well-formed YAML file is a *valid issue form*. GitHub fails that silently: it does
not reject the file, it just refuses to render the form. Since these templates are the
org-wide fallback, a broken one breaks issue creation in every repository that has none of
its own. `.github/workflows/validate-issue-forms.sh` checks them against the form schema —
shell plus the aqua-pinned `yq`, so it introduces no interpreter the toolchain does not
already pin, and `do lint shell` lints it like any other script we ship.

### The profile page lists only public repositories

Most of this organization is still private. `profile/README.md` therefore links only the
repositories that are actually public, and there is no root `.lychee.toml`.

Keep it that way as things open up: lychee runs unauthenticated — that is the point, it sees
what an anonymous visitor sees — so a link to a private repository 404s and fails the run. If
you ever want one listed before it is public, mark it 🔒 *and* exclude it in a new root
`.lychee.toml`. Only ever exclude a repository that is private **on purpose**; an entry there
silences a real check.
