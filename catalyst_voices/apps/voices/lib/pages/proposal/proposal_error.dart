import 'dart:async';

import 'package:catalyst_voices/common/typedefs.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalError extends StatelessWidget {
  const ProposalError({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalCubit, ProposalState, ErrorVisibilityState>(
      selector: (state) => (show: state.showError, data: state.error),
      builder: (context, state) {
        final errorMessage = state.data?.message(context);

        return Offstage(
          offstage: !state.show,
          child: _ProposalError(
            message: errorMessage ?? context.l10n.somethingWentWrong,
          ),
        );
      },
    );
  }
}

class _ProposalError extends StatelessWidget {
  final String message;

  const _ProposalError({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VoicesErrorIndicator(
        message: message,
        onRetry: () {
          unawaited(context.read<ProposalCubit>().retryLastRef());
        },
      ),
    );
  }
}
