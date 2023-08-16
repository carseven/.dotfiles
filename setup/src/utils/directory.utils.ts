import $ from "dax";

export async function createDirectory(
  path: string,
  cwd: string = Deno.env.get("HOME") || "",
): Promise<void> {
  try {
    await $`mkdir ${path}`.cwd(cwd).quiet("both");
  } catch (_error) {
    // TODO: Only show if debug mode active
    $.logWarn(`[DEBUG] Directory ${cwd}/${path} already exist!`);
  }
}
