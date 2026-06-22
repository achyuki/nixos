{ lib, ... }: {
  ids.uids.nixbld = lib.mkForce 9300;
  nix.optimise.automatic = lib.mkForce true;
}
