{ pkgs, ... }:

# Dolphin context-menu entry: open Claude Code in a folder.
#
# WARNING — this module has two imperative dependencies, outside of Nix:
#
#   1. The `claude-code-cli:latest` Docker image, built by hand. On a clean
#      reinstall from this flake the menu entry appears but fails until the
#      image is rebuilt.
#   2. The file ~/.config/claude/api.env, which exports ANTHROPIC_API_KEY.
#      Deliberately kept outside the repository — never commit the key.
{
  environment.systemPackages = [
    (pkgs.writeTextDir "share/kio/servicemenus/claude-code.desktop" ''
      [Desktop Entry]
      Type=Service
      MimeType=inode/directory;
      Actions=claudeCodeHere;
      X-KDE-Priority=TopLevel
      [Desktop Action claudeCodeHere]
      Name=Abrir Claude Code Aqui
      Icon=utilities-terminal
      Exec=konsole --workdir "%f" -e bash -c 'source ~/.config/claude/api.env && mkdir -p ~/.config/claude-docker && docker run -it --rm -v "%f:/app" -v "$HOME/.config/claude-docker:/home/claude" -w /app -e HOME=/home/claude -e npm_config_cache=/home/claude/.npm -e ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY" claude-code-cli:latest su-exec $(id -u):$(id -g) claude'
    '')
  ];
}
