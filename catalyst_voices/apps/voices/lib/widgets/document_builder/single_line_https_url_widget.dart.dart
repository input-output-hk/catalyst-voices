import 'package:catalyst_voices/widgets/text_field/voices_https_text_field.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SingleLineHttpsUrlWidget extends StatelessWidget {
  final String description;
  const SingleLineHttpsUrlWidget({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description.isNotEmpty) ...[
          Text(
            description,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
        ],
        VoicesHttpsTextField(
          controller: controller,
          validator: (value) {
            if (value.isEmpty) {
              return const VoicesTextFieldValidationResult.none();
            }
            if (value == 'https://') {
              return const VoicesTextFieldValidationResult.success();
            } else {
              return const VoicesTextFieldValidationResult.error('Invalid URL');
            }
          },
          readOnly: false,
        ),
      ],
    );
  }
}
