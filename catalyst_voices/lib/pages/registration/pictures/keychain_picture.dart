import 'package:catalyst_voices/pages/registration/pictures/task_picture.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class KeychainPicture extends StatelessWidget {
  final TaskPictureType type;

  const KeychainPicture({
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
