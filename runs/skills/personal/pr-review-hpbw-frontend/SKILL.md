---
name: pr-review-hpbw-frontend
description: Review a pull request in an HPBW frontend repository, and verify it in a throwaway clone with install, validate, test, CI parity, and a runtime smoke test.
disable-model-invocation: true
---

# Pull request review: HPBW frontend

Extends `pr-review`. Load the `pr-review` skill and follow it unchanged, except for the overrides below. Do not restate its rules here.

## Overrides to `pr-review`

- **Step 7** (permission before running PR code) is replaced by the **Trust gate**. Invoking this skill permits the commands in **Verify**, inside the throwaway clone only, and nothing more.
- Run **Verify** after step 3 and before step 4, so that review step 4 uses execution evidence.
- The last rule of "Finding quality" now reads: claim only what a **Verify** command ran to completion, and quote the command and its exit status.

## Verify

Run the steps in order. Each step ends on its completion criterion. Do not move on before it holds.

### 1. Scope

Run `gh pr view <number> --json number,url,headRefOid,baseRefName,isCrossRepository,mergeable,mergeStateStatus,files,statusCheckRollup`. The repository can be on GitHub Enterprise, so take the host from the PR URL.

Done when you hold the head SHA, base ref, repository URL, and changed file list.

### 2. Trust gate

Stop and ask the user before any install if one of these holds:

- `isCrossRepository` is true (a fork).
- The diff changes an install-time vector: `dependencies`, `devDependencies`, `overrides`, or lifecycle scripts (`preinstall`, `install`, `postinstall`, `prepare`) in `package.json`; a new `resolved` host or `hasInstallScript` in `package-lock.json`; or any `.npmrc*` file.

Show the exact lines and the reason. If the user declines, skip steps 3 to 9. Report only the remote checks from step 7 and list the rest as evidence gaps.

The user's `~/.npmrc` holds a private registry token. Install and test commands run PR-controlled code with access to it. Never print, copy, or edit that file. Never copy `.env` files into the clone.

Done when the gate passes, or the user answers.

### 3. Throwaway clone

```bash
dir="$(mktemp -d -t pr-review-hpbw)"
gh repo clone <repository-url> "$dir/repo"
cd "$dir/repo"
git remote set-url --push origin no-push
git fetch origin "pull/<number>/head"
git checkout --detach <headRefOid>
```

Never use the user's own checkouts (for example under `~/dev/hpbw`). Never push. Run every later command from `$dir/repo`.

Done when `git rev-parse HEAD` equals `headRefOid`. If the PR head moves while you work, restart from step 1.

### 4. Toolchain

Read `engines.node` and `packageManager` in `package.json`, `.nvmrc`, and `node -v`. If the active Node version does not satisfy the range, use an installed or newly installed version (`fnm list`, `fnm install <version>`) and prefix every command with `fnm exec --using=<version> --`.

If `packageManager` pins an npm version that differs from `npm -v`, run npm as `npx --yes npm@<pinned>`. The bundled npm can reject a lockfile that CI accepts (`npm ci` reports `Missing: ... from lock file`).

Done when a satisfying Node version and the pinned npm run, or the mismatch is recorded as an evidence gap and the steps that need them are skipped.

### 5. Install

Run `npm ci`. It matches CI and fails on lockfile drift. If the repository has no lockfile, run `npm install`.

Do not weaken npm settings to pass (`--force`, `--legacy-peer-deps`, `--ignore-scripts`, a lower `min-release-age`). A lockfile out of sync with `package.json` is a finding. A 401, 403, or 404 on the private registry is an environment gap, not a PR defect.

Done when the exit status is 0, or the failure is recorded with its first error lines and the steps that need `node_modules` are skipped.

### 6. Validate and test

Read `scripts` in `package.json`. Do not invent scripts. Write each command's output to `$dir/logs/` and set `CI=true`. Never use watch mode: run a bare `vitest` script as `npx vitest run`. Before you run a tool that reports usage (for example `react-doctor`), read its source in `node_modules` for an opt-out and set it (`REACT_DOCTOR_NO_TELEMETRY=1`, `DO_NOT_TRACK=1`). If you find no opt-out, tell the user before you run it.

1. `npm run validate`. If the script does not exist, say so. Then run the repository's equivalents that do exist among `lint`, `type-check`, `typecheck`, `compile`, and `build`.
2. `npm run test`. Skip it only if the `validate` script already calls `test`, and note that.

If tests fail because Playwright browsers are missing and a `first-test` script exists, run `npx playwright install` once and retry once.

On a failure, run the same command once on the base ref. Use `git checkout --detach origin/<baseRefName>`, and reinstall only if the lockfile differs. Then return to the head SHA.

Done when every command has an exit status, and every failure is attributed to the PR, the base, or the environment, with its first failing error lines.

### 7. CI parity

CI for these repositories runs on Azure DevOps. The definition is in `pipelines/ci.yml` or `pipelines/ci-cd.yml`.

- **Remote**: run `gh pr checks <number>`. Report each check as passed, failed, or pending, with its link. A pending check is not a pass.
- **Local**: read the pipeline file for the enabled stages. Reproduce the stages that run locally, and skip stages that step 6 already covered:
  - lint: `npm run lint`
  - unit tests with coverage: the repository's `test:coverage`, `coverage`, or `test-pipe` script
  - audit: `npm audit`. Count only advisories that the PR introduces.
  - build: `npm run build`
- Stages that cannot run locally (Lokalise Sync, SonarQube, Veracode, Privado AI Scan, version bump) depend on the remote check. Say so.
- **Merge state**: a passing check proves only the commit it ran on. If `mergeStateStatus` is `DIRTY` or `BEHIND`, or the check is older than the base branch's latest commits, run a trial merge in the clone: `git merge --no-commit --no-ff origin/<baseRefName>`. List the conflicted files, and for each one list the base-branch commits that touched it (`git log HEAD..origin/<baseRefName> -- <file>`). If the PR moves or deletes code that the base also changed, check what the base changed. Resolve a conflict the naive way (keep the PR side), reinstall (base dependencies can differ), then run `typecheck` and the tests of the affected folder. Failures here become findings. Run `git merge --abort` afterwards.

Done when every enabled CI stage is labelled passed, failed, pending, or not reproducible, with its source: local run or remote check, and the merge state is checked or recorded as clean.

### 8. Runtime smoke test

Read the diff and the PR description. If no runtime behavior changes (docs, tests, or types only), mark this step not applicable and give the reason.

1. Start the app in the background. Use the `dev`, `serve`, or `start` script, or `preview` after a build. Bind to `127.0.0.1` on a free port. Wait until `curl` gets a response.
2. If the repository has an `api-mock` script, start it and point the app at it. Never use real credentials, tokens, or non-local environments.
3. Drive each changed user flow with the browser tools (Playwright, or Chrome DevTools). Check that the page loads, the flow behaves as the PR describes, there are no new console errors, and no network requests fail for reasons other than a missing backend. Take a screenshot of each changed view.
4. A micro-frontend that is a Module Federation remote (`remoteEntry.js`, no standalone `index.html`) needs a host shell, sign-in, and a backend. Do not connect it to real services. Rely on the production `build` and the component tests, and list the runtime check as an evidence gap.
5. Never run scripts that `npm link`, publish, deploy, or open a browser (for example `shared`, `dev:link`, `publish`, `deploy-lib`, or a `serve` script that ends in `open`). Run the underlying command instead.

Done when each behavior the PR claims to change was exercised, or is listed as an evidence gap with its reason.

### 9. Cleanup

Always run this step, also when earlier steps failed. Stop every process you started with `kill <PID>`. Remove `$dir`, the directory that `mktemp` created, unless the user asked to keep it.

Done when no started process remains and `$dir` no longer exists, or the user asked to keep it.

## Feed the review

- Put a **Verification** table at the top of the draft review. Columns: check, command or source, result, notes. Include the tested head SHA and the Node version.
- A failure caused by the PR becomes an `issue (blocking)` comment. Quote the command and the error excerpt. Anchor it to the narrowest changed line that the error points at. If the error points at no line, make it a review-level comment.
- A failure that exists on the base, or that comes from the environment, becomes a `note`, not an `issue`.
- A passing check produces no comment. It is not proof of correctness. Still complete review steps 4 to 6 on the diff.
- List every skipped step and every evidence gap in the final report, with the reason.
- Steps 8 to 10 of `pr-review` stay unchanged. Verification results never approve or reject a PR by themselves.
