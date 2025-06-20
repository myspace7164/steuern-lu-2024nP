{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  jdk17,
  fontconfig,
  freetype,
  glib,
  nss,
  nspr,
  dbus,
  atk,
  cups,
  libdrm,
  gdk-pixbuf,
  gtk3,
  pango,
  cairo,
  libgbm,
  expat,
  libxkbcommon,
  libGL,
  xorg,
  alsa-lib,
}:

let
  xorgLibs = with xorg; [
    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libxcb
  ];
in stdenv.mkDerivation rec {
  pname   = "steuern-lu-2024nP";
  version = "2024.0";

  src = fetchurl {
    url    = "https://steuersoftware.lu.ch/steuern24/steuern.lu.2024nP.sh";
    sha256 = "sha256-UucIvnCl81RGynerZhRTiziDdXTs2dwDy+a6GWJdFfA=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
    jdk17
  ];
  
  buildInputs = [
    alsa-lib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    jdk17
    libGL
    libdrm
    libgbm
    libxkbcommon
    nspr
    nss
    pango
  ] ++ xorgLibs;

  installPhase = ''
    mkdir -p $out/opt
    cp $src installer.sh
    chmod +x installer.sh

    export INSTALL4J_DISABLE_BUNDLED_JRE=true
    export INSTALL4J_JAVA_HOME_OVERRIDE=${jdk17}
    export INSTALL4J_KEEP_TEMP=yes
    export HOME=$TMPDIR

    ./installer.sh -q -overwrite -dir $out/opt

    exe="$out/opt/steuern.lu.2024 nP"
    mkdir -p $out/bin
    makeWrapper "$exe" "$out/bin/steuern-lu-2024" \
      --set JAVA_HOME ${jdk17} \
      --prefix PATH : ${jdk17}/bin \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --set-default TZ Europe/Zurich

    # Install desktop entry and icon
    mkdir -p $out/share/applications
    cat > $out/share/applications/steuern-lu-2024.desktop <<EOF
[Desktop Entry]
Type=Application
Name=steuern.lu.2024 nP
Exec=$out/bin/steuern-lu-2024
Icon=steuern-lu-2024
Categories=Office;
Terminal=false
EOF

    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp "$out/opt/app.png" "$out/share/icons/hicolor/256x256/apps/steuern-lu-2024.png"
'';

  meta = with lib; {
    description = "Tax declaration software 2024 for the canton of Lucerne";
    homepage    = "https://steuersoftware.lu.ch/";
    license     = licenses.unfree;
    platforms   = platforms.linux;
  };
}
