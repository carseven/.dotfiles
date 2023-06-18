import { $ } from "dax";
import {
  BREW_CASK_PACKAGES,
  BREW_FONTS,
  BREW_PACKAGES as BREW_MACOS_PACKAGES,
} from "./src/config/brew.config.ts";
import { installBrewPackages } from "./src/tasks/brew.ts";
import { createDirectory } from "./src/utils/directory.utils.ts";
import { CliArguments } from "./src/services/cli-args.service.ts";
import { Logger } from "./src/services/logger.service.ts";
import { configSystemShell } from "./src/utils/shells.utils.ts";
import { cloneRepository } from "./src/utils/git.utils.ts";
import { Task, TaskRunner } from "./src/services/task-runner.service.ts";
import { vscodeInstallExtensions } from "./src/tasks/vscode.ts";
import { VSCODE_EXTENSIONS } from "./src/config/vscode.config.ts";

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
      action: () =>
        installBrewPackages([...packages, ...caskPackages, ...BREW_FONTS], os),
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
      // TODO: No currently on my workflow
      name: "Install tmux TPM (Tmux plugin manager)",
      action: () => Promise.resolve(),
    },
    {
      name: "Install vscode extensions",
      action: () => vscodeInstallExtensions(VSCODE_EXTENSIONS),
    },
    {
      // TODO: No currently on my workflow
      name: "Config yabai",
      action: () => Promise.resolve(),
    },
  ];
} else {
  logger.warn(`TODO: ${os} still not implemented`);
}

const taskRunner = new TaskRunner(tasks, logger);
await taskRunner.run();
