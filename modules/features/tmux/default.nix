{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake.modules.darwin.tmux = moduleWithSystem (
    {
      self',
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.tmux
      ];

      nixpkgs.overlays = [
        (final: prev: {
          tmux = self'.packages.tmux;
        })
      ];

      programs.tmux = {
        enable = true;
      };
    }
  );

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.tmux = inputs.wrappers.wrappers.tmux.wrap ({ config, ... }: {
        inherit pkgs;
        runtimePkgs = with pkgs; [ zoxide fzf eza yazi ];
        mouse = true;
        modeKeys = "vi";
        baseIndex = 1;
        paneBaseIndex = 1;
        plugins = with pkgs.tmuxPlugins; [
          sensible
          vim-tmux-navigator
          catppuccin
          resurrect
          continuum
        ];

        constructFiles.tmuxpopup = {
          relPath = "bin/tmuxpopup";
          content = builtins.readFile ./tmuxpopup;
          builder = ''
            cp "$1" "$2"
            chmod +x "$2"
          '';
        };

        constructFiles.tmuxpopupYazi = {
          relPath = "bin/tmuxpopup_yazi";
          content = builtins.readFile ./tmuxpopup_yazi;
          builder = ''
            cp "$1" "$2"
            chmod +x "$2"
          '';
        };

        configBefore = ''
          bind r source-file ${config.constructFiles.generatedConfig.path} \; display-message "tmux config reloaded"
          bind m run-shell "${config.constructFiles.tmuxpopup.path}"
          bind y run-shell "${config.constructFiles.tmuxpopupYazi.path}"
        '' + builtins.readFile ./configBefore.conf;
        configAfter = builtins.readFile ./configAfter.conf;
      });
    };
}
