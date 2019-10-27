self: super:

let

  pkgGroups = with super.pkgs; {

    CLI = {

      personal = [
        go-4d
        barr
        horeb
        mtlcam

        battery
        goplot
        k3d
        loccount
        s-nail

        # Clone not working ("No user exists for uid").
        # Known issue, see: https://github.com/NixOS/nixpkgs/issues/31762
        #brightness
      ];

      nix = [
        #cachix
        nix-index
        nixops
        nix-bash-completions
        nix-zsh-completions
      ];

      shell = [
        bash_5
        bash-completion
      ];

      utilities = [
        aerc
        ansible
        aria2
        binutils
        davmail
        ed
        elinks
        fdupes
        file
        fortune
        fzf
        gnupg
        gopass
        htop
        influxdb
        iotop
        jq
        lastpass-cli
        libfaketime
        lsof
        mkpasswd
        neovim
        pandoc
        pdfcpu
        pv
        renameutils
        ripgrep
        rlwrap
        sqlite
        telegraf
        tesseract
        tree
        unzip
        utillinux
        weechat
      ];

      financial = [
        beancount
        fava
      ];

      network = [
        bettercap
        caddy
        dnsutils
        iw
        mtr
        nmap
        wireguard-tools
      ];

      backup = [
        adb-sync
        rclone
        restic
        rsync
        syncthing
      ];

      multimedia = [
        alsaLib
        alsaPluginWrapper
        alsaPlugins
        alsaTools
        alsaUtils

        beets
        cmus

        ffmpeg
        fluidsynth
        soundfont-fluid

        mpv
        opusTools
        pulseaudio
        sox
        strawberry
        streamripper
        youtube-dl
        youtube-viewer
      ];

      devtools = [
        fossil
        hugo

        # Go.
        delve
        fly
        gnumake
        gocode
        gogetdoc
        gomodifytags
        gotags
        gotools
        errcheck
        upx

        mkcert
        mr

        # Node.
        nodejs
        now-cli

        postgresql_11

        # Python.
        python37Packages.cookiecutter
        python37Packages.ipython
        python37Packages.poetry

        sbcl
        tig
        universal-ctags
      ];

      # NOTE: VirtualBox is enabled at the system level.
      virt = [
        buildah
        dive
        docker-compose
        kubectl
        kubernetes-helm
        minikube
        packer
        podman
        qemu
        skopeo
        stern
        tinyemu
        vagrant
      ];

    };

    GUI = {

      browsers = [
        browserpass
        chromium
        qutebrowser
        tor-browser-bundle-bin
      ];

      utilities = [
        gcolor3
        libnotify
        mesa
        qrencode
        sent
        wireshark
        xaos
        xorg.xclock
        xorg.xev
        xorg.xeyes
        xorg.xhost
        xorg.xinit
        xorg.xkill
        xscreensaver
        xwinwrap
      ];

      games = [
        dosbox
        nethack
        pokerth
        retroarch
        libretro.fba
        libretro.fceumm
        libretro.genesis-plus-gx
        libretro.mame
        libretro.mupen64plus
        libretro.nestopia
        libretro.prboom
        libretro.snes9x-next
        libretro.stella
      ];

      dev = [
        dbeaver
        vscode
      ];

      # NOTE: Screen locker is configured via system config.
      window_manager = [
        albert
        dmenu
        i3lock
        st
      ];

      office = [
        bluejeans-gui
        bookworm
        calibre
        evince
        libreoffice-fresh
        rdesktop
        slack
        thunderbird-bin
        tectonic
        texlive.combined.scheme-medium
        zathura
      ];

      fonts = [
        fira-code
        font-awesome-ttf
        font-manager
        fontconfig-penultimate
        fontforge-gtk
        go-font
        gtk2fontsel
        inconsolata
        iosevka
        libertine
        monoid
        roboto
        unifont
        unifont_upper
        victor-mono
      ];

      themes = [
        arc-icon-theme
        lxappearance
        # FIXME: re-enable qt5ct when building successfully
        # See issue: https://github.com/NixOS/nixpkgs/issues/71463
        #qt5ct
        qogir-theme
        vanilla-dmz
      ];

      multimedia = [
        audacity
        blender
        digikam
        feh
        flashplayer-standalone
        gimp # gimp-with-plugins didn't compile! 2019-07-07
        imagemagick
        inkscape
        obs-studio
        pavucontrol
        picard
        pulseeffects
        qt5.qtbase
        sxiv
        vlc
      ];

      # FIXME: These apps close immediately on startup (eiffel only?), complaining about GLX.
      broken = [
        baresip
        cool-retro-term
        glxinfo
        zoom-us
      ];

    };

  };
in
  {

    env-demo = super.pkgs.buildEnv {
      name = "env-demo";
      meta.priority = 0;
      paths = with super.pkgs; [ horeb ];
    };

    env-cli = super.pkgs.buildEnv {
      name = "env-cli";
      meta.priority = 0;
      paths = super.lib.lists.flatten (super.lib.attrsets.collect builtins.isList pkgGroups.CLI) ;
    };

    env-gui = super.pkgs.buildEnv {
      name = "env-gui";
      meta.priority = 0;
      paths = super.lib.lists.flatten (super.lib.attrsets.collect builtins.isList pkgGroups.CLI) ;
    };

    env-workstation = super.pkgs.buildEnv {
      name = "env-workstation";
      meta.priority = 0;
      paths =
        super.lib.lists.flatten (super.lib.attrsets.collect builtins.isList pkgGroups.CLI) ++
        super.lib.lists.flatten (super.lib.attrsets.collect builtins.isList pkgGroups.GUI)
        ;
    };

  }