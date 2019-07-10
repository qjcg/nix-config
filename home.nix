# home-manager configuration.
# See https://github.com/rycee/home-manager#usage
# For a good example with i3 configuration, see:
#   https://github.com/j0xaf/dotfiles/blob/master/.config/nixpkgs/home.nix
#
# TODO:
#  - decide howto manage secrets (passwords, keys, etc)

{ pkgs, lib ? pkgs.stdenv.lib, ... }:

{
  home.packages = with pkgs; [

    # Nix utilities
    nixops

    # BROKEN
    # FIXME: These apps close immediately on startup, complaining about GLX.
    alacritty
    cool-retro-term
    glxinfo
    zoom-us

    # Utilities
    ansible
    aria2
    davmail
    ed
    fdupes
    fzf
    gopass
    jq
    libfaketime
    lsof
    mkpasswd
    mtr
    pv
    renameutils
    ripgrep
    tesseract
    tree
    unzip
    weechat

    ## Utilities; Network
    bettercap
    dnsutils
    nmap
    wireshark

    ## Utilities: Backup
    rclone
    restic
    rsync
    syncthing

    # FIXME: Baresip NOT working.
    baresip


    # MultiMedia
    alsaLib
    alsaPluginWrapper
    alsaPlugins
    alsaTools
    alsaUtils
    cmus

    fluidsynth
    soundfont-fluid

    mpv
    pavucontrol
    pulseaudio
    pulseeffects
    sox
    streamripper
    youtube-dl

    # Dev Tools
    ctags
    delve
    fossil
    go
    tig
    upx
    mkcert
    python37Packages.cookiecutter
    nodejs


    # Virtualization & Containers
    buildah
    docker-compose
    packer
    podman
    qemu
    skopeo
    tinyemu
    vagrant

    # GUI
    gcolor3
    mesa
    xaos
    rdesktop

    ## GUI: Window Manager
    # FIXME: dmenu_run exits after one keypress (Ubuntu 18.04).
    #dmenu
    i3blocks-gaps
    i3lock

    # FIXME: Fails with error on invocation.
    # slock: getgrnam nogroup: group entry not found
    #slock

    st

    ## GUI: Documents
    # TODO: Find out *why* this only runs when started as root (Ubuntu 18.04).
    libreoffice-fresh

    zathura

    ## GUI: Graphics
    feh
    gimp # gimp-with-plugins didn't compile! 2019-07-07
    imagemagick
    inkscape
    sxiv

    ## GUI: Fonts
    fira-code
    fontconfig-penultimate
    gtk2fontsel
    iosevka
    inconsolata
    libertine
    roboto

    ## GUI: VideoConferencing
    bluejeans-gui
  ];

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
  };

  home.language = {
    base = "en_US.utf8";
  };

  home.sessionVariables = {
    BROWSER = "firefox";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.autorandr.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    configure = {
      customRC = ''
        colorscheme abstract

        set autochdir
        set autoindent
        set hlsearch			" highlight search results
        set ignorecase			" case insensitive searches
        set laststatus=1		" only show statusbar if >1 windows open
        set listchars=tab:>-,eol:$
        set nowrap
        set shortmess+=I		" disable welcome screen
        set smartcase			" case-sensitive search only if specified
        set splitright			" vsplit window to the right by default
        set wildmenu			" dmenu-style menu
        set wildmode=full

        "" MAPS
        "" See :h keycodes
        let mapleader=","

        nnoremap <leader>l :set list!<CR>
        nnoremap <leader>r :source $MYVIMRC<CR>
        nnoremap <leader>S :setlocal spell!<CR>
        nnoremap <leader>v :e $MYVIMRC<CR>
        nnoremap <leader>w :w !sudo tee %<CR><CR>

        nnoremap <leader>g :Goyo<CR>

        autocmd FileType yaml setlocal ai et sw=2 ts=2 cuc
        autocmd FileType nix setlocal cuc
      '';

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          ansible-vim
          awesome-vim-colorschemes
          fzf-vim
          goyo
          limelight-vim
          neosnippet
          nerdtree
          python-mode
          tagbar
          vim-nix
        ];
      };

    };
  };

  home.keyboard = {
    layout = "us,ca";
    model = "pc105";
    options = ["grp:shifts_toggle"];
  };

  manual.html.enable = true;

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.magit
    ];
  };

  programs.firefox = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "John Gosset";
    userEmail = "jgosset@drw.com";
  };

  # X11 compositor (transparency, etc).
  # FIXME: Fails, complaining about GLX.
  services.compton = {
    enable = false;
    activeOpacity = "0.9";
  };

  services.dunst = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 3600;
    defaultCacheTtlSsh = 3600;
    enableScDaemon = false;
    enableSshSupport = true;
    extraConfig = ''
      allow-emacs-pinentry
    '';
  };

  # FIXME: Does NOT unlock with correct password!
  #services.screen-locker = {
  #  enable = true;
  #  lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
  #};

  # Assuming this is needed when NOT using NixOS.
  #systemd.user = {
  #  systemctlPath = "/usr/bin/systemctl";
  #};

  xsession = {
    enable = true;

    windowManager.i3 = 
    let
      modifier = "Mod4";

      cmd_term = "gnome-terminal";
      cmd_menu = "dmenu_run -fn 'Iosevka Term:style=Regular:size=13' -nb '#000000'";
      cmd_browser = "${pkgs.firefox}/bin/firefox";

      left = "h";
      down = "j";
      up = "k";
      right = "l";
    in {
      enable = true;

      config = {
        fonts = [
          "Iosevka Term Regular 11"
        ];

        modifier = "${modifier}";

        gaps = {
          inner = 8;
          outer = 8;
        };

        keybindings =
          lib.mkOptionDefault {
            # FIXME: st not working on Ubuntu 18.04 desktop
            "${modifier}+Return" = "exec ${cmd_term}";
            "${modifier}+d"      = "exec ${cmd_menu}";

            "${modifier}+${left}"  = "focus left";
            "${modifier}+${down}"  = "focus down";
            "${modifier}+${up}"    = "focus up";
            "${modifier}+${right}" = "focus right";

            "${modifier}+Shift+${left}"  = "move left";
            "${modifier}+Shift+${down}"  = "move down";
            "${modifier}+Shift+${up}"    = "move up";
            "${modifier}+Shift+${right}" = "move right";

            "${modifier}+n"       = "workspace next_on_output";
            "${modifier}+p"       = "workspace prev_on_output";
            "${modifier}+Tab"     = "workspace back_and_forth";

            "${modifier}+minus"       = "scratchpad show";
            "${modifier}+Shift+minus" = "move scratchpad";
	  };

        colors = {
          focused         = { border = "#000000"; background = "#000000"; text = "#00ffed"; indicator = "#ffffff"; childBorder = "#000000"; };
          focusedInactive = { border = "#000000"; background = "#000000"; text = "#ffffff"; indicator = "#ffffff"; childBorder = "#000000"; };
          unfocused       = { border = "#000000"; background = "#222222"; text = "#999999"; indicator = "#ffffff"; childBorder = "#000000"; };
        };

        bars = [{
        # FIXME: Setting i3blocks as command doesn't work, causes bar not to display.
          #command = "${pkgs.i3blocks-gaps}/bin/i3blocks";
          command = "/usr/bin/i3bar";
          position = "top";
          mode = "dock";

          colors = {
            background = "#000000";
            statusline = "#cccccc";
            separator  = "#00ffea";

            focusedWorkspace   = {border = "#000000"; background = "#000000"; text = "#00fcff"; };
            activeWorkspace    = {border = "#000000"; background = "#000000"; text = "#cccccc"; };
            inactiveWorkspace  = {border = "#000000"; background = "#000000"; text = "#cccccc"; };
            urgentWorkspace    = {border = "#00ff00"; background = "#000000"; text = "#ffffff"; };
          };
        }];

        startup = [
          # FIXME: Remove absolute path for alacritty when working via home-manager.
          { notification = false; command = "${cmd_term}"; }
          { notification = false; command = "${cmd_browser}"; }
          { notification = false; command = "~/.fehbg"; }
          { notification = false; command = "home-manager-help"; }

          # Set faster key repeat rate, inspired by EXWM.
          # Results in snappier Emacs usage.
          # See https://github.com/ch11ng/exwm/blob/master/xinitrc
          { notification = false; command = "xset r rate 200 60"; }
        ];

      };
    };
  };
}
