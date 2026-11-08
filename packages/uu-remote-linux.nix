{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland-scanner,
  wrapGAppsHook3,
  gtk3,
  SDL2,
  glib,
  libei,
  libxkbcommon,
  libx11,
  libxext,
  libxfixes,
  libxtst,
  pam,
  pipewire,
  wayland,
  xrandr,
  ffmpeg,
  pulseaudio,
  wl-clipboard,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uu-remote-linux";
  version = "0.2.56";

  src = fetchFromGitHub {
    owner = "VallierDev";
    repo = "uu-remote-linux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EUeD8h7ifXxdscRq/MXX0KHdkD97YOJexqPHGucXfQU=";
  };

  cargoHash = "sha256-XTlXZe9R9Dmp/0aDincwnbcD/lQvePm3k01Ii1NK+zA=";

  # The upstream release feature set: the wlroots Wayland and GNOME/KDE portal engines are
  # built as dlopen'ed plugins, so an X11 host needs none of their libraries present.
  buildFeatures = [
    "wayland"
    "portal"
    "engine-plugins"
    "native-viewer"
    "viewer-sdl"
  ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    wrapGAppsHook3
  ];

  nativeCheckInputs = [ ffmpeg ];

  buildInputs = [
    glib
    gtk3
    libei
    libxkbcommon
    libx11
    libxext
    libxfixes
    libxtst
    pipewire
    SDL2
    wayland
  ];

  postInstall = ''
    # build.rs drops the runtime-loaded engines next to the binaries.
    plugin_dir=$(dirname "$(find target -type f -name uuremote-server | head -n1)")
    mkdir -p $out/lib/uu-remote-linux
    install -m755 "$plugin_dir/libuu-wayland.so" "$plugin_dir/libuu-portal.so" \
      $out/lib/uu-remote-linux/
    # cargoInstallHook also copies every shared library to $out/lib; the host loads the
    # engines from lib/uu-remote-linux only, so keep a single copy there.
    rm -f $out/lib/libuu-wayland.so $out/lib/libuu-portal.so

    install -Dm644 contrib/desktop/uu-remote-linux.desktop \
      $out/share/applications/uu-remote-linux.desktop
    install -Dm644 contrib/desktop/uu-remote-linux-viewer.desktop \
      $out/share/applications/uu-remote-linux-viewer.desktop
    install -Dm644 contrib/desktop/uu-remote-linux.svg \
      $out/share/icons/hicolor/scalable/apps/uu-remote-linux.svg

    # Opt-in access to /dev/uinput for keyboard and mouse injection on Wayland; pick it up with
    # `services.udev.packages = [ pkgs.uu-remote-linux ];`.
    install -d $out/lib/udev/rules.d
    echo 'KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"' \
      > $out/lib/udev/rules.d/60-uu-remote-linux-uinput.rules
  '';

  # `uuremote-server` shells out to these at runtime; FFmpeg needs libx264 for desktop video.
  # libpam is dlopen'ed (c_engine/pam_check.c) for the auto-unlock check, so it has to be
  # reachable through LD_LIBRARY_PATH instead of a link-time dependency. wrapGAppsHook3
  # also hands the GTK login and host windows their GSettings schemas and pixbuf loaders.
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          pulseaudio
          wl-clipboard
          xrandr
        ]
      }
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pam ]}
    )
  '';

  # The suite spawns real child processes (ffmpeg, login shells on a pty). Some of them need
  # a writable HOME, which the build sandbox does not provide, and runs are only reproducible
  # with a single test thread; with both in place all ~350 upstream cases pass.
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkFlags = [ "--test-threads=1" ];

  meta = {
    description = "Unofficial Linux host for NetEase UU Remote";
    homepage = "https://github.com/VallierDev/uu-remote-linux";
    license = lib.licenses.gpl3Plus;
    mainProgram = "uuremote-server";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
