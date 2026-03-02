# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Homebrew tap for the `af` CLI tool (Afrael's CLI). It contains a single formula that builds and bottles a Rust-based application.

## Formula Structure

- **Formula location**: `Formula/af.rb`
- **Upstream project**: https://github.com/smykla-skalski/af
- **License**: MIT
- **Build dependencies**: `rust`, `openssl`, `zlib`
- **Bottle hosting**: GitHub Container Registry (`ghcr.io/v2/smykla-skalski/af`)

The formula:
1. Downloads source tarball from GitHub releases
2. Builds using `cargo install`
3. Generates shell completions using `af completions`
4. Generates man pages using `cargo genman`
5. Bottles for macOS (arm64_sequoia) and Linux (x86_64)

## Testing and CI

### Local Testing

```bash
# Test formula installation locally
brew install --build-from-source Formula/af.rb

# Run formula audit
brew audit --strict Formula/af.rb

# Test formula
brew test Formula/af.rb

# Uninstall for cleanup
brew uninstall af
```

### CI Workflow

The repository uses Homebrew's `brew test-bot` for automated testing:

- **Trigger**: PRs that modify `Formula/**/*`
- **Platforms**: Ubuntu 24.04 and macOS 15
- **Steps**:
  1. `brew test-bot --only-cleanup-before` - Clean environment
  2. `brew test-bot --only-setup` - Setup test environment
  3. `brew test-bot --only-tap-syntax` - Validate Ruby syntax
  4. `brew test-bot --only-formulae --root-url='https://ghcr.io/v2/smykla-skalski/af'` - Build bottles
- **Artifacts**: Bottles uploaded as `bottles_${{ matrix.os }}`

### Publishing Workflow

When a PR is labeled with `pr-pull`:
1. `brew pr-pull` merges the PR and publishes bottles to GHCR
2. Commits are pushed to `main`
3. Source branch is deleted (if not from fork)

## Updating the Formula

When updating to a new version of `af`:

1. Update `url` with new version tag
2. Download the new tarball and compute SHA256:
   ```bash
   curl -L https://github.com/smykla-skalski/af/archive/refs/tags/vX.Y.Z.tar.gz | shasum -a 256
   ```
3. Update `sha256` field
4. Remove the `bottle do...end` block (bottles will be rebuilt by CI)
5. Create PR - CI will build new bottles
6. Once tests pass, add `pr-pull` label to merge and publish

## Repository Management

- **Renovate**: Configured for auto-merging minor/patch updates
- **Sync config**: File sync disabled, label sync enabled with removal
- **Branch**: `main`

## Claude Code skills

The `git-stage-hunk` SAI plugin stages partial file changes without a TTY. Use `/stage-hunk` when only some changes in a file belong in the current commit, multiple sessions modified the same file, or `git add -p` is unavailable.

Install: `claude --plugin-dir ~/Projects/github.com/smykla-skalski/sai/git-stage-hunk/`
Modes: `--list`, `--hunk H1,H2`, `--pattern REGEX`, `--file PATH`, `--range FILE:S-E`, `--verify`, `--dry-run`
