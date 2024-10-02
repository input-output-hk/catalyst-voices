import 'package:catalyst_voices/pages/registration/pictures/task_picture.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class PasswordPicture extends StatelessWidget {
  const PasswordPicture({super.key});

  @override
  Widget build(BuildContext context) {
    return TaskPicture(
      child: TaskPictureIconBox(
        type: TaskPictureType.error,
        child: VoicesAssets.icons.lockClosed.buildIcon(size: 48),
      ),
    );
  }
}
