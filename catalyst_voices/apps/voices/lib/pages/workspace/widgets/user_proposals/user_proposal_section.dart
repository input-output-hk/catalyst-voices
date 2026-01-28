import 'package:catalyst_voices/pages/workspace/widgets/user_proposals/proposal_card/workspace_proposal_card.dart';
import 'package:catalyst_voices/widgets/headers/section_learn_more_header.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserProposalSection extends StatefulWidget {
  final List<UsersProposalOverview> items;
  final String title;
  final String info;
  final String? learnMoreUrl;
  final String emptyTextMessage;

  const UserProposalSection({
    super.key,
    required this.items,
    required this.emptyTextMessage,
    required this.title,
    required this.info,
    this.learnMoreUrl,
  });

  @override
  State<UserProposalSection> createState() => _UserProposalSectionState();
}

class _ListOfProposals extends StatelessWidget {
  final List<UsersProposalOverview> items;
  final String emptyTextMessage;

  const _ListOfProposals({
    required this.items,
    required this.emptyTextMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
          child: Text(emptyTextMessage),
        ),
      );
    }

    return SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return WorkspaceProposalCard(
          key: ValueKey(item.id),
          proposal: item,
        );
      },
    );
  }
}

class _ProposalVisibility extends StatelessWidget {
  final bool isExpanded;
  final List<UsersProposalOverview> items;
  final String emptyTextMessage;

  const _ProposalVisibility({
    required this.isExpanded,
    required this.items,
    required this.emptyTextMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (!isExpanded) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return _ListOfProposals(
      items: items,
      emptyTextMessage: emptyTextMessage,
    );
  }
}

class _UserProposalSectionState extends State<UserProposalSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: SectionLearnMoreHeader(
            title: widget.title,
            info: widget.info,
            learnMoreUrl: widget.learnMoreUrl,
            isExpanded: _isExpanded,
            onExpandedChanged: _onExpandedChanged,
          ),
        ),
        _ProposalVisibility(
          isExpanded: _isExpanded,
          items: widget.items,
          emptyTextMessage: widget.emptyTextMessage,
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(UserProposalSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.items, widget.items)) {
      _setVisibility();
    }
  }

  @override
  void initState() {
    super.initState();
    _setVisibility();
  }

  void _onExpandedChanged(bool value) {
    setState(() {
      _isExpanded = value;
    });
  }

  void _setVisibility() {
    _isExpanded = widget.items.isNotEmpty;
  }
}
