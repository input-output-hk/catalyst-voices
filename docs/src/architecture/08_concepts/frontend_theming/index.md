---
icon: material/palette
---

# Frontend Theming System

This section documents the theming and branding system used in the Catalyst Voices frontend
application.

## Overview

The application uses a brand-based theming system built on Material Design 3, supporting multiple
brands and light/dark modes.

## Architecture

### ThemeBuilder

The `ThemeBuilder` utility class provides a centralized way to build themes:

```dart
ThemeData buildTheme({
  Brand brand = Brand.catalyst,
  Brightness brightness = Brightness.light,
})
```

### Brand System

Brands are defined as enums:

* `Brand.catalyst`: Catalyst brand theme

Each brand supports:

* Light theme
* Dark theme
* Custom color schemes
* Brand-specific assets

### Theme Structure

Each theme consists of:

1. **ColorScheme**: Material Design 3 color scheme
2. **VoicesColorScheme**: Application-specific colors
3. **BrandAssets**: Brand-specific assets (logos, images)
4. **TextTheme**: Typography configuration
5. **Component Themes**: Custom themes for specific widgets

### Custom Theme Extensions

**VoicesColorScheme**: Extends ThemeData with application-specific colors:

* Voting colors (positive, negative, abstain)
* Discovery colors
* Surface and elevation colors
* Icon colors

**BrandAssets**: Provides brand-specific assets:

* Logos
* Images
* Brand identifiers

### Usage

```dart
// Access theme colors
final colorScheme = Theme.of(context).colorScheme;
final voicesColors = Theme.of(context).voicesColors;

// Access brand assets
final brandAssets = Theme.of(context).brandAssets;
```

### Theme Switching

Theme switching is managed via `BrandBloc`:

```dart
context.read<BrandBloc>().add(
  const BrandChangedEvent(Brand.catalyst),
);
```

The app automatically rebuilds with the new theme.

## Material Design 3

The theming system is based on Material Design 3:

* Dynamic color schemes
* Material You design principles
* Adaptive components
* Consistent spacing and typography

## Best Practices

1. **Use semantic colors**: Prefer theme colors over hard-coded colors
2. **Support both themes**: Always test light and dark modes
3. **Extend ThemeData**: Use theme extensions for custom properties
4. **Organize by brand**: Keep brand-specific assets organized
5. **Document custom colors**: Document the purpose of custom colors
