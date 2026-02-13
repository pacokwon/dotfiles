{ config, lib, pkgs, ... }: {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  networking.hostName = "thinkpad";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          muhenkan = "layer(nav)";
          henkan = "space";
          katakanahiragana = "space";
          ro = "rightshift";
          yen = "backspace";
          capslock = "leftcontrol";
        };
        nav = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
        };
      };
    };
  };

}
