# Lab-8916100448256 nur packages

**This is my personal [NUR](https://github.com/nix-community/NUR) repository**

## Setup your own NUR repository

1. Click on [Use this template](https://github.com/nix-community/nur-packages-template/generate) to start a repo based on this template. (Do _not_ fork it.)
2. Add your packages to the [pkgs](./pkgs) directory and to
   [default.nix](./default.nix)
   * Remember to mark the broken packages as `broken = true;` in the `meta`
     attribute, or travis (and consequently caching) will fail!
   * Library functions, modules and overlays go in the respective directories
3. Choose your CI: Depending on your preference you can use github actions (recommended) or [Travis ci](https://travis-ci.com).
   - Github actions: Change your NUR repo name and optionally add a cachix name in [.github/workflows/build.yml](./.github/workflows/build.yml) and change the cron timer
     to a random value as described in the file
   - Travis ci: Change your NUR repo name and optionally your cachix repo name in 
   [.travis.yml](./.travis.yml). Than enable travis in your repo. You can add a cron job in the repository settings on travis to keep your cachix cache fresh
5. Change your travis and cachix names on the README template section and delete
   the rest
6. [Add yourself to NUR](https://github.com/nix-community/NUR#how-to-add-your-own-repository)


## Notes to self
### Update flake.lock
Remember to `nix flake update` from times to times  

### How to build a package from a local checkout
`nix-build -A <package-name>`  

### How to build a package from github
`nix build 'github:Lab-8916100448256/nur#package-name'`  
or to directly run an apllication :  
`nix run 'github:Lab-8916100448256/nur#package-name'`  

### How to use this NUR on NixOS
Add this in /etc/nixos/configuration.nix :  
```
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/Lab-8916100448256/nur/archive/main.tar.gz") {
      inherit pkgs;
    };
  };
```

To use it with nix-shell add this to `~/.config/nixpkgs/config.nix` :  
```
{
  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/Lab-8916100448256/nur/archive/main.tar.gz") {
      inherit pkgs;
    };
  };
}
```

### How to update the version of a package
#### Update the version in the package
expl : `sed -i '/version = "0.2.0"/version = "0.3.0"/' pkgs/picoforge/default.nix`
#### Prefetch the git repo to get the hash of the new version
expl : `nix-prefetch-git   --url https://github.com/librekeys/picoforge --rev "v0.3.0"`
#### Try to build the package and update the other hashes if they have changed
expl : `nix-build -A picoforge` then if build fails update the hashes that have changed

<!-- Uncomment this if you use github actions 
![Build and populate cache](https://github.com/<YOUR-GITHUB-USER>/nur-packages/workflows/Build%20and%20populate%20cache/badge.svg)
-->

<!-- Uncomment this if you use travis:
[![Build Status](https://travis-ci.com/<YOUR_TRAVIS_USERNAME>/nur-packages.svg?branch=master)](https://travis-ci.com/<YOUR_TRAVIS_USERNAME>/nur-packages)
-->

<!-- Uncomment this if you use cachix:
[![Cachix Cache](https://img.shields.io/badge/cachix-<YOUR_CACHIX_CACHE_NAME>-blue.svg)](https://<YOUR_CACHIX_CACHE_NAME>.cachix.org)
-->

