import 'dart:async';

import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/co_proposers/widgets/add_collaborator/add_collaborator_view.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class AddCollaboratorDialog extends StatefulWidget {
  final CatalystId authorId;
  final CollaboratorsIds collaborators;

  const AddCollaboratorDialog({super.key, required this.authorId, required this.collaborators});

  @override
  State<AddCollaboratorDialog> createState() => _AddCollaboratorDialogState();

  static Future<CatalystId?> show(
    BuildContext context, {
    required CatalystId authorId,
    CollaboratorsIds? collaborators,
  }) async {
    return VoicesDialog.show(
      context: context,
      builder: (context) => AddCollaboratorDialog(
        authorId: authorId,
        collaborators: collaborators ?? const CollaboratorsIds(),
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
      child: const ScaffoldMessenger(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: VoicesPanelDialog(
            constraints: Responsive.single(BoxConstraints(maxWidth: 602, maxHeight: 396)),
            child: AddCollaboratorView(),
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
    _cubit = Dependencies.instance.get<AddCollaboratorCubit>();

    _cubit.init(collaborators: widget.collaborators, authorCatalystId: widget.authorId);
  }
}
