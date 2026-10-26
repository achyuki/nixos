{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  gawk,
  wayland-scanner,

  fontconfig,
  fuse3,
  spice-protocol,
  nettle,
  libGL,
  libxkbcommon,

  libx11,
  libxi,
  libxfixes,
  libxrandr,
  libxcursor,
  libxinerama,
  libxpresent,
  libxscrnsaver,

  wayland,
  wayland-protocols,
  libdecor,

  pipewire,
  pulseaudio,
  libsamplerate,

  elfutils,
  libunwind,
  usbredir,

  openGLSupport ? true,
  xorgSupport ? true,
  waylandSupport ? true,
  libdecorSupport ? true,
  pipewireSupport ? true,
  pulseSupport ? true,
  usbAudioSupport ? true,
  backtraceSupport ? true,
}:

assert xorgSupport || waylandSupport;
assert usbAudioSupport -> (pipewireSupport || pulseSupport);

stdenv.mkDerivation (finalAttrs: {
  pname = "looking-glass-client";
  version = "cdba29f2";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "LookingGlass";
    rev = "cdba29f2f6bcae3ded26369fc231a067cbca3752";
    hash = "sha256-/QE1Hre4Q7YplkudZZ7DSzmosY/MJc1XiAy69xcBXg4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    gawk
  ]
  ++ lib.optionals waylandSupport [
    wayland-scanner
  ];

  buildInputs = [
    fontconfig
    fuse3
    spice-protocol
    nettle
    libGL
    libxkbcommon
  ]
  ++ lib.optionals xorgSupport [
    libx11
    libxi
    libxfixes
    libxrandr
    libxcursor
    libxinerama
    libxpresent
    libxscrnsaver
  ]
  ++ lib.optionals waylandSupport [
    wayland
    wayland-protocols
  ]
  ++ lib.optionals (waylandSupport && libdecorSupport) [
    libdecor
  ]
  ++ lib.optionals (pipewireSupport || pulseSupport) [
    libsamplerate
  ]
  ++ lib.optionals pipewireSupport [
    pipewire
  ]
  ++ lib.optionals pulseSupport [
    pulseaudio
  ]
  ++ lib.optionals backtraceSupport [
    elfutils
    libunwind
  ]
  ++ lib.optionals usbAudioSupport [
    usbredir
  ];

  cmakeFlags = [
    "-DOPTIMIZE_FOR_NATIVE=OFF"
  ]
  ++ lib.optionals (!openGLSupport) [ "-DENABLE_OPENGL=OFF" ]
  ++ lib.optionals (!xorgSupport) [ "-DENABLE_X11=OFF" ]
  ++ lib.optionals (!waylandSupport) [ "-DENABLE_WAYLAND=OFF" ]
  ++ lib.optionals (!(waylandSupport && libdecorSupport)) [ "-DENABLE_LIBDECOR=OFF" ]
  ++ lib.optionals (!pipewireSupport) [ "-DENABLE_PIPEWIRE=OFF" ]
  ++ lib.optionals (!pulseSupport) [ "-DENABLE_PULSEAUDIO=OFF" ]
  ++ lib.optionals (!usbAudioSupport) [ "-DENABLE_USB_AUDIO=OFF" ]
  ++ lib.optionals (!backtraceSupport) [ "-DENABLE_BACKTRACE=OFF" ];

  postUnpack = ''
    echo ${finalAttrs.src.rev} > source/VERSION
    export sourceRoot=source/client
  '';

  strictDeps = true;

  meta = {
    description = "KVM Frame Relay (KVMFR) client";
    homepage = "https://looking-glass.io/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "looking-glass-client";
    platforms = [ "x86_64-linux" ];
  };
})
