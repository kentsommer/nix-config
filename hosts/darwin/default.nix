{ config, pkgs, ... }:

let user = "kentsommer"; in

{

  imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/darwin
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Setup user, packages, programs
  nix = {
    package = pkgs.nix;
    settings.trusted-users = [ "@admin" "${user}" ];

    gc = {
      user = "root";
      automatic = true;
      interval = { Weekday = 1; Hour = 0; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Load system packages
  environment.systemPackages = with pkgs; (import ../../modules/darwin/packages.nix { inherit pkgs; }); 

  # Enable fish shell
  programs.fish.enable = true;

  system = {
    stateVersion = 4;

    defaults = {
      NSGlobalDomain = {
        # Dark Mode
        AppleInterfaceStyle = "Dark";
        # Save to documents to disk by default
        NSDocumentSaveNewDocumentsToCloud = false;
        # Expand save panel by default
        NSNavPanelExpandedStateForSaveMode = false;
        NSNavPanelExpandedStateForSaveMode2 = false;
        # Expand print panel by default
        PMPrintingExpandedStateForPrint = false;
        PMPrintingExpandedStateForPrint2 = false;
        # Disable automatic capitalization
        NSAutomaticCapitalizationEnabled = false;
        # Disable smart dashes
        NSAutomaticDashSubstitutionEnabled = false;
        # Disable automatic period substitution
        NSAutomaticPeriodSubstitutionEnabled = false;
        # Disable smart quotes
        NSAutomaticQuoteSubstitutionEnabled = false;
        # Disable auto-correct
        NSAutomaticSpellingCorrectionEnabled = false;
        # Disable press-and-hold for keys in favor of key repeat
        ApplePressAndHoldEnabled = false;
        # Set units to celsius
        AppleTemperatureUnit = "Celsius";
        # Set a blazingly fast keyboard repeat rate
        KeyRepeat = 2;
        InitialKeyRepeat = 10;
        # Always show scroll bars
        AppleShowScrollBars = "WhenScrolling";
        # Enable subpixel font rendering on non-Apple LCDs
        # Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
        AppleFontSmoothing = 2;
        # Finder: show all filename extensions
        AppleShowAllExtensions = true;
      };
      LaunchServices = {
        # Whether to enable quarantine for downloaded applications
        LSQuarantine = false;
      };
      dock = {
        # Automatically hide and show the Dock
        autohide = true;
        # Move Dock to the bottom
        orientation = "bottom";
        # Make Dock icons of hidden applications translucent
        showhidden = true;
        # Don’t show recent applications in Dock
        show-recents = false;
        tilesize = 40;
        # Don't animate opening applications from the Dock
        launchanim = false;
        # Speed up Mission Control animations
        expose-animation-duration = 0.1;
        # Don't show Dashboard as a Space
        dashboard-in-overlay = true;
        # Don’t automatically rearrange Spaces based on most recent use
        mru-spaces = false;
        # Show progress indicators
        show-process-indicators = true;
        # Remove the auto-hiding Dock delay
        autohide-delay = 0.0;
        # Remove the auto-hiding Dock delay
        autohide-time-modifier = 0.0;
        # Minimize windows into their application icon
        minimize-to-application = true;
        # Set apps
        persistent-apps = [
          "/Applications/Arc.app"
          "/Applications/Nix Apps/WezTerm.app"
          "/Applications/Signal.app"
          "/System/Applications/System Settings.app"
        ];
      };
      finder = {
        # Whether to allow quitting of the Finder
        QuitMenuItem = false;
        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";
        # Display full POSIX path as Finder window title
        _FXShowPosixPathInTitle = true;
        # Disable the warning when changing a file extension
        FXEnableExtensionChangeWarning = false;
        # Use list view by default
        FXPreferredViewStyle = "Nlsv";
        # Show status bar
        ShowStatusBar = true;
        # Do not show icons on the desktop
        CreateDesktop = false;
      };
      loginwindow = {
        GuestEnabled = false;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = false;
      };
      menuExtraClock = {
        ShowAMPM = true;
        ShowDate = 0;
      };
      CustomUserPreferences = {
        "com.apple.systempreferences" = {
          # Disable Resume system-wide
          NSQuitAlwaysKeepsWindows = false;
        };
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.screensaver" = {
          # Require password immediately after sleep or screen saver begins
          askForPassword = 1;
          askForPasswordDelay = 0;
        };
        "com.apple.AdLib" = {
          # Disable tracking
          allowApplePersonalizedAdvertising = false;
        };
        "com.apple.BluetoothAudioAgent" = {
          # Increase sound quality for Bluetooth headphones/headsets
          "Apple Bitpool Min (editable)" = -40;
        };
        "com.apple.dashboard" = {
          # Disable Dashboard
          mcx-disabled = true;
        };
        "com.apple.DiskUtility" = {
          # Enable the debug menu in Disk Utility
          DUDebugMenuEnabled = true;
          advanced-image-options = true;
        };
        "com.apple.TextEdit" = {
          # Use plain text mode for new TextEdit documents
          RichText = 0;
          # Open and save files as UTF-8 in TextEdit
          PlainTextEncoding = 4;
          PlainTextEncodingForWrite = 4;
        };
        "com.apple.finder" = {
          # Finder should open to home
          NewWindowTarget = "PfHm";
          # Do not warn me when I empty the trash
          WarnOnEmptyTrash = false;
          # Do not show tags
          ShowRecentTags = false;
          # Allow to quit the finder
          QuitMenuItem = true;
        };
        "com.apple.loginwindow" = {
          # Do not save window state through logout/login
          TALLogoutSavesState = false;
          LoginwindowLaunchesRelaunchApps = false;
        };
      };
    };
  };
}
