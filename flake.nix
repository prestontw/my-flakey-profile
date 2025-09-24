# SPDX-FileCopyrightText: 2023 Jade Lovelace
#
# SPDX-License-Identifier: CC0-1.0

{
  description = "Basic usage of flakey-profile";

  inputs = {
    flakey-profile.url = "github:lf-/flakey-profile";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    floating.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , flakey-profile
    , floating
    ,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        floatingPkgs = import floating {
          inherit system;
        };
        commonPinnedPkgs = with pkgs; [
          aha
          direnv
          jq
          nodejs_22
          pnpm
          stow
        ];
        # "Applications" or floating dependencies common to both OS's
        commonFloatingPkgs = with floatingPkgs; [
          # alacritty
          jujutsu
          lua-language-server
          nil
          nixpkgs-fmt
          # rio # Doesn't support buttonless windows right now with Aerospace; the window is only 600x400 rather than taking up the full space.
          watchexec
          wezterm
          zellij
        ];
        # "Applications" or floating dependencies specifically for Linux
        linuxFloatingPkgs = with floatingPkgs; [
          atuin
          # ghostty
          helix
          starship
        ];
        # Mac floating packages are managed through the Brewfile
      in
      {
        # Any extra arguments to mkProfile are forwarded directly to pkgs.buildEnv.
        #
        # Usage:
        # Switch to this flake:
        #   nix run .#profile.switch
        # Revert a profile change (note: does not revert pins):
        #   nix run .#profile.rollback
        # Build, without switching:
        #   nix build .#profile
        # Pin nixpkgs in the flake registry and in NIX_PATH, so that
        # `nix run nixpkgs#hello` and `nix-shell -p hello --run hello` will
        # resolve to the same hello as below [should probably be run as root, see README caveats]:
        #   sudo nix run .#profile.pin
        packages.profile = flakey-profile.lib.mkProfile {
          inherit pkgs;
          # Specifies things to pin in the flake registry and in NIX_PATH.
          pinned = {
            nixpkgs = toString nixpkgs;
          };
          paths =
            commonPinnedPkgs ++ commonFloatingPkgs ++ pkgs.lib.optionals pkgs.stdenv.isLinux linuxFloatingPkgs;
        };
      }
    );
}
