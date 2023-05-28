import $ from "https://deno.land/x/dax@0.31.1/mod.ts";

export class CliArguments {
  public isDebugMode = false;

  constructor() {
    this.isDebugMode = Deno.args.some((arg) => arg === "--debug" || "-d");
    if (this.isDebugMode) {
      $.setPrintCommand(this.isDebugMode);
    }
  }
}
