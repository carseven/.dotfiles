import $ from "https://deno.land/x/dax@0.31.1/mod.ts";

export class Logger {
  private isDebugMode: boolean;
  constructor(isDebugMode: boolean) {
    this.isDebugMode = isDebugMode;
  }

  public info(message: string): void {
    $.logStep(`${message}`);
  }

  public error(message: string): void {
    $.logError(`[ERROR] ${message}`);
  }

  public warn(message: string): void {
    if (this.isDebugMode) {
      $.logWarn(`[WARN] ${message}`);
    }
  }
}
