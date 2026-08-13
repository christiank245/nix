{
  flake.modules.darwin.nix =
    { ... }:
    {
      # Enable modern Nix CLI and flakes.
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
}
