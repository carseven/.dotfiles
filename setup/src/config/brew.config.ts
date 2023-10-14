// TODO: Remove taps and directly use tap/formula syntax
// Because It will be easier to know which formula pair with each tap
// tap "cmacrae/formulae"
// tap "homebrew/bundle"
// tap "homebrew/cask"
// tap "homebrew/cask-fonts"
// tap "homebrew/core"
// tap "homebrew/services"
// tap "koekeishiya/formulae"
// tap "osx-cross/arm"
// tap "osx-cross/avr"
// tap "qmk/qmk"

export const BREW_PACKAGES: string[] = [
  "bat",
  "fzf",
  "git",
  "lazygit",
  "htop",
  "lsd",
  "mas",
  "neofetch",
  "nvm",
  "fnm",
  "deno",
  "p7zip",
  "starship",
  "stow",
  "tldr",
  "tmux",
  "gitmux",
  "trash",
  "wget",
  "neovim",
  "zsh",
  "qmk/qmk/qmk",
];

export const BREW_CASK_PACKAGES = [
  "alt-tab",
  "authy",
  "bitwarden",
  "brave-browser",
  "discord",
  "dozer",
  "fig",
  "google-drive",
  "wezterm",
  "karabiner-elements",
  "mos",
  "notion",
  "raycast",
  "runjs",
  "spotify",
  "the-unarchiver",
  "visual-studio-code",
  "dbeaver-community",
  "postman",
  "flameshot",
];

export const BREW_FONTS = [
  "font-cascadia-code", // Vscode font
  "font-caskaydia-cove-nerd-font", // Cascadia code nerd font patched
];
