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

  # Encryption and security tools
  gnupg
  _1password-gui
  _1password

  # Media-related packages
  nerdfonts
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
