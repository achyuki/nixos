{ inputs, ... }:
{
  sops.defaultSopsFile = "${inputs.self.outPath}/secrets/default.yaml";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets = {
    password00 = { };
    tailscale_key = { };
  };
}
