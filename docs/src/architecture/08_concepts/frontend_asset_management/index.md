---
icon: material/file-image
---

# Frontend Asset Management

This section documents asset management patterns and processes in the Catalyst Voices
frontend application.

## Overview

The application manages various asset files, images, fonts, videos, and animations with a focus
on performance and type safety.

## Asset Types

### SVG Graphics

SVGs are compiled to `vector_graphics` binary format for efficient rendering:

* **Source**: `assets_svg_source/` directory
* **Compiled**: `assets/` directory
* **Tool**: `vector_graphics_compiler`
* **Format**: Binary vector graphics format

### Images

* **Format**: WebP (see ADR 0004)
* **Organization**: By feature/category
* **Precaching**: Critical images precached on app start

### Fonts

* **Font Family**: SF Pro Rounded
* **Location**: `assets/fonts/`
* **Generated Access**: Via `VoicesFonts` class

### Animations

* **Lottie**: JSON-based animations
* **Location**: `assets/lottie/`
* **Usage**: Via `lottie` package

### Videos

* **Location**: `assets/videos/`
* **Format**: Platform-appropriate formats

## Asset Compilation

### SVG Compilation Process

1. Place SVG files in `assets_svg_source/`
2. Run compilation script:

   ```bash
   dart run compile_svg.dart
   ```

3. Compiled files written to `assets/` maintaining directory structure

**Note**: This is a temporary workaround until Flutter issue #158865 is resolved.

### Code Generation

Assets are accessed via generated classes:

* `VoicesAssets`: Type-safe asset access
* `VoicesFonts`: Font access
* `VoicesColors`: Color definitions

Generated via `flutter_gen_runner` and `flutter_gen`.

## Web Asset Versioning

Web builds use content-based MD5 hashing for cache busting:

### Process

1. Calculate MD5 hash for each asset
2. Rename file with hash
3. Update all references
4. Generate manifest file

### Auto-Versioned Files

* JavaScript files (`main.dart.js`, `flutter_bootstrap.js`)
* WASM files (`canvaskit/*.wasm`)
* Related symbol files

### Manual Versioning

Some files require manual version updates when changed (filenames hardcoded in Dart).

## Asset Access Patterns

### Type-Safe Access

```dart
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';

// SVG
CatalystSvgPicture.asset(VoicesAssets.icons.catalystLogo)

// Image
Image.asset(VoicesAssets.images.category.example)

// Font
TextStyle(fontFamily: VoicesFonts.sfProRounded)
```

### Asset Preloading

Critical assets are precached:

```dart
precacheImage(VoicesAssets.images..., context);
```

## Best Practices

1. **Organize by type**: Keep assets organized by type and feature
2. **Use generated classes**: Always use generated asset classes
3. **Optimize SVGs**: Keep SVG files optimized before compilation
4. **Version web assets**: Always version web assets after builds
5. **Precache critical assets**: Precache images used immediately
6. **Document manual versioning**: Document files requiring manual versioning
