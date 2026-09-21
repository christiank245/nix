{
  flake.modules.darwin.system =
    { self, pkgs, ... }:
    {
      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
      ];

      # Required so Touch ID sudo auth also works inside tmux/screen sessions.
      security.pam.services.sudo_local.reattach = true;
      security.pam.services.sudo_local.touchIdAuth = true;
      nixpkgs.config.allowUnsupportedSystem = true;

      system = {
        primaryUser = "christian.kirmse";
        defaults = {
          dock = {
            autohide = true;
            persistent-apps = [
              "/Applications/Arc.app"
              "/System/Applications/Mail.app"
              "/System/Applications/Calendar.app"
              "/Applications/TickTick.app"
              "/Applications/Rambox.app"
              "/Applications/Nix Apps/WezTerm.app"
              "/Applications/Obsidian.app"
              "/Applications/Bitwarden.app"
              "/Applications/1Password.app"
            ];
            expose-group-apps = true;
          };
          finder = {
            FXPreferredViewStyle = "clmv";
          };
          NSGlobalDomain = {
            # 120, 90, 60, 30, 12, 6, 2
            KeyRepeat = 2;
            # 120, 94, 68, 35, 25, 15
            InitialKeyRepeat = 15;
            NSWindowShouldDragOnGesture = true;
          };
          trackpad = {
            Clicking = true;
          };
          CustomUserPreferences = {
            "com.apple.finder" = {
              # When performing a search, search the current folder by default
              FXDefaultSearchScope = "SCcf";
              _FXSortFoldersFirst = true;
              AppleShowAllExtensions = true;
            };
            "com.apple.desktopservices" = {
              # Avoid creating .DS_Store files on network or USB volumes
              DSDontWriteNetworkStores = true;
              DSDontWriteUSBStores = true;
            };
          };
        };
      };
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;
    };
}
