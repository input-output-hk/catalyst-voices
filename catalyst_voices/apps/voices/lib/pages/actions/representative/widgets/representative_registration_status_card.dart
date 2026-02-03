import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class RepresentativeRegistrationStatusCard extends StatelessWidget {
  const RepresentativeRegistrationStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      RepresentativeActionCubit,
      RepresentativeActionState,
      RepresentativeRegistrationStatus?
    >(
      selector: (state) {
        return state.registrationStatus;
      },
      builder: (context, status) {
        return Offstage(
          offstage: status == null,
          child: _RepresentativeRegistrationStatusCard(
            status: status ?? RepresentativeRegistrationStatus.notRegistered,
          ),
        );
      },
    );
  }
}

class _RepresentativeRegistrationStatusCard extends StatelessWidget {
  final RepresentativeRegistrationStatus status;

  const _RepresentativeRegistrationStatusCard({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: status.backgroundColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.status,
            style: context.textTheme.bodyMedium?.copyWith(color: context.colors.textOnPrimaryWhite),
          ),
          Text(
            status.label(context),
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colors.textOnPrimaryWhite,
            ),
          ),
        ],
      ),
    );
  }
}

extension on RepresentativeRegistrationStatus {
  Color backgroundColor(BuildContext context) {
    return switch (this) {
      RepresentativeRegistrationStatus.notRegistered => context.colors.iconsWarning,
      RepresentativeRegistrationStatus.registered => context.colors.iconsSuccess,
    };
  }

  String label(BuildContext context) {
    return switch (this) {
      RepresentativeRegistrationStatus.notRegistered =>
        context.l10n.representativeRegistrationNotFound,
      RepresentativeRegistrationStatus.registered => context.l10n.representativeRegistrationFound,
    };
  }
}
