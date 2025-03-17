import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalVersion extends StatelessWidget {
  final bool readOnly;
  final bool showBorder;

  const ProposalVersion({
    super.key,
    this.readOnly = false,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBloc, ProposalState, List<DocumentVersion>>(
      selector: (state) => state.data.header.versions,
      builder: (context, state) {
        return _ProposalVersion(
          versions: state,
          readOnly: readOnly,
          showBorder: showBorder,
        );
      },
    );
  }
}

class _ProposalVersion extends StatelessWidget {
  final bool readOnly;
  final bool showBorder;
  final List<DocumentVersion> versions;

  const _ProposalVersion({
    required this.readOnly,
    required this.showBorder,
    required this.versions,
  });

  @override
  Widget build(BuildContext context) {
    return DocumentVersionSelector(
      versions: versions,
      onSelected: readOnly
          ? null
          : (value) {
              final signal = ChangeVersionSignal(to: value);
              context.read<ProposalBloc>().emitSignal(signal);
            },
      readOnly: readOnly,
      showBorder: showBorder,
    );
  }
}
