# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [];

  hardware.cpu.intel.updateMicrocode = true;

  boot.plymouth.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest ;
  boot.extraModulePackages = with config.boot.kernelPackages ; [
    bcc

    # TODO: Uncomment when working again!
    #bpftrace

    sysdig
    wireguard
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.systemd-boot.consoleMode = "0";
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/8a54628e-f640-4fa8-9825-e346d132de08";
      preLVM = true;
      allowDiscards = true;
    };
  };

  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    keyMap = "us";
  };

  i18n = {
    defaultLocale = "en_CA.UTF-8";
  };

  time.timeZone = secrets.timeZone;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpi
    curl
    elinks
    file
    git
    gnome3.gnome-tweak-tool
    htop
    iw
    openvpn
    pciutils
    psmisc
    tig
    tmux
    tree
    vim
    wget
    wpa_supplicant # TODO: Remove once iwd working perfectly.
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.slock.enable = true;

  # FIXME: Re-enable when the xonsh package builds properly.
  #programs.xonsh.enable = true;

  # List services that you want to enable:
  services.gpm.enable = true;
  services.gnome3.games.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # wpa_supplicant
  # NOTE: wpa_supplicant was enabled due to DRW EAP-PEAP not being usable without a certificate (that doesn't seem to be provided).
  networking.dhcpcd.enable = false;
  networking.firewall.allowedTCPPorts = [  ];
  networking.firewall.allowedUDPPorts = [  ];
  networking.firewall.enable = true;
  networking.hostName = "luban";
  networking.interfaces.wlp4s0.useDHCP = true;
  networking.useDHCP = false;
  networking.useNetworkd = true;
  networking.usePredictableInterfaceNames = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluezFull;

  # TODO: Get BOSE headphones working (no success yet!)
  # See: https://askubuntu.com/a/833323
  #hardware.bluetooth.extraConfig = ''
  #  [General]
  #  ControllerMode = bredr
  #'';

  # Enable systemd-resolved (DNS).
  services.resolved.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.defaultSession = "gnome";

  services.xserver.desktopManager.gnome3.enable = true;

  services.xserver.windowManager.dwm.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  virtualisation.docker.enable = true;
  #virtualisation.virtualbox.host.enable = true;

  systemd.defaultUnit = "graphical.target";

  security.sudo = secrets.sudo;

  users.users = secrets.users;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?

}
