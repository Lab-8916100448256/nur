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
  atkmm,
  eudev,
  gdk-pixbuf,
  libgudev,
  libsoup_3,
  pango,
  cargo-tauri,
  copyDesktopItems,
  makeDesktopItem,
}: let
  pname = "picoforge";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "librekeys";
    repo = "picoforge";
    rev = "v${version}";
    sha256 = "1lvg1j92222x333qj7s3yi4n33z1bd7scv171i7p12f3f04zql3d";
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

    cargoHash = "sha256-nLf8v4MIt2zAeA9YMVaoI3s/yut5/Jy2fGM3Sx33EJc=";

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

      atkmm
      eudev
      gdk-pixbuf
      libgudev
      libsoup_3
      pango
    ];

    # Copy frontend assets and disable tauri's build command
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
