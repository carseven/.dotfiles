export type TaskStatus = "OK" | "ERROR";

export interface TaskResult {
  status: TaskStatus;
  message?: string;
}

export interface Task {
  action: () => Promise<TaskResult>;
}
