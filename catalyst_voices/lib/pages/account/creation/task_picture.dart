import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

enum TaskPictureType {
  normal,
  success,
  error;

  Color _foregroundColor(ThemeData theme) {
    return switch (this) {
      // TODO(damian-molinski): Color should come from colors scheme
      TaskPictureType.normal => const Color(0xFF0C288D),
      TaskPictureType.success => theme.colors.successContainer!,
      TaskPictureType.error => theme.colors.errorContainer!,
    };
  }

  Color _backgroundColor(ThemeData theme) {
    return switch (this) {
      // TODO(damian-molinski): Color should come from colors scheme
      TaskPictureType.normal => const Color(0xFFCCE2FF),
      TaskPictureType.success => theme.colors.success!,
      TaskPictureType.error => theme.colorScheme.error,
    };
  }
}

class TaskKeychainPicture extends StatelessWidget {
  final TaskPictureType type;

  const TaskKeychainPicture({
    super.key,
    this.type = TaskPictureType.normal,
  });

  @override
  Widget build(BuildContext context) {
    return TaskPicture(
      child: TaskPictureIconBox(
        type: type,
        child: VoicesAssets.images.keychain.buildIcon(allowSize: false),
      ),
    );
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

    final foregroundColor = type._foregroundColor(theme);
    final backgroundColor = type._backgroundColor(theme);

    final iconThemeData = IconThemeData(color: foregroundColor);

    return IconTheme(
      data: iconThemeData,
      child: Container(
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
