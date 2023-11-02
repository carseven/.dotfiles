import $ from "dax";

export class CliArguments {
  public isDebugMode = false;

  constructor() {
    this.isDebugMode = Deno.args.some((arg) => arg === "--debug" || "-d");
    if (this.isDebugMode) {
      $.setPrintCommand(this.isDebugMode);
    }
  }
}
