{
  imports = [
    # ../../editors/helix
    ../../editors/neovim
    ../../programs
    ../../programs/games.nix
    ../../programs/dunst.nix
    ../../services/cinny.nix
    ../../services/kdeconnect.nix
    ../../services/power-monitor.nix
    ../../wayland
    ../../terminals/alacritty.nix
    ../../terminals/wezterm.nix
  ];

  home.sessionVariables = {
    GDK_SCALE = "1";
  };

  wayland.windowManager.hyprland.settings = let
  in {
    monitor = [
      "eDP-1, preferred, auto, 1.0"
    ];

    "device:synaptics-tm3276-022" = {
      accel_profile = "adaptive";
      natural_scroll = true;
    };
  };
}
