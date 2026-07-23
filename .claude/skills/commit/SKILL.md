---
name: commit
description: Create a git commit following this repo's Conventional Commits + gitmoji format enforced by cz-git (.czrc).
disable-model-invocation: true
---

# commit

Stage (if needed) and create a git commit that conforms to this repo's commit
convention: **Conventional Commits with a gitmoji**.

## Format

```
type(scope): :gitmoji: Subject
```

- `type` — the change type. Most commits use `feat` or `fix`. Other Conventional
  Commit types are allowed when they fit: `docs`, `refactor`, `style`, `perf`,
  `test`, `build`, `chore`, `ci`, `revert`.
- `:gitmoji:` — a gitmoji code that matches the type. Common mappings:
  - `feat` → `:sparkles:`
  - `fix` → `:bug:`
  - `docs` → `:memo:`
  - `refactor` → `:recycle:`
  - `perf` → `:zap:`
  - `test` → `:white_check_mark:`
  - `chore` / `build` → `:wrench:` or `:arrow_up:` (dependency bumps)
- `scope` — **optional**. If used, it MUST be one of the allowlisted scopes from
  `.czrc`:
  `colorscheme, command, completion, dashboard, gui, keymap, lsp, lualine,
  option, plugin, py, statusline, telescope, treesitter, ui, win32, vscode`.
- `Subject` — imperative, concise. Capitalized in this repo's history.

## Steps

1. Run `git status` and `git diff --staged` (and `git diff` for unstaged) to see
   what changed. If nothing is staged, review unstaged changes and stage the
   relevant files with `git add`.
2. Run `git log --oneline -10` to match the existing style.
3. Pick `type`, matching `gitmoji`, and an optional allowlisted `scope` based on
   which part of the config changed (e.g. a change under
   `lua/mynvim/plugins/treesitter.lua` → scope `treesitter`).
4. Write the message. For non-trivial changes, add a body explaining the *why*.
5. Commit:
   ```sh
   git commit -m "type(scope): :gitmoji: Subject" [-m "body"]
   ```
6. Show the result with `git log -1 --stat` and confirm it succeeded.

## Notes

- Only commit when the user asks; never push unless asked.
- Do not hand-edit `lazy-lock.json`; if it changed, include it but describe it as
  a dependency/lockfile update.
- If unsure which scope applies or whether to split into multiple commits, ask.
