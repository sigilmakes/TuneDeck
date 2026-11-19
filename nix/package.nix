{
  lib,
  python3Packages,
  qt6,
  libxcb-cursor,
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

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  buildInputs = [ qt6.qtbase libxcb-cursor ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libxcb-cursor ]}"
  ];

  doCheck = false;
}
