let
  desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDfz9yFYsombg3uBtCGNbYd157gVhqn2c58zpcv4sUQd dejvi@DESKTOP-RN8MS24";

  nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQlV2MCMwyAAo7j8Spx2+f4TPT2YARmtF6oM60R08vV root@nixos";
in
{
  "userPassword.age".publicKeys = [ desktop nixos ];
  "piholePassword.age".publicKeys = [ desktop nixos ];
  "wg-private.age".publicKeys = [ desktop nixos ];
  "wg-psk.age".publicKeys = [ desktop nixos ];
  "baserowPassword.age".publicKeys = [desktop nixos];
}
