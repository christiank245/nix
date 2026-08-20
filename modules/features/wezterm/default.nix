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


        luaInfo = {
          font_locator = "ConfigDirsOnly";
          font_dirs = [ "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype" ];
          font = pkgs.lib.generators.mkLuaInline ''wezterm.font("JetBrains Mono")'';
          font_size = 11;
          freetype_load_flags = "DEFAULT";
          color_scheme = "Catppuccin Mocha";
          window_decorations = "RESIZE";
          enable_tab_bar = false;
          window_padding = {
            left = 8;
            right = 8;
            top = 8;
            bottom = 8;
          };
          hide_mouse_cursor_when_typing = true;
          colors = {
            cursor_fg = "#000000";
          };
        };

        # Add Lua packages used by require(...) in inline Lua.
        # Example: luaEnv = lp: [ lp.luafilesystem ];
        luaEnv = lp: [ ];
      });
    };
}
