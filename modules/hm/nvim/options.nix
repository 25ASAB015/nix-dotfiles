{pkgs, ...}: {
  globals.mapleader = " ";
  opts = {
    number = true;
    relativenumber = true;

    expandtab = true;
    shiftwidth = 2;
    tabstop = 2;

    undofile = true;
    undodir = "$HOME/.local/state/nvim/undo";

    termguicolors = true;
    signcolumn = "yes";
    updatetime = 250;
    clipboard = "unnamedplus";
  };
}
