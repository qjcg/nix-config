{ pkgs, dag, ... }:
let
  secrets = {
    git-name = "John Gosset";
    git-email = "john@gossetx.com";
  };
in
{
  manual.html.enable = true;

  # FIXME: Not working (settings.ini is *empty*), so creating manual config file below.
  #gtk = with pkgs; {
  #  enable = true;

  #  font = {
  #    package = roboto;
  #    name = "Roboto 18";
  #  };

  #  theme = {
  #    package = qogir-theme;
  #    name = "Qogir-light";
  #  };

  #};

  home = {
    activation.cloneGitRepos = dag.entryAfter [ "writeBoundary" ] ''
      # Ensure srcdir exists and cd into it for subsequent commands.
      srcdir="$HOME/src"
      mkdir -p $srcdir
      cd $srcdir

      # Check for presence of repo dirs, and clone if not found.
      [ -d nix ] || git clone https://github.com/qjcg/nix
    '';

    language = { base = "en_US.utf8"; };

    sessionVariables = {
      EDITOR = "emacsclient -cn";
      PAGER = "less";
      VISUAL = "emacsclient -cn";

      NIX_PATH =
        "nixpkgs=$HOME/.nix-defexpr/channels/nixpkgs:nixos-config=$HOME/.config/nixpkgs/configuration.nix:/nix/var/nix/profiles/per-user/root/channels";

      MAILRC = "$HOME/.config/s-nail/mailrc";
    };

    keyboard = {
      layout = "us,ca";
      model = "pc105";
      options = [ "grp:shifts_toggle" ];
    };

  };

  programs = {

    alacritty = {
      enable = true;
      settings = {
        font.normal.family = "monospace";
        font.normal.style = "Regular";
        font.size = 20;

        colors.cursor.text = "#000000";
        colors.cursor.cursor = "#ef02f7";
      };
    };

    bash = {
      enable = true;

      initExtra = ''
        command -v direnv >/dev/null && eval "$(direnv hook bash)"
        command -v starship >/dev/null && eval "$(starship init bash)"
        command -v zoxide >/dev/null && eval "$(zoxide init bash)"
      '';

      profileExtra = ''
        export LC_COLLATE=C
        export PAGER=less

        # nodejs
        export npm_config_prefix=~/.node_modules
        export PATH=$npm_config_prefix/bin:$PATH

        # go
        export GO111MODULE=on
        export GOPATH=~/go
        export GOBIN=$GOPATH/bin
        export PATH=$GOBIN:$PATH

        # janet
        export JANET_PATH=~/.janet_modules
        [ -d $JANET_PATH ] || mkdir -p $JANET_PATH
        export PATH=$PATH:$JANET_PATH/bin

        # nix
        if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
      '';

      shellAliases = rec {
        e = "emacsclient -cn";
        k = "kubectl";

        ls = "ls --color --human-readable --group-directories-first";
        grep = "grep -E";
        tree = "tree -A -C";

        # Aliases for downloading audio via youtube-dl.
        ytj = "youtube-dl --dump-single-json";
        yta =
          "youtube-dl --add-metadata --embed-thumbnail --ignore-errors -o '%(playlist)s/%(playlist_index)02d. %(uploader)s - %(title)s.mp3'";
      };
    };

    git = {
      enable = true;
      userName = "${secrets.git-name}";
      userEmail = "${secrets.git-email}";
      ignores = [ "node_modules" "__pycache__" "*.pyc" "*.iso" ".netrwhist" ];

      delta = {
        enable = true;
        options = { features = "side-by-side line-numbers decorations"; };
      };

      extraConfig = { pull.rebase = false; };

      aliases = {
        br = "branch -avv";
        ci = "commit";
        co = "checkout";
        de = "daemon --verbose --export-all";
        dl = "diff HEAD^ HEAD";
        ds = "diff --staged";
        lasttag = "describe --tags --abbrev=0";
        lg =
          "log --pretty=format:'%C(yellow)%h%Creset %s  %C(red)<%cn> %Cgreen[%cr] %Creset%d' --graph";
        lga =
          "log --pretty=format:'%C(yellow)%h%Creset %s  %C(red)<%cn> %Cgreen[%cr] %Creset%d' --graph --all";
        re = "remote -v";
        reu = "remote set-url";
        sm = "submodule";
        st = "status --column";

        # Via https://git.wiki.kernel.org/index.php/Aliases#Use_graphviz_for_display
        graphviz = ''
          !f() { echo 'digraph git {' ; git log --pretty='format:  %h -> { %p }' "$@" | sed 's/[0-9a-f][0-9a-f]*/"&"/g' ; echo '}'; }; f'';

        # find fat git files
        # via: https://stackoverflow.com/questions/9456550/how-to-find-the-n-largest-files-in-a-git-repository#comment59168142_28783843
        fatfiles =
          "!f() { git ls-tree -r -l --abbrev --full-name HEAD | sort -rnk4 | head -20; }; f";
      };
    };

    tmux = {
      enable = true;
      escapeTime = 10;
      shortcut = "b";
      terminal = "screen-256color";
      historyLimit = 10000;
      extraConfig = ''
        set -g renumber-windows on
        set -g set-titles on
        set -g set-titles-string "tmux: #H/#S/#W"

        set -sa terminal-overrides ',st-256color:RGB'

        set -g status-left "[#H/#S] "
        set -g status-left-length 25
        set -g status-right ""
        set -g status-right-length 25
        set -g status-justify left
        set -g message-style                 "fg=green bright"
        set -g status-style                  "fg=white dim"
        setw -g window-status-style       "fg=white dim"
        setw -g window-status-current-style  "fg=cyan  dim"

        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        bind C command-prompt -p "New session name:" "new-session -s %1"
        bind R source-file ~/.tmux.conf \; display-message "source-file ~/.tmux.conf"
        bind < command-prompt -p "Rename session to:" "rename-session %%"
        bind > choose-tree "move-window -t %%"

        bind -r M-Left previous-window
        bind -r M-Right next-window

        #bind -r C-Left previous-session
        #bind -r C-Right next-session
      '';
    };

  };

  services = {

    emacs = {
      enable = true;
      package = pkgs.jg.overrides.emacs;
      socketActivation.enable = true;
    };

    gpg-agent = {
      enable = true;
      pinentryFlavor = "tty";
      defaultCacheTtl = 3600;
      defaultCacheTtlSsh = 3600;
      enableScDaemon = false;
      enableSshSupport = true;
      extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
    };

    # FIXME: i3lock does NOT unlock with correct password!
    #services.screen-locker = {
    #  enable = true;
    #  lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
    #};
    #polybar = {
    #  enable = true;
    #};

    #mpd = {
    #  enable = true;
    #  musicDirectory = /home/john/Sync/Music ;
    #  network.listenAddress = "any";
    #};

    syncthing.enable = true;

  };

  # These are read by Wayland.
  # See https://wiki.archlinux.org/index.php/Systemd/User#Environment_variables
  systemd.user.sessionVariables = {
    BROWSER = "firefox";
    QT_PLATFORMTHEME = "qt5ct";
    QT_PLATFORM_PLUGIN = "qt5ct";
    QT_QPA_PLATFORMTHEME = "qt5ct";

    # Enable wayland with Firefox.
    # See https://wiki.archlinux.org/index.php/Firefox#Wayland
    # Verify via about:support -> "Window Protocol"
    MOZ_ENABLE_WAYLAND = "1";

    # For Firefox HiDPI
    # See:
    #   - https://wiki.archlinux.org/index.php/HiDPI#GDK_3_(GTK_3)
    #   - https://wiki.archlinux.org/index.php/HiDPI#Firefox
    GDK_DPI_SCALE = "1.5";
  };

  wayland.windowManager.sway =
    let
      modifier = "Mod4";

      cmd_term = "${pkgs.gnome.gnome-terminal}/bin/gnome-terminal";
      cmd_term_tmux = "${cmd_term} -t tmux-main -- sh -c 'tmux new -ADs main'";

      cmd_menu =
        "${pkgs.dmenu}/bin/dmenu_run -fn 'Fira Code:size=13' -nb '#000000' -sb '#00fcff' -sf '#000000'";
      cmd_browser = "${pkgs.firefox}/bin/firefox";

      wpdir = "/home/jgosset/Sync/Pictures/Wallpapers";
      cmd_browse_wallpaper = "${pkgs.sxiv}/bin/sxiv -artos f ${wpdir}";
      cmd_set_wallpaper =
        "${pkgs.feh}/bin/feh --bg-fill ${wpdir}/gtgraphics.de/infinitus.jpg ${wpdir}/wallpaperfx.com/white-tiger-in-jungle-2560x1440-wallpaper-2916.jpg --geometry -550";

      left = "h";
      down = "j";
      up = "k";
      right = "l";
    in
    {
      enable = true;

      extraConfig = ''
        default_border  pixel 8
        title_align     center

        output eDP-1    bg #000000 solid_color scale 1 pos 0 0
        output HDMI-A-2 bg #000000 solid_color scale 1 pos 2560 0
      '';

      config = {
        fonts = {
          names = [ "Iosevka Medium" ];
          size = 13.0;
        };

        modifier = "${modifier}";

        gaps = {
          inner = 5;
          outer = 5;
        };

        # FIXME: NOT working to change repeat_ delay or rate.
        # See sway-input(5).
        #input = {
        #  "1:1:AT_Translated_Set_2_keyboard" = {
        #    repeat_delay = "2000"; # (ms) Sets the amount of time a key must be held before it starts repeating.
        #    repeat_rate = "60";  # (chars per sec) Sets the frequency of key repeats once the repeat_delay has passed.
        #  };
        #};

        keybindings = pkgs.lib.mkOptionDefault {

          # Start apps
          "${modifier}+Return" = "exec ${cmd_term}";
          "${modifier}+d" = "exec ${cmd_menu}";
          "${modifier}+Shift+b" = "exec ${cmd_browse_wallpaper}";

          # Focus windows
          "${modifier}+${left}" = "focus left";
          "${modifier}+${down}" = "focus down";
          "${modifier}+${up}" = "focus up";
          "${modifier}+${right}" = "focus right";

          # Move windows
          "${modifier}+Shift+${left}" = "move left";
          "${modifier}+Shift+${down}" = "move down";
          "${modifier}+Shift+${up}" = "move up";
          "${modifier}+Shift+${right}" = "move right";

          # Switch workspaces
          "${modifier}+n" = "workspace next_on_output";
          "${modifier}+p" = "workspace prev_on_output";
          "${modifier}+Tab" = "workspace back_and_forth";

          # Move containers accross outputs.
          "${modifier}+Shift+period" = "move container to output right";
          "${modifier}+Shift+comma" = "move container to output left";

          # Use scratchpad
          "${modifier}+minus" = "scratchpad show";
          "${modifier}+Shift+minus" = "move scratchpad";

          "${modifier}+Shift+e" = "exit";
          "${modifier}+Shift+x" = "kill";

          # Control cmus(1) music playback.
          "XF86AudioPlay" = "exec cmus-remote --pause";
          "XF86AudioPrev" = "exec cmus-remote --prev";
          "XF86AudioNext" = "exec cmus-remote --next";
          "XF86AudioStop" = "exec cmus-remote --stop";

          # Control pulseaudio volume for default sink.
          # Ref: https://wiki.archlinux.org/index.php/PulseAudio#Keyboard_volume_control
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioLowerVolume" =
            "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioRaiseVolume" =
            "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        };

        # NOTE: Border of i3-gaps windows is set via childBorder.
        colors = {
          focused = {
            border = "#0000ff";
            background = "#000000";
            text = "#00ffed";
            indicator = "#ffffff";
            childBorder = "#0000ff";
          };
          focusedInactive = {
            border = "#000000";
            background = "#000000";
            text = "#ffffff";
            indicator = "#ffffff";
            childBorder = "#000000";
          };
          unfocused = {
            border = "#000000";
            background = "#222222";
            text = "#999999";
            indicator = "#ffffff";
            childBorder = "#000000";
          };
        };

        bars = [
          {
            position = "top";
            mode = "dock";

            fonts = {
              names = [ "Iosevka Medium" ];
              size = 16.0;
            };

            colors = {
              background = "#000000";
              statusline = "#cccccc";
              separator = "#00ffea";

              focusedWorkspace = {
                border = "#000000";
                background = "#000000";
                text = "#00fcff";
              };
              activeWorkspace = {
                border = "#000000";
                background = "#000000";
                text = "#cccccc";
              };
              inactiveWorkspace = {
                border = "#000000";
                background = "#000000";
                text = "#cccccc";
              };
              urgentWorkspace = {
                border = "#00ff00";
                background = "#000000";
                text = "#ffffff";
              };
            };

            statusCommand = "${pkgs.jg.custom.barr}/bin/barr";
            extraConfig = ''
              output eDP-1
            '';
          }
          {
            position = "top";
            mode = "dock";

            fonts = {
              names = [ "Iosevka Medium" ];
              size = 13.0;
            };

            colors = {
              background = "#000000";
              statusline = "#cccccc";
              separator = "#00ffea";

              focusedWorkspace = {
                border = "#000000";
                background = "#000000";
                text = "#00fcff";
              };
              activeWorkspace = {
                border = "#000000";
                background = "#000000";
                text = "#cccccc";
              };
              inactiveWorkspace = {
                border = "#000000";
                background = "#000000";
                text = "#cccccc";
              };
              urgentWorkspace = {
                border = "#00ff00";
                background = "#000000";
                text = "#ffffff";
              };
            };

            statusCommand = "${pkgs.jg.custom.barr}/bin/barr";
            extraConfig = ''
              output HDMI-A-2
            '';
          }
        ];

        startup = [
          #{ notification = false; command = "${cmd_set_wallpaper}"; }
          { command = "${pkgs.jg.overrides.emacs}/bin/emacsclient -cn"; }
          { command = "${cmd_browser}"; }
        ];

        terminal = "${pkgs.gnome.gnome-terminal}/bin/gnome-terminal";

      };
    };

  xdg.configFile = {
    "albert/albert.conf".source = ../../files/albert.conf;
    "cmus/rc".source = ../../files/cmusrc;
    "emacs/elfeed.org".source = ../../files/emacs/elfeed.org;
    "gtk-3.0/settings.ini".source = ../../files/gtk-3.0_settings.ini;
    "i3/workspace1.json".source = ../../files/workspace1_luban.json;
    "nix/nix.conf".text = ''
      experimental-features = nix-command flakes # See https://www.tweag.io/blog/2020-05-25-flakes/
    '';
    "nvim/coc-settings.json".source = ../../files/coc-settings.json;
    "starship.toml".source = ../../files/starship.toml;
    "sway/i3status-rust.toml".source = ../../files/i3status-rust_luban.toml;
    "sxiv/exec/key-handler" = {
      executable = true;
      source = ../../files/sxiv-key-handler.sh;
    };
    "tig/config".source = ../../files/tigrc;
    "VSCodium/User/settings_example.json".source =
      ../../files/vscodium_settings_example.json;
    "xonsh/".source = ../../files/xonsh;
    "waybar/".source = ../../files/waybar;
    "wayfire.ini".source = ../../files/wayfire.ini;
  };

  xdg.dataFile = {
    "fonts/Apl385.ttf" = {
      source = ../../files/fonts/Apl385.ttf;
      onChange = "fc-cache -f";
    };
  };

  #xresources.properties = {
  #  "Xft.dpi" = 96;
  #  "Xft.autohint" = 0;
  #  "Xft.lcdfilter" = "lcddefault";
  #  "Xft.hintstyle" = "hintfull";
  #  "Xft.hinting" = 1;
  #  "Xft.antialias" = 1;
  #  "Xft.rgba" = "rgb";
  #};

  #xsession = {
  #  enable = true;

  #  pointerCursor = with pkgs; {
  #    name = "Vanilla-DMZ";
  #    package = vanilla-dmz;
  #    size = 64;
  #  };

  #  initExtra = ''
  #    xrdb -merge ~/.Xresources
  #  '';
  #};

}
