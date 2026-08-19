{ lib, pkgs, ... }:

{
  security.pam.services = {
    login.u2fAuth = true;
    login.fprintAuth = true;
    login.rules.auth.fprintd.settings.timeout = 99;
    gdm-password.u2fAuth = true;
    gdm-password.enableGnomeKeyring = true;
    sddm.u2fAuth = true;
    sddm.fprintAuth = true;
    sddm-greeter.u2fAuth = true;
    sddm-greeter.fprintAuth = true;
    sudo.u2fAuth = true;
    sudo.fprintAuth = true;
    polkit-1.fprintAuth = true;
    polkit-1.u2fAuth = true;
  };

  security.pam.u2f = {
    enable = true;
    settings.cue = true;
  };

  services.pcscd.enable = true;

  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

  

  environment.systemPackages = with pkgs; [
    wlopm
  ];
  /*
    services.udev.extraRules = ''
      ACTION=="remove",\
       ENV{ID_BUS}=="usb",\
       ENV{ID_MODEL_ID}=="0407",\
       ENV{ID_VENDOR_ID}=="1050",\
       ENV{ID_VENDOR}=="Yubico",\
       RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    '';
  */
}
