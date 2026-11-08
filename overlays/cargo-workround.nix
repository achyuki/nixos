# TODO
final: prev: {
  llm-agents = prev.llm-agents // {
    cc-switch-cli = prev.llm-agents.cc-switch-cli.overrideAttrs (_: {
      dontCargoUseSystemLibs = true;
    });
  };
  splayer-next = prev.splayer-next.overrideAttrs (_: {
    dontCargoUseSystemLibs = true;
  });
}
