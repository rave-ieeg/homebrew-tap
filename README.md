# RAVE Homebrew tap

Installs [RAVE](https://rave.wiki/), Reproducible Analysis and Visualization of intracranial EEG data, on a Mac.

## Install

```sh
brew install rave-ieeg/tap/rave-ieeg
```

This installs R if you don't have it, the system libraries RAVE needs, Node.js, RAVE's R packages, and the `rave` command. It takes several minutes and about 3 GB of disk space. Homebrew may ask for your password while it installs R.

When it finishes, open RAVE:

```sh
rave start
```

If the install stopped early, `rave start` finishes it. If your R is more than one minor version behind the latest, `rave start` offers to update it.

## Commands

| Command | What it does |
| --- | --- |
| `rave start` | Open RAVE. `rave start --help` lists the options. |
| `rave update` | Update RAVE |
| `rave configure python` | Set up Python, or repair it |
| `rave configure python --reset` | Remove RAVE's Python environment and build it again |
| `rave install r-<name>` | Add an R package |
| `rave install py-<name>` | Add a Python package |

`rave install` takes several names at once, such as `rave install r-praise py-tabulate`.

## Python

Python isn't installed by default, and some RAVE modules need it. To set it up, run:

```sh
rave configure python
```

This uses Homebrew's `miniforge` or `miniconda` if you have one, and installs `miniforge` with Homebrew if you don't. It takes about 2 GB of disk space.

Keep Homebrew's conda installed afterwards. If you remove it, modules that need Python stop working until you run `rave configure python` again.

## Uninstall

```sh
brew uninstall --cask rave-ieeg/tap/rave-ieeg
```

This removes the `rave` command. R and RAVE's R packages stay installed.

To also move RAVE's caches and Python environment to the Trash, add `--zap`:

```sh
brew uninstall --zap --cask rave-ieeg/tap/rave-ieeg
```

Neither command removes `~/rave_data` or your RAVE settings.

## Help

Email help@rave.wiki.

## Maintainers

The cask pins one file, `inst/shell/rave`, to a commit of [`ravemanager`](https://github.com/dipterix/ravemanager). RAVE's packages aren't pinned, because `rave update` always installs the latest versions.

To move the pin, set `version` in `Casks/rave-ieeg.rb` to `<ravemanager version>,<commit>`, and set `sha256` to the output of:

```sh
curl -fsSL "https://raw.githubusercontent.com/dipterix/ravemanager/<commit>/inst/shell/rave" | shasum -a 256
```

CI runs on every push and once a week. It checks the cask's style, audits it, installs it, and opens RAVE.

- The audit skips `stanza_requires_uninstall`. That check asks for an `uninstall` stanza, but the only thing to remove is the `rave` link, and the link removes itself.
- `must_succeed: false` lets `brew install` finish even if RAVE's install fails, so that `rave` exists to retry it. Only the step that opens RAVE proves the install worked.
- Never add `rave_data`, settings or templates to `zap`.
