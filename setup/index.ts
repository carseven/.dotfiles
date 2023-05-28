import $ from "https://deno.land/x/dax@0.31.1/mod.ts";
import {
  BREW_CASK_PACKAGES,
  BREW_PACKAGES as BREW_MACOS_PACKAGES,
} from "./src/config/macos.ts";
import { BREW_PACKAGES as BREW_LINUX_PACKAGES } from "./src/config/linux.ts";
import { installBrewPackages } from "./src/package-managers/brew.ts";
import { createDirectory } from "./src/utils/directory-utils.ts";
import { CliArguments } from "./src/utils/cli-args.ts";
import { Logger } from "./src/utils/logger.ts";
import { configSystemShell } from "./src/utils/shells.ts";
// deno compile -A setup/index.ts --output install
// Example of use: ./install -d

// TODO: Refactor script configuration and args manipulation to specific file
const cliArguments = new CliArguments();
const logger = new Logger(cliArguments.isDebugMode);

const os = await $`uname -s`.text();

// TODO: Builder of async tasks
let tasks: Array<() => Promise<void>> = [];
if (os === "Linux") {
  logger.info("Running script on Linux...");
  const packages = BREW_LINUX_PACKAGES;

  tasks = [
    () => createDirectory("dev"),
    () => installBrewPackages(packages, os),
    () => configSystemShell("zsh"),
    // Git clone repository
    // Git stow repository
    // Git install node (LTS and pnpm)
    // - ansible.builtin.include_tasks: ./ansible-tasks/tmux.yml
  ];
} else if (os === "Macos") {
  // Manually launch macos.sh
  // Maybe detect if updated to last version? And launch

  logger.info("Running script on MacOS...");
  const packages = BREW_MACOS_PACKAGES;
  const caskPackages = BREW_CASK_PACKAGES;

  tasks = [
    () => createDirectory("dev"),
    () => installBrewPackages([...packages, ...caskPackages], os),
    // TODO: Add mas install
    () => configSystemShell("zsh"),
    // Git clone repository
    // Git stow repository (Maybe manually symlink for better project structure and been able to separate OS config files?)
    // Git install node (LTS and pnpm)
    // - ansible.builtin.include_tasks: ./ansible-tasks/node.yml
    // - ansible.builtin.include_tasks: ./ansible-tasks/vscode-extensions.yml
    // - ansible.builtin.include_tasks: ./ansible-tasks/fig.yml
    //  - ansible.builtin.include_tasks: ./ansible-tasks/tmux.yml
    // - ansible.builtin.include_tasks: ./ansible-tasks/yabai.yml
  ];
} else if (os === "Windows") {
  // TODO: Implement script from notion manual scripts
  // Window add autohotkey
}

for (const task of tasks) {
  await task();
}
