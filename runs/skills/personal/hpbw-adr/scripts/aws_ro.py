#!/usr/bin/env python3
"""Run an `aws` command only when it is a read-only operation.

Usage: aws_ro.py [aws options] <service> <operation> [arguments]

Allowed: `describe-*`, `list-*`, `get-*` operations and `s3 ls`, minus a list of
operations that return secrets, credentials or stored data. Everything else exits
with status 2 and runs nothing. The guard protects against accidents. It is not a
sandbox, so keep using a read-only profile where one exists.
"""

import os
import shutil
import subprocess
import sys

VALUE_OPTIONS = {
    "--profile",
    "--region",
    "--output",
    "--query",
    "--color",
    "--cli-read-timeout",
    "--cli-connect-timeout",
}
FLAG_OPTIONS = {"--no-cli-pager", "--no-paginate"}
FORBIDDEN_OPTIONS = {"--debug", "--endpoint-url", "--no-verify-ssl", "--no-sign-request"}

READ_PREFIXES = ("describe-", "list-", "get-")
EXTRA_ALLOWED = {("s3", "ls")}

# Operations that return secrets, credentials, stored data or code locations.
SENSITIVE_OPERATIONS = {
    "get-secret-value",
    "get-parameter",
    "get-parameters",
    "get-parameters-by-path",
    "get-parameter-history",
    "get-object",
    "get-object-torrent",
    "get-login-password",
    "get-authorization-token",
    "get-credential-report",
    "get-password-data",
    "get-session-token",
    "get-federation-token",
    "get-function",
    "get-layer-version",
    "get-layer-version-by-arn",
    "get-item",
    "get-records",
    "get-shard-iterator",
    "get-log-events",
    "get-log-record",
    "get-query-results",
}

# Operations whose full output includes environment variables: the caller must project fields.
REQUIRE_QUERY = {
    ("lambda", "list-functions"),
    ("lambda", "get-function-configuration"),
    ("lambda", "list-versions-by-function"),
    ("ecs", "describe-task-definition"),
    ("elasticbeanstalk", "describe-configuration-settings"),
}


class Refusal(Exception):
    pass


def option_name(token):
    return token.split("=", 1)[0]


def check(args):
    """Raise Refusal unless `args` is an allowed read-only aws command."""
    positional = []
    has_query = False
    i = 0
    while i < len(args):
        token = args[i]
        name = option_name(token)
        if name in FORBIDDEN_OPTIONS:
            raise Refusal(f"option {name} is not allowed")
        if name == "--query":
            has_query = True
        if token.startswith("--"):
            if name in VALUE_OPTIONS:
                if "=" not in token:
                    i += 1
            elif name not in FLAG_OPTIONS and len(positional) < 2:
                raise Refusal(f"unknown option {name} before the operation")
        elif len(positional) < 2:
            positional.append(token)
        i += 1

    if len(positional) < 2:
        raise Refusal("expected '<service> <operation>'")
    service, operation = positional
    if (service, operation) not in EXTRA_ALLOWED:
        if not operation.startswith(READ_PREFIXES):
            raise Refusal(f"'{service} {operation}' is not a describe, list or get operation")
        if operation in SENSITIVE_OPERATIONS:
            raise Refusal(f"'{operation}' can return secrets or stored data")
    if (service, operation) in REQUIRE_QUERY and not has_query:
        raise Refusal(f"'{service} {operation}' needs --query to project the fields you need")


def main(argv):
    try:
        check(argv)
    except Refusal as error:
        print(f"aws_ro: refused: {error}. Give the command to the user to run.", file=sys.stderr)
        return 2
    aws = shutil.which("aws")
    if aws is None:
        print("aws_ro: the aws CLI is not on PATH", file=sys.stderr)
        return 127
    return subprocess.call([aws, *argv], env={**os.environ, "AWS_PAGER": ""})


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
