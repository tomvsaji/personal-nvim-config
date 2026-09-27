# Setting up on a fresh VPS (Debian/Ubuntu)

Copy-paste walkthrough. The requirements table in the [README](../README.md#install)
explains why each tool is needed.

## 1. System packages

```sh
sudo apt update
sudo apt install -y git build-essential make unzip curl ripgrep fd-find \
  python3 python3-venv nodejs npm
```

## 2. Neovim 0.11+

The distro package is too old, so install the official release tarball.
On ARM servers (e.g. Ampere), use `nvim-linux-arm64` in place of `nvim-linux-x86_64`.

```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
nvim --version   # must be 0.11 or newer
```

## 3. tree-sitter CLI

The treesitter `main` branch uses it to compile parsers.

```sh
sudo npm install -g tree-sitter-cli
```

## 4. Clone the config

SSH (needs a key on the VPS added to GitHub):

```sh
git clone git@github.com:tomvsaji/personal-nvim-config.git ~/.config/nvim
```

Or HTTPS, if you don't have a key set up there:

```sh
git clone https://github.com/tomvsaji/personal-nvim-config.git ~/.config/nvim
```

## 5. Install plugins

```sh
nvim --headless "+Lazy! restore" +qa   # plugins at the versions in lazy-lock.json
nvim                                   # Mason installs servers/formatters on first run
```

Restart nvim afterwards and run `:checkhealth`. It should report no errors.

## Notes

- **Icons**: the Nerd Font goes on the machine you SSH *from*. Your local terminal draws the glyphs, not the VPS.
- **tmux**: `vim-tmux-navigator` only does something inside tmux (`sudo apt install tmux`).
- **Optional**: `lazygit` is not required, since Neogit (`<leader>gg`) covers it.

## Updating later

```sh
cd ~/.config/nvim && git pull
nvim "+Lazy restore"
```
