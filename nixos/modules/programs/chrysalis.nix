{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.chrysalis;
  chrysalisSource = pkgs.fetchFromGitHub {
    owner = "keyboardio";
    repo = "Chrysalis";
    rev = "v${pkgs.chrysalis.version}";
    hash = "sha256-3lEoeAbBfNGKLl9PzcWDfdJ7JdHxiz0Vv2fVhv5OXjw=";
  };
in
{
  options = {
    programs.chrysalis = {
      enable = lib.mkOption {
        default = false;
        description = ''
          Whether to enable Chrysalis and configure udev.
        '';
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ chrysalis ];

    services.udev.extraRules = builtins.readFile "${chrysalisSource}/static/udev/60-kaleidoscope.rules";
  };

  meta.maintainers = with lib.maintainers; [ atalii ];
}
