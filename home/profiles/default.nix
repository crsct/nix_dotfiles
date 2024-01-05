{
  self,
  inputs,
  withSystem,
  module_args,
  ...
}: let
  sharedModules = [
    ../.
    ../shell
    module_args
    inputs.ags.homeManagerModules.default
    inputs.anyrun.homeManagerModules.default
    inputs.nix-index-db.hmModules.nix-index
    inputs.spicetify-nix.homeManagerModule
    inputs.hyprland.homeManagerModules.default
    self.nixosModules.theme
  ];

  homeImports = {
    "noah@ThinkTwice" = [./ThinkTwice] ++ sharedModules;
    "mihai@rog" = [./rog] ++ sharedModules;
    server = [./server] ++ sharedModules;
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;
in {
  imports = [
    # we need to pass this to NixOS' HM module
    {_module.args = {inherit homeImports;};}
  ];

  flake = {
    homeConfigurations = withSystem "x86_64-linux" ({pkgs, ...}: {
      "noah@ThinkTwice" = homeManagerConfiguration {
        modules = homeImports."noah@ThinkTwice";
        inherit pkgs;
      };

      "mihai@rog" = homeManagerConfiguration {
        modules = homeImports."mihai@rog";
        inherit pkgs;
      };

      server = homeManagerConfiguration {
        modules = homeImports.server;
        inherit pkgs;
      };
    });
  };
}
