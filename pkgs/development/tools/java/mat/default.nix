{ stdenv, fetchzip, makeDesktopItem, makeWrapper
, freetype, fontconfig, libX11, libXrender, zlib
, glib, gtk3, libXtst, jdk11, gsettings-desktop-schemas
, webkitgtk ? null  # for internal web browser,
, autoPatchelfHook
}:

# The build process is almost like eclipse's.
# See `pkgs/applications/editors/eclipse/*.nix`

stdenv.mkDerivation rec {
  pname = "mat";
  version = "1.10.0.20200225";

  buildInputs = [
    fontconfig freetype glib gsettings-desktop-schemas gtk3 jdk11 libX11
    libXrender libXtst makeWrapper zlib
  ] ++ stdenv.lib.optional (webkitgtk != null) webkitgtk;

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];

  src = fetchzip {
    url = "https://www.eclipse.org/downloads/download.php?mirror_id=1&file=/mat/1.10.0/rcp/MemoryAnalyzer-${version}-linux.gtk.x86_64.zip";
    sha256 = "03105w81msnzmmz8sv076ijlrzsfi90mjizghj2ppwcaiv5p65v8";
    extraPostFetch = ''
      chmod go-w $out
    '';
  };

  installPhase = ''
    mkdir -p $out/
    cp -r . $out/mat

    makeWrapper $out/mat/MemoryAnalyzer $out/bin/MemoryAnalyzer \
      --prefix PATH : ${jdk11}/bin \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath ([ glib gtk3 libXtst ] ++ stdenv.lib.optional (webkitgtk != null) webkitgtk)} \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" 
  '';

  meta = with stdenv.lib; {
    homepage = https://www.eclipse.org/mat/;
    description = "The Eclipse Memory Analyzer is a fast and feature-rich Java heap analyzer that helps you find memory leaks and reduce memory consumption.";
    longDescription = ''
    The Eclipse Memory Analyzer is a fast and feature-rich Java heap analyzer that helps you find memory leaks and reduce memory consumption.

    Use the Memory Analyzer to analyze productive heap dumps with hundreds of millions of objects, quickly calculate the retained sizes of objects, see who is preventing the Garbage Collector from collecting objects, run a report to automatically extract leak suspects.
    '';
    license = licenses.epl10;
    platforms = [ "x86_64-linux" ];
    maintainers = [];
  };
}
