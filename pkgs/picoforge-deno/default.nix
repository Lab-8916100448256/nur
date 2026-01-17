{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, dbus
, openssl
, librsvg
, webkitgtk_4_1
, gtk3
, libsoup_3
, cairo
, gdk-pixbuf
, glib
, pango
, atkmm
, at-spi2-atk
, harfbuzz
, pcsclite
, hidapi
, udev
, libglvnd
, libGL
, vulkan-loader
, mesa
, gst_all_1
, deno
, nodejs
, cargo
, rustc
, stdenv
, copyDesktopItems
, cacert
, makeDesktopItem
}:

let
  pname = "picoforge";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Lab-8916100448256";
    repo = "picoforge";
    rev = "a1cb592197916ca13cfe8b18d2a2b800e7e5bb92"; # Assuming tags are like v0.2.0
    hash = "sha256-6bYxDKVI8jexvKDUpN2SqmVJpMIrYJ4YAjpRnDB3+OE=";
  };

  # Fixed-output derivation to cache Deno dependencies
  denoDeps = stdenv.mkDerivation {
    name = "${pname}-deno-deps";
    inherit src;
    nativeBuildInputs = [ deno cacert ];
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    buildPhase = ''
      export DENO_DIR=$out
      # This will download all dependencies into $out
      deno install --frozen
    '';
    # This hash must be updated whenever deno.lock or dependencies change.
    # Initially set to a dummy value so Nix shows the actual hash.
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-l7Mh5jUJa9ImFZkLbfIh8haqMe0WIYu6CHLkGt55nNA=";
  };

  desktopItem = makeDesktopItem {
    name = "picoforge";
    exec = "picoforge";
    icon = "picoforge";
    desktopName = "Picoforge";
    genericName = "FIDO Key Commissioning Tool";
    categories = [ "Utility" ];
  };

in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoRoot = "src-tauri";
  cargoLock = {
    lockFile = ./src-tauri/Cargo.lock;
  };

  nativeBuildInputs = [
    pkg-config
    deno
    nodejs
    cargo
    rustc
    copyDesktopItems
  ];

  buildInputs = [
    dbus
    openssl
    librsvg
    webkitgtk_4_1
    gtk3
    libsoup_3
    cairo
    gdk-pixbuf
    glib
    pango
    atkmm
    at-spi2-atk
    harfbuzz
    pcsclite
    hidapi
    udev
    libglvnd
    libGL
    vulkan-loader
    mesa
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  desktopItems = [ desktopItem ];

  # Pre-build step for the frontend
  preBuild = ''
    # Ensure a clean and writable environment
    rm -rf node_modules
    chmod -R +w .
    
    # Writable Deno cache populated from the read-only store cache
    export HOME=$(mktemp -d)
    export DENO_DIR=$HOME/.cache/deno
    mkdir -p $DENO_DIR
    cp -r ${denoDeps}/* $DENO_DIR/
    chmod -R +w $DENO_DIR
    
    # Populate node_modules from the writable cache (hermetically)
    deno install --frozen
    
    # Deno task build runs vite build
    deno task build
    
    # Change to the Rust project directory for the next build phases
    cd src-tauri
  '';

  postInstall = ''
    # Install icons (path is relative to src-tauri due to the cd in preBuild)
    install -Dm644 icons/128x128.png $out/share/icons/hicolor/128x128/apps/picoforge.png
  '';

  meta = with lib; {
    description = "An open source commissioning tool for Pico FIDO security keys";
    homepage = "https://github.com/librekeys/picoforge";
    license = licenses.agpl3Only;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
