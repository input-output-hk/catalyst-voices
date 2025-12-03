import 'dart:async';

import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';

class ReviewRequestButton extends StatelessWidget {
  final DocumentRef id;

  const ReviewRequestButton({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return VoicesOutlinedButton(
      onTap: () => _onTap(context),
      child: Text(context.l10n.reviewRequest),
    );
  }

  void _onTap(BuildContext context) {
    unawaited(ProposalRoute.fromRef(ref: id).push(context));
  }
}
