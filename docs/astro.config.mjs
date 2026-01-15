// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	site: 'https://25ASAB015.github.io',
	base: '/nix-dotfiles',
	integrations: [
		starlight({
			title: 'Hydenix Manual',
			customCss: ['./src/styles/custom.css'],
			social: [{ icon: 'github', label: 'GitHub', href: 'https://github.com/25ASAB015/nix-dotfiles' }],
			sidebar: [{ label: 'Manual', slug: '' }],
		}),
	],
});
