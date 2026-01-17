{
  config,
  lib,
  pkgs,
  ...
}:
pkgs.rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-ci-ambient";
  version = "0.12.0";
  src = pkgs.fetchFromRadicle {
    seed = "radicle12.distrilab.eu";
    repo = "z35CgFVYCKpqqDtJMzk8dyE6dViS6";
    node = "z6MkgEMYod7Hxfy9qCvDv5hYHkZ4ciWmLFgfvm3Wn1b2w2FV"; #lars
    tag = "v${finalAttrs.version}";
    hash = "sha256-gGYQplj5eblBwkDUtza6iyX5WZ+3chTZjX7lliPR8oU=";
  };
  cargoHash = "sha256-QR8pODzNGRsrfoEh2mlWwEmdiDU2ZulRs4UHbOX2ArU=";
  preCheck = ''
    git config --global user.name nixbld
    git config --global user.email nixbld@example.com
  '';
  nativeCheckInputs = [
    pkgs.writableTmpDirAsHomeHook
    pkgs.radicle-node
    pkgs.gitMinimal
  ];
  nativeInstallCheckInputs = [pkgs.versionCheckHook];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;
  meta = {
    description = "Radicle CI adapter for ambient CI";
    homepage = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:z35CgFVYCKpqqDtJMzk8dyE6dViS6";
    changelog = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:z35CgFVYCKpqqDtJMzk8dyE6dViS6/tree/NEWS.md";
    mainProgram = "radicle-ci-ambient";
  };
})
