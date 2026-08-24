<!-- markdownlint-disable MD013 -->
<!-- Line-length rule off: table rows cannot wrap. -->

# Neovim config

Fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Leader key
is space; `<leader>` below means space. Upstream README:
[KICKSTART-UPSTREAM.md](KICKSTART-UPSTREAM.md).

## Install

```sh
git clone git@github.com:tomvsaji/personal-nvim-config.git ~/.config/nvim
nvim          # installs plugins, servers and parsers; takes a few minutes
:checkhealth  # after restart, should report no errors
```

| Requirement | Why | macOS | Debian/Ubuntu |
| --- | --- | --- | --- |
| Neovim **0.11+** | `vim.lsp.config` API | `brew install neovim` | AppImage/tarball — distro packages too old |
| git | Plugin management | preinstalled | `apt install git` |
| `tree-sitter` CLI | Compiles parsers | `brew install tree-sitter-cli` | `npm install -g tree-sitter-cli` |
| Node.js | Six servers are npm packages | `brew install node` | `apt install nodejs npm` |
| Python 3 | pyright, debugpy | preinstalled | `apt install python3 python3-venv` |
| C compiler | Compiles parsers | Xcode CLI tools | `apt install build-essential` |
| ripgrep | Project search | `brew install ripgrep` | `apt install ripgrep` |
| fd | File finding | `brew install fd` | `apt install fd-find` |
| `make`, `unzip`, `curl` | Build and fetch | preinstalled | `apt install make unzip curl` |

- `brew install tree-sitter` installs only the library. The CLI is
  `tree-sitter-cli`. Without it, parsers fail and Neovim errors on every startup.
- Ubuntu LTS ships Neovim 0.9 or earlier, which cannot run this config.
- Windows: use WSL. Keep the repo on the Linux filesystem, not `/mnt/c/`.
- VPS: Node-based servers need a few hundred MB RAM; trim `servers` in
  `init.lua` on small boxes.

## Language support

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

- SchemaStore validates `package.json`, `tsconfig.json`, GitHub Actions
  workflows and compose files against their published schemas.
- Python venvs resolve automatically: activated venv, then project `.venv/` or
  `venv/`, then system python.

## Discovery

| Keys | Result |
| --- | --- |
| `<leader>` then wait | which-key lists the next available keys |
| `<leader>sk` | Fuzzy-search all keymaps by description |
| `<leader>sc` | Fuzzy-search all `:` commands |
| `<leader>sh` | Search Neovim help |

## Finding things

| Keys | Action |
| --- | --- |
| `<leader>sf` | Search files by name |
| `<leader>sg` | Live grep across the project |
| `<leader>sw` | Search the word under the cursor |
| `<leader>s.` | Recent files |
| `<leader><leader>` | Switch buffers |
| `<leader>/` | Fuzzy-find in the current file |
| `<leader>s/` | Grep across open files only |
| `<leader>sr` | Resume the last search |
| `<leader>sn` | Browse these config files |
| `<leader>ss` | List all Telescope pickers |

In a picker: `Ctrl-n`/`Ctrl-p` move, `Enter` opens, `Esc` closes.

## Navigating code

| Keys | Action |
| --- | --- |
| `grd` | Go to definition |
| `grr` | List references |
| `gri` | Go to implementation |
| `grt` | Go to type definition |
| `grD` | Go to declaration |
| `K` | Hover: docs and type |
| `gO` | Outline of the current file |
| `grn` | Rename the symbol everywhere |
| `gra` | Code actions |
| `Ctrl-o` / `Ctrl-i` | Back / forward through the jump list |
| `gx` | Open the URL or path under the cursor |

## Errors and warnings

| Keys | Action |
| --- | --- |
| `]d` / `[d` | Next / previous problem in this file |
| `]D` / `[D` | Last / first problem in this file |
| `Ctrl-w d` | Full message for the problem under the cursor |
| `<leader>sd` | Search all problems in the project |
| `<leader>q` | Send this file's problems to a location list |
| `:TodoTelescope` | List TODO / FIXME / HACK comments |

## Formatting

| Keys | Action |
| --- | --- |
| `<leader>f` | Format the file, or the visual selection |
| `:ConformInfo` | Show which formatter runs here |

Does not run on save: formatters rewrite the whole file, producing large
unrelated diffs in projects with a different style. To enable, add
`format_on_save` to `opts` in `lua/custom/plugins/formatting.lua`.

## Completion

| Keys | Action |
| --- | --- |
| `Tab` | Accept the suggestion (the first, if none selected) |
| `Ctrl-y` | Accept |
| `Ctrl-n` / `Ctrl-p` | Next / previous suggestion |
| `Ctrl-Space` | Open the menu, or show docs if open |
| `Ctrl-e` | Dismiss |
| `Ctrl-k` | Toggle signature help |
| `Shift-Tab` | Previous snippet placeholder |
| `Ctrl-f` / `Ctrl-b` | Scroll the docs popup |

`Tab` accepts with the menu open, jumps placeholders inside a snippet, otherwise
inserts a tab (blink `super-tab` preset). Space never accepts.

## Brackets and quotes

nvim-autopairs: typing `(`, `[`, `{`, `"`, `'` inserts the closing half; typing
the closer when it exists steps over it; backspace on an empty pair deletes
both; `Enter` inside a pair opens it into a block. For existing text, use
surround below.

## Files, windows and tmux panes

| Keys | Action |
| --- | --- |
| `\` | Toggle the file tree, revealing the current file |
| `Ctrl-h` / `Ctrl-j` / `Ctrl-k` / `Ctrl-l` | Move left / down / up / right across Neovim splits and tmux panes |
| `Ctrl-\` | Return to the previously active Neovim split or tmux pane |
| `:vsplit` / `:split` | Split vertically / horizontally |

[`vim-tmux-navigator`](https://github.com/christoomey/vim-tmux-navigator)
provides both sets of mappings. Within Neovim it first moves between editor
splits; at an outer edge it asks tmux to select the neighboring pane. Outside
tmux, the same keys continue to work between Neovim splits.

The matching tmux plugin must also be installed. This is already declared in
the [personal tmux config](https://github.com/tomvsaji/personal-tmux-config),
where TPM installs it with `Ctrl-Space I`. Movement is spatial: `Ctrl-h/l`
crosses side-by-side panes, while `Ctrl-j/k` crosses vertically stacked panes.

## Debugging

| Keys | Action |
| --- | --- |
| `<leader>b` | Toggle a breakpoint |
| `<leader>B` | Conditional breakpoint |
| `F5` | Start / continue |
| `F1` / `F2` / `F3` | Step into / over / out |
| `F7` | Toggle the debugger UI |

Python only, runner is pytest:

| Keys | Action |
| --- | --- |
| `<leader>dm` | Debug the test method under the cursor |
| `<leader>dc` | Debug the test class |
| `<leader>ds` | Debug the visual selection |

## Editing

| Keys | Action |
| --- | --- |
| `gcc` | Comment / uncomment the line |
| `gc` + motion | Comment a range (`gcap` = paragraph) |
| `sa` + motion + char | Surround add: `saiw"` wraps the word |
| `sd` + char | Surround delete: `sd"` |
| `sr` + old + new | Surround replace: `sr"'` |
| `]<Space>` / `[<Space>` | Blank line below / above |
| `Esc` | Also clears search highlighting |

### Grammar

**verb + [count] + modifier + object** — e.g. `ci"`, `dap`, `d2aw`, `yi(`.

| Verbs | | Modifiers | |
| --- | --- | --- | --- |
| `c` | change | `i` | inside: contents only |
| `d` | delete | `a` | around: plus delimiters |
| `y` | yank | | |
| `v` | visual select | | |
| `>` / `<` | indent / dedent | | |
| `gu` / `gU` | lower / uppercase | | |

| Objects | |
| --- | --- |
| `w` / `W` | word / WORD (ignores punctuation) |
| `"` `'` `` ` `` | quoted string |
| `(` `)` `b` | parentheses |
| `[` `]` | square brackets |
| `{` `}` `B` | braces |
| `t` | HTML/XML tag |
| `p` | paragraph |
| `f` | function **call** (mini.ai) |
| `a` | argument (mini.ai) |

- `f` is a call, not a definition. On `result = foo(alpha, beta)`, `dif` leaves
  `result = foo()`, `daf` leaves `result =`. Use `am`/`im` for definitions.
- On `alpha`: `cia` changes that argument; `daa` deletes it with its comma but
  leaves `foo( beta)`.

### Treesitter objects

| Keys | Object |
| --- | --- |
| `am` / `im` | Function or method definition / its body |
| `ac` / `ic` | Class / its body |
| `al` / `il` | Loop / its body |
| `]m` / `[m` | Next / previous function start |
| `]M` / `[M` | Next / previous function end |
| `]]` / `[[` | Next / previous class start |
| `<leader>a` / `<leader>A` | Swap this parameter with the next / previous |

`m` not `f`, since mini.ai uses `f` for calls — `dam` deletes a definition,
`cim` replaces a body, `dac` deletes a class. Movement records a jump, so
`Ctrl-o` returns.

`vim.g.no_plugin_maps` is set in
`lua/custom/plugins/treesitter-textobjects.lua`, because the built-in Python,
Ruby, Rust and Go ftplugins map `]m` and `[[` buffer-locally and would shadow
these. Trade-off: Markdown loses its built-in `]]` section jumps.

### Common edits

| Keys | Action |
| --- | --- |
| `ciw` | Change the word under the cursor |
| `ci"` / `ci(` / `ci{` | Change inside quotes / parens / braces |
| `caw` | Change the word and its trailing space |
| `dd` / `yy` | Delete / copy the line |
| `A` / `I` | Append at end / insert at first non-blank |
| `o` / `O` | Open a line below / above |
| `x` / `X` | Delete char under / before the cursor |
| `r<char>` | Replace one character |
| `~` | Toggle case of one character |
| `J` | Join with the next line |
| `.` | Repeat the last change |
| `u` / `Ctrl-r` | Undo / redo |

`.` repeats the last change: `/oldName` `Enter`, `ciw` `newName` `Esc`, then
`n` `.` per occurrence. For a symbol across the project use `grn`, which
understands scope.

### Motions

| Keys | Moves to |
| --- | --- |
| `w` / `b` | Start of next / previous word |
| `e` | End of the current word |
| `0` / `^` / `$` | Start of line / first non-blank / end of line |
| `f<char>` / `F<char>` | Next / previous occurrence on this line |
| `t<char>` | Just before the next occurrence |
| `;` / `,` | Repeat the last `f`/`t` forward / backward |
| `%` | Matching bracket |
| `{` / `}` | Previous / next blank line |
| `gg` / `G` | Top / bottom of file |
| `<n>G` | Line `<n>` |
| `Ctrl-d` / `Ctrl-u` | Half page down / up |
| `zz` | Centre the current line |
| `Ctrl-o` / `Ctrl-i` | Back / forward through the jump list |

Motions work as objects: `d$`, `y%`, `cf,`. Line numbers are relative, so `d5j`
and `9k` read off the gutter.

### Visual mode

`v` characters, `V` lines, `Ctrl-v` block. With `Ctrl-v`: select a column, `I`,
type, `Esc` — inserted on every selected line. In visual mode `>` / `<` indent,
`=` auto-indents, `<leader>f` formats the selection, `<leader>hs` stages it.

### Search and replace

| Command | Action |
| --- | --- |
| `/text` `Enter` | Search forward; `n` / `N` next / previous |
| `*` | Search the word under the cursor |
| `:%s/old/new/g` | Replace in the file |
| `:%s/old/new/gc` | Replace with confirmation |
| `:s/old/new/g` | Current line only |
| `:'<,'>s/old/new/g` | Within the visual selection |

### Undo

`u` / `Ctrl-r`. Undo blocks break at each `Esc`. `:earlier 10m` rewinds the file
ten minutes, `:later` returns.

## Git

A **hunk** is one contiguous chunk of a diff — editing lines 10 and 300 gives
two hunks, editing 10–12 gives one. **Staging** is the intermediate step that
lets you commit some changes and leave others.

| Place | Meaning |
| --- | --- |
| Working tree | Files on disk now |
| Staging area (index) | Chosen for the next commit |
| Repository | Committed |

### Current file

| Keys | Action |
| --- | --- |
| `]c` / `[c` | Next / previous changed hunk |
| `<leader>hp` | Preview the hunk's diff |
| `<leader>hi` | Preview inline |
| `<leader>hb` | Blame this line with its commit message |
| `<leader>tb` | Toggle always-on blame |
| `<leader>hd` / `<leader>hD` | Diff against index / last commit |
| `<leader>hs` / `<leader>hr` | Stage / reset this hunk |
| `<leader>hS` / `<leader>hR` | Stage / reset the buffer |

`<leader>hs` and `<leader>hr` accept a visual selection, staging part of a hunk.

### Whole change and history

| Keys | Action |
| --- | --- |
| `<leader>gd` | Diffview: every changed file, side by side |
| `<leader>gm` | Diff the branch against main |
| `<leader>gl` | Log: commit history with each commit's diff |
| `<leader>gf` | History of this file |
| `<leader>gq` | Quit the diff view |

In the diff view, `Tab`/`Shift-Tab` move between files, `g?` lists all keys.
Left pane old, right new.

### Neogit

| Keys | Action |
| --- | --- |
| `<leader>gg` | Neogit status buffer |
| `<leader>gc` | Write a commit |
| `<leader>gs` | Fuzzy-list changed files |
| `<leader>gb` | Fuzzy-list and switch branches |
| `<leader>gz` | List stashes |

Inside Neogit: `?` lists every command, `Tab` expands a diff, `s`/`u` stage and
unstage, `c` `c` commits, `p`/`F` push and pull, `q` quits.

## Maintenance

| Command | Action |
| --- | --- |
| `:Lazy` | Plugins — `U` update, `S` sync, `x` clean |
| `:Mason` | Servers and tools — `i` install, `X` uninstall |
| `:checkhealth` | Full diagnostic |
| `:LspInfo` | Servers attached to this buffer |
| `:ConformInfo` | Formatter for this buffer |
| `:TSUpdate` | Rebuild syntax parsers |

Roll back a bad plugin update with `git checkout lazy-lock.json` then
`:Lazy restore`.

## Adding a language

1. In `init.lua`, find `local servers = {` and add e.g. `gopls = {},`
2. Restart — Mason installs it
3. Formatting: add the filetype to `formatters_by_ft` in
   `lua/custom/plugins/formatting.lua`
4. Linter with no language server: add to `linters_by_ft` in
   `lua/kickstart/plugins/lint.lua`

## Layout

| Path | Contains |
| --- | --- |
| `init.lua` | Options, keymaps, language servers, most plugins |
| `lua/custom/plugins/formatting.lua` | Formatter per filetype |
| `lua/custom/plugins/git.lua` | Diffview and Neogit |
| `lua/custom/plugins/python.lua` | Python test debugging |
| `lua/custom/plugins/treesitter-textobjects.lua` | Definition objects and movement |
| `lua/kickstart/plugins/lint.lua` | Linters not covered by a server |
| `lua/kickstart/plugins/debug.lua` | Debugger setup |
| `lazy-lock.json` | Pinned plugin versions, tracked deliberately |
