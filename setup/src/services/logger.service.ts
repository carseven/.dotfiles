import $ from "dax";

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

  public debug(message: string): void {
    if (this.isDebugMode) {
      $.logWarn(`[WARN] ${message}`);
    }
  }
}
