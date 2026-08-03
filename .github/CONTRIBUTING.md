# Contributing

Got ideas? Found a bug you can fix? Go for it.

Everything below exists because it is **mechanically enforced** — CI or a branch ruleset
will reject the pull request otherwise. Reading this first saves you a round trip.

## Sign your commits off (DCO)

Every commit must carry a `Signed-off-by` trailer. Git writes it for you:

```
git commit -s
```

Forgot? Fix the last commit with `git commit -s --amend`, or a whole branch with
`git rebase --signoff origin/main`.

The trailer must match the author identity of the commit, and it is a real statement —
by adding it you certify the [Developer Certificate of Origin 1.1](https://developercertificate.org/):

```
Developer's Certificate of Origin 1.1

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or

(b) The contribution is based upon previous work that, to the best
    of my knowledge, is covered under an appropriate open source
    license and I have the right under that license to submit that
    work with modifications, whether created in whole or in part
    by me, under the same open source license (unless I am
    permitted to submit under a different license), as indicated
    in the file; or

(c) The contribution was provided directly to me by some other
    person who certified (a), (b) or (c) and I have not modified
    it.

(d) I understand and agree that this project and the contribution
    are public and that a record of the contribution (including all
    personal information I submit with it, including my sign-off) is
    maintained indefinitely and may be redistributed consistent with
    this project or the open source license(s) involved.
```

Edits made through the GitHub web UI are signed off automatically — the organization
requires it.

## Commit messages

Three rules are checked, per commit, on the range your pull request adds:

| Rule | What it means |
|------|---------------|
| `DCO` | The `Signed-off-by` trailer above. |
| `short-subject` | The subject line is **strictly under 90 characters** — GitHub ellipsizes there. Aim for 72 or less. |
| `dangling-whitespace` | No trailing whitespace anywhere in the message. |

Write the subject in the imperative ("Fix the checksum drift", not "Fixed" or "Fixes"), and
use the body to explain *why* — the diff already says what.

## Pull requests

- **Always a pull request.** Nobody pushes to `main`, including maintainers. The PR is the
  audit trail and the CI gate, not only a review venue — a solo project merging its own
  green PR is working as intended.
- **Linear history.** Merge commits are disallowed; `squash` and `rebase` are the available
  merge methods. Rebase onto `main` rather than merging `main` into your branch.
- **CI must be green.** Required status checks block the merge button. Do not ask for an
  exception; fix the check or explain why the check is wrong.
- **Force-pushing your own branch is fine** and often the right move after review. Force-push
  and deletion are blocked on `main` only.

## Before you open it

Run the project's own checks. The repositories here are migrating onto a shared interface
rather than already sharing one, so look before you assume:

- **If the repository has a `Justfile`** it is governed by
  [`limen`](https://github.com/farcloser/limen), and `just lint` / `just test` run the exact
  pinned tooling CI runs — green locally means green in CI. `just --list` shows the rest, and
  `aqua` fetches the tools on first use, so there is nothing to install by hand.
- **Otherwise** it is the ordinary Go toolchain: `go build ./...`, `go test ./...`, and
  whatever linter config the repository ships.

Audio code has one extra expectation: **if you touch a decoder, run the test corpus.** These
libraries are judged on bit-exactness, and "it compiles and plays" is not evidence.
[`agar`](https://github.com/mycophonic/agar) exists to generate deliberately broken input —
clipping, truncation, upsampling — precisely so the failure paths get exercised too.

If a check fails on code you did not touch, say so in the pull request; that is our bug, not
yours.

## Sign your commits (mandatory)

**Every commit must be cryptographically signed.** This is not the same thing as the
`Signed-off-by` trailer above — the DCO trailer is a statement of provenance you type, a
signature is proof the commit came from your key. We require both.

We sign with SSH keys, preferably backed by a hardware token (YubiKey and other `sk-`
keys). Configure git once:

```
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519_sk.pub
git config --global commit.gpgsign true
git config --global tag.gpgsign true
```

With `commit.gpgsign` set, every commit is signed without you thinking about it. To sign a
single commit explicitly, use `git commit -S -s`; to sign a branch you already wrote,
`git rebase --exec 'git commit --amend --no-edit -S' origin/main`.

Repositories ship an `.allowed_signers` file mapping identities to public keys, so
`git log --show-signature` and `git tag -v` resolve locally. Add your key to it in the same
pull request as your first contribution:

```
you@example.com namespaces="git" sk-ssh-ed25519@openssh.com AAAA... you@example.com
```

Release tags are always signed — the release tooling refuses to reuse an unsigned tag.

## Security issues

Do not open a pull request or a public issue for a vulnerability. See
[SECURITY.md](./SECURITY.md) — use private vulnerability reporting.
