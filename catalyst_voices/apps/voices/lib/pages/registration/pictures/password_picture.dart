import 'package:catalyst_voices/pages/registration/pictures/task_picture.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class PasswordPicture extends StatelessWidget {
  final TaskPictureType type;

  const PasswordPicture({
    super.key,
    this.type = TaskPictureType.normal,
  });

  @override
  Widget build(BuildContext context) {
    return TaskPicture(
      child: TaskPictureIconBox(
        type: type,
        child: VoicesAssets.icons.lockClosed.buildIcon(size: 48),
      ),
    );
  }
}
