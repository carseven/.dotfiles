import { Logger } from "../utils/logger.ts";

export type TaskStatus = "OK" | "ERROR" | "WARN";

// TODO: Refactor type safe, only error should have errorMessage
export interface TaskResult {
  status: TaskStatus;
  errorMessage?: string;
}

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

      if (result?.status === "ERROR" && result.errorMessage) {
        this.logger.error(result.errorMessage);
      }
    }
  }
}
