import 'package:flutter/material.dart';

/// A constant grayscale [ColorFilter] used to de-saturate an image.
const _grayscaleFilter = ColorFilter.matrix([
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
]);

/// Applies grayscale filter to a widget.
class GrayscaleFilter extends StatelessWidget {
  final Widget image;

  const GrayscaleFilter({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: _grayscaleFilter,
      child: image,
    );
  }
}
