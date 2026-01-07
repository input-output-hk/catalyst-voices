# Catalyst Voices Assets

```sh
dart run build_runner build
```

## Adding SVG files

* Drop new `.svg` assets into `assets_svg_source`.
* Run:

  ```sh
  dart run compile_svg_to_vec.dart
  ```

  This script mirrors `assets_svg_source` directory layout and writes the generated `vector_graphics`
binary format files into `assets`.
* This workaround stays in place until <https://github.com/flutter/flutter/issues/158865> is resolved.

When the Flutter issue is fixed we can switch to the `transformers` solution:

```yaml
flutter:
  generate: true
  assets:
    # --no-optimize-overdraw - https://github.com/flutter/flutter/issues/174619
    - assets/images/
    - path: assets/images/category/
      transformers:
        - package: vector_graphics_compiler
          args: ['--no-optimize-overdraw']
    - assets/images/opportunities/
    - path: assets/images/svg/
      transformers:
        - package: vector_graphics_compiler
          args: ['--no-optimize-overdraw']
    - path: assets/icons/
      transformers:
        - package: vector_graphics_compiler
          args: ['--no-optimize-overdraw']
    - assets/lottie/
    - assets/videos/
```
