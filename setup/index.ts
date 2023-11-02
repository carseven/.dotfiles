import { $ } from "dax";
import {
  BREW_CASK_PACKAGES,
  BREW_FONTS,
  BREW_PACKAGES as BREW_MACOS_PACKAGES,
} from "./src/config/brew.config.ts";
import { MAS_PACKAGES } from "./src/config/mas.config.ts";
import { STOW_DIRECTORIES } from "./src/config/stow.config.ts";
import { VSCODE_EXTENSIONS } from "./src/config/vscode.config.ts";
import { CliArguments } from "./src/services/cli-args.service.ts";
import { Logger } from "./src/services/logger.service.ts";
import { Task, TaskRunner } from "./src/services/task-runner.service.ts";
import { installBrewPackages } from "./src/tasks/brew.ts";
import { installMasPackages } from "./src/tasks/mas.ts";
import { launchSkhdService } from "./src/tasks/shkd.ts";
import { stowDirectories } from "./src/tasks/stow.ts";
import { vscodeInstallExtensions } from "./src/tasks/vscode.ts";
import { createDirectory } from "./src/utils/directory.utils.ts";
import { cloneRepository } from "./src/utils/git.utils.ts";
import { configSystemShell } from "./src/utils/shells.utils.ts";

const cliArguments = new CliArguments();
const logger = new Logger(cliArguments.isDebugMode);

const os = await $`uname -s`.text();

let tasks: Task[] = [];
if (os === "Darwin") {
  logger.info("[INFO] Running script on MacOS...");
  const packages = BREW_MACOS_PACKAGES;
  const caskPackages = BREW_CASK_PACKAGES;

  tasks = [
    {
      name: "Create dev directory",
      action: () => createDirectory("dev", undefined, logger),
    },
    {
      name: "Install brew packages",
      action: () =>
        installBrewPackages(
          [...packages, ...caskPackages, ...BREW_FONTS],
          os,
          logger
        ),
    },
    {
      name: "Config zsh shell",
      action: () => configSystemShell("zsh", logger),
    },
    {
      name: "Install mas packages",
      action: () => {
        return installMasPackages(MAS_PACKAGES, logger);
      },
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
      action: async () => await stowDirectories(STOW_DIRECTORIES),
    },
    {
      name: "Install vscode extensions",
      action: () => vscodeInstallExtensions(VSCODE_EXTENSIONS),
    },
    {
      name: "Start skhd service",
      action: launchSkhdService,
    },
  ];
} else {
  logger.debug(`TODO: ${os} still not implemented`);
}

const taskRunner = new TaskRunner(tasks, logger);
await taskRunner.run();
