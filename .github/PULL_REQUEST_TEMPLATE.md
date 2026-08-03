<!--
Thanks for the pull request.

The title and this body become the squash commit message — write them for someone
reading `git log` in two years, not for the review thread.
-->

## What

<!-- What changes, in one or two sentences. -->

## Why

<!--
The reason, not the diff. What was broken, what was missing, what decision changed.
Link the issue it closes: "Closes #123".
-->

## How it was verified

<!--
What you actually ran or observed. "just lint && just test" is a fine answer.
"Should work" is not.
-->

---

<!--
The links below are absolute on purpose. This template is COPIED into the pull
request body of whatever repository inherits it, so a relative link would
resolve against that repository — which does not carry these files, since
inheriting them is the whole point.
-->

- [ ] Commits are signed off (`git commit -s`) — see
      [CONTRIBUTING.md](https://github.com/mycophonic/.github/blob/main/.github/CONTRIBUTING.md)
- [ ] Commits are cryptographically signed (`commit.gpgsign`), and my key is in
      `.allowed_signers`
- [ ] Subject lines are under 90 characters, no trailing whitespace
- [ ] Branch is rebased on `main` (no merge commits)
- [ ] This is not a security fix — those go through
      [private vulnerability reporting](https://github.com/mycophonic/.github/blob/main/.github/SECURITY.md),
      never a public PR
