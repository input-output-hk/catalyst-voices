import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

enum TaskPictureType {
  normal,
  success,
  error;

  // TODO(damian-molinski): Color should come from colors scheme
  Color foregroundColor(
    ThemeData theme, {
    bool isHighlight = false,
  }) {
    return switch (this) {
      TaskPictureType.normal when isHighlight => const Color(0xFF728EF3),
      TaskPictureType.normal => const Color(0xFF0C288D),
      TaskPictureType.success when isHighlight => const Color(0xFFF2F4F8),
      TaskPictureType.success => const Color(0xFF1D722A),
      TaskPictureType.error when isHighlight => const Color(0xFFF2F4F8),
      TaskPictureType.error => const Color(0xFFAD0000),
    };
  }

  // TODO(damian-molinski): Color should come from colors scheme
  Color _backgroundColor(ThemeData theme) {
    return switch (this) {
      TaskPictureType.normal => const Color(0xFFCCE2FF),
      TaskPictureType.success => const Color(0xFFBAEDC2),
      TaskPictureType.error => const Color(0xFFFF9999),
    };
  }
}

class TaskPicture extends StatelessWidget {
  final Size preferredSize;
  final Widget child;

  // Original size is 125 but we want to have it scale with overall picture
  static const _childSizeFactor = 125 / 354;

  const TaskPicture({
    super.key,
    // Original asset sizes. "Magic number" from figma.
    this.preferredSize = const Size(354, 340),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints
            .constrainSizeAndAttemptToPreserveAspectRatio(preferredSize);
        final childSize = Size.square(size.width * _childSizeFactor);

        return SizedBox.fromSize(
          size: size,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              CatalystImage.asset(
                VoicesAssets.images.taskIllustration.path,
                width: size.width,
                height: size.height,
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tight(childSize),
                child: child,
              ),
            ],
          ),
        );
      },
    );
  }
}

class TaskPictureIconBox extends StatelessWidget {
  final TaskPictureType type;
  final Widget child;

  const TaskPictureIconBox({
    super.key,
    this.type = TaskPictureType.normal,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final foregroundColor = type.foregroundColor(theme);
    final backgroundColor = type._backgroundColor(theme);

    final iconThemeData = IconThemeData(color: foregroundColor);

    return IconTheme(
      data: iconThemeData,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
