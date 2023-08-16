import $ from "dax";
import {
  taskError,
  taskOk,
  TaskResult,
} from "../services/task-runner.service.ts";

export async function stowDirectories(
  directories: string[],
  cwd?: string,
): Promise<TaskResult> {
  try {
    // TODO: Check error with existing files (Just remove it)
    // TODO: Test launch script from .dotfiles cloned directory and works properly
    await $`stow ${directories.join(" ")}`.cwd(cwd || Deno.cwd()).quiet();

    return taskOk;
  } catch (error: unknown) {
    return taskError(`${error}`);
  }
}
