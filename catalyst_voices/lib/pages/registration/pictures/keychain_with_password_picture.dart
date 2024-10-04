import 'package:catalyst_voices/pages/registration/pictures/task_picture.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

class KeychainWithPasswordPicture extends StatelessWidget {
  const KeychainWithPasswordPicture({super.key});

  @override
  Widget build(BuildContext context) {
    return TaskPicture(
      child: TaskPictureIconBox(
        type: TaskPictureType.success,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VoicesAssets.images.keychain.buildIcon(allowSize: false),
            Align(
              alignment: const Alignment(0.52, -0.4),
              child: VoicesAssets.icons.lockClosed.buildIcon(),
            ),
          ],
        ),
      ),
    );
  }
}
