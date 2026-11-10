# Read-only access (AWS and databases)

**Read-only is the only mode.** Nothing in this skill creates, changes, invokes, publishes, tags or deletes anything in AWS, and nothing writes to a database.
Deployed reality is evidence for the ADR. The Terragrunt in `construction-services-live` and the migrations in `aec_database` are the source of truth for intent.

## AWS

1. Ask the user first, with the question tool: which account and profile to read (default the dev account), and confirm that read-only calls are fine. Skip AWS entirely if the user declines.
2. Run every command through the guard `scripts/aws_ro.py` of this skill. It forwards the command to `aws` only when the operation is `describe-*`, `list-*` or `get-*` and is not on the sensitive list. Otherwise it exits with status 2 and runs nothing.

   ```bash
   python3 <skill-dir>/scripts/aws_ro.py sts get-caller-identity
   python3 <skill-dir>/scripts/aws_ro.py --region us-east-1 sqs get-queue-attributes --queue-url <url> --attribute-names All
   ```

3. Show the user the account from `sts get-caller-identity` before the first read and name it in the ADR evidence.
4. Project only the fields you need with `--query`. The guard requires it for operations that return environment variables, such as `lambda list-functions` and `lambda get-function-configuration`.
5. When the guard refuses, or the answer lives in data (secret values, object content, queue messages, log events, table items), give the user the exact command to run and ask them to paste the output with sensitive values removed. Never work around the guard with another tool.

Useful reads:

| Question | Command |
| --- | --- |
| What does an S3 upload trigger? | `s3api get-bucket-notification-configuration --bucket <b>`, then `sns list-subscriptions-by-topic --topic-arn <t>` |
| Queue behaviour (visibility, DLQ, retention) | `sqs get-queue-attributes --queue-url <u> --attribute-names All` |
| What consumes a queue? | `lambda list-event-source-mappings --event-source-arn <arn>` |
| Async invoke retries and failure destinations | `lambda get-function-event-invoke-config --function-name <f> --qualifier <alias>` |
| Timeouts and memory | `lambda get-function-configuration --function-name <f> --query '[Timeout,MemorySize]'` |
| Event bus rules and targets | `events list-event-buses`, `events list-rules --event-bus-name <b>`, `events list-targets-by-rule --rule <r> --event-bus-name <b>` |
| Alarms and log metric filters | `cloudwatch describe-alarms`, `logs describe-metric-filters` |
| Object tags (not content) | `s3api get-object-tagging --bucket <b> --key <k>` |

## Databases

1. Start with the migrations: `aec_database/changelog.sql` at `origin/main`. Read the changesets for the table in order, because later changesets alter earlier ones. Cite the changeset and line.
2. When the live schema matters (size, indexes, defaults, current columns), ask the user to run read-only statements in their client and paste the results: `SHOW CREATE TABLE <schema>.<table>;`, `SHOW INDEX FROM <schema>.<table>;`, a row count, or an `information_schema` query.
3. Do not connect with credentials yourself, and do not ask for credentials. Every statement you propose is `SELECT`, `SHOW` or `DESCRIBE`.
