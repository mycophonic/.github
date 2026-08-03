# Mycophonic

> High-fidelity audio, from the ground up

An audiophile music ecosystem written in Go — decoding, bit-perfect playback, defect
analysis, metadata and multi-room streaming, built as a set of libraries rather than one
monolith.

Everything is named after the fungal kingdom, which is the joke and also the architecture:
a shared substrate, then things that grow out of it.

## Open components

Much of the ecosystem is still private while it settles. What is public today:

### Audio

- [**saprobe-flac**](https://github.com/mycophonic/saprobe-flac) — pure-Go FLAC streaming
  decoder and encoder, presenting our standard PCM API over a heavily optimized
  [fork](https://github.com/mycophonic/flac) of
  [mewkiz/flac](https://github.com/mewkiz/flac).
- [**saprobe-alac**](https://github.com/mycophonic/saprobe-alac) — pure-Go ALAC decoder,
  ported from Apple's open-source C implementation. Streaming and seekable.
- [**flac**](https://github.com/mycophonic/flac) — our fork of
  [mewkiz/flac](https://github.com/mewkiz/flac), carrying the performance patches the
  decoder above depends on.
- [**haustorium**](https://github.com/mycophonic/haustorium) — audio analysis specialized in
  music *defect* detection: clipping, faked bit depth, transcode artefacts, loudness and
  dynamics.
- [**sporeprint**](https://github.com/mycophonic/sporeprint) — audio fingerprinting CLI and
  CGO binding to Chromaprint.

### Foundations

- [**primordium**](https://github.com/mycophonic/primordium) — the primitives every one of
  our projects shares: filesystem, networking, SQLite, errors, storage, compression.
- [**agar**](https://github.com/mycophonic/agar) — a testing framework that *generates
  deliberately defective audio* — clipping, truncation, upsampling — so the analysis and
  decoding paths can be tested against known-bad input.

### Distribution

- [**homebrew-mycota**](https://github.com/mycophonic/homebrew-mycota) — the Homebrew tap.
- [**mycophonic**](https://github.com/mycophonic/mycophonic) — the project hub.
- [**mycophonic.com**](https://github.com/mycophonic/mycophonic.com) — the website.

## Contributing & support

Projects here are provided as-is, best-effort, without warranty.

- [Contributing guide](https://github.com/mycophonic/.github/blob/main/.github/CONTRIBUTING.md)
  — sign-off (DCO), commit signing, and the pull request flow.
- [Security policy](https://github.com/mycophonic/.github/blob/main/.github/SECURITY.md) —
  **never** report a vulnerability in a public issue.
- Bugs and ideas go to the issue tracker of the repository they concern.
