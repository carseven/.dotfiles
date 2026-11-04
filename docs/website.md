# Website maintenance

The public website uses Astro Starlight for guides and reference documentation.
Its package, lockfile, generated files, and build commands are isolated under [`site/`](../site/).

## Develop

Use Node 24 or newer and npm.
The lockfile is committed. Use `npm ci` for a reproducible installation rather than updating dependencies during routine content work.

From the repository root:

```bash
cd site
npm ci
npm run dev
```

Open `http://localhost:4321/.dotfiles/`.
The development server uses the same base path as GitHub Pages.

## Edit user documentation

Add Markdown or MDX pages in [`site/src/content/docs/`](../site/src/content/docs/).
Each page needs `title` and `description` frontmatter.
Update the explicit sidebar in [`astro.config.mjs`](../site/astro.config.mjs) when adding a navigation entry.

Keep the root README short and link to authoritative public pages.
Check script source rather than copying assumptions from an old guide.
For every entrypoint, document invocation, prerequisites, platform branches, side effects, and known limitations.

Reference headings use the exact source path, for example `` ## `runs/jq` ``.
The site tests compare these headings with the root commands, executable two-level installer inventory,
and shell scripts, including shell files without executable bits.
New or removed entrypoints must change the reference in the same commit.

Use relative links between content routes, accounting for each generated page's trailing slash.
In Astro or MDX expressions, prefix local links and assets with `import.meta.env.BASE_URL`.
Hard-coded `/guides/` links would break beneath the Pages project path.

## Validate

```bash
cd site
npm run check
npm test
```

`check` runs Astro and TypeScript diagnostics.
`test` builds the static site, then uses Node's built-in test runner to check:

- Every exposed entrypoint has exactly one reference section.
- Generated local links, anchors, and linked assets resolve beneath `/.dotfiles/`.
- Internal documentation and removed blog routes do not enter the output.

The tests do not execute workstation installers or follow external links.
Review rendered pages after layout changes, including narrow-screen navigation.
Root `./test` remains a separate shell behavior test suite.

For a local production preview, run `npm run preview` after building.
Generated output lives in `site/dist/` and is ignored by Git.

## Deploy

The [documentation workflow](../.github/workflows/pages.yml) validates pull requests without deployment.
Pushes to `main` and manual runs on `main` upload the built site and deploy through the `github-pages` environment.
GitHub Pages must use **GitHub Actions** as its source.
The intended URL is `https://carseven.github.io/.dotfiles/`.

No deploy token or additional repository secret is required.
The deployment job uses GitHub's Pages and OIDC permissions.
If deployment fails, inspect the workflow run and environment protection rules.
Local validation is not proof of a successful remote deployment.

The existing shell workflow remains independent.
Node dependencies are installed only in the documentation workflow, so shell lint jobs do not scan a website `node_modules` tree.

## Fork or change the address

Update `site` and `base` in Astro configuration, repository/edit links,
and the deployment branch if needed.
Update the base-path expectations in `site/scripts/site.test.mjs` as part of the same change.
Enable Pages on the new repository before expecting a live deployment.
