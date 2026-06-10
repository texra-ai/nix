# TeXRA Nix Flake

Official Nix packaging for the [TeXRA](https://texra.ai) CLI — AI theorist
for the terminal.

## Try it

```bash
nix run github:texra-ai/nix#texra
```

## Install

```bash
nix profile install github:texra-ai/nix#texra
```

Or add it to a flake-based NixOS / home-manager configuration:

```nix
{
  inputs.texra.url = "github:texra-ai/nix";

  # then in your packages:
  # inputs.texra.packages.${system}.texra
  # or apply inputs.texra.overlays.default and use pkgs.texra
}
```

TeXRA is proprietary software (`meta.license = unfree`); consuming the
package through this flake already allows it, but if you use the overlay
you may need `nixpkgs.config.allowUnfree = true`.

## How it works

The derivation fetches the published
[`@texra-ai/cli`](https://www.npmjs.com/package/@texra-ai/cli) tarball from
the npm registry (it bundles all its dependencies) and wraps its entry point
with Node.js 22. A scheduled workflow
([`update-package.yml`](.github/workflows/update-package.yml)) keeps the
version and hash in sync with the latest npm release; it can also be run
manually from the Actions tab right after a release.

The packaging approach was adapted from
[pogoba's derivation](https://github.com/pogoba/dotfiles/blob/master/pkgs/texra-cli.nix) — thanks!

## License

The Nix expressions in this repo are MIT. TeXRA itself is proprietary —
see the [TeXRA terms of service](https://texra.ai/terms).
