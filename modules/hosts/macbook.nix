{ inputs, self, ... }:

{
  flake.modules.darwin.macbook =
    { ... }:
    {
      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config.allowUnfree = true;
    };

  flake.darwinConfigurations.macbook =
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs self;
      };

      modules = [
        inputs.nix-homebrew.darwinModules.nix-homebrew
        inputs.mac-app-util.darwinModules.default
        self.modules.darwin.macbook
        self.modules.darwin.nix
        self.modules.darwin.system
        self.modules.darwin.homebrew
        self.modules.darwin.packages
        self.modules.darwin.zsh
      ];
    };
}
