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
  final Widget child;

  const TaskPicture({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        CatalystImage.asset(VoicesAssets.images.taskIllustration.path),
        child,
      ],
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
        constraints: BoxConstraints.tight(const Size.square(125)),
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
