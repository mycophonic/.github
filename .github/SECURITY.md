# Security

## Reporting a vulnerability

**Do not open a public issue for a security vulnerability.**

Every Mycophonic repository has GitHub private vulnerability reporting enabled. Use it:

1. Go to the **Security** tab of the affected repository.
2. **Report a vulnerability** — or go straight to
   `https://github.com/mycophonic/<repository>/security/advisories/new`.

That opens a private advisory visible only to you and the maintainers. It is the only
supported channel: it keeps the report confidential until a fix exists, and it is where
the advisory — and a CVE, if one is warranted — is published from.

If the repository has no Security tab (it should — that would be an error on our side),
report it privately against
[`mycophonic/primordium`](https://github.com/mycophonic/primordium/security/advisories/new)
instead and say which repository you meant.

## What to expect

An acknowledgement, and a fix on a **best-effort** basis.

There is no service-level agreement and no warranty of a timely patch — these projects are
provided as-is, see [SUPPORT.md](./SUPPORT.md). We will credit you in the advisory unless
you ask us not to.

## A note on decoders

Most of what is here parses untrusted input: audio files, tags, and metadata from wherever
the user got them. Malformed-input findings — out-of-bounds reads, unbounded allocations,
panics on truncated or hostile files — are squarely in scope and are the kind of report we
most want. A crash on a fuzzed file is a real finding here, not a curiosity.

## A note on forks

[`flac`](https://github.com/mycophonic/flac) is a fork of
[mewkiz/flac](https://github.com/mewkiz/flac). If a flaw is in the code we inherited rather
than in our changes, it affects every user of the original, so please report it upstream too
— tell us either way and we will track it and pull the fix in. Not sure which side it falls
on? Report it to us and say so; working that out is our job.

## Scope

Reports are in scope when they concern code in this organization's repositories.

Out of scope: findings against third-party dependencies — report those upstream, though we
do want to hear about it if we are shipping a vulnerable pin — and reports that consist
only of an automated scanner's output with no demonstrated impact.
