import $ from "dax";
import { Logger } from "../services/logger.service.ts";

export async function createDirectory(
  path: string,
  cwd: string = Deno.env.get("HOME") || "",
  logger: Logger
): Promise<void> {
  try {
    await $`mkdir ${path}`.cwd(cwd).quiet("both");
  } catch (_error) {
    // TODO: Only show if debug mode active
    logger.debug(`Directory ${cwd}/${path} already exist!`);
  }
}
