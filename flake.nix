{
  description = "TuneDeck";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs:
        let
          tunedeck = pkgs.callPackage ./nix/package.nix { };
        in
        {
          inherit tunedeck;
          default = tunedeck;
        });
    };
}
