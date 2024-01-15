{
  config,
  pkgs,
  self,
  inputs,
  default,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];

    # use latest kernel
    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
    ];
  };

  environment.systemPackages = [config.boot.kernelPackages.cpupower];

  networking.hostName = "tenshi";

  networking.interfaces = {
    eno1 = {
      wakeOnLan.enable = true;
    };
  };

  programs = {
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
    xserver = {
      enable = true;
      displayManager = {
        sddm.enable = true;
        defaultSession = "plasmawayland";
      };
      desktopManager.plasma5.enable = true;
      videoDrivers = ["nvidia"];
      libinput = {
        enable = true;
        mouse.accelProfile = "flat";
      };
    };
    dbus.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
  };

  # Set portals
  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-kde
      ];
      wlr.enable = true;
    };
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };
    };
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1"; #necessary? on 1
    NIXOS_OZONE_WL = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    GTK_USE_PORTAL = "1";
    NVD_BACKEND = "direct"; # VA-API backend
    PROTON_HIDE_NVIDIA_GPU = "0"; # Report as Nvidia
    PROTON_ENABLE_NVAPI = "1"; # Enable NVAPI library
    VKD3D_CONFIG = "dxr"; # Enable DirectX Raytracing
  };
}
