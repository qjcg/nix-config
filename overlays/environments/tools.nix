self: super:

{
  env-tools = super.pkgs.buildEnv {
    name = "env-tools";
    meta.priority = 1;
    paths = with super.pkgs;
      [
        age
        aria2
        bat
        binutils
        caddy
        coreutils
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
        gitAndTools.delta
        gitAndTools.gitui
        gitAndTools.hub
        gnugrep
        gnumake
        gnupg
        gopass
        got
        htop
        imagemagick
        jq
        lastpass-cli
        lefthook
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
        pup
        pv
        rclone
        renameutils
        restic
        ripgrep
        rlwrap
        rsync
        s-nail
        sqlite
        starship
        syncthing
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
      ] ++ lib.optional stdenv.isLinux [
        bettercap
        elinks
        iotop
        iw
        mkpasswd
        pinentry
        psmisc
        tailscale
        utillinux
        wtf
      ] ++ lib.optional stdenv.isDarwin [ pstree ];
  };
}
