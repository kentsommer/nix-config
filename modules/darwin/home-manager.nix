{ config, pkgs, lib, home-manager, ... }@inputs:

let name = "Kent Sommer";
    user = "kentsommer";
    email = "services@kentsommer.com"; in
{
  # Configure user
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.fish;
  };

  homebrew = {
    enable = true;
    onActivation.upgrade = true;
    casks = pkgs.callPackage ./casks.nix {};
    masApps = {
      "line" = 539883307;
      "infuse" = 1136220934;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file.".wezterm.lua".source = ./dotfiles/wezterm/wezterm.lua;
        file.".config/lvim/config.lua".source = ./dotfiles/lunarvim/config.lua;
        file.".ssh/config".source = ./dotfiles/ssh/config;
        file.".jjconfig.toml".source = ./dotfiles/jj/config.toml;
        file.".aerospace.toml".source = ./dotfiles/aerospace/aerospace.toml;
        sessionVariables = {
          EDITOR = "lvim";
          SSH_AUTH_SOCK = "~/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
        };
        stateVersion = "23.11";
      };
      imports = [ 
        inputs.onepassword-shell-plugins.hmModules.default
      ];
      programs = {
        # Shared shell configuration
        fish = {
          enable = true;
          shellAliases = {
            blaze = "bazelisk";
            gh = "op plugin run -- gh";
          };
        };

        git = {
          enable = true;
          ignores = [ "*.swp" ];
          userName = name;
          userEmail = email;
          lfs = {
            enable = true;
          };
          extraConfig = {
            init.defaultBranch = "main";
            core = {
            editor = "lvim";
              autocrlf = "input";
            };
          };
        };

        neovim = {
          enable = true;
        };

        # wezterm = {
        #   enable = true;
        # };

        zellij = {
          enable = true;
        };

        fzf = {
          enable = true;
          enableFishIntegration = true;
        };

        jujutsu = {
          enable = true;
        };

        _1password-shell-plugins = {
          # enable 1Password shell plugins for bash, zsh, and fish shell
          enable = true;
          # the specified packages as well as 1Password CLI will be
          # automatically installed and configured to use shell plugins
          plugins = with pkgs; [ gh ];
        };

        gh = {
          # We disable this so that 1password manages this as a plugin
          enable = false;
        };
      };
      manual.manpages.enable = true;
    };
  };
}
