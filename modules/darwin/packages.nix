{ pkgs }:

with pkgs; [
  # General packages for development and system management
  # wezterm
  coreutils
  killall
  openssh
  wget
  zip
  lunarvim
  bazelisk
  jq
  darwin.xcode_15_1
  socat

  # Encryption and security tools
  gnupg
  _1password-gui
  _1password-cli

  # Media-related packages
  nerd-fonts.fira-code
  nerd-fonts.fira-mono
  ffmpeg
  fzf

  # Text and terminal utilities
  htop
  ripgrep
  zellij
  unrar
  unzip

  # Python packages
  python312
  python312Packages.virtualenv
]
