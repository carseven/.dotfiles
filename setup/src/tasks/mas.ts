import { $ } from "dax";
import { Logger } from "../services/logger.service.ts";

export async function installMasPackages(
  packages: { name: string; id: number }[],
  logger: Logger
): Promise<void> {
  const pb = $.progress("Mas installing packages...", {
    length: packages.length,
    noClear: true,
  });

  logger.info(`[INFO] Installing ${packages.map((pack) => pack.name)}`);

  try {
    await pb.with(async () => {
      for (const packageToInstall of packages) {
        await $`mas install ${packageToInstall.id}`.quiet();
        pb.increment();
      }
    });
  } catch (error) {
    logger.error("Some error installing MAS packages");
    logger.error(error);
  }
}
