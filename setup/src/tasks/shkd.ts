import $ from "dax";
import {
  TaskResult,
  taskError,
  taskOk,
} from "../services/task-runner.service.ts";

export async function launchSkhdService(): Promise<TaskResult> {
  try {
    await $`skhd --start-service`;
    return taskOk;
  } catch (error: unknown) {
    return taskError(`${error}`);
  }
}
