import 'package:flutter/material.dart';

class VoicesImagesScheme extends StatelessWidget {
  final Widget image;
  final Widget background;
  const VoicesImagesScheme({
    super.key,
    required this.image,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        background,
        image,
      ],
    );
  }
}
