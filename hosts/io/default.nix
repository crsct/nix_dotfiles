{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot = {
    binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];

    extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    kernelModules = ["acpi_call" "amdgpu"];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    # Panel Self Refresh support
    kernelParams = ["amdgpu.dcfeaturemask=0x8"];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "dm_mod"
        "tpm"
      ];
      kernelModules = [
        "btrfs"
        "kvm-amd"
        "sd_mod"
        "dm_mod"
      ];
      supportedFilesystems = ["btrfs"];
      # systemd = {
      #   enable = true;
      #   emergencyAccess = true;
      # };
    };
  };
  # boot.plymouth.enable = true;

  environment.systemPackages = [config.boot.kernelPackages.cpupower];

  hardware = {
    bluetooth = {
      enable = true;
      disabledPlugins = ["sap"];
      hsphfpd.enable = true;
      package = pkgs.bluezFull;
      powerOnBoot = false;
      settings = {
        # make Xbox Series X controller work
        General = {
          Class = "0x000100";
          FastConnectable = true;
          JustWorksRepairing = "always";
          Privacy = "device";
          Experimental = true;
        };
      };
    };

    cpu.amd.updateMicrocode = true;

    enableRedistributableFirmware = true;

    opentabletdriver.enable = true;

    video.hidpi.enable = true;

    xpadneo.enable = true;
  };

  networking.hostName = "io";

  programs = {
    adb.enable = true;
    hyprland = {
      enable = true;
      package = null;
    };
    light.enable = true;
    steam.enable = true;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
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
      extraProfile = "export GDK_SCALE=2";
    };

    gamescope = pkgs.gamescope.overrideAttrs (_: rec {
      version = "3.11.43";
      src = pkgs.fetchFromGitHub {
        owner = "Plagman";
        repo = "gamescope";
        rev = "refs/tags/${version}";
        hash = "sha256-XxOVM7xWeE2pF4U34jLvil5+vj+jePHPWHIfw0e/mnM=";
      };
    });
  };
  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
  };

  services = {
    btrfs.autoScrub.enable = true;

    fwupd.enable = true;

    kmonad.keyboards = {
      io = {
        name = "io";
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        defcfg = {
          enable = true;
          fallthrough = true;
          allowCommands = false;
        };
        config = builtins.readFile "${inputs.self}/modules/main.kbd";
      };
    };

    pipewire.lowLatency.enable = true;

    printing.enable = true;

    ratbagd.enable = true;

    tlp = {
      enable = true;
      settings = {
        PCIE_ASPM_ON_BAT = "powersupersave";
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
      };
    };

    udev.extraRules = ''
      # add my android device to adbusers
      SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="adbusers"
    '';

    xserver.enable = lib.mkForce false;
  };

  # https://github.com/NixOS/nixpkgs/issues/114222
  systemd.user.services.telephony_client.enable = false;
}
