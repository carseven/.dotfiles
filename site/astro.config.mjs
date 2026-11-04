// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
	site: 'https://carseven.github.io',
	base: '/.dotfiles',
	trailingSlash: 'always',
	integrations: [
		starlight({
			title: '.dotfiles',
			description: 'Understand, adapt, and use a personal macOS and Ubuntu workstation setup.',
			social: [{ icon: 'github', label: 'GitHub', href: 'https://github.com/carseven/.dotfiles' }],
			editLink: { baseUrl: 'https://github.com/carseven/.dotfiles/edit/main/site/' },
			sidebar: [
				{ label: 'Start here', slug: '' },
				{
					label: 'Guides',
					items: [
						{ label: 'Safe setup', slug: 'guides/setup' },
						{ label: 'Daily workflows', slug: 'guides/workflows' },
						{ label: 'Make it yours', slug: 'guides/customization' },
						{ label: 'Troubleshooting and recovery', slug: 'guides/troubleshooting' },
					],
				},
				{
					label: 'Manual setups',
					items: [
						{ label: 'Windows', slug: 'guides/windows' },
						{ label: 'NuPhy Air60 V2', slug: 'guides/nuphy-air60-v2' },
						{ label: 'Planck keyboard', slug: 'guides/planck-keyboard' },
					],
				},
				{
					label: 'Reference',
					items: [
						{ label: 'Root commands', slug: 'reference/root-commands' },
						{ label: 'Installer targets', slug: 'reference/installers' },
						{ label: 'Shell commands', slug: 'reference/shell-commands' },
						{ label: 'Agent skills', slug: 'reference/skills' },
					],
				},
			],
		}),
	],
});
