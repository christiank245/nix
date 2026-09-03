{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake.modules.darwin.wezterm = moduleWithSystem (
    {
      self',
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.wezterm
      ];

      nixpkgs.overlays = [
        (final: prev: {
          wezterm = self'.packages.wezterm;
        })
      ];
      launchd.user.envVariables = {
        WEZTERM_CONFIG_FILE = "${self'.packages.wezterm}/wezterm-rc.lua";
      };
    }
  );

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.wezterm = inputs.wrappers.wrappers.wezterm.wrap ({ ... }: {
        inherit pkgs;
        # also wrap gui binary not just the cli binary
        wrapperVariants.weztermGui = {
          exePath = "Applications/WezTerm.app/wezterm-gui";
          binDir = "Applications/WezTerm.app";
          binName = "wezterm-gui";
        };


        "wezterm.lua" = {
          path = ./wezterm.lua;
        };

        luaInfo = {
          font_dirs = [ "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype" ];
        };

        # Add Lua packages used by require(...) in inline Lua.
        # Example: luaEnv = lp: [ lp.luafilesystem ];
        luaEnv = lp: [ ];
      });
    };
}
