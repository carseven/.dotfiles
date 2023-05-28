import $ from "https://deno.land/x/dax@0.31.1/mod.ts";

export async function configSystemShell(shell: string): Promise<void> {
  const isShellOnSystem = await isSystemShell(shell);
  if (!isShellOnSystem) {
    await addToSystemShells(shell);
  } else {
    $.logStep(`[DEBUG] Shell ${shell} is already on /etc/shells`);
  }
  const isCurrentShell = await isCurrentSystemShell(shell);
  if (!isCurrentShell) {
    await setCurrentSystemShell(shell);
  } else {
    $.logStep(`[DEBUG] Shell ${shell} is already current shell`);
  }
}

export async function isSystemShell(shell: string): Promise<boolean> {
  const systemShells = await $`cat /etc/shells`.lines();
  const shellPath = await whichShell(shell);
  return systemShells.some((shell) => shell === shellPath);
}

export function whichShell(shell: string): Promise<string> {
  return $`which ${shell}`.text();
}

export async function isCurrentSystemShell(shell: string): Promise<boolean> {
  const currentShell = await $`echo $SHELL`.quiet().text();
  const shellPath = await whichShell(shell);
  return shellPath === currentShell;
}

export async function addToSystemShells(shell: string): Promise<void> {
  await $`which ${shell} >> /etc/shells"`;
}

export async function setCurrentSystemShell(shell: string): Promise<void> {
  const shellPath = await whichShell(shell);
  await $`chsh -s ${shellPath}`;
}
