import 'package:catalyst_voices/pages/registration/widgets/registration_tile.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class CreateAccountMethods extends StatelessWidget {
  final ValueChanged<CreateAccountType> onTap;

  const CreateAccountMethods({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RegistrationCubit, RegistrationState, RegistrationGetStartedState>(
      selector: (state) => state.getStarted,
      builder: (context, state) {
        return _CreateAccountMethods(
          methods: state.availableMethods,
          onTap: onTap,
        );
      },
    );
  }
}

class _CreateAccountMethods extends StatelessWidget {
  final List<CreateAccountType> methods;
  final ValueChanged<CreateAccountType> onTap;

  const _CreateAccountMethods({
    required this.methods,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: methods.map((method) {
        return RegistrationTile(
          key: Key(method.toString()),
          icon: method._icon,
          title: method._getTitle(context.l10n),
          subtitle: method._getSubtitle(context.l10n),
          semanticsIdentifier: method.toString(),
          onTap: () => onTap(method),
        );
      }).toList(),
    );
  }
}

extension on CreateAccountType {
  SvgGenImage get _icon => switch (this) {
    CreateAccountType.createNew => VoicesAssets.icons.colorSwatch,
    CreateAccountType.recover => VoicesAssets.icons.download,
  };

  String _getSubtitle(VoicesLocalizations l10n) {
    return l10n.accountCreationOnThisDevice;
  }

  String _getTitle(VoicesLocalizations l10n) => switch (this) {
    CreateAccountType.createNew => l10n.accountCreationCreate,
    CreateAccountType.recover => l10n.accountCreationRecover,
  };
}
