{pkgs, ...}: {
  config.vim.lazy.plugins = {
    "render-markdown.nvim" = {
      package = pkgs.vimPlugins.render-markdown-nvim;
      setupModule = "render-markdown-nvim";
      cmd = ["RenderMarkdown"];
      ft = ["markdown"];
    };
    "zoxide.vim" = {
      package = pkgs.vimPlugins.zoxide-vim;
      setupModule = "zoxide-vim";
      cmd = ["Z" "Lz" "Tz" "Zi" "Lzi" "Tzi"];
    };
    "telescope-zoxide" = {
      package = pkgs.vimPlugins.telescope-zoxide;
      setupModule = "telescope-zoxide";
      cmd = ["Telescope zoxide list"];
    };

  };
}
