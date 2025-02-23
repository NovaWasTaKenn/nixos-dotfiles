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
      inputs.obsidian-nvim.follows = "obsidian-nvim"; # <- this will use the obsidian-nvim from your inputs
    };
  };

  outputs = { self, nixpkgs, home-manager, nvf,... }@inputs: let 
    system = "x86_64-linux";
    user = "quentin";
    allowed-unfree-packages = ["nvidia-x11" "nvidia-settings"];
    pkgs = nixpkgs.legacyPackages.${system};
   
    specialArgs = {inherit allowed-unfree-packages inputs user;};
    extraSpecialArgs = {inherit allowed-unfree-packages inputs user;};

  in { 
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
