{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # messaging
    tdesktop
    discord
    linphone
    webcord

    # Cloud
    nextcloud-client
    bitwarden

    # misc
    libnotify
    xdg-utils

    # productivity
    obsidian
    xournalpp
    super-slicer-latest
    blender
    freecad
    vscodium
    godot_4
    krita
    libreoffice-still

    # Dependencies for hyprland / ags
    config.wayland.windowManager.hyprland.package
    bash
    coreutils
    dart-sass
    gawk
    gnome.gnome-control-center
    imagemagick
    overskride
    procps
    ripgrep
    wlogout
  ];
}
