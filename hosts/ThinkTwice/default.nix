{
  config,
  pkgs,
  self,
  inputs,
  default,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot = {
    binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];

    # use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      "amd_pstate=active"
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      "ideapad_laptop.allow_v4_dytc=Y"
      ''acpi_osi="Windows 2020"''
    ];
  };

  environment.systemPackages = [config.boot.kernelPackages.cpupower];

  networking.hostName = "ThinkTwice";

  programs = {
    # enable hyprland and required options
    hyprland.enable = true;

    matugen = {
      enable = false;

      wallpaper = default.wallpaper;
    };

    steam = {
      enable = true;
      # fix gamescope inside steam
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            keyutils
            libkrb5
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
          ];
      };
    };
  };

  security.tpm2.enable = false;

  services = {
    # for SSD/NVME
    fstrim.enable = true;

    howdy = {
      enable = true;
      package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.howdy;
      settings = {
        core = {
          no_confirmation = true;
          abort_if_ssh = true;
        };
        video.dark_threshold = 90;
      };
    };
    linux-enable-ir-emitter = {
      enable = true;
      package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.linux-enable-ir-emitter;
    };
  };
}
