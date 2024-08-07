import 'package:catalyst_voices/widgets/toggles/voices_checkbox.dart';
import 'package:flutter/material.dart';

class VoicesCheckboxGroup extends StatelessWidget {
  const VoicesCheckboxGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VoicesCheckbox(
          value: false,
          label: Text('Select All'),
          onChanged: (value) {},
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VoicesCheckbox(
              value: false,
              label: Text('Founded'),
              onChanged: (value) {},
            ),
            VoicesCheckbox(
              value: false,
              label: Text('Not Founded'),
              onChanged: (value) {},
            ),
            VoicesCheckbox(
              value: false,
              label: Text('In Progress'),
              onChanged: (value) {},
            ),
          ],
        ),
      ],
    );
  }
}
