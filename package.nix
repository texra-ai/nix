# Packaging approach adapted from pogoba's derivation:
# https://github.com/pogoba/dotfiles/blob/master/pkgs/texra-cli.nix
{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  nodejs_22,
}:
stdenv.mkDerivation rec {
  pname = "texra-cli";
  version = "0.39.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@texra-ai/cli/-/cli-${version}.tgz";
    hash = "sha256-IGZjrfxC9Xyywnwl+HM/YIP6KWZOS8SMKOloON8nFJM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
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
