{pkgs, ...}: {
  programs.nvf.settings.vim.lazy.plugins = {
    "render-markdown.nvim" = {
      package = pkgs.vimPlugins.render-markdown-nvim;
      setupModule = "render-markdown-nvim";
      cmd = ["RenderMarkdown"];
    };
  };
}
