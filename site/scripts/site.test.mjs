import assert from 'node:assert/strict';
import { access, readFile, readdir, stat } from 'node:fs/promises';
import path from 'node:path';
import test from 'node:test';
import { fileURLToPath } from 'node:url';

const site = fileURLToPath(new URL('../', import.meta.url));
const repo = path.resolve(site, '..');
const dist = path.join(site, 'dist');
const base = '/.dotfiles/';

async function filesUnder(directory) {
	const entries = await readdir(directory, { withFileTypes: true });
	const files = await Promise.all(entries.map(async (entry) => {
		const target = path.join(directory, entry.name);
		return entry.isDirectory() ? filesUnder(target) : [target];
	}));
	return files.flat();
}

test('the reference documents every exposed entrypoint exactly once', async () => {
	const installers = [];
	for (const entry of await readdir(path.join(repo, 'runs'), { withFileTypes: true })) {
		const relative = path.join('runs', entry.name);
		const candidates = entry.isDirectory()
			? (await readdir(path.join(repo, relative))).map((name) => path.join(relative, name))
			: [relative];
		for (const candidate of candidates) {
			const info = await stat(path.join(repo, candidate));
			if (info.isFile() && (info.mode & 0o111)) installers.push(candidate);
		}
	}
	const shell = (await readdir(path.join(repo, 'shell/scripts'), { withFileTypes: true }))
		.filter((entry) => entry.isFile())
		.map((entry) => `shell/scripts/${entry.name}`);
	const expected = ['install', 'run', 'test', ...installers, ...shell].sort();
	const documented = [];
	for (const reference of ['root-commands', 'installers', 'shell-commands']) {
		const markdown = await readFile(path.join(site, `src/content/docs/reference/${reference}.md`), 'utf8');
		documented.push(...Array.from(markdown.matchAll(/^## `([^`]+)`$/gm), (match) => match[1]));
	}
	assert.equal(new Set(documented).size, documented.length, 'duplicate entrypoint sections');
	assert.deepEqual(documented.sort(), expected);
});

test('all generated local links and assets resolve under the Pages base path', async () => {
	const htmlFiles = (await filesUnder(dist)).filter((file) => file.endsWith('.html'));
	assert.ok(htmlFiles.length >= 10, 'expected documentation home, guides, references, and a 404 page');
	for (const file of htmlFiles) {
		const html = await readFile(file, 'utf8');
		const relative = path.relative(dist, file).split(path.sep).join('/');
		const page = relative === 'index.html' ? base : base + relative.replace(/index\.html$/, '');
		for (const match of html.matchAll(/<(a|link|script|img|source|video|audio|iframe|input)\b[^>]*?\b(?:href|src)="([^"]+)"[^>]*>/g)) {
			// Canonical metadata can describe Starlight's virtual 404 slug, not a navigable route.
			if (match[1] === 'link' && /\brel="canonical"/.test(match[0])) continue;
			const href = match[2].replaceAll('&amp;', '&');
			const url = new URL(href, `https://carseven.github.io${page}`);
			if (url.origin !== 'https://carseven.github.io') continue;
			assert.ok(url.pathname.startsWith(base), `${relative}: link escapes Pages base: ${href}`);
			const destination = decodeURIComponent(url.pathname.slice(base.length));
			let target = path.join(dist, destination);
			const info = await stat(target).catch((error) => {
				assert.fail(`${relative}: broken link ${href}: ${error.message}`);
			});
			if (info.isDirectory()) target = path.join(target, 'index.html');
			await access(target);
			if (url.hash && target.endsWith('.html')) {
				const targetHtml = target === file ? html : await readFile(target, 'utf8');
				const id = decodeURIComponent(url.hash.slice(1));
				const ids = Array.from(targetHtml.matchAll(/\bid="([^"]+)"/g), (item) => item[1]);
				assert.ok(ids.includes(id), `${relative}: missing anchor ${href}`);
			}
		}
	}
});

test('only documentation routes are published', async () => {
	const files = (await filesUnder(dist)).map((file) => path.relative(dist, file));
	for (const file of files) {
		assert.ok(!/(^|\/)(AGENTS\.md|GLOSSARY\.md|docs|adr)(\/|$)/.test(file), file);
		assert.ok(!/(^|\/)blog(\/|$)/.test(file), `removed blog output: ${file}`);
	}
	for (const required of [
		'index.html',
		'guides/setup/index.html',
		'guides/workflows/index.html',
		'guides/customization/index.html',
		'guides/troubleshooting/index.html',
		'guides/windows/index.html',
		'guides/nuphy-air60-v2/index.html',
		'guides/planck-keyboard/index.html',
		'reference/root-commands/index.html',
		'reference/installers/index.html',
		'reference/shell-commands/index.html',
		'reference/skills/index.html',
	]) {
		await access(path.join(dist, required));
	}
});
