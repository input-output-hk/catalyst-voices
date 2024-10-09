import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:flutter/material.dart';

class AccountDetailsPanel extends StatelessWidget {
  const AccountDetailsPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24),
        Text('Catalyst account recovery'),
        SizedBox(height: 24),
        SizedBox(height: 24),
        Spacer(),
        SizedBox(height: 24),
        VoicesFilledButton(
          onTap: () {},
          child: Text('Set unlock password for this device'),
        ),
        SizedBox(height: 10),
        VoicesTextButton(
          onTap: () {},
          child: Text('Back'),
        ),
      ],
    );
  }
}
