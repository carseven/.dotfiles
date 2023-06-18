import { $ } from "dax";
import {
  BREW_CASK_PACKAGES,
  BREW_PACKAGES as BREW_MACOS_PACKAGES,
} from "./src/config/macos.ts";
import { installBrewPackages } from "./src/package-managers/brew.ts";
import { createDirectory } from "./src/utils/directory-utils.ts";
import { CliArguments } from "./src/utils/cli-args.ts";
import { Logger } from "./src/utils/logger.ts";
import { configSystemShell } from "./src/utils/shells.ts";
import { cloneRepository } from "./src/utils/git.ts";
import { Task, TaskRunner } from "./src/task/task.ts";

const cliArguments = new CliArguments();
const logger = new Logger(cliArguments.isDebugMode);

const os = await $`uname -s`.text();

let tasks: Task[] = [];
if (os === "Macos") {
  // Add flag for updating macos if not last version
  // Add flag to launch macos config script

  logger.info("Running script on MacOS...");
  const packages = BREW_MACOS_PACKAGES;
  const caskPackages = BREW_CASK_PACKAGES;

  tasks = [
    {
      name: "Create dev directory",
      action: () => createDirectory("dev"),
    },
    {
      name: "Install brew packages",
      action: () => installBrewPackages([...packages, ...caskPackages], os),
    },
    {
      name: "Config zsh shell",
      action: () => configSystemShell("zsh"),
    },
    {
      name: "Install mas packages",
      action: () => Promise.resolve(),
    },
    {
      name: "Clone .dotfiles repository",
      action: () =>
        cloneRepository(
          "https://github.com/carseven/.dotfiles.git",
          Deno.env.get("HOME") || ".",
          ".dotfiles"
        ),
    },
    {
      name: "Stow dotfiles",
      action: () => Promise.resolve(),
    },
    {
      name: "Install node LTS and PNPM",
      action: () => Promise.resolve(),
    },
    {
      name: "Install tmux TPM (Tmux plugin manager)",
      action: () => Promise.resolve(),
    },
    {
      name: "Install vscode extensions",
      action: () => Promise.resolve(),
    },
    {
      // Probably remove, because really need it?
      name: "Config Fig color theme",
      action: () => Promise.resolve(),
    },
    {
      // Probably remove because not using it at the moment
      name: "Config yabai",
      action: () => Promise.resolve(),
    },
  ];
} else {
  logger.warn(`TODO: ${os} still not implemented`);
}

const taskRunner = new TaskRunner(tasks, logger);
await taskRunner.run();
