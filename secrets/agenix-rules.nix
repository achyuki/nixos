let
  yuki= "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqNxUrlnSLf8Vr0RPOPydlwRltW0kMboxtxwLV/gBTV";
  users = [ yuki ];

  unk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBja7TUDKvvQ1zkhFcu3Tna/HTlGrAedq3Xv8L8Rd1tF";
  ice = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINvnlAvYEUVG5SfJMuH+zloCeXirKEPa1kmwag6AvPEY";
  atropine = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINIEzV2P6w6xJNfNK1HWAACAHFz+MJPEJ7smiTjZ++yP";
  hosts = [ unk ice atropine ];
in
{
  "password00".publicKeys = users ++ hosts;
  "tailscale".publicKeys = users ++ hosts;
}