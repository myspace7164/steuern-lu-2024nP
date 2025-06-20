self: super:
let
  src = builtins.fetchGit {
    url = "https://github.com/myspace7164/steuern-lu-2024nP.git";
    ref = "main";
  };

in {
  steuern-lu-2024nP = super.callPackage (src + "/default.nix") { };
}
