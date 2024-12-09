let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      android-tools
      pkg-config
      gobject-introspection
      cargo
      cargo-tauri
      nodejs
      bun
    ];

    buildInputs = with pkgs; [
      at-spi2-atk
      atkmm
      cairo
      gdk-pixbuf
      glib
      gtk3
      harfbuzz
      librsvg
      libsoup_3
      pango
      webkitgtk_4_1
      openssl
    ];

    # export JAVA_HOME=/opt/android-studio/jbr
    shellHook = ''
      export ANDROID_HOME="$HOME/Android/Sdk"
      export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"
    '';
  }
