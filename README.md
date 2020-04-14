# nix-config

My personal [nix](https://nixos.org/nix/) configuration.


# Features

- [Modular](https://nixos.org/nixos/manual/index.html#sec-modularity) and composable (machines, roles, users, packages) [configuration](https://nixos.org/nixos/manual/index.html#ch-configuration)
- Uses [home-manager](https://github.com/rycee/home-manager) to manage user settings
- Templating via the [nix expression language](https://nixos.org/nix/manual/#ch-expression-language)
- Get secrets from [gopass](https://www.gopass.pw/) / [password-store](https://www.passwordstore.org/)
- Multi-platform (NixOS, Ubuntu, macOS)


# Use

```sh
# Install the nix package manager.
curl https://nixos.org/nix/install | sh

# Clone this repo.
mkdir -p ~/.config
git clone https://github.com/qjcg/nix-config ~/.config/nixpkgs

# Install the mac environment.
nix-env -i env-mac
```

## Raspberry Pi

From a NixOS base image:

```sh
git clone https://github.com/qjcg/nix-config ~/.config/nixpkgs
cd ~/.config/nixpkgs
nixos-rebuild switch --upgrade -I nixos-config=$HOME/.config/nixpkgs/machines/rpi3/configuration.nix

```


# Layout

```
.
├── README.md   - this README file
├── config.nix  - nix configuration
├── files/      - application files and templates
├── machines/   - per-machine configuration
├── nixops/     - nixops configurations
├── packages/   - overlay packages and environments
├── roles/      - system roles
└── secrets.nix - secrets file (gitignored, do e.g.: `gopass nix-secrets > secrets.nix`)
```


# TODO

- [x] Add NixOS system configuration(s)
- [x] Consider using [nix-darwin](https://github.com/LnL7/nix-darwin) on macOS
- [x] Consider using [home-manager](https://github.com/rycee/home-manager) on macOS
	- [x] Consider refactoring to follow layout of [Your Home in Nix (dotfile management)](https://hugoreeves.com/posts/2019/nix-home/)
- [ ] Consider adding custom [NixOS modules](https://nixos.org/nixos/manual/index.html#sec-writing-modules)
- [ ] Create custom NixOS LiveUSB / install media
	- [manual](https://nixos.org/nixos/manual/index.html#sec-building-cd)
	- [wiki](https://nixos.wiki/wiki/Creating_a_NixOS_live_CD)
- [ ] Create custom Rasbperry Pi SD card
	- [Build your own image](https://nixos.wiki/wiki/NixOS_on_ARM#Build_your_own_image)
	- [Compiling through QEMU](https://nixos.wiki/wiki/NixOS_on_ARM#Compiling_through_QEMU)
	- [Wiki Cross-compile packages](https://nixos.wiki/wiki/Cheatsheet#Cross-compile_packages)
	- [Wiki: Raspberry Pi](https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi)
- [ ] Use version pinning
	- [NixOS Wiki: FAQ/Pinning Nixpkgs](https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs)
	- [Intro to Nix Channels & Reproducible NixOS Environment](https://matrix.ai/blog/intro-to-nix-channels-and-reproducible-nixos-environment/)
- [ ] Pilot a small refactor of the current configuration into Nix Flakes
- [ ] Refactor configuration.nix to include package environments (env-workstation, etc)


# Using Flakes

```sh
nix-shell -p nixFlakes
```


# References

Interesting and useful links on a variety of nix-related topics.

## Manuals

- [NixOS manual](https://nixos.org/nixos/manual/)
- [nixpkgs manual](https://nixos.org/nixpkgs/manual/)
- [nix manual](https://nixos.org/nix/manual/)
- [NixOps manual](https://nixos.org/nixops/manual/)
- [Nix Pills](https://nixos.org/nixos/nix-pills/)
- [Home Manager manual](https://rycee.gitlab.io/home-manager/index.html)

## Guides

- [nix-1p: A one page introduction to Nix, the language](https://github.com/tazjin/nix-1p)
- [A Gentle Introduction to the Nix Family](https://ebzzry.io/en/nix/)
- [(neo)vim overlay configuration example](https://nixos.wiki/wiki/Vim#Custom_setup_without_using_Home_Manager)
	- [Example of adding new custom (neo)vim plugin](https://nixos.wiki/wiki/Vim#Add_a_new_custom_plugin_to_the_users_packages)
- [Setting up a custom nix channel](https://savanni.luminescent-dreams.com/2019/09/13/nix-channel/)
- [How to put your /nix directory on a separate device](https://cs-syd.eu/posts/2019-09-14-nix-on-seperate-device)
- [Cheatsheet comparing Ubuntu & NixOS](https://nixos.wiki/wiki/Cheatsheet)
- [Flakes RFC / proposal](https://github.com/tweag/rfcs/blob/flakes/rfcs/0049-flakes.md)
	- [Flakes RFC GitHub PR (discussion)](https://github.com/NixOS/rfcs/pull/49)
- [Secure, Declarative Key Management with NixOps, Pass, and nix-plugins](https://elvishjerricco.github.io/2018/06/24/secure-declarative-key-management.html)
- [Nix by example Part 1: The Nix expression language](https://medium.com/@MrJamesFisher/nix-by-example-a0063a1a4c55)
- [Learn X in Y Minutes: nix](https://learnxinyminutes.com/docs/nix/)
- [Your Home in Nix (dotfile management)](https://hugoreeves.com/posts/2019/nix-home/)
- [Create a custom NixOS Live CD](https://nixos.org/nixos/manual/index.html#sec-building-cd)
	- [Related Wiki article](https://nixos.wiki/wiki/Creating_a_NixOS_live_CD)
- [Intro to Nix Channels and Reproducible NixOS Environment](https://matrix.ai/blog/intro-to-nix-channels-and-reproducible-nixos-environment/)

## Packaging

- [Announcing the new Golang infrastructure: buildGoModule](https://kalbas.it/2019/03/17/announcing-the-new-golang-infrastructure-buildgomodule/)
- [Nixpkgs Manual: Go modules](https://nixos.org/nixpkgs/manual/#ssec-go-modules)
- [Python: poetry2nix](https://github.com/nix-community/poetry2nix)

### Containers

- [ociTools in NixOS](https://spacekookie.de/blog/ocitools-in-nixos/) (for building and running containers)
- [Tekton Pipelines - the Nix way](https://lewo.abesis.fr/posts/2019-09-30-tekton-pipelines-the-nix-way.html)
- [Deploying k8s apps with kubenix](https://zimbatm.com/deploying-k8s-apps-with-kubenix/)
- [Optimising Docker Layers for Better Caching with Nix](https://grahamc.com/blog/nix-and-layered-docker-images)
- [arion: Run docker-compose with help from Nix/NixOS](https://github.com/hercules-ci/arion)
	- [Arion Docs](https://docs.hercules-ci.com/arion/)

### Build System

- [Nix, the purely functional build system](http://www.boronine.com/2018/02/02/Nix/)
- [Nix + Bazel = Fully Reproducible, Incremental Builds](https://www.tweag.io/posts/2018-03-15-bazel-nix.html)


## Config Examples

- [grahamc: nixos-config](https://github.com/grahamc/nixos-config)
	- [grahamc: network (personal servers & router config)](https://github.com/grahamc/network)
	- [grahamc: NixOS 2019 Talks](https://github.com/grahamc/talks) (overrides, overlays, ...)
	- [grahamc: Erase Your Darlings](https://grahamc.com/blog/erase-your-darlings)
- [j0xaf (with i3 config)](https://github.com/j0xaf/dotfiles/blob/master/.config/nixpkgs/home.nix)
- [rummik (with system configurations, custom NixOS modules, nix-darwin, and home-manager)](https://github.com/rummik/nixos-config)
- [HugoReeves (with machine / role / user structure)](https://github.com/HugoReeves/nix-home/)

## Community Resources

- [NixOS Wiki](https://nixos.wiki/)
- [NixOS Weekly](https://weekly.nixos.org/)

## Tools & Services

- [nixery](https://nixery.dev/)
- [`nixfmt`](https://github.com/serokell/nixfmt)
- [mobile nixos](https://github.com/samueldr/mobile-nixos/)
- [nix-pre-commit-hooks](https://github.com/hercules-ci/nix-pre-commit-hooks)
- [cachix: Nix binary cache hosting](https://cachix.org/)
- [Cachix & Install Nix actions for GitHub](https://discourse.nixos.org/t/cachix-nix-install-actions-for-github/4242/2)
- [netboot.xyz (boot nix directly via network, no USB key)](https://github.com/antonym/netboot.xyz)
