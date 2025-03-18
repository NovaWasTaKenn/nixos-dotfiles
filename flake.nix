{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

     home-manager = {
       url = "github:nix-community/home-manager/release-24.11";
       inputs.nixpkgs.follows = "nixpkgs";
     };

     # Required, nvf works best and only directly supports flakes
    nvf = {
      url = "github:notashelf/nvf";

      # You can override the input nixpkgs to follow your system's
      # instance of nixpkgs. This is safe to do as nvf does not depend
      # on a binary cache.
      inputs.nixpkgs.follows = "nixpkgs";
      # Optionally, you can also override individual plugins
      # for example:
      #inputs.obsidian-nvim.follows = "obsidian-nvim"; # <- this will use the obsidian-nvim from your inputs
    };

    nixos-wsl = {
      url ="github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  oututs = { self, nixpkgs, home-manager, nvf, lib, ... }@inputs: let 
    system = "x86_64-linux";# Passer dans dossier profile
    user = "nova";# 
    allowed-unfree-packages = ["nvidia-x11" "nvidia-settings" "obsidian"];
    pkgs = nixpkgs.legacyPackages.${system};
   
    specialArgs = {inherit allowed-unfree-packages inputs user;};
    extraSpecialArgs = {inherit allowed-unfree-packages inputs user;};
    host= "";

  in { 
      homeConfigurations = {
        user = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (./. + "/profiles/users/"+user+".nix") # load home.nix from selected PROFILE
          ];
          extraSpecialArgs = {
            # pass config variables from above
           inherit extraSpecialArgs;
          };
        };
      };

      nixosConfigurations = {
        system = lib.nixosSystem {
          system = system;
          modules = [
            (./. + "/profiles/hosts/"+host+".nix")
          ]; # load configuration.nix from selected PROFILE
          specialArgs = {
            # pass config variables from above
           inherit specialArgs system;
          };
        };
      };

    nixosConfigurations."quentin-desktop" = nixpkgs.lib.nixosSystem {
        inherit specialArgs system;
        
        modules = [
          ./nixos/hosts/quentin-desktop/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./home-manager/users/${user}.nix;
            home-manager.extraSpecialArgs =  extraSpecialArgs;
	        }
        ];
    };
  };
}
