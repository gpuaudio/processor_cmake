# Processor

## Configure

Configure on Windows:
```
cmake -S . -B ../@BUILD
```

Configure on macOS:
```
cmake -S . -B ../@BUILD -GXcode
```

Configure on Linux:
```
cmake -S . -B ../@BUILD -GNinja
```

## Build
```
cmake --build ../@BUILD --config Release
cmake --build ../@BUILD --config RelWithDebInfo
cmake --build ../@BUILD --config Debug
```
