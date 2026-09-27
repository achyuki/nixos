{ pkgs, ... }: {
  programs.vscode.enable = true;
  home.packages = with pkgs.llm-agents; [
    claude-code cc-switch-cli
  ];
}
