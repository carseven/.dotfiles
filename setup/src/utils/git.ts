import $ from "dax";
import { TaskResult, taskError, taskOk } from "../task/task.ts";

export async function cloneRepository(
  url: string,
  cwd: string,
  destinationFolder = ""
): Promise<TaskResult> {
  try {
    await $`git clone ${url} ${destinationFolder}`
      .cwd(cwd || Deno.cwd())
      .quiet();

    return taskOk;
  } catch (error: unknown) {
    return taskError(`${error}`);
  }
}