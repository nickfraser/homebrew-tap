# Homebrew Tap

Custom Homebrew formulae for Linux x86_64. Formulae in this tap are intentionally
limited to the platforms declared in their formula definitions.

## Install

```sh
brew install nickfraser/tap/git-credential-gopass
brew install nickfraser/tap/podman-compose-host
brew install nickfraser/tap/tuxedo-hooks
```

Homebrew will tap the repository during the direct install. As with any
third-party tap, review and trust the formula before installing it.

## Formulae

### `git-credential-gopass`

Installs the [gopass Git credential helper][gopass-helper] from its upstream
Linux amd64 GitHub Release archive. The archive URL and SHA-256 checksum are
pinned in the formula.

The helper requires Git, GnuPG, and an initialized gopass password store. It
does not change Git configuration during installation. Enable it explicitly:

```sh
git-credential-gopass configure --global
```

### `podman-compose-host`

Installs [podman-compose][podman-compose] without installing Podman. Provide a
compatible `podman` executable through the host operating system or another
package manager, and ensure it is available on `PATH`.

This formula installs the standard `podman-compose` command and conflicts with
Homebrew core's `podman-compose`. Replace the core formula before installing
this variant:

```sh
brew uninstall podman-compose
brew install nickfraser/tap/podman-compose-host
```

### `tuxedo-hooks`

Installs the [tuxedo-hooks][tuxedo-hooks] keyboard-driven terminal UI and CLI
for todo.txt with post-mutation hooks from its upstream Linux x86_64 release.
The archive URL and SHA-256 checksum are pinned in the formula.

## Maintaining Formulae

Use a tagged, platform-specific upstream archive and its SHA-256 checksum for
every prebuilt release asset. GitHub Release assets can be replaced upstream;
the pinned checksum prevents an unexpected replacement from installing. Update
the version and checksum together only after reviewing and testing a new asset.

Run these checks on Linux x86_64 before publishing formula changes:

```sh
brew tap nickfraser/tap
brew readall --syntax nickfraser/tap
for formula in git-credential-gopass podman-compose-host tuxedo-hooks; do
  brew audit --strict --online --new --formula "nickfraser/tap/$formula"
  brew install --build-from-source "nickfraser/tap/$formula"
  brew test "nickfraser/tap/$formula"
done
```

[gopass-helper]: https://github.com/gopasspw/git-credential-gopass
[podman-compose]: https://github.com/containers/podman-compose
[tuxedo-hooks]: https://github.com/nickfraser/tuxedo-hooks
