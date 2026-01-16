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
  wrapGAppsHook3,
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
}: let
  pname = "picoforge";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "librekeys";
    repo = "picoforge";
    rev = "v${version}";
    sha256 = "1x61a4ldps5j176w0bs04pp0fbcb1r04qayl9w11q8g8f0pbkkf5";
  };

  srcWithLock = runCommand "src-with-lock" {} ''
    cp -r ${src} $out
    chmod -R +w $out
    cp ${./package-lock.json} $out/package-lock.json
  '';

  frontend = buildNpmPackage {
    pname = "${pname}-frontend";
    src = srcWithLock;
    inherit version;

    npmDepsHash = "sha256-aZPvkkwJMBN3IAp9NuSqAQNqqmNeQSkbR4gqON48ccQ=";

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

    cargoHash = "sha256-+2TKSA0otct5KYiSy5hP0ZH8WlhM/Wr8ibwMVE5pcpo=";

    nativeBuildInputs = [
      cargo-tauri.hook
      pkg-config
      wrapGAppsHook3
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

    meta = with lib; {
      description = "A commissioning tool for pico-fido firmware based hardware keys";
      homepage = "https://github.com/librekeys/picoforge";
      license = licenses.mit;
      mainProgram = "picoforge";
    };
  }
