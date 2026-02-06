import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/text/day_at_time_text.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class SubmissionCloseDateCategoryDetailText extends StatelessWidget {
  const SubmissionCloseDateCategoryDetailText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CategoryDetailCubit, CategoryDetailState, DateTime?>(
      selector: (state) {
        return state.submissionCloseAt;
      },
      builder: (context, dateTime) {
        if (dateTime != null) {
          return _SubmissionCloseAt(dateTime);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _SubmissionCloseAt extends StatelessWidget {
  final DateTime dateTime;

  const _SubmissionCloseAt(this.dateTime);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14,
      children: [
        VoicesAssets.icons.calendar.buildIcon(),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.proposalsSubmissionClose,
              style: context.textTheme.bodyMedium,
            ),
            DayAtTimeText(
              dateTime: dateTime,
              showTimezone: true,
            ),
          ],
        ),
      ],
    );
  }
}
