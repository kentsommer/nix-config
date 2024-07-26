# nix-config
Flake for configuring my MacOS computers

## Install Instructions

1. Dependencies
```
xcode-select --install
```

2. Nix
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

3. Move nix config values from `/etc/nix/nix.conf` -> `.config/nix/nix.conf`

4. Validate the config/build
```
nix run .#build
```

5. Configure the system
```
nix run .#build-switch
```

### Quirks/FYI:
* `1password` needs manual configuration to setup the ssh agent and
  integrate with the `1password-cli`  after logging in
* The `1password-cli` seems not to pick up the ssh agent until a solid
  trigger. I was able to do this with `ssh -Tvvv git@github.com`
* `Alfred` needs to be configured to include `/nix/store` to find things
  like `wezterm`, etc.
