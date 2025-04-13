{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
  };

  outputs = inputs @ {...}: let
    system = "x86_64-linux"; # Passer dans dossier profile / plus simple de laisser ici
    user = "quentin"; # TODO : multi users
    host = "desktop";
    pkgs = inputs.nixpkgs.legacyPackages.${system};

    # Use loops
    nvimConfigs = {
      baseConfig = import ./profiles/baseNvim.nix {
        lib = pkgs.lib;
        pkgs = pkgs;
      };

      dotfilesConfig = import ./profiles/dotfilesNvim.nix {
        lib = pkgs.lib;
        pkgs = pkgs;
      };

      scalaConfig = import ./profiles/scalaNvim.nix {
        lib = pkgs.lib;
        pkgs = pkgs;
      };
      pythonConfig = import ./profiles/pythonNvim.nix {
        lib = pkgs.lib;
        pkgs = pkgs;
      };
    };

    builtNvim = {
      baseNvim = inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [nvimConfigs.baseConfig];
      };
      dotfilesNvim = inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [nvimConfigs.dotfilesConfig];
      };
      scalaNvim = inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [nvimConfigs.scalaConfig];
      };
      pythonNvim = inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [nvimConfigs.pythonConfig];
      };
    };
  in {
    packages.${system} = pkgs.lib.mapAttrs (packageName: packageConfig: packageConfig.neovim) builtNvim;
  };
}
