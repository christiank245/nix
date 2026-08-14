{
  flake.modules.darwin.homebrew =
    { inputs, config, ... }:
    {
      homebrew = {
        enable = true;
        global.brewfile = true;
        onActivation = {
          cleanup = "none";
          autoUpdate = true;
          upgrade = true;
        };

        brews = [ 
          "helm"
          "ksm"
          "gitlab-ci-local"
          "trash"
          "borders"
          "mpdecimal"
          "loft-sh/tap/vcluster"
          "worktrunk"
          "ollama"
          "komorebi-for-mac"
          "omp"
        ];

        casks = [
          "arc"
          "appcleaner"
          "1password"
          "aerospace"
          "obsidian"
          "raycast"
          "bitwarden"
          "homerow"
          "ghostty"
          "rambox"
          "visual-studio-code"
          "citrix-workspace"
          "ticktick"
          "bruno"
          "raspberry-pi-imager"
          "microsoft-teams"
          "tunnelblick"
          "tailscale-app"
          "orbstack"
        ];

        masApps = {
          "Flow" = 1423210932;
          "Flyleaf" = 6475200381;
        };
      };

      nix-homebrew = {
        # Install Homebrew under the default prefix
        enable = true;

        # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
        enableRosetta = true;

        # User owning the Homebrew prefix
        user = "christian.kirmse";

        # Declarative tap management
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
          "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
          "nikitabobko/homebrew-tap" = inputs.nikitabobko-tap;
          "ck0ne9000/homebrew-tap" = inputs.ck0ne9000-tap;
          "sst/homebrew-tap" = inputs.sst-tap;
          "flux-iac/homebrew-tap" = inputs.flux-iac-tap;
          "FelixKratz/homebrew-formulae" = inputs.felix-kratz;
          "robusta-dev/homebrew-krr" = inputs.robusta-dev;
          "controlplaneio-fluxcd/homebrew-tap" = inputs.controlplaneio-fluxcd;
          "loft-sh/homebrew-tap" = inputs.loft-sh;
          "gammons/homebrew-tap" = inputs.gammons;
          "BarutSRB/homebrew-tap" = inputs.barutsrb;
          "lgug2z/homebrew-tap" = inputs.lgug2z;
          "can1357/homebrew-tap" = inputs.can1357;
        };

        trust = {
          casks = [
            "nikitabobko/tap/aerospace"
          ];
          taps = [ 
            "nikitabobko/tap"
            "ck0ne9000/tap"
            "felixkratz/formulae"
            "sst/tap"
            "flux-iac/tap"
            "robusta-dev/krr"
            "controlplaneio/fluxcd"
            "loft-sh/tap"
            "BarutSRB/homebrew-tap"
            "lgug2z/homebrew-tap"
            "can1357/homebrew-tap"
            # "gammons/tap"
          ];
        };

        # Optional: Enable fully-declarative tap management
        #
        # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
        mutableTaps = false;
      };

      homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
    };
}
