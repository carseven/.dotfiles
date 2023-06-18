import $ from "dax";
import {
  TaskResult,
  taskError,
  taskOk,
} from "../services/task-runner.service.ts";

// TODO: Test promise all or make it sync
export async function vscodeInstallExtensions(
  extensions: string[]
): Promise<TaskResult> {
  try {
    await Promise.all(
      extensions.map(async (extension) => {
        return await $`code --install-extension ${extension}`.quiet();
      })
    );
    return taskOk;
  } catch (error: unknown) {
    return taskError(`${error}`);
  }
}
