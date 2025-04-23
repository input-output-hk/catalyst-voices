import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPublicVerificationStatusChip extends StatelessWidget {
  const AccountPublicVerificationStatusChip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AccountCubit, AccountState, AccountPublicStatus>(
      selector: (state) => state.accountPublicStatus,
      builder: (context, state) => _Chip(status: state),
    );
  }
}

class _Chip extends StatelessWidget {
  final AccountPublicStatus status;

  const _Chip({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesChip.round(
      content: Text(
        status.localizedName(context),
        style: context.textTheme.labelSmall
            ?.copyWith(color: status.foregroundColor(context)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 6),
      backgroundColor: status.backgroundColor(context),
    );
  }
}

extension on AccountPublicStatus {
  Color backgroundColor(BuildContext context) {
    return switch (this) {
      AccountPublicStatus.verified => context.colors.success,
      AccountPublicStatus.verifying ||
      AccountPublicStatus.banned ||
      AccountPublicStatus.notSetup ||
      AccountPublicStatus.unknown =>
        context.colorScheme.error,
    };
  }

  Color foregroundColor(BuildContext context) {
    return switch (this) {
      AccountPublicStatus.verified ||
      AccountPublicStatus.verifying ||
      AccountPublicStatus.banned ||
      AccountPublicStatus.notSetup ||
      AccountPublicStatus.unknown =>
        context.colors.textOnPrimaryWhite,
    };
  }

  String localizedName(BuildContext context) {
    return switch (this) {
      AccountPublicStatus.verified => context.l10n.verified,
      AccountPublicStatus.verifying => context.l10n.verificationPending,
      AccountPublicStatus.banned ||
      AccountPublicStatus.notSetup ||
      AccountPublicStatus.unknown =>
        context.l10n.notVerified,
    };
  }
}
