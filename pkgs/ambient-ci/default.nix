{
  config,
  lib,
  pkgs,
  ...
}:
pkgs.rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ambient-ci";
  version = "0.11.0";
  src = pkgs.fetchFromRadicle {
    seed = "radicle12.distrilab.eu";
    repo = "zwPaQSTBX8hktn22F6tHAZSFH2Fh";
    node = "z6MkgEMYod7Hxfy9qCvDv5hYHkZ4ciWmLFgfvm3Wn1b2w2FV"; #lars
    tag = "v${finalAttrs.version}";
    hash = "sha256-geKkyB1q8hIjxMVmGCr8jP6iyz2bPC5nJF9ob+ITe+0=";
  };
  cargoHash = "sha256-l4ZnhDtPwL5ofqOAIDqtiKGrNXk6b+3Cp6ucNWyCX0M=";

  preCheck = ''
    git config --global user.name nixbld
    git config --global user.email nixbld@example.com
  '';
  nativeCheckInputs = [
    pkgs.writableTmpDirAsHomeHook
    pkgs.radicle-node
    pkgs.gitMinimal
    pkgs.libisoburn
  ];
  nativeInstallCheckInputs = [pkgs.versionCheckHook];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;
  meta = {
    description = "Ambient CI";
    homepage = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:zwPaQSTBX8hktn22F6tHAZSFH2Fh";
    changelog = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:zwPaQSTBX8hktn22F6tHAZSFH2Fh/tree/NEWS.md";
    mainProgram = "ambient";
  };
})
