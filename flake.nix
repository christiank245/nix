{
  description = "MacBook Darwin system flake";

  inputs = {
    # System
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";

    # Fix nix gui apps on darwin
    mac-app-util.url = "github:hraban/mac-app-util";

    workmux.url = "github:raine/workmux";

    # Homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    nikitabobko-tap = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
    ck0ne9000-tap = {
      url = "github:ck0ne9000/homebrew-tap";
      flake = false;
    };
    sst-tap = {
      url = "github:sst/homebrew-tap";
      flake = false;
    };
    flux-iac-tap = {
      url = "github:flux-iac/homebrew-tap";
      flake = false;
    };
    felix-kratz = {
      url = "github:FelixKratz/homebrew-formulae";
      flake = false;
    };
    robusta-dev = {
      url = "github:robusta-dev/homebrew-krr";
      flake = false;
    };
    controlplaneio-fluxcd = {
      url = "github:controlplaneio-fluxcd/homebrew-tap";
      flake = false;
    };
    loft-sh = {
      url = "github:loft-sh/homebrew-tap";
      flake = false;
    };
    gammons = {
      url = "github:gammons/homebrew-tap";
      flake = false;
    };
    barutsrb = {
      url = "github:BarutSRB/homebrew-tap";
      flake = false;
    };
    lgug2z = {
      url = "github:lgug2z/homebrew-tap";
      flake = false;
    };
    can1357 = {
      url = "github:can1357/homebrew-tap";
      flake = false;
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
