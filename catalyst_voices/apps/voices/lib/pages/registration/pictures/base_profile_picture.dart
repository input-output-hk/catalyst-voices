import 'package:catalyst_voices/pages/registration/pictures/task_picture.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class BaseProfilePicture extends StatelessWidget {
  final TaskPictureType type;

  const BaseProfilePicture({
    super.key,
    this.type = TaskPictureType.normal,
  });

  @override
  Widget build(BuildContext context) {
    return TaskPicture(
      child: TaskPictureIconBox(
        type: type,
        child: VoicesAssets.images.createBaseProfile.buildIcon(
          allowSize: false,
        ),
      ),
    );
  }
}
