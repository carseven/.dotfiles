import { Logger } from "./logger.service.ts";

export type TaskStatus = "OK" | "ERROR" | "WARN";

export type TaskResult =
  | {
      status: "OK";
    }
  | {
      status: "WARN";
    }
  | {
      status: "ERROR";
      errorMessage: string;
    };

export const taskOk: TaskResult = { status: "OK" };
export const taskError: (errorMessage: string) => TaskResult = (
  errorMessage: string
) => {
  return {
    status: "ERROR",
    errorMessage,
  };
};

export interface Task {
  name: string;
  showProgress?: boolean;
  action: () => Promise<TaskResult | void>;
}

export class TaskRunner {
  constructor(
    private readonly tasks: Task[],
    private readonly logger: Logger
  ) {}

  public async run(): Promise<void> {
    for (const task of this.tasks) {
      this.logger.info(`[STEP] ${task.name}`);

      // TODO: Add progress
      const result = await task.action();

      if (result?.status === "ERROR") {
        this.logger.error(result.errorMessage);
      }
    }
  }
}
