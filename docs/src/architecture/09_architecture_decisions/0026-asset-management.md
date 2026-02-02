---
    title: 0026 Asset Management Strategy
    adr:
        author: Catalyst Engineering Team
        created: 15-Jan-2024
        status: accepted
    tags:
        - flutter
        - assets
        - svg
        - optimization
        - frontend
---

## Context

The Catalyst Voices frontend application requires efficient asset management for:

* SVG icons and graphics
* Images (WebP format)
* Fonts
* Videos and animations (Lottie)
* Web asset versioning for cache busting

We need:

* Efficient SVG rendering
* Optimized asset loading
* Cache busting for web deployments
* Type-safe asset access
* Asset compilation pipeline

## Decision

We use a **multi-layered asset management approach**:

1. **SVG Compilation**: SVGs compiled to `vector_graphics` binary format
2. **Asset Generation**: Code generation for type-safe asset access via `flutter_gen`
3. **Web Asset Versioning**: Content-based MD5 hashing for web assets
4. **WebP Images**: WebP format for images (see ADR 0004)
5. **Asset Organization**: Structured asset directories by type

## Implementation Details

### SVG Compilation

SVGs are compiled from `assets_svg_source/` to `assets/` using `vector_graphics_compiler`:

```dart
// compile_svg.dart
final result = encodeSvg(
  xml: svgString,
  debugName: outputPath,
  enableOverdrawOptimizer: false, // Workaround for Flutter issue #174619
);
```

**Workflow**:

1. Place SVG files in `assets_svg_source/`
2. Run `dart run compile_svg.dart`
3. Compiled binary files written to `assets/` maintaining directory structure

**Note**: This is a temporary workaround until
[Flutter issue #158865](https://github.com/flutter/flutter/issues/158865) is resolved.

### Asset Organization

```text
assets/
  ├── images/
  │   ├── category/
  │   ├── opportunities/
  │   └── svg/
  ├── icons/
  ├── lottie/
  ├── videos/
  └── fonts/
```

### Type-Safe Asset Access

Assets are accessed via generated `VoicesAssets` class:

```dart
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';

// SVG asset
CatalystSvgPicture.asset(
  VoicesAssets.icons.catalystLogo,
)

// Image asset
Image.asset(VoicesAssets.images.category.example)
```

### Web Asset Versioning

Web builds use content-based MD5 hashing for cache busting:

```bash
dart run scripts/version_web_assets/version_web_assets.dart \
  --build-dir=apps/voices/build/web
```

**Auto-versioned files**:

* `flutter_bootstrap.js`
* `main.dart.js` (and part files)
* `canvaskit/*.wasm` and `canvaskit/*.js`
* WASM-related files (when `--wasm` flag is used)

**Process**:

1. Calculate MD5 hash for each file
2. Rename file with hash (e.g., `main.dart.js` → `main.dart.abc12345.js`)
3. Update all references in HTML and JavaScript
4. Generate `asset_versions.json` manifest

### Asset Preloading

Images are precached for better performance:

```dart
class GlobalPrecacheImages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Precache critical images
    precacheImage(VoicesAssets.images..., context);
    return child;
  }
}
```

## Alternatives Considered

### Direct SVG Rendering (flutter_svg)

* **Pros**: Simple, no compilation step
* **Cons**: Larger bundle size, slower rendering
* **Rejected**: `vector_graphics` provides better performance

### Manual Asset References

* **Pros**: No code generation
* **Cons**: Error-prone, no type safety
* **Rejected**: Type-safe access prevents errors

### No Web Asset Versioning

* **Pros**: Simpler deployment
* **Cons**: Cache issues, users see stale assets
* **Rejected**: Cache busting is essential for web

## Consequences

### Positive

* Efficient SVG rendering with `vector_graphics`
* Type-safe asset access
* Automatic cache busting for web
* Organized asset structure
* Optimized asset loading

### Negative

* SVG compilation step required
* Web asset versioning adds build complexity
* Need to maintain asset organization

### Best Practices

* Keep SVG source files in `assets_svg_source/`
* Run SVG compilation before builds
* Use generated asset classes for access
* Organize assets by type and feature
* Precache critical images
* Version web assets after builds
* Document manual versioning requirements
