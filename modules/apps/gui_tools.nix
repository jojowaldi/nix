{
  pkgs,
  isLinux,
  lib,
  ...
}:

{
  environment.systemPackages =
    with pkgs;
    [
      dbeaver-bin
      postman
      insomnia
      #wireshark
      drawio
      filezilla
      piper
      gimp
      vlc
      obsidian
      xkill
      qjournalctl
      nomacs
    ]
    ++ lib.optionals isLinux [
      deskflow
      wl-clipboard
      networkmanagerapplet
    ];

  services = (
    if isLinux then
      {
        ratbagd.enable = true;
      }
    else
      { }
  );
}
