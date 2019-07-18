with import <nixpkgs> {};
let
  elmTools = import (pkgs.fetchFromGitHub {
    owner = "turboMaCk";
    repo = "nix-elm-tools";
    rev = "8168561d341ad5bafd5573d1e2a904d4d1fff7b2";
    sha256 = "0svag008jis34knyj7a59lmdhnz2b7h8mqh1arrkbl5yhpxg7n65";
  }) { inherit pkgs; };
in
stdenv.mkDerivation {
  name = "elm-env";
  buildInputs = with elmPackages; [
    nodejs-11_x
    elm
    elm-format
    elmTools.elm-test
    python
  ];
}
