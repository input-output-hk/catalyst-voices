import 'dart:async';

import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/co_proposers/widgets/add_collaborator/add_collaborator_view.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class AddCollaboratorDialog extends StatefulWidget {
  final CatalystId authorId;
  final Collaborators collaborators;

  const AddCollaboratorDialog({super.key, required this.authorId, required this.collaborators});

  @override
  State<AddCollaboratorDialog> createState() => _AddCollaboratorDialogState();

  static Future<CatalystId?> show(
    BuildContext context, {
    required CatalystId authorId,
    Collaborators? collaborators,
  }) async {
    return VoicesDialog.show(
      context: context,
      builder: (context) => AddCollaboratorDialog(
        authorId: authorId,
        collaborators: collaborators ?? const Collaborators(),
      ),
      routeSettings: const RouteSettings(name: '/add-collaborator-dialog'),
    );
  }
}

class _AddCollaboratorDialogState extends State<AddCollaboratorDialog> {
  late final AddCollaboratorCubit _cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: ScaffoldMessenger(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: VoicesPanelDialog(
            constraints: const Responsive.single(BoxConstraints(maxWidth: 602, maxHeight: 396)),
            child: const AddCollaboratorView(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final proposalService = Dependencies.instance.get<ProposalService>();
    _cubit = AddCollaboratorCubit(
      proposalService,
      collaborators: widget.collaborators,
      authorCatalystId: widget.authorId,
    );
  }
}
