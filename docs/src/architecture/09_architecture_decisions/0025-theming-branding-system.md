---
    title: 0025 Theming and Branding System
    adr:
        author: Catalyst Engineering Team
        created: 15-Jan-2024
        status: accepted
    tags:
        - flutter
        - theming
        - branding
        - material-design
        - frontend
---

## Context

The Catalyst Voices frontend application requires a flexible theming system that:

* Supports multiple brands/themes
* Provides Material Design customization
* Supports light and dark modes
* Enables consistent styling across the application
* Allows for easy brand customization

We need to support:

* Material Design 3 theming
* Custom color schemes
* Brand-specific assets
* Light and dark themes

## Decision

We use a **brand-based theming system** with:

1. **ThemeBuilder**: Utility class for building themes based on brand keys
2. **Brand Enum**: Enumeration of supported brands (currently Catalyst)
3. **ThemeData Extension**: Custom theme extensions for brand-specific assets and colors
4. **Material Design 3**: Based on Material Design 3 color schemes
5. **BrandBloc**: State management for theme switching

## Implementation Details

### ThemeBuilder

```dart
abstract final class ThemeBuilder {
  static ThemeData buildTheme({
    Brand brand = Brand.catalyst,
    Brightness brightness = Brightness.light,
  }) {
    return switch (brand) {
      Brand.catalyst when brightness == Brightness.dark => darkCatalyst,
      Brand.catalyst => catalyst,
    };
  }
}
```

### Brand Enum

```dart
enum Brand {
  catalyst,
}
```

### Theme Data Structure

Each brand has:

* **ColorScheme**: Material Design 3 color scheme
* **VoicesColorScheme**: Custom color scheme for application-specific colors
* **BrandAssets**: Brand-specific assets (logos, images)
* **TextTheme**: Typography configuration

### Usage in MaterialApp

```dart
MaterialApp.router(
  theme: ThemeBuilder.buildTheme(),
  darkTheme: ThemeBuilder.buildTheme(brightness: Brightness.dark),
  themeMode: themeMode, // From BrandBloc or user preference
  // ...
)
```

### Custom Theme Extensions

**VoicesColorScheme**: Application-specific colors

```dart
extension VoicesColorScheme on ThemeData {
  VoicesColorScheme get voicesColors =>
    extension<VoicesColorScheme>()!;
}
```

**BrandAssets**: Brand-specific assets

```dart
extension BrandAssets on ThemeData {
  BrandAssets get brandAssets =>
    extension<BrandAssets>()!;
}
```

### Brand Switching

Theme switching is managed via `BrandBloc`:

```dart
context.read<BrandBloc>().add(
  const BrandChangedEvent(Brand.catalyst),
);
```

### Theme Customization

Themes are defined in `packages/internal/catalyst_voices_brands/lib/src/themes/`:

* `catalyst.dart`: Catalyst brand theme definitions
* Custom theme data for widgets (e.g., `document_builder_theme.dart`)

## Alternatives Considered

### Single Theme

* **Pros**: Simpler implementation
* **Cons**: No brand flexibility, harder to customize
* **Rejected**: Need to support multiple brands

### CSS-like Theming

* **Pros**: Familiar to web developers
* **Cons**: Not idiomatic for Flutter, less type-safe
* **Rejected**: Material Design theming is standard for Flutter

### Third-party Theming Packages

* **Pros**: Additional features
* **Cons**: External dependency, less control
* **Rejected**: Material Design theming is sufficient

## Consequences

### Positive

* Consistent styling across application
* Easy brand customization
* Material Design 3 support
* Light and dark mode support
* Type-safe theme access
* Centralized theme management

### Negative

* Theme setup complexity
* Need to maintain theme definitions
* Brand-specific assets management

### Best Practices

* Define all colors in color schemes
* Use theme extensions for custom properties
* Support both light and dark themes
* Keep brand assets organized
* Use semantic color names
* Document custom theme extensions
