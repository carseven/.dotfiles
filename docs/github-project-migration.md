# GitHub Project migration

The intended task source is a public, repository-linked GitHub Project named `.dotfiles`.
This is a one-time migration, not a synchronization system.

## Preconditions

The operator needs permission to create repository issues and manage the owner's Project.
GitHub CLI needs the `project` scope:

```bash
gh auth refresh --hostname github.com --scopes project
gh project list --owner carseven --format json
```

Complete authorization in the browser. Do not copy tokens into the repository.
Verify Project listing before changing the README.
If authorization is unavailable, preserve the original roadmap and report the migration as blocked.

## Migrate without losing context

1. Inspect owner Projects and reuse a matching repository-linked `.dotfiles` Project if one exists.
2. Otherwise create it, make it public, and link `carseven/.dotfiles`.
3. Use a Todo, In progress, Done workflow.
4. Check existing issues before creating duplicates.
5. Create one issue per unfinished roadmap bullet. Preserve original wording in the body and add acceptance criteria.
6. Note partial implementation and unresolved behavior explicitly. Do not decide feature behavior during a bookkeeping migration.
7. Add every migrated issue to the Project in Todo, with no automatic assignee or deadline.
8. Re-query the Project and verify all eight issue URLs, repository identity, and status values.
9. Only then replace the README roadmap with the verified Project URL.

Clean-install testing must distinguish Linux containers from macOS runners or virtual machines.
Keep the original goal in its issue while making that platform constraint explicit.

## Completion

A successful issue creation alone does not complete the migration.
All eight issues must exist in the intended Project before removing the source list.
After that point, track work in GitHub only and link to it from documentation.
Do not maintain another roadmap in these internal documents.
