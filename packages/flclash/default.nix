{
  lib,
  stdenv,
  flutter,
  fetchFromGitHub,
  runCommand,
  go_1_27,
  cargo,
  rustc,
  gitMinimal,
  cacert,
  writeShellScriptBin,
  pkg-config,
  autoPatchelfHook,
  glib,
  gtk3,
  libsecret,
  libayatana-appindicator,
  yq-go,
}:

let
  version = "0.9.3";

  # The Git tree carries two submodules, both of which are published as
  # separate repositories over SSH in .gitmodules, so they are fetched
  # individually instead of with `fetchSubmodules`.
  flclashSource = fetchFromGitHub {
    owner = "chen08209";
    repo = "FlClash";
    tag = "v${version}";
    hash = "sha256-zmJKfKyi3YaRw74uur/Rf9U3NimCG3TWIInINeD+zqs=";
  };

  clashMeta = fetchFromGitHub {
    owner = "chen08209";
    repo = "Clash.Meta";
    rev = "024245dc72bc92f48237f865119afe0cd53ac9e6";
    hash = "sha256-4eBx2dfXrrG+tJXZLINvVuiWgn3DWbUg3i9/lHUF/XA=";
  };

  prismUi = fetchFromGitHub {
    owner = "chen08209";
    repo = "prism_ui";
    rev = "63450c0ac0e8e1b2c0f3ed4ad7926dc94e083185";
    hash = "sha256-4imx9nyjrqv2up4PvB4yY6MN6icq0izHRhaesJxmqXg=";
  };

  src = runCommand "flclash-${version}-source" { } ''
    cp -r ${flclashSource} $out
    chmod -R u+w $out

    rm -rf $out/core/Clash.Meta $out/plugins/prism_ui
    mkdir -p $out/core $out/plugins
    cp -r ${clashMeta} $out/core/Clash.Meta
    cp -r ${prismUi} $out/plugins/prism_ui
  '';

  # The Go core is compiled by FlClash's own Dart build hook with a plain
  # `go build`, so the dependencies are vendored ahead of time.
  goModules = stdenv.mkDerivation {
    pname = "flclash-go-modules";
    inherit version src;

    nativeBuildInputs = [
      go_1_27
      gitMinimal
      cacert
    ];

    env.GOTOOLCHAIN = "local";

    buildPhase = ''
      runHook preBuild

      export GOMODCACHE=$TMPDIR/go-mod
      export GOCACHE=$TMPDIR/go-cache
      export GOPATH=$TMPDIR/go

      (cd core && go mod vendor)

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r core/vendor $out/vendor

      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-hdB0z+Zd/neLRwqVcBCw8E3I/4Bla2rGsJvACPjMWw4=";
  };

  # Likewise, the Rust helper in services/helper and the flutter_rust_bridge
  # library in plugins/rust_api are compiled by build hooks that call Cargo
  # directly, so both lock files are vendored into one directory source.
  cargoDeps = stdenv.mkDerivation {
    pname = "flclash-cargo-deps";
    inherit version src;

    nativeBuildInputs = [
      cargo
      rustc
      gitMinimal
      cacert
    ];

    env.CARGO_HOME = "/build/cargo-home";

    # Some crates ship shell scripts whose shebangs would otherwise be rewritten
    # to a store path, which a fixed-output derivation may not reference.
    dontPatchShebangs = true;

    buildPhase = ''
      runHook preBuild

      mkdir -p vendor-helper vendor-rust-api
      (cd services/helper && cargo vendor --locked "$PWD/../../vendor-helper" >/dev/null)
      (cd plugins/rust_api/rust && cargo vendor --locked "$PWD/../../../vendor-rust-api" >/dev/null)

      # The two lock files pin different versions of a few crates, and
      # `cargo vendor` only appends the version to names that clash inside a
      # single run, so every crate is stored under <name>-<version>.
      mkdir vendor
      for dir in vendor-helper/* vendor-rust-api/*; do
        name="$(sed -n 's/^name = "\(.*\)"$/\1/p' "$dir/Cargo.toml" | head -n 1)"
        version="$(sed -n 's/^version = "\(.*\)"$/\1/p' "$dir/Cargo.toml" | head -n 1)"
        target="vendor/$name-$version"
        if [ -e "$target" ]; then
          diff -r "$dir" "$target" >/dev/null || {
            echo "vendor: conflicting content for $name-$version" >&2
            exit 1
          }
        else
          cp -r "$dir" "$target"
        fi
      done

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r vendor $out/vendor

      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-h68gE1pLIxyhWi7QdjLw+NHkFwaFGXZmWutQrV7J/KA=";
  };

  # native_toolchain_rust, which builds the flutter_rust_bridge library, insists
  # on driving Cargo through rustup. Nixpkgs ships exactly the toolchain pinned
  # in rust-toolchain.toml, so a shim is enough.
  rustup = writeShellScriptBin "rustup" ''
    case "$1" in
      run)
        shift 2
        exec "$@"
        ;;
      show | toolchain)
        echo "${rustc.version}-${stdenv.hostPlatform.rust.rustcTarget} (default)"
        ;;
      *)
        exec ${cargo}/bin/cargo "$@"
        ;;
    esac
  '';
in

flutter.buildFlutterApplication {
  pname = "flclash";
  inherit version src;

  # The Dart frontend takes the language version of the root package from
  # pubspec.lock's aggregate `sdks` field, which here records the constraints of
  # the resolved dependencies (>=3.13.2). That is newer than what the app itself
  # declares, where 3.10 semantics are still required.
  pubspecLock =
    let
      lock = lib.importJSON ./pubspec.lock.json;
    in
    lock
    // {
      sdks = lock.sdks // {
        dart = ">=3.10.0 <4.0.0";
      };
    };
  gitHashes = lib.importJSON ./git-hashes.json;

  flutterBuildFlags = [ "--dart-define=APP_ENV=stable" ];

  # The in-app autostart toggle records `Platform.resolvedExecutable`, which is
  # the bundle binary here; starting that directly skips the launcher wrapper
  # (LD_LIBRARY_PATH and the gapps environment), so native assets such as
  # librust_api.so cannot be found. The patch points the entry at the wrapper
  # and rewrites it on every start so an upgrade replaces the stale path.
  patches = [ ./autostart-wrapper.patch ];

  # sqlcipher_flutter_libs 0.7.0+eol is an empty placeholder: it ships no
  # CMakeLists.txt to patch, and the default nixpkgs builder expects one.
  customSourceBuilders.sqlcipher_flutter_libs = { src, ... }: src;

  nativeBuildInputs = [
    go_1_27
    cargo
    rustc
    rustup
    pkg-config
    autoPatchelfHook
  ];

  buildInputs = [
    glib
    gtk3
    libsecret
    libayatana-appindicator
  ];

  preBuild = ''
    # FlClash's build hook writes libclash/ into the root of the workspace it
    # resolves, and pub2nix points the workspace's path dependencies at the
    # read-only store copy, so re-point them at the build tree.
    substituteInPlace .dart_tool/package_config.json \
      --replace-fail "file://${src}" "file://$PWD"

    # The Dart build hook drives `go build` and `cargo build` from the source
    # tree, so point both of them at the pre-fetched dependencies.
    cp -r ${goModules}/vendor core/vendor

    export HOME=$TMPDIR
    export GOCACHE=$TMPDIR/go-cache

    # Flutter runs the Dart build hooks with an environment it composes itself,
    # so the Cargo source replacement goes where Cargo always looks, $HOME/.cargo.
    mkdir -p "$HOME/.cargo"
    cat > "$HOME/.cargo/config.toml" <<EOF
    [source.crates-io]
    replace-with = "vendored-sources"

    [source.vendored-sources]
    directory = "${cargoDeps}/vendor"
    EOF
    export CARGO_NET_OFFLINE=true
  '';

  postInstall = ''
    install -Dm 444 ${./flclash.desktop} $out/share/applications/flclash.desktop
    install -Dm 444 assets/images/icon.png $out/share/icons/hicolor/512x512/apps/flclash.png

    # The bundle-level files are linked into bin by the Flutter install phase,
    # but only the executables belong there: the Dart fixup hook wraps every
    # entry and refuses anything that is not executable.
    rm -f $out/bin/manifest.json
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Native assets built by the Dart build hook, such as the
      # flutter_rust_bridge library, are opened by bare file name from inside
      # libflutter_linux_gtk.so, whose own RPATH does not cover the bundle.
      --prefix LD_LIBRARY_PATH : "$out/app/$pname/lib"
      # The tray and the keyring are opened at runtime as well.
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libayatana-appindicator libsecret ]}"
    )
  '';

  passthru = {
    # Keeps the generated lock file reproducible; see the update notes in README.
    pubspecSource = runCommand "pubspec.lock.json" {
      inherit src;
      nativeBuildInputs = [ yq-go ];
    } ''
      ${lib.getExe yq-go} eval --output-format=json --prettyPrint "$src/pubspec.lock" > $out
    '';
  };

  meta = {
    description = "Multi-platform proxy client based on ClashMeta";
    homepage = "https://github.com/chen08209/FlClash";
    mainProgram = "FlClash";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
