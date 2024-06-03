import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class UserProfileButton extends StatelessWidget {
  final String? user;

  const UserProfileButton({
    super.key,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return CircleAvatar(
        backgroundColor: Theme.of(context).colors.avatarsWarning,
        child: Text(user![0]),
      );
    } else {
      return Chip(
        shape: const RoundedRectangleBorder(
        // This is a custom chip that simulates a button look&feel, so visual 
        // property are specified.
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        label: Text(context.l10n.userProfileGuestLabelText),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
      );
    }
  }
}
