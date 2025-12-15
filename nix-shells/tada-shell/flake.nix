{
  description = "Django dev shell with Python 3.10, pyodbc, pycairo, zsh, FreeTDS";

  inputs = {
    nixpkgs-unstable = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-25-05.url = "github:NixOS/nixpkgs/nixos-25.05";
    nvimConfigs = {
      url = "github:NovaWasTakenn/nvimConfigs/main";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs @ {...}: let
    system = "x86_64-linux";
    # Main packages from stable 24.11 with GLIBC 2.38+ for compatibility
    pkgs = import inputs.nixpkgs {inherit system;};
    # Newer packages from 25.05 for nvim configs
    pkgs-25-05 = import inputs.nixpkgs-25-05 {inherit system;};
    python = pkgs.python310;
    pythonPackages = pkgs.python310Packages;
  in {
    devShells.${system}.default = pkgs.mkShell {
      name = "tada-nix-shell";

      buildInputs = with pkgs; [
        python
        pythonPackages.pip
        pythonPackages.virtualenv

        gcc
        ninja
        meson
        cmake
        pkg-config

        cairo.dev
        glib.dev
        pango.dev
        gobject-introspection.dev
        libffi.dev
        freetype.dev
        fontconfig.dev
        libpng.dev

        freetds
        unixODBC
        openssl

        pkgs-25-05.azure-cli
        zsh
        # Use nvim from 25.05 with your custom configs
        inputs.nvimConfigs.packages.${system}.pythonNvim
      ];

      shellHook = ''

        source $HOME/.dotfiles/nix-shells/tada-shell/.env

        echo "🎉 Tada! Nix shell initializing... ✨"
        # PKG_CONFIG_PATH for pycairo and other C libraries
        export PKG_CONFIG_PATH=$(for p in \
          ${pkgs.cairo.dev} \
          ${pkgs.glib.dev} \
          ${pkgs.pango.dev} \
          ${pkgs.gobject-introspection.dev} \
          ${pkgs.libffi.dev} \
          ${pkgs.freetype.dev} \
          ${pkgs.fontconfig.dev} \
          ${pkgs.libpng.dev}; do
            echo -n "$p/lib/pkgconfig:"
          done):$PKG_CONFIG_PATH
        echo "🔧 PKG_CONFIG_PATH configured for C libraries"

        # LD_LIBRARY_PATH for unixODBC, libstdc++, FreeTDS
        export LD_LIBRARY_PATH=${pkgs.unixODBC}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.freetds}/lib:$LD_LIBRARY_PATH
        echo "📚 LD_LIBRARY_PATH configured for ODBC & FreeTDS"

        # Create ODBC and FreeTDS environment variables
        export ODBCINI=$projectPath/.shell-env-nixos/odbc.ini
        export ODBCSYSINI=$projectPath/.shell-env-nixos
        export ODBCINSTINI=odbcinst.ini
        export FREETDSCONF=$projectPath/.shell-env-nixos/freetds.conf
        echo "🌐 ODBC environment variables configured"

        echo "📁 Creating ODBC configuration files..."
        # Create odbc and freetds config files
        mkdir -p $ODBCSYSINI

        cat > $ODBCINI <<EOF
        [FreeTDS]
        Driver = FreeTDS
        Server = $dbName.database.windows.net
        Port = 1433
        Database = $dbName-database
        TDS_Version = 7.4
        Encrypt = yes
        EOF

        echo "⚙️  Generating FreeTDS ODBC driver configuration..."
        cat > "$ODBCSYSINI/$ODBCINSTINI" <<EOF
        [FreeTDS]
        Description=FreeTDS
        Driver=${pkgs.freetds}/lib/libtdsodbc.so
        UsageCount=1
        EOF

        cat > $FREETDSCONF <<EOF
        [global]
        tds version = 7.4
        encryption = require

        [$dbName-database]
        host = $dbName.database.windows.net
        database = $dbName-database
        port = 1433
        tds version = 7.4
        encryption = require

        [$dbName.database.windows.net]
        host = $dbName.database.windows.net
        database = $dbName-database
        port = 1433
        tds version = 7.4
        encryption = require
        EOF

        echo "✅ ODBC configuration files created successfully!"
        echo ""
        echo "📍 Working directory: $PWD"
        venvPath=$projectPath/.python-venv-nixos
        # Create venv if not exists
        if [ ! -d $venvPath ]; then
          echo "🐍 Creating Python virtual environment with $(python --version)"
          python -m venv $venvPath
          echo "✅ Virtual environment created at $venvPath"
        else
          echo "♻️  Using existing Python virtual environment"
        fi

        source $venvPath/bin/activate


        alias prs='python manage.py runserver'
        alias pcs='python manage.py collectstatic'
        alias pmm='python manage.py makemigrations'
        alias pmi='python manage.py migrate'

        echo "🔌 Virtual environment activated"

        echo ""
        echo "🎊 Tada! Nix environment setup complete! 🚀"
        echo "🎯 Ready for Django development with FreeTDS support!"

      '';
    };
  };
}
