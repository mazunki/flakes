{
  description = "mazunki's flake collection";

  inputs = {
    vmrunner.url     = "github:mazunki/vmrunner";
    linux-runner.url = "github:mazunki/linux-runner";
    includeos.url    = "github:mazunki/IncludeOS";
  };

  outputs = inputs@{ self, ... }:
    let
      system = "x86_64-linux";
      repos  = [ "vmrunner" "linux-runner" "includeos" ];
      flakes = builtins.listToAttrs (map (r: { name = r; value = inputs.${r}; }) repos);
      mkPackages = builtins.mapAttrs (_: f: f.packages.${system}.default);
      mkApps     = builtins.mapAttrs (_: f: f.apps.${system}.default);
    in {
      lib.repos          = repos;
      packages.${system} = mkPackages flakes;
      apps.${system}     = mkApps flakes;
    };
}
