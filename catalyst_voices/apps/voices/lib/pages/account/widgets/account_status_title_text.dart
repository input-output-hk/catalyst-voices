import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class AccountStatusTitleText extends StatelessWidget {
  final MyAccountStatusNotification data;

  const AccountStatusTitleText({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: data.title(context),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: ': '),
          TextSpan(text: data.titleDesc(context)),
        ],
      ),
      style: context.textTheme.labelLarge?.copyWith(
        color: data.type.foregroundColor(context),
      ),
      maxLines: 1,
      overflow: TextOverflow.clip,
    );
  }
}
