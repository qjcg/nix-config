self: super:

{
  env-tools = super.pkgs.buildEnv {
    name = "env-tools";
    meta.priority = 1;
    paths = with super.pkgs;
      [
        age
        annie
        aria2
        bat
        binutils
        bpytop
        caddy
        conform
        coreutils
        croc
        dnsutils
        ed
        exa
        fd
        fdupes
        figlet
        file
        findutils
        fortune
        fzf
        getent
        git
        github-cli
        gitAndTools.delta
        gitAndTools.gitui
        gitAndTools.hub
        gitAndTools.lefthook
        gnugrep
        gnumake
        gnupg
        gopass
        got
        grafterm
        grpcurl
        htop
        imagemagick
        influxdb
        jq
        lastpass-cli
        libfaketime
        loccount
        lsof
        mdbook
        mkcert
        mtr
        neofetch
        nmap
        pandoc
        pdfcpu
        postgresql_12
        pup
        pv
        rclone
        renameutils
        restic
        ripgrep
        rlwrap
        rsync
        s-nail
        shellcheck
        shfmt
        sqlite
        starship
        step-ca
        step-cli
        syncthing
        telegraf
        tig
        tmux
        toilet
        tree
        unzip
        watch
        wireguard-tools
        youtube-dl
        ytop
        zoxide
      ] ++ lib.lists.optionals stdenv.isLinux [
        bettercap
        elinks
        iotop
        iw
        kapacitor
        mkpasswd
        pinentry
        psmisc
        tailscale
        utillinux
        wtf
      ] ++ lib.lists.optionals stdenv.isDarwin [ pstree ];
  };
}
