# Homebrew Tap

Custom Homebrew formulae for Linux x86_64. Formulae in this tap are intentionally
limited to the platforms declared in their formula definitions. The tap is hosted
at https://github.com/nickfraser/homebrew-tap.

## Install

```sh
brew install nickfraser/tap/git-credential-gopass
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

## Maintaining Formulae

Use a tagged, platform-specific upstream archive and its SHA-256 checksum for
every prebuilt release asset. GitHub Release assets can be replaced upstream;
the pinned checksum prevents an unexpected replacement from installing. Update
the version and checksum together only after reviewing and testing a new asset.

Run these checks on Linux x86_64 before publishing formula changes:

```sh
brew tap nickfraser/tap
brew readall --syntax nickfraser/tap
brew audit --strict --online --new --formula nickfraser/tap/git-credential-gopass
brew install --build-from-source nickfraser/tap/git-credential-gopass
brew test nickfraser/tap/git-credential-gopass
```

[gopass-helper]: https://github.com/gopasspw/git-credential-gopass
