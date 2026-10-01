{ pkgs, ... }: {
  programs.vscode.enable = true;
  home.packages = with pkgs.llm-agents; [
    claude-code
    cc-switch-cli
    (dsh.overrideAttrs (old: {
      postInstall = old.postInstall + ''
        substituteInPlace \
        $out/lib/node_modules/@deepseek-ai/dsh/node_modules/@deepseek-ai/dsh-app-boot/lib/index.js \
        --replace-fail \
        'createRequire(import.meta.url)("node-addon-require-builtin")' \
        '{ requireBuiltin: createRequire(import.meta.url) }'
      '';
    }))
  ];
}
