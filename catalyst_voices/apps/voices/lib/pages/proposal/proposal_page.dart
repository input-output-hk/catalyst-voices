import 'package:catalyst_voices/pages/proposal/proposal_body.dart';
import 'package:catalyst_voices/pages/proposal/proposal_sticky_header.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalPage extends StatefulWidget {
  final String id;
  final String? version;
  final bool isDraft;

  const ProposalPage({
    super.key,
    required this.id,
    this.version,
    required this.isDraft,
  });

  DocumentRef get ref {
    return DocumentRef.build(
      id: id,
      version: version,
      isDraft: isDraft,
    );
  }

  @override
  State<ProposalPage> createState() => _ProposalPageState();
}

class _ProposalPageState extends State<ProposalPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: VoicesAppBar(),
      body: Column(
        children: [
          ProposalStickyHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 48),
              child: ProposalBody(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ProposalPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.ref != oldWidget.ref) {
      final event = ShowProposalEvent(ref: widget.ref);
      context.read<ProposalBloc>().add(event);
    }
  }

  @override
  void initState() {
    super.initState();

    final event = ShowProposalEvent(ref: widget.ref);
    context.read<ProposalBloc>().add(event);
  }

  void _changeVersion(String version) {
    Router.neglect(context, () {
      final ref = widget.ref.copyWith(version: Optional.of(version));
      ProposalRoute.from(ref: ref).replace(context);
    });
  }
}
