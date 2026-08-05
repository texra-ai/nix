# Packaging approach adapted from pogoba's derivation:
# https://github.com/pogoba/dotfiles/blob/master/pkgs/texra-cli.nix
{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  importNpmLock,
  nodejs_22,
}:
stdenv.mkDerivation rec {
  pname = "texra-cli";
  version = "0.40.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@texra-ai/cli/-/cli-${version}.tgz";
    hash = "sha256-ruGOGRHaxqG3yN8WXTC9l3rG0abXO1u5vTSX3JRY8tI=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs_22
  ];

  npmDeps = importNpmLock {
    npmRoot = ./.;
    package = builtins.fromJSON ''
      {
        "name": "@texra-ai/cli",
        "version": "${version}",
        "bin": {
          "texra": "dist/bin/texra.js"
        },
        "dependencies": {
          "@inkjs/ui": "^2.0.0",
          "clipboardy": "^5.3.2"
        }
      }
    '';
  };

  unpackPhase = ''
    runHook preUnpack
    tar -xzf "$src"
    sourceRoot=package
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    export HOME="$TMPDIR"
    export npm_config_cache="$TMPDIR/npm-cache"
    cp ${npmDeps}/package.json package.json
    cp ${npmDeps}/package-lock.json package-lock.json
    npm ci --ignore-scripts --omit=dev
    mkdir -p $out/lib/texra-cli $out/bin
    cp -r . $out/lib/texra-cli/
    makeWrapper ${nodejs_22}/bin/node $out/bin/texra \
      --add-flags $out/lib/texra-cli/dist/bin/texra.js
    runHook postInstall
  '';

  meta = {
    description = "TeXRA CLI - AI theorist for the terminal";
    homepage = "https://texra.ai";
    downloadPage = "https://www.npmjs.com/package/@texra-ai/cli";
    license = lib.licenses.unfree;
    mainProgram = "texra";
    platforms = lib.platforms.unix;
  };
}
