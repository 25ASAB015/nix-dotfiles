# Hydenix Documentation

Documentation site for Ravn's NixOS Configuration, built with [Starlight](https://starlight.astro.build).

## See It in Action

<div align="center">

<video controls width="100%" style="max-width: 800px; border-radius: 8px;">
  <source src="/nix-dotfiles/324331744-7f8fadc8-e293-4482-a851-e9c6464f5265.mp4" type="video/mp4" />
  Your browser does not support the video tag.
</video>

</div>

## 🚀 Project Structure

This documentation site is built with Astro + Starlight. The structure includes:

```
docs/
├── public/              # Static assets (videos, images, favicons)
├── src/
│   ├── assets/          # Images and other assets
│   ├── content/
│   │   └── docs/        # Documentation pages (.mdx files)
│   └── styles/          # Custom CSS
├── astro.config.mjs     # Astro configuration
├── package.json
└── tsconfig.json
```

Documentation pages are written in `.mdx` format in `src/content/docs/`. Each file is exposed as a route based on its file name.

Static assets like videos and images should be placed in `public/` for direct access.

## 🧞 Commands

All commands are run from the `docs/` directory:

| Command                   | Action                                           |
| :------------------------ | :----------------------------------------------- |
| `npm install`             | Installs dependencies                            |
| `npm run dev`             | Starts local dev server at `localhost:4321`      |
| `npm run build`           | Build your production site to `./dist/`          |
| `npm run preview`         | Preview your build locally, before deploying     |
| `npm run astro ...`       | Run CLI commands like `astro add`, `astro check` |

## 📦 Deployment

This documentation is automatically deployed to GitHub Pages at [25ASAB015.github.io/nix-dotfiles](https://25ASAB015.github.io/nix-dotfiles).

The site is configured with `base: '/nix-dotfiles'` in `astro.config.mjs` to match the GitHub Pages subdirectory structure.

## 👀 Learn More

- [Starlight Documentation](https://starlight.astro.build/)
- [Astro Documentation](https://docs.astro.build)
- [Main Project README](../README.md)
