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
    ThinkTwice = nixosSystem {
      modules =
        [
          ./ThinkTwice
          ../modules/bluetooth.nix
          ../modules/greetd.nix
          ../modules/desktop.nix
          ../modules/gamemode.nix
          ../modules/lanzaboote.nix
          {home-manager.users.noah.imports = homeImports."noah@ThinkTwice";}
          ../modules/security.nix
          # {disabledModules = ["security/pam.nix"];}
          # "${howdy}/nixos/modules/security/pam.nix"
          # "${howdy}/nixos/modules/services/security/howdy"
          # "${howdy}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"
        ]
        ++ sharedModules;
    };

    rog = nixosSystem {
      modules =
        [
          ./rog
          ../modules/bluetooth.nix
          ../modules/greetd.nix
          ../modules/desktop.nix
          ../modules/gamemode.nix
          ../modules/lanzaboote.nix
          {home-manager.users.mihai.imports = homeImports."mihai@rog";}
        ]
        ++ sharedModules;
    };

    kiiro = nixosSystem {
      modules =
        [
          ./kiiro
          {home-manager.users.mihai.imports = homeImports.server;}
        ]
        ++ sharedModules;
    };
  };
}
