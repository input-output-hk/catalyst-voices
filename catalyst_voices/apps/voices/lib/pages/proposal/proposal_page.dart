import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/containers/space_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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

  @override
  State<ProposalPage> createState() => _ProposalPageState();
}

class _ProposalPageState extends State<ProposalPage> {
  @override
  void didUpdateWidget(covariant ProposalPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.id != oldWidget.id) {
      print('Changed id from ${oldWidget.id} to ${widget.id}');
    }

    if (widget.version != oldWidget.version) {
      print('Changed version from ${oldWidget.version} to ${widget.version}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SpaceScaffold(
      left: Center(child: Text('Left')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'id:${widget.id}\nver:${widget.version}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          VoicesFilledButton(
            child: Text('Ver'),
            onTap: () {
              Router.neglect(context, () {
                ProposalRoute(
                  proposalId: widget.id,
                  version: const Uuid().v7(),
                  draft: widget.isDraft,
                ).replace(context);
              });
            },
          ),
        ],
      ),
      right: Center(child: Text('Right')),
    );
  }
}
