inputs: final: prev: let
  wlroots-patches = [
    (prev.fetchpatch {
      url = "https://gitlab.freedesktop.org/lilydjwg/wlroots/-/commit/6c5ffcd1fee9e44780a6a8792f74ecfbe24a1ca7.diff";
      sha256 = "sha256-Eo1pTa/PIiJsRZwIUnHGTIFFIedzODVf0ZeuXb0a3TQ=";
    })
  ];

  hp = inputs.hyprland.packages.${prev.system};
in rec {
  # instant repl with automatic flake loading
  repl = prev.callPackage ./repl {};

  discord-electron-openasar = prev.callPackage ./discord rec {
    inherit (prev.discord) src version pname;
    openasar = prev.callPackage "${inputs.nixpkgs}/pkgs/applications/networking/instant-messengers/discord/openasar.nix" {};
    binaryName = "Discord";
    desktopName = "Discord";

    isWayland = true;
    # enableVulkan = true;
    # extraOptions = [
    #   "--disable-gpu-memory-buffer-video-frames"
    #   "--enable-accelerated-mjpeg-decode"
    #   "--enable-accelerated-video"
    #   "--enable-gpu-rasterization"
    #   "--enable-native-gpu-memory-buffers"
    #   "--enable-zero-copy"
    #   "--ignore-gpu-blocklist"
    # ];
  };

  gamescope = prev.callPackage ./gamescope {};

  gdb-frontend = prev.callPackage ./gdb-frontend {};

  mako = prev.mako.overrideAttrs (_: {
    src = prev.fetchFromGitHub {
      owner = "emersion";
      repo = "mako";
      rev = "405588468807d4f4d855b71afdc52ff5f88f0efc";
      sha256 = "sha256-KVVobXSGWDm+4TC8eLq4+SuM9avD1Ex3bk6Ma9lk6gw=";
    };
  });

  hyprland =
    (hp.default.override {
      wlroots =
        (hp.wlroots-hyprland.overrideAttrs (
          _: {patches = wlroots-patches;}
        ))
        .override {inherit (final) xwayland;};
      inherit (final) xwayland;
    })
    .overrideAttrs (_: {NIX_CXXFLAGS_COMPILE = "-O3";});

  technic-launcher = prev.callPackage ./technic.nix {};

  tlauncher = prev.callPackage ./tlauncher.nix {};

  waveform = prev.callPackage ./waveform {};

  wlroots = prev.wlroots.overrideAttrs (_: {patches = wlroots-patches;});

  xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.overrideAttrs (_: {
    patches = [./patches/xdpw-crash.patch];
  });

  xwayland = prev.xwayland.overrideAttrs (_: {
    patches = [
      ./patches/xwayland-vsync.patch
      ./patches/xwayland-hidpi.patch
    ];
  });
}
