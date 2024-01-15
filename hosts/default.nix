{
  inputs,
  sharedModules,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.nixpkgs.lib) nixosSystem;
    # howdy = inputs.nixpkgs-howdy;
  in {
    Kadosei = nixosSystem {
      modules =
        [
          ./kadosei
          ../modules/bluetooth.nix
          ../modules/network.nix
          ../modules/greetd.nix
          ../modules/desktop.nix
          ../modules/gamemode.nix
          ../modules/lanzaboote.nix
          ../modules/hyprland.nix
          {home-manager.users.noah.imports = homeImports."noah@kadosei";}
          ../modules/security.nix
          {disabledModules = ["security/pam.nix"];}
          # "${howdy}/nixos/modules/security/pam.nix"
          # "${howdy}/nixos/modules/services/security/howdy"
          # "${howdy}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"
        ]
        ++ sharedModules;
    };
    Tenshi = nixosSystem {
      modules =
        [
          ./Tenshi
          ../modules/network.nix
          ../modules/desktop.nix
          ../modules/lanzaboote.nix
          {home-manager.users.noah.imports = homeImports."noah@Tenshi";}
        ]
        ++ sharedModules;
    };
  };
}
