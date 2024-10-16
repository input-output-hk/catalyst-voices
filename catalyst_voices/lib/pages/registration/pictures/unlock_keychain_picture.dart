import 'package:catalyst_voices/pages/registration/pictures/task_picture.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class UnlockKeychainPicture extends StatelessWidget {
  const UnlockKeychainPicture({super.key});

  @override
  Widget build(BuildContext context) {
    return TaskPicture(
      child: TaskPictureIconBox(
        child: AspectRatio(
          aspectRatio: 101 / 42,
          child: Container(
            height: double.infinity,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv0,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
