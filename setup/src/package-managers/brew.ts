import $ from "https://deno.land/x/dax@0.31.1/mod.ts";
import { OS } from "../definitions.ts";

export async function installBrewPackages(
  packages: string[],
  os: OS
): Promise<void> {
  await installBrewPackageManager(os);

  const installedPackages = await $`brew list`.printCommand(false).lines();
  const packagesToInstall = packages.filter(
    (packageToInstall) =>
      !installedPackages.some(
        (installedPackage) => installedPackage === packageToInstall
      )
  );

  if (packagesToInstall.length === 0) {
    $.logStep("[INFO] No brew packages to install");
    return;
  }

  const pb = $.progress("Brew installing packages...", {
    length: packagesToInstall.length,
    noClear: true,
  });

  try {
    await pb.with(async () => {
      for (const packageToInstall of packagesToInstall) {
        await $`brew install ${packageToInstall}`.quiet();
        pb.increment();
      }
    });
  } catch (error) {
    $.logError("[ERROR] Some error installing brew packages");
    $.logError(error);
  }
}

export async function isBrewInstalled(): Promise<boolean> {
  return (await $`which brew`.quiet().noThrow()).code === 0;
}

export async function installBrewPackageManager(os: OS): Promise<void> {
  try {
    if (await isBrewInstalled()) {
      $.logWarn("[DEBUG] Brew package manager already installed.");
      return;
    }

    const scriptPath = await $.request(
      "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
    )
      .showProgress()
      .pipeToPath();
    await $`NONINTERACTIVE=1 /bin/bash ${scriptPath}`.quiet();

    // TODO: Test on a fresh install
    if (os === "Linux") {
      await $`sh -c eval ${"/home/linuxbrew/.linuxbrew/bin/brew shellenv"}`;
    } else {
      await $`export PATH="/opt/homebrew/bin:$PATH"`.exportEnv();
    }
    await $`rm ${scriptPath}`;
  } catch (error) {
    $.logError(`[ERROR] Installing brew package manager ${error}`);
  }
}
