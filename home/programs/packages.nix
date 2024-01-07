{pkgs, ...}: {
  home.packages = with pkgs; [
    # messaging
    tdesktop

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
  ];
}
