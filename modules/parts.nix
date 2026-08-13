{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  config = {
    systems = [
      "aarch64-darwin"
    ];
  };
}
