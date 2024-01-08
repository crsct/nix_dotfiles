{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    gnome.nautilus
    nautilus-open-any-terminal
    gnome.sushi
    gnome.gnome-clocks
  ];
}
