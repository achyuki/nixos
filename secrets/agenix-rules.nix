let
  yuki= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqNxUrlnSLf8Vr0RPOPydlwRltW0kMboxtxwLV/gBTV";
  users = [ yuki ];

  unk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBja7TUDKvvQ1zkhFcu3Tna/HTlGrAedq3Xv8L8Rd1tF";
  ice = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINvnlAvYEUVG5SfJMuH+zloCeXirKEPa1kmwag6AvPEY";
  hosts = [ unk ice ];
in
{
  "password00".publicKeys = users ++ hosts;
  "tailscale".publicKeys = users ++ hosts;
}