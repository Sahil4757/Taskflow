# TaskFlow Agent Guide

## Build & Validate
- **Dev Server**: `pnpm dev`
- **Build**: `pnpm build`
- **Type Check**: `pnpm check` (runs `svelte-check`)
- **Lint**: `pnpm lint` (runs `eslint` and `prettier --check`)
- **Format**: `pnpm format` (runs `prettier --write`)
- **Package Manager**: `pnpm`

## Architecture & Structure
- **Framework**: SvelteKit (Svelte 5) with TypeScript and Vite.
- **Styling**: Tailwind CSS.
- **Backend**: Supabase (`@supabase/supabase-js`) for auth and database.
- **Icons**: `lucide-svelte`.
- **Routing**: File-based routing in `src/routes`.
- **Shared**: `src/lib` for shared components and utilities.
- **Entry**: `src/app.html` and `src/routes/+layout.svelte`.

## Conventions
- **Style**: Follow ESLint and Prettier configs. Run `pnpm format` before committing.
- **Types**: Use TypeScript for all new code. Avoid `any`.
- **Components**: PascalCase for Svelte components (e.g., `MyComponent.svelte`).
- **Imports**: Use `$lib` alias for imports from `src/lib`.
- **CSS**: Use Tailwind utility classes.
- **Auth**: Use Supabase auth UI/helpers.
