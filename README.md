# dotfiles

Personal dotfiles managed with [chezmoi](https://github.com/twpayne/chezmoi).
One repo, four environments, three levels. Each machine gets the config and
tools that fit its role.

Repo: <https://github.com/USFAkbari/dotfiles>

- **Environments** (`CHEZMOI_ENV`): `desktop`, `server`, `vm`, `work`
- **Levels** (`CHEZMOI_LEVEL`): `simple` (default), `medium`, `high`. Each level includes the one before it.

---

## Contents

- [Quick start](#quick-start)
- [Choosing environment and level](#choosing-environment-and-level)
- [What each environment gets](#what-each-environment-gets)
- [What each level adds](#what-each-level-adds)
- [Tool reference](#tool-reference)
- [Shell setup](#shell-setup)
- [Updating and day-to-day use](#updating-and-day-to-day-use)
- [Repository layout](#repository-layout)
- [Secrets policy](#secrets-policy)
- [Troubleshooting](#troubleshooting)
- [Testing this repo](#testing-this-repo)

---

## Quick start

Requirements:

- Ubuntu or Debian (apt), or macOS (Homebrew installed first: <https://brew.sh>)
- `git`, `curl`, and `sudo` on Linux (only the apt step needs root)

Install chezmoi with the [official install docs](https://www.chezmoi.io/install/),
then init from this repo. Pick your environment and level:

```bash
CHEZMOI_ENV=server CHEZMOI_LEVEL=medium chezmoi init --apply USFAkbari/dotfiles
```

Afterwards, restart your shell (or run `exec zsh`).

Dry run first, to see what would change without installing anything:

```bash
CHEZMOI_ENV=desktop CHEZMOI_LEVEL=simple chezmoi init USFAkbari/dotfiles
chezmoi diff
```

---

## Choosing environment and level

Both values are read **once, at `chezmoi init`**, and saved in
`~/.config/chezmoi/chezmoi.toml`. To change them later, run `chezmoi init`
again with new values.

| Variable | Values | Default |
|---|---|---|
| `CHEZMOI_ENV` | `desktop`, `server`, `vm`, `work` | `desktop` |
| `CHEZMOI_LEVEL` | `simple`, `medium`, `high` | `simple` |

Invalid values stop `chezmoi init` with a message such as
`Invalid CHEZMOI_LEVEL="ultra". Valid values: simple, medium, high`.

Example, a Linux server that should get the dev tools:

```bash
CHEZMOI_ENV=server CHEZMOI_LEVEL=medium chezmoi init --apply USFAkbari/dotfiles
```

---

## What each environment gets

| Environment | Intended for | Extra packages | Config specifics |
|---|---|---|---|
| `desktop` | Laptop or workstation with a GUI | rofi, xsel, xclip, wl-clipboard, keyutils | wezterm and rofi configs, Hack Nerd Font, Bitwarden rofi menu |
| `server` | Headless servers reached over SSH | tmux, fail2ban, openssh-server, mosh, ncdu | SSH login auto-attaches to tmux session `main`; `P10K_ASCII` fallback |
| `vm` | Virtual machines | Same as server, plus qemu-guest-agent and spice-vdagent | Same as server |
| `work` | Work machine | None extra | Commented proxy placeholders in `~/.zshrc`; no personal GUI tools |

Notes:

- `rofi` and `wezterm` configs are deployed **only** on `desktop`.
- `tmux` is installed on server and vm at every level (needed for SSH auto-attach). On desktop it arrives at `medium`.
- `work` has no separate git identity yet. Add one by hand or extend the templates.

---

## What each level adds

Each level includes everything from the level below it.

### `simple` (all environments)

Base system packages: `zsh git curl wget unzip jq tree`

Terminal tools: `bat fd ripgrep eza zoxide atuin git-delta tealdeer fastfetch`

Zsh plugins: `zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search zsh-bat zsh-completions fzf-tab`, plus oh-my-zsh `git npm node sudo extract fzf`.

### `medium` (adds)

Tools: `mise uv gh lazygit lazydocker k9s direnv just yq neovim zellij yazi shellcheck tmux`

Docker CLI only (no daemon): `docker-cli` on Ubuntu/Debian when available, otherwise `docker.io`. On macOS, the `docker` formula.

Zsh plugins: oh-my-zsh `docker docker-compose kubectl gh`

### `high` (adds)

Tools: `btop dust duf procs hyperfine glow trippy difftastic tokei`

Zsh plugins: `you-should-use zsh-autopair`

---

## Tool reference

Every tool links to its upstream project. Usage notes are short; check each
project's docs for full options.

### Shell and navigation

| Tool | Level | What it does | Source |
|---|---|---|---|
| zsh | simple | Shell this config targets | <https://www.zsh.org> |
| oh-my-zsh | all | Zsh framework that loads plugins and themes | <https://github.com/ohmyzsh/ohmyzsh> |
| Powerlevel10k | all | Fast prompt theme (`p10k configure` to change it) | <https://github.com/romkatv/powerlevel10k> |
| fzf | all | Fuzzy finder. `Ctrl-T` files, `Ctrl-R` history, `Alt-C` cd | <https://github.com/junegunn/fzf> |
| zoxide | simple | Smarter `cd`. `z proj` jumps to the most-used matching folder | <https://github.com/ajeetdsouza/zoxide> |
| atuin | simple | Searchable shell history. Takes over `Ctrl-R` | <https://github.com/atuinsh/atuin> |
| direnv | medium | Loads per-project environment variables on `cd` | <https://github.com/direnv/direnv> |
| mise | medium | Version manager for node, python, go and others (`mise use node@22`) | <https://github.com/jdx/mise> |
| just | medium | Command runner. A `justfile` in a project defines its commands | <https://github.com/casey/just> |

### Files and search

| Tool | Level | What it does | Source |
|---|---|---|---|
| bat | simple | `cat` with syntax highlighting. Aliased as `cat` | <https://github.com/sharkdp/bat> |
| eza | simple | `ls` with icons and git status. Aliased as `ls` | <https://github.com/eza-community/eza> |
| fd | simple | Fast `find` replacement. Used by fzf defaults | <https://github.com/sharkdp/fd> |
| ripgrep (`rg`) | simple | Fast recursive grep | <https://github.com/BurntSushi/ripgrep> |
| tree | simple | Directory tree listing | <http://mama.indstate.edu/users/ice/tree/> |
| jq | simple | JSON query and transform | <https://github.com/jqlang/jq> |
| yq | medium | Same idea as jq, for YAML | <https://github.com/mikefarah/yq> |
| yazi | medium | Terminal file manager with previews | <https://github.com/sxyazi/yazi> |
| tokei | high | Counts lines of code by language | <https://github.com/XAMPPRocky/tokei> |

### Git and development

| Tool | Level | What it does | Source |
|---|---|---|---|
| git-delta (`delta`) | simple | Readable side-by-side diffs | <https://github.com/dandavison/delta> |
| difftastic | high | Diff that understands code structure | <https://github.com/Wilfred/difftastic> |
| gh | medium | GitHub CLI: PRs, issues, releases from the terminal | <https://github.com/cli/cli> |
| lazygit | medium | Terminal UI for git | <https://github.com/jesseduffield/lazygit> |
| uv | medium | Fast Python package and project manager | <https://github.com/astral-sh/uv> |
| shellcheck | medium | Lints shell scripts | <https://github.com/koalaman/shellcheck> |
| neovim | medium | Editor. Config lives in `~/.config/nvim` (LazyVim-based) | <https://github.com/neovim/neovim> |
| hyperfine | high | Benchmarks commands with statistics | <https://github.com/sharkdp/hyperfine> |

### Containers and Kubernetes

| Tool | Level | What it does | Source |
|---|---|---|---|
| docker CLI | medium | Docker client only (no daemon) | <https://docs.docker.com/cli/> |
| lazydocker | medium | Terminal UI for Docker | <https://github.com/jesseduffield/lazydocker> |
| kubectl | medium | Kubernetes CLI | <https://kubernetes.io/docs/reference/kubectl/> |
| k9s | medium | Terminal UI for Kubernetes | <https://github.com/derailed/k9s> |

### Terminal multiplexers

| Tool | Level | What it does | Source |
|---|---|---|---|
| tmux | server, vm (all levels); desktop from medium | Multiplexer. Config in `~/.config/tmux/tmux.conf`. Prefix `Ctrl-b`. SSH login attaches to `main` | <https://github.com/tmux/tmux> |
| zellij | medium | Multiplexer with layouts and keybind hints. Default program in wezterm | <https://github.com/zellij-org/zellij> |

### Monitoring and system

| Tool | Level | What it does | Source |
|---|---|---|---|
| fastfetch | simple | System info summary at a glance | <https://github.com/fastfetch-cli/fastfetch> |
| tealdeer (`tldr`) | simple | Short command examples, e.g. `tldr tar` | <https://github.com/dbrgn/tealdeer> |
| btop | high | Resource monitor (CPU, memory, disks, network) | <https://github.com/aristocratos/btop> |
| dust | high | Disk usage as a tree | <https://github.com/bootandy/dust> |
| duf | high | Readable `df` | <https://github.com/muesli/duf> |
| procs | high | Readable `ps` | <https://github.com/dalance/procs> |
| trippy | high | Live network path diagnosis (traceroute and ping) | <https://github.com/fujiapple852/trippy> |
| glow | high | Renders Markdown in the terminal | <https://github.com/charmbracelet/glow> |
| ncdu | server, vm | Interactive disk usage browser | <https://dev.yorhel.nl/ncdu> |

### Remote access and security (server and vm)

| Tool | Level | What it does | Source |
|---|---|---|---|
| openssh-server | server, vm | SSH daemon | <https://www.openssh.com/> |
| mosh | server, vm | SSH replacement that survives network changes | <https://github.com/mobile-shell/mosh> |
| fail2ban | server, vm | Bans IPs after repeated failed logins | <https://github.com/fail2ban/fail2ban> |
| qemu-guest-agent | vm | Lets the host shut down or snapshot the VM cleanly | <https://www.qemu.org/docs/master/interop/qemu-ga.html> |
| spice-vdagent | vm | Clipboard and resolution sharing with SPICE displays | <https://www.spice-space.org/> |

### Desktop only

| Tool | What it does | Source |
|---|---|---|
| wezterm | Terminal emulator. Config in `~/.config/wezterm`. **Not installed by this repo**; install it yourself | <https://github.com/wez/wezterm> |
| rofi | Application launcher and menus. Configs in `~/.config/rofi` | <https://github.com/davatorium/rofi> |
| xsel, xclip, wl-clipboard | Clipboard access for X11 and Wayland | <https://github.com/kfish/xsel> |
| Hack Nerd Font | Icon font for the p10k prompt. Installed to `~/.local/share/fonts/NerdFonts` (Linux) or `~/Library/Fonts` (macOS) | <https://github.com/ryanoasis/nerd-fonts> |
| bitwarden-rofi (`bwmenu`) | Rofi menu for Bitwarden. Pinned to a known commit | <https://github.com/mattydebie/bitwarden-rofi> |

### Secrets tooling (all environments)

| Tool | What it does | Source |
|---|---|---|
| Bitwarden CLI (`bw`) | Password vault from the terminal. Installed to `~/.local/bin` | <https://bitwarden.com/help/cli/> |

### Zsh plugins

| Plugin | Level | What it does | Source |
|---|---|---|---|
| zsh-autosuggestions | simple | Grey suggestions from history as you type. `→` accepts | <https://github.com/zsh-users/zsh-autosuggestions> |
| zsh-syntax-highlighting | simple | Colors commands as valid or invalid | <https://github.com/zsh-users/zsh-syntax-highlighting> |
| zsh-history-substring-search | simple | Up/Down arrows search history by what you typed | <https://github.com/zsh-users/zsh-history-substring-search> |
| zsh-bat | simple | Uses bat for `man` and help pages | <https://github.com/fdellwing/zsh-bat> |
| zsh-completions | simple | Extra completion definitions for many commands | <https://github.com/zsh-users/zsh-completions> |
| fzf-tab | simple | Tab completion becomes a fuzzy-search menu | <https://github.com/Aloxaf/fzf-tab> |
| sudo (omz) | simple | Press `Esc Esc` to prefix the current line with `sudo` | <https://github.com/ohmyzsh/ohmyzsh> |
| extract (omz) | simple | `extract file.tar.gz` unpacks any archive | <https://github.com/ohmyzsh/ohmyzsh> |
| docker, docker-compose, kubectl, gh (omz) | medium | Completions and aliases for those tools | <https://github.com/ohmyzsh/ohmyzsh> |
| you-should-use | high | Reminds you when an alias exists for a command you typed | <https://github.com/MichaelAquilina/zsh-you-should-use> |
| zsh-autopair | high | Auto-closes quotes and brackets | <https://github.com/hlissner/zsh-autopair> |

Plugins and themes are **not copied into this repo**. chezmoi clones them into
`~/.oh-my-zsh`, `~/.fzf` and `~/.zsh-custom` on `chezmoi apply`, and re-pulls
them weekly (see `.chezmoiexternal.toml.tmpl`).

### Management

| Tool | What it does | Source |
|---|---|---|
| chezmoi | Manages this repo's files into `$HOME` | <https://github.com/twpayne/chezmoi> |

---

## Shell setup

Loaded from `~/.zshrc`, in this order:

1. p10k instant prompt, then `~/.local/bin` and mise shims on `PATH`.
2. oh-my-zsh with the plugins listed for your level.
3. Prompt from `~/.p10k.zsh`. Run `p10k configure` to change it.
4. fzf defaults and tool hooks. Each hook is skipped silently if its tool is missing.

Aliases, set only when the tool exists:

- `ls` → `eza --icons=auto --group-directories-first`
- `cat` → `bat --paging=never`

Key bindings:

| Key | Action |
|---|---|
| `Ctrl-R` | atuin history search |
| `Ctrl-T` | fzf file picker |
| `Alt-C` | fzf directory jump |
| `Up` / `Down` | history substring search |
| `→` | accept autosuggestion |
| `Esc Esc` | add `sudo` to the current line |

### Icons and the prompt

The default prompt uses Nerd Font icons. If the terminal lacks a Nerd Font
(for example, an SSH client), export this before starting zsh, or put it in
`~/.zshrc` on that machine:

```bash
export P10K_ASCII=1
```

### tmux on servers

On `server` and `vm`, an SSH login runs `tmux new-session -A -s main`, so you
reconnect to the same session. The guard skips this when already inside tmux
or for non-SSH logins.

---

## Updating and day-to-day use

| Task | Command |
|---|---|
| Pull latest repo changes and apply | `chezmoi update` |
| Preview changes before applying | `chezmoi diff` |
| Apply local source edits | `chezmoi apply` |
| Edit a managed file | `chezmoi edit ~/.zshrc` |
| Commit edits made in the source repo | `chezmoi cd`, then `git commit` |
| Change env or level | `CHEZMOI_ENV=... CHEZMOI_LEVEL=... chezmoi init`, then `chezmoi apply` |
| List what chezmoi manages | `chezmoi managed` |

Notes:

- Plugins and fzf refresh weekly through externals. Force a refresh with `chezmoi apply --refresh-externals`.
- Package scripts are `run_onchange_`: they re-run when their rendered text changes, for example when you add a tool to the list.
- Scripts never need root except the apt step, which uses `sudo`.

---

## Repository layout

```
.
├── .chezmoi.toml.tmpl            env/level input, validation, data flags
├── .chezmoiignore                env/level gating and secret patterns
├── .chezmoiexternal.toml.tmpl    oh-my-zsh, powerlevel10k, plugins, fzf (cloned on apply)
├── .chezmoiscripts/
│   ├── run_onchange_before_10-install-packages.sh.tmpl   apt/brew + mise tools
│   ├── run_onchange_before_20-install-bitwarden.sh.tmpl  Bitwarden CLI and bwmenu
│   ├── run_onchange_after_30-setup-fzf.sh.tmpl           fzf binary
│   └── run_onchange_after_40-install-nerd-font.sh.tmpl   Hack Nerd Font (desktop)
├── dot_zshrc.tmpl                ~/.zshrc (per-level plugins and hooks)
├── dot_p10k.zsh                  ~/.p10k.zsh (prompt config)
├── dot_fzf.zsh                   ~/.fzf.zsh (fzf shell setup)
└── private_dot_config/
    ├── tmux/tmux.conf
    ├── wezterm/wezterm.lua.tmpl  (desktop only)
    ├── rofi/                     (desktop only)
    ├── nvim/                     LazyVim-based config
    ├── yazi/
    └── zellij/
```

Chezmoi naming used here:

- `dot_` → leading `.` in the target name (`dot_zshrc` → `~/.zshrc`)
- `private_` → directory or file without group/world permissions
- `executable_` → executable bit set
- `.tmpl` → rendered as a Go template with env/level data
- `run_onchange_before_` / `run_onchange_after_` → scripts run before/after file apply, re-run on change

---

## Secrets policy

No secrets are stored in this repo. `.chezmoiignore` blocks common secret
filenames from being deployed (keys, `.env`, `.netrc`, `.npmrc`, SSH and GPG
dirs, cloud credential files, shell history). Keep credentials in Bitwarden
and read them at runtime with `bw`.

Do not commit tokens, passwords or private keys. If one is committed by
accident, rotate it first, then remove it from history.

---

## Troubleshooting

**`chezmoi init` says invalid `CHEZMOI_ENV` or `CHEZMOI_LEVEL`.** Use one of the listed values exactly, in lowercase.

**Prompt icons show as boxes.** The terminal font lacks Nerd Font glyphs. Desktop: install Hack Nerd Font and select `Hack Nerd Font Mono` in your terminal. SSH client: use `P10K_ASCII=1`.

**A package is not installed.** Apt names differ on some distros, and mise may not know a tool name. The script prints `WARNING: Could not install '<name>'` and continues. Install it by hand, or fix the name in `.chezmoiscripts/run_onchange_before_10-install-packages.sh.tmpl`.

**A plugin is missing after apply.** Run `chezmoi apply --refresh-externals`, then check that `~/.zsh-custom/plugins/<name>` exists.

**The fzf binary is missing after apply.** Run `~/.fzf/install --bin` by hand. Ubuntu's apt `fzf` is too old for `fzf --zsh`.

**tmux does not auto-attach on SSH.** Confirm `CHEZMOI_ENV` is `server` or `vm`, that tmux is installed (`command -v tmux`), and that you are not already inside tmux.

---

## Testing this repo

Validate every environment and level in a temporary HOME, without touching
your real home and without installing anything:

```bash
for e in desktop server vm work; do
  for l in simple medium high; do
    H=$(mktemp -d)
    HOME=$H CHEZMOI_ENV=$e CHEZMOI_LEVEL=$l chezmoi --source "$PWD" init
    HOME=$H chezmoi --source "$PWD" managed >/dev/null && echo "ok $e/$l"
    rm -rf "$H"
  done
done
```

Lint a rendered script:

```bash
chezmoi --source "$PWD" execute-template < .chezmoiscripts/run_onchange_before_10-install-packages.sh.tmpl > pkg.sh
shellcheck -s bash pkg.sh
rm pkg.sh
```

Do not run `chezmoi apply` in a test environment unless you intend to install packages.

---

## License

Personal configuration. Each tool and plugin is under its own upstream license.
