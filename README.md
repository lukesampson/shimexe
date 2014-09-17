shimexe
=======

Quickly add executables to your path.

### How to install
With [Scoop](http://scoop.sh), run:
```
scoop install https://raw.githubusercontent.com/lukesampson/shimexe/master/scoop/shim.json
```

### How to build from source..

Run `src/build.ps1`. This creates `lib/shim.exe`, which is the .NET executable used by `bin/shim.ps1` when creating shims.


### To create shims...

If you haven't installed with [Scoop](http://scoop.sh), you can create shims using `bin/shim.ps1`. Run without arguments for help.
