# sioyek looks for its configs and shaders in Contents/Resources, but the
# darwin build installs them into Contents/MacOS. Fix it up in a copy of the
# cached package rather than overriding the build, so sioyek isn't
# recompiled from source on every nixpkgs update.
(final: prev: {
  sioyek = prev.runCommand prev.sioyek.name {
    inherit (prev.sioyek) meta;
    nativeBuildInputs = [ prev.perl prev.darwin.sigtool prev.cctools ];
  } ''
    cp -R ${prev.sioyek} $out
    chmod -R u+w $out
    # The launchers exec the original package's .sioyek-wrapped; repoint
    # them at this copy (same-length store path) and re-sign.
    for f in $out/bin/sioyek $out/Applications/sioyek.app/Contents/MacOS/sioyek; do
      perl -0777 -pi -e "s|${prev.sioyek}|$out|g" $f
      codesign -f -s - $f
    done
    app=$out/Applications/sioyek.app/Contents
    for f in prefs.config keys.config tutorial.pdf shaders; do
      cp -R $app/MacOS/$f $app/Resources/
    done
  '';
})
