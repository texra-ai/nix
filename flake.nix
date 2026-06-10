{
  description = "TeXRA CLI - AI theorist for the terminal";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
    in
    {
      packages = forAllSystems (system: rec {
        texra = (pkgsFor system).callPackage ./package.nix { };
        default = texra;
      });

      overlays.default = final: prev: {
        texra = final.callPackage ./package.nix { };
      };
    };
}
