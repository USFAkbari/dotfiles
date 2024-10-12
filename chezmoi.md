# My dotfiles, managed with chezmoi

**is more feature-rich and user-friendly, offering automation, advanced configuration management, and cross-platform support.**

1. **Purpose**: Designed to manage personal configuration files (dotfiles) across multiple machines seamlessly.
2. **Management**: It allows you to keep your configuration files in a Git repository while managing them locally. chezmoi tracks changes and can sync dotfiles automatically.
3. **Installation**: Can install various dependencies and tools automatically as part of the setup process.
4. **Template Engine**: Offers a template engine that supports various conditional logic and functions, which makes it flexible for different environments.
5. **User-Friendly**: Focuses on ease of use with commands that simplify the process of applying, reverting, and managing configurations.

```console
export GITHUB_USERNAME=USFAkbari
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```
