# Adminer Setup

Personal, env-driven [Adminer](https://www.adminer.org/) setup. `adminer.php` is
downloaded on demand (never committed), plugins and default login credentials
are controlled through `.env`, so the same repo works across machines.

## Quick start

```bash
./setup.sh          # creates .env, downloads adminer.php, starts server
```

Then open <http://127.0.0.1:8080> — the login form comes pre-filled from `.env`.

Other commands:

```bash
./setup.sh download # (re)download adminer.php
./setup.sh update   # alias for download
```

## Configuration

Copy `.env.example` to `.env` (or let `setup.sh` do it) and edit:

| Variable | Description |
| --- | --- |
| `ADMINER_VERSION` | `latest` or a specific release, e.g. `6.0.0` |
| `DB_HOST` | Prefills the **Server** field (`host` or `host:port` via `DB_PORT`) |
| `DB_PORT` | Port appended to `DB_HOST` |
| `DB_NAME` | Prefills the **Database** field |
| `DB_USER` | Prefills the **Username** field |
| `DB_PASSWORD` | Stored for reference; not prefilled into the form |
| `PLUGIN_PASSWORDLESS` | `true`/`false` — enable login without a DB password |
| `PLUGIN_JSON_PREVIEW` | `true`/`false` — render JSON columns as tables |
| `PLUGIN_DUMP_JSON` | `true`/`false` — add JSON export format |
| `PASSWORDLESS_PASSWORD` | Password accepted by the passwordless plugin (empty = empty password) |

`.env` is gitignored — keep real credentials out of the repo.

## How it works

- `index.php` loads `.env`, injects `DB_*` values into `$_GET` to prefill the
  login form, then requires `adminer.php`.
- `env.php` is a tiny dependency-free dotenv parser (`env()`, `env_bool()`).
- `adminer-plugins.php` is picked up automatically by Adminer; it only
  `require`s plugin files whose flag is enabled and returns the instances.
- Plugin sources live in `plugins/` — deliberately **not** in
  `adminer-plugins/`, because Adminer auto-includes every `.php` in that
  directory, which would bypass the env gating.
- `setup.sh` downloads `adminer.php` from <https://www.adminer.org/latest.php>
  (or a pinned GitHub release) and serves the folder with PHP's built-in
  server.

## Requirements

- PHP CLI with the `mysqli` extension (for MySQL/MariaDB)
- `curl` for downloading Adminer
