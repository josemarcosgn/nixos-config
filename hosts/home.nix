{ config, pkgs, ... }:

{

  home.username = "jose";
  home.homeDirectory = "/home/jose";

  home.stateVersion = "24.11";

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "codium";
  };

  programs.home-manager.enable = true;
  
  home.packages = with pkgs; [
    firefox
    flatpak
    gnome-software
    scrcpy
    hunspell
    gsound
    libgda6
    vlc
    wget
    telegram-desktop
    ntfs3g
    ] ++ (with pkgs.gnomeExtensions; [
      blur-my-shell
      tiling-assistant
      rounded-window-corners-reborn
      pano
      tray-icons-reloaded
      vitals
      space-bar
      just-perfection
    ]);
  	
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        # gnome-extensions list for a list
        enabled-extensions = [
        "blur-my-shell@aunetx"
        "tiling-assistant@leleat-on-github"
	"rounded-window-corners@fxgn"
	"pano@elhan.io"
	"trayIconsReloaded@selfmade.pl"
	"Vitals@CoreCoding.com"
	"space-bar@luchrioh"
	"just-perfection-desktop@just-perfection"
        ];
      };
    };
  };
  
  # 
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    shellAliases = {
      v = "nvim";
      ll = "ls -l";
      ls = "exa";
      la = "exa -a";
      grep = "grep --color=auto";
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
      g = "git";
      gs = "git status";
    };
  };
  
  programs.git = {
    enable = true;
    userName  = "josemarcosgn";
    userEmail = "josemarcos.tecno@gmail.com";
  };
  
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;	
    profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-ceintl.vscode-language-pack-pt-br
    ];
  };
}
