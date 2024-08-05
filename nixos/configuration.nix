{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./luks.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = ["https://devenv.cachix.org"];
  nix.settings.trusted-users = ["root" "nixos"];
  nix.settings.extra-trusted-public-keys = ["devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="];
  nixpkgs.config.allowUnfree = true;

  # Weitere Konfigurationen
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos";
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
  services.xserver.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
  console.keyMap = "de";
  services.printing.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  users.users.nix = {
    isNormalUser = true;
    description = "nix";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [];
  };
  fonts.packages = with pkgs; [ corefonts ];
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "nix";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    nextcloud-client
    gnome.nautilus-python
    remmina
    chromedriver
    fish
    unstable.neovim
    python3Full
    git
    btop
    element-desktop
    whois
    gnumake
    tdrop
    nodejs_20
    nerdfonts
    vim
    intel-media-driver
    auto-cpufreq
    touchegg
    xclip
    ocs-url
    fira-code
    libinput
    gnomeExtensions.x11-gestures
    gnome-extension-manager
    gnome.gnome-shell-extensions
    gnome.gnome-tweaks
    gnome.gnome-themes-extra
    gnomeExtensions.thinkpad-battery-threshold
    gnome-browser-connector
    gnomeExtensions.blur-my-shell
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.just-perfection
    gnomeExtensions.search-light
    gnomeExtensions.space-bar
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.logo-menu
    gnomeExtensions.pop-shell
    gnomeExtensions.gsconnect
    neofetch
    docker
    gcc
    appimage-run
    home-manager
    onlyoffice-bin
    p7zip
    gnome.gnome-boxes
    unstable.lunarvim
    usbutils
    fprintd
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    libimobiledevice
    vmware-workstation
    tor-browser
    libsForQt5.polonium
  ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    lua-language-server
    rust-analyzer
    tailwindcss-language-server
    djlint
  ];
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime
      onevpl-intel-gpu
      intel-media-sdk
    ];
  };
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user="nix";
  };
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  };
  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };
  virtualisation.vmware.guest.enable = true;
  virtualisation.vmware.host.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  programs.kdeconnect = { enable = true; package = pkgs.gnomeExtensions.gsconnect; };
  services.touchegg.enable = true;
  services.mullvad-vpn.enable = true;
  users.users.nix.shell = pkgs.fish;
  programs.fish.enable = true;
  services.openssh.enable = true;
  virtualisation.docker.enable = true;
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
  '';
  networking.firewall.allowedTCPPorts = [ 80 443 1401 5000 ];
  networking.firewall.allowedUDPPorts = [ 53 1194 1195 1196 1197 1300 1301 1302 1303 1400 5000 ];
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  system.stateVersion = "24.05";
}
