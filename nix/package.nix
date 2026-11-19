{
  lib,
  python3Packages,
  qt6,
  libxcb-cursor,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  src = lib.cleanSource ./..;
  pyproject = lib.importTOML (src + "/pyproject.toml");
in
python3Packages.buildPythonApplication {
  pname = "tunedeck";
  inherit src;
  version = pyproject.project.version;
  pyproject = true;

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    textual
    rich
    platformdirs
    dbus-fast
    pyside6
  ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [ qt6.qtbase libxcb-cursor ];

  desktopItems = [
    (makeDesktopItem {
      name = "tunedeck";
      desktopName = "TuneDeck";
      comment = "Control JBL headphones, earbuds and speakers";
      exec = "tunedeck-gui";
      icon = "tunedeck";
      categories = [ "AudioVideo" "Audio" "Utility" ];
      keywords = [ "JBL" "headphones" "bluetooth" "equalizer" ];
    })
  ];

  postInstall = ''
    install -Dm644 ${src}/tunedeck_gui/assets/logo.png $out/share/pixmaps/tunedeck.png
  '';

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libxcb-cursor ]}"
  ];

  doCheck = false;
}
