{
  description = "Kent's OSX System Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
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
    aerospace-tap = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
    jj = {
      url = github:martinvonz/jj;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    onepassword-shell-plugins = {
      url = "github:1Password/shell-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { 
    self,
    darwin,
    nix-homebrew,
    homebrew-bundle,
    homebrew-core,
    homebrew-cask,
    aerospace-tap,
    home-manager,
    nixpkgs,
    jj,
    onepassword-shell-plugins,
    ... 
  } @inputs:
    let
      user = "kentsommer";
      darwinSystems = [ "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs (darwinSystems) f;
      devShell = system: let pkgs = nixpkgs.legacyPackages.${system}; in {
        default = with pkgs; mkShell {
          nativeBuildInputs = with pkgs; [ bashInteractive git ];
          shellHook = with pkgs; ''
            export EDITOR=vim
          '';
        };
      };
      mkApp = scriptName: system: {
        type = "app";
        program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
          #!/usr/bin/env bash
          PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
          echo "Running ${scriptName} for ${system}"
          exec ${self}/apps/${system}/${scriptName}
        '')}/bin/${scriptName}";
      };
      mkDarwinApps = system: {
        "apply" = mkApp "apply" system;
        "build" = mkApp "build" system;
        "build-switch" = mkApp "build-switch" system;
        "rollback" = mkApp "rollback" system;
      };
    in
    {
      devShells = forAllSystems devShell;
      apps = nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;

      darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (system: let
        user = "kentsommer";
      in
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                inherit user;
                enable = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                  "nikitabobko/homebrew-tap" = aerospace-tap;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            ./hosts/darwin
          ];
        }
      );
  };
}
