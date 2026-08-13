{
  flake.modules.darwin.packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
      ];
    };
}
