{
  pkgs,
  lib,
  ...
}:
# lanzaboote config
{
  boot = {
    bootspec.enable = true;
    initrd = {
      systemd.enable = true;
      supportedFilesystems = ["ext4"];
    };

    loader = {
      # systemd-boot on UEFI
      efi.canTouchEfiVariables = true;
      # we let lanzaboote install systemd-boot
      systemd-boot.enable = true;
    };
  };

  environment.systemPackages = [pkgs.sbctl];
}
