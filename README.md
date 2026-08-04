<!-- markdownlint-disable MD013 -->
<!-- Line-length rule off: the tables below have rows that cannot wrap. -->

# Neovim config

A personal fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim),
set up for Python, JavaScript/TypeScript, shell, Markdown, JSON/YAML/TOML and
Docker, with a full git review workflow.

The upstream kickstart README is kept as
[KICKSTART-UPSTREAM.md](KICKSTART-UPSTREAM.md) for reference.

**Leader key is the spacebar.** Below, `<leader>` means space.

---

## Install

```sh
git clone <this-repo> ~/.config/nvim
nvim
```

On first launch lazy.nvim installs every plugin at the versions pinned in
`lazy-lock.json`, Mason installs the language servers, and treesitter compiles
the syntax parsers. It takes a couple of minutes and prints progress. Restart
when it settles.

Then run `:checkhealth` — it should report no errors.

### Requirements

Install these first; the config assumes they exist.

| Needed | Why | macOS | Debian/Ubuntu |
| --- | --- | --- | --- |
| Neovim **0.11+** | Uses the `vim.lsp.config` API | `brew install neovim` | see note below |
| git | Plugin management | preinstalled | `apt install git` |
| `tree-sitter` CLI | Compiles syntax parsers | `brew install tree-sitter-cli` | `npm install -g tree-sitter-cli` |
| Node.js | Six of the language servers are npm packages | `brew install node` | `apt install nodejs npm` |
| Python 3 | pyright and debugpy | preinstalled | `apt install python3 python3-venv` |
| A C compiler | Compiles treesitter parsers | Xcode CLI tools | `apt install build-essential` |
| ripgrep | Fast project-wide search | `brew install ripgrep` | `apt install ripgrep` |
| fd | Fast file finding | `brew install fd` | `apt install fd-find` |
| `make`, `unzip`, `curl` | Building and fetching | preinstalled | `apt install make unzip curl` |

> **The `tree-sitter` CLI is the one people miss.** Without it every syntax
> parser fails to compile and Neovim throws errors on each startup. Note the
> Homebrew formula split: `brew install tree-sitter` gives you only the library.
> You want `tree-sitter-cli`.
>
> **Neovim version on Linux.** Distro packages are usually far too old — Ubuntu
> LTS ships 0.9 or earlier, which cannot run this config. Use the official
> AppImage or tarball from the
> [Neovim releases page](https://github.com/neovim/neovim/releases), or Homebrew
> on Linux.

### Platform notes

**macOS and Linux** — as above, nothing special.

**Windows** — use **WSL**, and treat it as Linux. Everything then behaves
identically to a native Linux install. Native Windows will run, and the Python
interpreter paths are handled for it, but it is a far less tested path: some
Mason packages are Unix-oriented and `shellcheck`/`shfmt` are of limited use.

If you do use WSL, keep this repo on the Linux filesystem (`~/.config/nvim`),
**not** under `/mnt/c/`. Cross-filesystem I/O in WSL is slow enough to make
Telescope and treesitter feel sluggish.

**A VPS or remote box** — works fine. Watch the Neovim version note above, and
be aware the Node-based servers want a few hundred MB of RAM; on a small box you
may want to trim the server list in `init.lua`.

---

## What each language gets

| Filetype | Navigation & types | Formatting | Linting |
| --- | --- | --- | --- |
| Python | pyright | ruff | ruff |
| JavaScript / TypeScript | ts_ls | prettierd | ts_ls |
| Lua | lua_ls | stylua | lua_ls |
| Bash / sh / zsh | bashls | shfmt | shellcheck |
| Markdown | marksman | prettierd | markdownlint |
| JSON | jsonls + SchemaStore | prettierd | schema validation |
| YAML | yamlls + SchemaStore | prettierd | schema validation |
| TOML | taplo | taplo | taplo |
| Dockerfile | dockerls | — | hadolint |
| compose.yaml | compose LS + yamlls | prettierd | compose schema |

SchemaStore means `package.json`, `tsconfig.json`, GitHub Actions workflows and
compose files are validated against their real published schemas — a wrong key
or a wrong type is flagged as you type.

**Python virtualenvs are detected automatically:** an activated venv wins, then
a project-local `.venv/` or `venv/`, then system python. Nothing to activate
before launching.

---

## Finding commands without reading this file

You do not need to memorise any of the below.

| Do this | And you get |
| --- | --- |
| Press `<leader>` and **wait** | which-key shows every key you can press next |
| `<leader>sk` | Fuzzy-search every keymap, by description |
| `<leader>sc` | Fuzzy-search every `:` command |
| `<leader>sh` | Search the full Neovim help |
| `:checkhealth` | Diagnose anything broken |

`<leader>sk` is the real answer to "what was that key again?" — it searches the
descriptions, so typing "hunk" or "rename" finds the mapping.

---

## Finding things

| Keys | Action |
| --- | --- |
| `<leader>sf` | Search **f**iles by name |
| `<leader>sg` | Search by **g**rep — live text search across the project |
| `<leader>sw` | Search the **w**ord under your cursor |
| `<leader>s.` | Recent files |
| `<leader><leader>` | Switch between open buffers |
| `<leader>/` | Fuzzy-find within the current file |
| `<leader>s/` | Grep, but only across open files |
| `<leader>sr` | **R**esume your last search where you left it |
| `<leader>sn` | Browse these config files |
| `<leader>ss` | List every Telescope picker |

Inside a picker: `Ctrl-n`/`Ctrl-p` to move, `Enter` to open, `Esc` to close.

## Navigating code

| Keys | Action |
| --- | --- |
| `grd` | **G**o to **d**efinition |
| `grr` | List all **r**eferences |
| `gri` | Go to **i**mplementation |
| `grt` | Go to **t**ype definition |
| `grD` | Go to **d**eclaration |
| `K` | Hover — docs and type for the symbol under the cursor |
| `gO` | Outline of the current file |
| `grn` | **R**e**n**ame the symbol everywhere |
| `gra` | Code **a**ctions — quick fixes, organise imports |
| `Ctrl-o` / `Ctrl-i` | Jump back / forward through where you have been |
| `gx` | Open the URL or file path under the cursor |

`Ctrl-o` is the one people forget. After `grd` takes you somewhere, `Ctrl-o`
brings you back.

## Errors and warnings

| Keys | Action |
| --- | --- |
| `]d` / `[d` | Next / previous problem in this file |
| `]D` / `[D` | Last / first problem in this file |
| `Ctrl-w d` | Full message for the problem under the cursor |
| `<leader>sd` | Search all problems across the project |
| `<leader>q` | Put this file's problems in a list |
| `gra` | Offer a fix |
| `:TodoTelescope` | Find every TODO / FIXME / HACK |

## Formatting

| Keys | Action |
| --- | --- |
| `<leader>f` | Format the file, or just the selection in visual mode |
| `:ConformInfo` | Show which formatter runs here, and why |

**Formatting deliberately does not run on save.** These formatters rewrite the
whole file, so in a project whose style differs from the default the first save
would produce a huge unrelated diff. To opt in, add a `format_on_save` function
to `opts` in `lua/custom/plugins/formatting.lua`.

## Editing

| Keys | Action |
| --- | --- |
| `gcc` | Comment / uncomment the line |
| `gc` + motion | Comment a range (`gcap` = this paragraph) |
| `sa` + motion + char | **S**urround **a**dd — `saiw"` wraps the word in quotes |
| `sd` + char | **S**urround **d**elete — `sd"` removes quotes |
| `sr` + old + new | **S**urround **r**eplace — `sr"'` turns "x" into 'x' |
| `]<Space>` / `[<Space>` | Add a blank line below / above |
| `Esc` | Also clears search highlighting |

Text objects from mini.ai: `va)` around parens, `ci"` inside quotes, `daf` a
function. Combine with any verb.

## Completion

| Keys | Action |
| --- | --- |
| `Ctrl-n` / `Ctrl-p` | Next / previous suggestion |
| `Ctrl-y` | Accept |
| `Ctrl-Space` | Open the menu, or show docs if open |
| `Ctrl-e` | Dismiss |
| `Ctrl-k` | Toggle signature help |
| `Tab` / `Shift-Tab` | Move between snippet placeholders |

## Files and windows

| Keys | Action |
| --- | --- |
| `\` | Toggle the file tree, revealing the current file |
| `Ctrl-h/j/k/l` | Move focus between splits |
| `:vsplit` / `:split` | Split vertically / horizontally |

## Debugging

| Keys | Action |
| --- | --- |
| `<leader>b` | Toggle a **b**reakpoint |
| `<leader>B` | Conditional breakpoint |
| `F5` | Start / continue |
| `F1` / `F2` / `F3` | Step into / over / out |
| `F7` | Toggle the debugger UI |

Python only (pytest is the configured runner):

| Keys | Action |
| --- | --- |
| `<leader>dm` | Debug the test **m**ethod under the cursor |
| `<leader>dc` | Debug the test **c**lass |
| `<leader>ds` | Debug the visual **s**election |

---

## Git

### What a hunk is

A **diff** is the list of differences between two versions of a file — only the
changed lines, plus a little context.

A **hunk** is one contiguous chunk of that diff. Edit line 10 and line 300 of
the same file and that is *two* hunks; edit lines 10–12 and that is *one*. Hunks
let you review or accept one change at a time instead of the whole file.

**Staging** is git's "shopping basket" step. Work lives in three places:

| Place | Meaning |
| --- | --- |
| Working tree | The files on disk right now |
| Staging area (index) | What you have chosen for the next commit |
| Repository | What you have actually committed |

`git add` moves a change from the first to the second, `git commit` from the
second to the third. The middle step exists so you can commit *some* of your
changes and leave the rest — if you fixed a bug and also renamed a variable, you
can commit them separately.

That is what `<leader>hs` is for: it stages one hunk, not the whole file. Select
lines in visual mode first and it stages only those.

### Reviewing the file you are in

| Keys | Action |
| --- | --- |
| `]c` / `[c` | Next / previous changed hunk |
| `<leader>hp` | **P**review the hunk's diff |
| `<leader>hi` | Same, but **i**nline |
| `<leader>hb` | **B**lame this line, with the commit message |
| `<leader>tb` | **T**oggle always-on **b**lame |
| `<leader>hd` / `<leader>hD` | **D**iff against the index / last commit |
| `<leader>hs` / `<leader>hr` | **S**tage / **r**eset this hunk |
| `<leader>hS` / `<leader>hR` | Stage / reset the whole buffer |

A typical pass: `]c` to the first change, `<leader>hp` to see it, `<leader>hs` to
keep it or `<leader>hr` to drop it, then `]c` onward.

### Reviewing a whole change, and history

| Keys | Action |
| --- | --- |
| `<leader>gd` | **D**iff view — every changed file, side by side |
| `<leader>gm` | Diff your branch against **m**ain — what a reviewer sees |
| `<leader>gl` | **L**og — commit history, with each commit's diff |
| `<leader>gf` | History of this **f**ile |
| `<leader>gq` | **Q**uit the diff view |

In the diff view: `Tab`/`Shift-Tab` for next/previous file, `g?` for all keys.
Left pane is old, right pane is new.

### The git UI

| Keys | Action |
| --- | --- |
| `<leader>gg` | Open Neogit — the status buffer |
| `<leader>gc` | Write a **c**ommit |
| `<leader>gs` | Fuzzy-list changed files |
| `<leader>gb` | Fuzzy-list and switch **b**ranches |
| `<leader>gz` | List stashes |

Neogit is self-documenting: press `?` inside it for every command. The main
ones: `Tab` expands a file's diff, `s`/`u` stage and unstage, `c` then `c`
commits, `p`/`F` push and pull, `q` quits.

### Which to use

- Sanity-check the file I'm in → `]c`, `<leader>hp`
- Review everything before committing → `<leader>gd`
- Stage and commit → `<leader>gg`
- See my branch as a whole → `<leader>gm`
- When and why did this line change → `<leader>gf`, or `<leader>hb`

---

## Maintenance

| Command | What it does |
| --- | --- |
| `:Lazy` | Plugins — `U` update, `S` sync, `x` clean |
| `:Mason` | Servers and tools — `i` install, `X` uninstall |
| `:checkhealth` | Full diagnostic |
| `:LspInfo` | Which servers are attached here |
| `:ConformInfo` | Which formatter runs here |
| `:TSUpdate` | Rebuild syntax parsers |

When something misbehaves: `:checkhealth`, then `:LspInfo` if it is a language
feature, then `:Lazy` to confirm the plugin loaded.

### Rolling back a bad update

`lazy-lock.json` is tracked precisely so this works. After an update that breaks
something:

```sh
git checkout lazy-lock.json
```

then `:Lazy restore` to put every plugin back to the previously pinned commit.

---

## Adding a language

1. In `init.lua`, find `local servers = {` and add a line, e.g. `gopls = {},`
2. Restart — Mason installs it automatically
3. For formatting, add the filetype to `formatters_by_ft` in
   `lua/custom/plugins/formatting.lua`
4. For a linter with no language server, add it to `linters_by_ft` in
   `lua/kickstart/plugins/lint.lua`

---

## Layout

| Path | Contains |
| --- | --- |
| `init.lua` | Options, keymaps, language servers, most plugins |
| `lua/custom/plugins/formatting.lua` | Which formatter per filetype |
| `lua/custom/plugins/git.lua` | Diffview and Neogit |
| `lua/custom/plugins/python.lua` | Python test debugging |
| `lua/kickstart/plugins/lint.lua` | Linters not covered by a server |
| `lua/kickstart/plugins/debug.lua` | Debugger setup |
| `lazy-lock.json` | Pinned plugin versions — **tracked on purpose** |
