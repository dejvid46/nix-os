# Guide for repo ❄️

## Search for packages

https://search.nixos.org/packages

## Rebuilding with flakes enabled

```bash
$ sudo nixos-rebuild switch --flake ~/nix-config/#pi
```

## Secrets Management (Agenix)

### 1. Set/Update User Password
User passwords in NixOS must be hashed. To generate a hash and store it directly into an encrypted agenix file without leaving a trace in shell history, use this command (replace `YOUR_PASSWORD`):

```bash
# Run from repo root
printf "YOUR_PASSWORD" | nix run nixpkgs#mkpasswd -- -m sha-512 -s | nix run github:ryantm/agenix -- -e secrets/userPassword.age
```

### 2. Create new Secret
Initilazed it in /secrets/secrets.nix

```nix
let
  user1 = "ssh-ed25519 ...";
  users = [ user1 ];

  system1 = "ssh-ed25519 ...";
  systems = [ system1 ];
in
{
  "secret1.age".publicKeys = [ user1 system1 ]; # <- create a new secret like this 
}
```

After that create secret with agenix:

```bash
nix run github:ryantm/agenix -- -e secret1.age
```

Use this secret in configuration:

```nix
{ config, ... }: {
  age.secrets.secret1 = {
    file = ../../secrets/secret1.age;
  };

  # Usage example (path to the decrypted file):
  services.myservice.passwordFile = config.age.secrets.secret1.path;
}
```
