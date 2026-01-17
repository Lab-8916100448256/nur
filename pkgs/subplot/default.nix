{
  config,
  lib,
  pkgs,
  ...
}:
pkgs.rustPlatform.buildRustPackage (finalAttrs: {
  pname = "subplot";
  version = "0.13.0";
  src = pkgs.fetchFromRadicle {
    seed = "radicle12.distrilab.eu";
    repo = "zjxyd2A1A7FnxtC69qDfoAajfTHo";
    node = "z6MkgEMYod7Hxfy9qCvDv5hYHkZ4ciWmLFgfvm3Wn1b2w2FV"; # lars
    tag = "${finalAttrs.version}";
    hash = "sha256-eGRXUe9SpFWej6UndXCluqWHEC6VadiwkFijEmoBWno=";
  };
  cargoHash = "sha256-g8HlhHbQl/sUvYAy3t/GYUogjPR8+d41xxZv5mqWKcU=";
  preCheck = ''
    git config --global user.name nixbld
    git config --global user.email nixbld@example.com
  '';
  nativeCheckInputs = [
    pkgs.writableTmpDirAsHomeHook
    pkgs.gitMinimal
    pkgs.jetbrains.jdk
    pkgs.graphviz
    pkgs.plantuml
  ];
  SUBPLOT_DOT_PATH = "${pkgs.graphviz}/bin/dot";
  SUBPLOT_JAVA_PATH = "${pkgs.jetbrains.jdk}/bin/java";
  SUBPLOT_PLANTUML_JAR_PATH = "${pkgs.plantuml}/lib/plantuml.jar";
  nativeInstallCheckInputs = [pkgs.versionCheckHook];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;
  meta = {
    description = "Subplot";
    homepage = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:zjxyd2A1A7FnxtC69qDfoAajfTHo";
    changelog = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:zjxyd2A1A7FnxtC69qDfoAajfTHo/tree/NEWS.md";
    mainProgram = "subplot";
  };
})
