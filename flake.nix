{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

     home-manager = {
       url = "github:nix-community/home-manager/release-24.11";
       inputs.nixpkgs.follows = "nixpkgs";
     };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let 
    system = "x86_64-linux";
    user = "quentin";
    allowed-unfree-packages = ["vscode" "nvidia-x11" "nvidia-settings"];
    pkgs = nixpkgs.legacyPackages.${system};
   
    specialArgs = {inherit allowed-unfree-packages inputs user;};
    extraSpecialArgs = {inherit allowed-unfree-packages user;};

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
