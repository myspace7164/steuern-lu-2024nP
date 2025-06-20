This will concern probably only a handful of people, if even that, but here is a working nix package declaration for the 2024 tax declaration software of the canton of lucerne.

To use this in your configuration.nix simply add the following lines and it should work:
```
{ config, pkgs, ... }:

{

  ...

  nixpkgs.overlays = [
    (import <path-to-repo>/overlays.nix)
  ];

  ...

  environment.systemPackages = with pkgs; [
  ...
  steuern-lu-2024nP
  ...
  ];
}

```

Currently only a simple default.nix declaration, if someone would like me to add a flake.nix let me know or send a pull request. As I'm currently not using flakes i didn't include one.

Happy for any feedback, cheers!
