import $ from "https://deno.land/x/dax@0.31.1/mod.ts";
// deno compile -A setup/index.ts --output install
// Example of use: ./install -d

// TODO: Refactor script configuration and args manipulation to specific file
const isDebugMode = Deno.args.some((arg) => arg === "--debug" || "-d");
if (isDebugMode) {
  $.setPrintCommand(isDebugMode);
}

const os = await $`uname -s`.text();
if (os === "Linux") {
  // TODO: Call specific installation
  $.logStep("[INFO] Running script on Linux...");
} else {
  // TODO: Call specific installation
  $.logStep("[INFO] Running script on MacOS...");
}

const packages = ["neofetch", "htop"];

const installedPackages = await $`brew list`.printCommand(false).lines();
const pb = $.progress("Brew installing packages...");
await pb.with(async () => {
  try {
    await Promise.allSettled(
      packages
        .filter(
          (packageToInstall) =>
            !installedPackages.some(
              (installedPackage) => installedPackage === packageToInstall
            )
        )
        .map((packageToInstall) => {
          return $`brew install ${packageToInstall}`.quiet("both");
        })
    );
  } catch (error) {
    $.logError("[ERROR] Some error installing brew packages");
    $.logError(error);
  }
});
