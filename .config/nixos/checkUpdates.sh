set -e
hash=$(shasum flake.lock | awk '{print $1}')
mv flake.lock "flake.lock.old-${hash}"
nix flake update

nix-store --query --requisites /run/current-system | cut -d- -f2- | sort -u > currentPackages
nixos-rebuild build
nix-store --query --requisites result | cut -d- -f2- | sort -u > newPackages
