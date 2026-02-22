{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation (finalAttrs: {
  pname = "fish-rose-pine";
  version = "6cfc508";

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "fish";
    rev = "6cfc508e81b231e955690dc9723c631374f468eb";
    hash = "sha256-NgfZnaik5OAur53y3WA0Hqu6f332aVdhhMWnEtDxmNs=";
  };

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    # Fish will not read theme-related files in any package directory.
    # It still needs to be linked manually.
    mkdir $out
    cp themes/*.theme $out/

    runHook postInstall
  '';

  meta = {
    description = "Rose Pine themes for Fish shell";
    homepage = "https://github.com/rose-pine/fish";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
