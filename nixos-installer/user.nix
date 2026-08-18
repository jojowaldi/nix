{ config, lib, ... }:

{
  users.users = lib.foldl (acc: spec:
    acc // {
      "${spec.username}" = {
        isNormalUser = true;
        hashedPassword =
          "$y$j9T$ZVnrBvkW67q5jDItkZP1B0$3MmwklwUezBGJ4jNVnETYfnsMaykoqjNLRyzg50RuHC";
        extraGroups = [ "wheel" ];
      };
    }) { } config.hostSpec.users;
}
