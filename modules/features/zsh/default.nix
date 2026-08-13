{
  inputs,
  moduleWithSystem,
  ...
}:
let
  shellToolPkgs = pkgs:
    with pkgs;
    [
      git
      neovim
      fzf
      atuin
      zoxide
      direnv
      oh-my-posh
      mise
      stow
      tmux
      glab
      jq
      yq-go
      k9s
      kubectx
      lazygit
      eza
      ripgrep
      nmap
      bat
      tldr
      postgresql
      gh
      kind
      yazi
      krew
      sops
      fluxcd
      nixd
      pre-commit
      kustomize
      kubebuilder
      oci-cli
      dive
      openvpn
      cookiecutter
      argocd
      uv
      herdr
      tuicr
    ];
in
{
  flake.modules.darwin.zsh = moduleWithSystem (
    {
      pkgs,
      self',
      ...
    }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          zsh = self'.packages.zsh;
        })
      ];

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableBashCompletion = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        histSize = 10000;
      };

        users.users."christian.kirmse".shell = "${self'.packages.zsh}/bin/zsh";
        environment.shells = [ self'.packages.zsh pkgs.zsh ];
    }
  );

  perSystem =
    {
      pkgs,
      lib,
      self',
      inputs',
      ...
    }:
    {
      packages.zsh = inputs.wrappers.wrappers.zsh.wrap {
        inherit pkgs;
        runtimePkgs = shellToolPkgs pkgs;
        zshAliases = {
          ls = "${lib.getExe pkgs.eza} --git --group-directories-first --time-style=long-iso --icons";
          l = "ls -lh";
          la = "ls -lah";
          lt = "ls --tree --level=2";
          lta = "ls --tree --level=2 -a";
          cd = lib.getExe pkgs.zoxide;
          v = "NVIM_APPNAME=lazyvim ${lib.getExe pkgs.neovim}";
          atr = "${lib.getExe pkgs.atuin} scripts run";
          wm = lib.getExe' inputs'.workmux.packages.default "workmux";
        };
        zshrc.content = ''
          # profile startup time with: time ZSH_DEBUGRC=1 zsh -i -c exit
          if [ -n "''${ZSH_DEBUGRC+1}" ]; then
              zmodload zsh/zprof
          fi
          # Set up mise
          eval "$(${lib.getExe pkgs.mise} activate zsh)"

          # Set XDG Base Directories
          export XDG_DATA_HOME="$HOME/.local/share"
          export XDG_CONFIG_HOME="$HOME/.config"

          # Set editor
          export EDITOR="nvim"
          export K9S_EDITOR=''${EDITOR}

          # Set krew dir
          export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

          # Set k9s Config Directory
          export K9S_CONFIG_DIR="$XDG_CONFIG_HOME/k9s"
          #
          # Set fzf color scheme
          export FZF_DEFAULT_OPTS=" \
          --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
          --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
          --color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
          --color=selected-bg:#494d64 \
          --multi"

          # Set the directory we want to store zinit and plugins
          ZINIT_HOME=''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git

          # Download Zinit, if it's not there yet
          if [[ ! -d $ZINIT_HOME ]]; then
            mkdir -p "$(dirname $ZINIT_HOME)"
            git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
          fi

          # Source/Load Zinit
          source "''${ZINIT_HOME}/zinit.zsh"

          # Add in Powerlevel10k
          # zinit ice depth=1; zinit light romkatv/powerlevel10k

          # Add in zsh plugins
          zinit light zsh-users/zsh-syntax-highlighting
          zinit light zsh-users/zsh-completions
          zinit light zsh-users/zsh-autosuggestions
          zinit light Aloxaf/fzf-tab

          # Add in snippets
          if command -v kubectl >/dev/null 2>&1; then zinit snippet OMZP::kubectl; fi # adds completion, aliases and wrappers https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl

          if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
          if command -v op >/dev/null 2>&1; then eval "$(command op completion zsh)"; fi
          if command -v nzero >/dev/null 2>&1; then eval "$(command nzero completion zsh)"; fi
          if command -v tfctl >/dev/null 2>&1; then eval "$(command tfctl completion zsh)"; fi
          if command -v tofu >/dev/null 2>&1; then complete -o nospace -C /Users/christian.kirmse/.local/share/mise/installs/opentofu/1.9.1/tofu tofu; fi
          fpath=(/Users/christian.kirmse/.docker/completions $fpath)
          fpath=(/Users/christian.kirmse/.zsh-completions $fpath)
          compdef _gnu_generic fd

          zinit cdreplay -q

          # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
          # [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

          # Load oh-my-posh
          eval "$(${lib.getExe self'.packages.ohMyPosh} init zsh --print)"

          # Keybindings
          bindkey -e
          bindkey '^p' history-search-backward
          bindkey '^n' history-search-forward
          bindkey "\e[3~" delete-char

          # History
          HISTSIZE=5000
          HISTFILE=~/.zsh_history
          SAVEHIST=$HISTSIZE
          HISTDUP=erase
          setopt appendhistory
          setopt sharehistory
          setopt hist_ignore_space
          setopt hist_ignore_all_dups
          setopt hist_save_no_dups
          setopt hist_ignore_dups
          setopt hist_find_no_dups

          # Completion styling
          zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
          zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
          zstyle ':completion:*' menu no
          # zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
          # zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

          # Shell integrations
          eval "$(${lib.getExe pkgs.fzf} --zsh)"
          eval "$(${lib.getExe pkgs.atuin} init zsh --disable-up-arrow)"

          # Load zoxide
          eval "$(${lib.getExe pkgs.zoxide} init zsh)"

          export PATH=$HOME/.local/bin:$PATH

          # Disable docker to automatically add provenance attestations to the image, fckn Gitlab can't understand this
          export BUILDX_NO_DEFAULT_ATTESTATIONS=1

          # Load direnv
          eval "$(${lib.getExe pkgs.direnv} hook zsh)"

          if [ -n "''${ZSH_DEBUGRC+1}" ]; then
              zprof
          fi
        '';
      };

      packages.ohMyPosh = inputs.wrappers.wrappers.oh-my-posh.wrap {
        inherit pkgs;
        configFile = ./ohmyposh.toml;
      };
    };
}
