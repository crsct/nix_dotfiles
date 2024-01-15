{
  imports = [
    # ../../editors/helix
    ../../editors/neovim
    ../../programs
    ../../programs/games.nix
    ../../services/kdeconnect.nix
    ../../services/power-monitor.nix
    ../../terminals/alacritty.nix
    ../../terminals/wezterm.nix
  ];

  home.sessionVariables = {
    GDK_SCALE = "1";
  };
}
