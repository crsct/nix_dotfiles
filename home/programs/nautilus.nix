{
  pkgs,
  config,
  ...
}: {
  services.gvfs.enable = true;
  services.gnome.sushi.enable = true;

  home.packages = with pkgs; [
    gnome.nautilus
    nautilus-open-any-terminal
    gnome.sushi
  ];
}
