{
  lib,
  fetchFromGitHub,
  rustPlatform,
  buildNpmPackage,
  pkg-config,
  openssl,
  glib,
  gtk3,
  webkitgtk_4_1,
  wrapGAppsHook4,
  runCommand,
  udev,
  pcsclite,
  cargo-tauri,
  copyDesktopItems,
  makeDesktopItem,
}: let
  pname = "picoforge";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "librekeys";
    repo = "picoforge";
    rev = "v${version}";
    sha256 = "13wnbzby5s9v9rbp1lyy9jzx07s63q1fx4649qa5wdz95hf0d9fv";
  };

  frontend = buildNpmPackage {
    pname = "${pname}-frontend";
    src = src;
    inherit version;
    npmDepsHash = "sha256-7DLooiGLzk3JRsKAftOxSf7HAgHBXCJDaAFp2p/pryc=";
    makeCacheWritable = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r build/* $out/
      runHook postInstall
    '';
  };
in
  rustPlatform.buildRustPackage {
    inherit pname version src;
    sourceRoot = "${src.name}/src-tauri";
    cargoHash = "sha256-DB54egPebUniP/yjEZc+/AY9vOChJRBA+tqnbISmEgg=";

    nativeBuildInputs = [
      cargo-tauri.hook
      pkg-config
      wrapGAppsHook4
      copyDesktopItems
    ];

    buildInputs = [
      openssl
      glib
      gtk3
      webkitgtk_4_1
      udev
      pcsclite
    ];

    postPatch = ''
      mkdir -p build
      cp -r ${frontend}/* build/
      substituteInPlace tauri.conf.json \
        --replace-fail '"beforeBuildCommand": "deno task build"' '"beforeBuildCommand": ""' \
        --replace-fail '"frontendDist": "../build"' '"frontendDist": "build"'
    '';

    postInstall = ''
      install -Dm644 ${src}/src-tauri/icons/128x128.png $out/share/icons/hicolor/128x128/apps/picoforge.png
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "picoforge";
        exec = "picoforge";
        icon = "picoforge";
        desktopName = "Picoforge";
        genericName = "Pico-Fido Commissioning Tool";
        categories = ["Utility"];
      })
    ];

    meta = with lib; {
      description = "A commissioning tool for pico-fido firmware based hardware keys";
      homepage = "https://github.com/librekeys/picoforge";
      license = licenses.mit;
      mainProgram = "picoforge";
    };
  }
