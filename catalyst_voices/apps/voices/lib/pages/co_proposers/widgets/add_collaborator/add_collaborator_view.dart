import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/signal_handler.dart';
import 'package:catalyst_voices/pages/co_proposers/widgets/add_collaborator/add_collaborator_button.dart';
import 'package:catalyst_voices/pages/co_proposers/widgets/add_collaborator/add_collaborator_text_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class AddCollaboratorView extends StatefulWidget {
  const AddCollaboratorView({super.key});

  @override
  State<AddCollaboratorView> createState() => _AddCollaboratorViewState();
}

class _AddCollaboratorViewState extends State<AddCollaboratorView>
    with
        ErrorHandlerStateMixin<AddCollaboratorCubit, AddCollaboratorView>,
        SignalHandlerStateMixin<AddCollaboratorCubit, AddCollaboratorSignal, AddCollaboratorView> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(40, 42, 40, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HeaderIcon(),
            _HeaderText(),
            SizedBox(height: 24),
            _Description(),
            SizedBox(height: 28),
            AddCollaboratorTextField(),
            SizedBox(height: 24),
            AddCollaboratorButton(),
          ],
        ),
      ),
    );
  }

  @override
  void handleSignal(AddCollaboratorSignal signal) {
    return switch (signal) {
      ValidCollaboratorIdSignal(:final catalystId) => _popWithResult(catalystId),
    };
  }

  void _popWithResult(CatalystId catalystId) {
    Navigator.pop(context, catalystId);
  }
}

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.howToAddCollaboratorDescription);
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon();

  @override
  Widget build(BuildContext context) {
    return VoicesAssets.icons.userGroup.buildIcon(
      size: 76,
      color: context.colors.iconsPrimary,
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.addCollaborator,
      style: context.textTheme.titleLarge,
    );
  }
}
