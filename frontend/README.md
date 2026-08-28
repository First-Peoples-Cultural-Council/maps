# fpcc

> First Peoples' Language Map

## Build Setup

This subproject is normally managed by Docker Compose.

To run the frontend directly while the Django backend is available at
`http://localhost:8000`:

```bash
cp .env.local.example .env.local
yarn install --frozen-lockfile
yarn dev:local
```

Open `http://localhost:3000`. Nuxt proxies `/api/` and `/media/` to the URL in
`BACKEND_URL`, keeping browser requests same-origin. Keep backend-only settings
in the repository root `.env`; frontend runtime settings belong in
`.env.local`.

For detailed explanation on how things work, checkout [Nuxt.js docs](https://nuxtjs.org).
