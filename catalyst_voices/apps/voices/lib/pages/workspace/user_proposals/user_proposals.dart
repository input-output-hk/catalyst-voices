import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';

class UserProposals extends StatefulWidget {
  final List<Proposal> items;

  const UserProposals({super.key, required this.items});

  @override
  State<UserProposals> createState() => _UserProposalsState();
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.myProposals,
      style: context.textTheme.headlineSmall,
    );
  }
}

class _ListOfProposals extends StatelessWidget {
  final List<Proposal> items;
  final String emptyTextMessage;

  const _ListOfProposals({
    required this.items,
    required this.emptyTextMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        child: Text(emptyTextMessage),
      );
    } else {
      return Column(
        children: items
            .map(
              (e) => WorkspaceProposalCard(
                key: ValueKey(e.selfRef),
                proposal: e,
              ),
            )
            .toList(),
      );
    }
  }
}

class _NotPublishedHeader extends StatelessWidget {
  final bool isExpanded;
  final ValueChanged<bool>? onExpandedChanged;

  const _NotPublishedHeader({
    this.isExpanded = false,
    this.onExpandedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SectionLearnMoreHeader(
      title: context.l10n.notPublished,
      // TODO(LynxLynxx): update when we get info from designers
      info: '',
      learnMoreUrl: VoicesConstants.proposalPublishingDocsUrl,
      isExpanded: isExpanded,
      onExpandedChanged: onExpandedChanged,
    );
  }
}

class _ProposalVisibility extends StatelessWidget {
  final bool isExpanded;
  final List<Proposal> items;
  final String emptyTextMessage;

  const _ProposalVisibility({
    required this.isExpanded,
    required this.items,
    required this.emptyTextMessage,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: isExpanded
          ? _ListOfProposals(
              items: items,
              emptyTextMessage: emptyTextMessage,
            )
          : const SizedBox.shrink(),
    );
  }
}

class _SharedForPublicHeader extends StatelessWidget {
  final bool isExpanded;
  final ValueChanged<bool>? onExpandedChanged;

  const _SharedForPublicHeader({
    this.isExpanded = false,
    this.onExpandedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SectionLearnMoreHeader(
      title: context.l10n.sharedForPublicInProgress,
      // TODO(LynxLynxx): update when we get info from designers
      info: 'info',
      learnMoreUrl: VoicesConstants.proposalPublishingDocsUrl,
      isExpanded: isExpanded,
      onExpandedChanged: onExpandedChanged,
    );
  }
}

class _SubmittedForReviewHeader extends StatelessWidget {
  final int maxCount;
  final int submittedCount;
  final bool isExpanded;
  final ValueChanged<bool>? onExpandedChanged;

  const _SubmittedForReviewHeader({
    required this.maxCount,
    required this.submittedCount,
    required this.isExpanded,
    this.onExpandedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SectionLearnMoreHeader(
      title: context.l10n.submittedForReview(submittedCount, maxCount),
      // TODO(LynxLynxx): update when we get info from designers
      info: 'Info',
      learnMoreUrl: VoicesConstants.proposalPublishingDocsUrl,
      onExpandedChanged: onExpandedChanged,
      isExpanded: isExpanded,
    );
  }
}

class _UserProposalsState extends State<UserProposals> {
  late bool _isPublishedExpanded;
  late bool _isLocalExpanded;
  late bool _isDraftExpanded;

  List<Proposal> get _draft =>
      widget.items.where((e) => e.publish.isDraft).toList();
  List<Proposal> get _local =>
      widget.items.where((e) => e.publish.isLocal).toList();

  List<Proposal> get _submitted =>
      widget.items.where((e) => e.publish.isPublished).toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(),
          VoicesDivider(
            indent: 0,
            endIndent: 0,
            height: 56,
            color: context.colors.primaryContainer,
          ),
          _SubmittedForReviewHeader(
            maxCount: 5,
            submittedCount: _submitted.length,
            isExpanded: _isPublishedExpanded,
            onExpandedChanged: _onPublishedExpandedChanged,
          ),
          _ProposalVisibility(
            isExpanded: _isPublishedExpanded,
            items: _submitted,
            emptyTextMessage: context.l10n.noFinalUserProposals,
          ),
          _SharedForPublicHeader(
            isExpanded: _isDraftExpanded,
            onExpandedChanged: _onDraftExpandedChanged,
          ),
          _ProposalVisibility(
            isExpanded: _isDraftExpanded,
            items: _draft,
            emptyTextMessage: context.l10n.noDraftUserProposals,
          ),
          _NotPublishedHeader(
            isExpanded: _isLocalExpanded,
            onExpandedChanged: _onLocalExpandedChanged,
          ),
          _ProposalVisibility(
            isExpanded: _isLocalExpanded,
            items: _local,
            emptyTextMessage: context.l10n.noLocalUserProposals,
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant UserProposals oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _setVisibility();
    }
  }

  @override
  void initState() {
    super.initState();
    _setVisibility();
  }

  void _onDraftExpandedChanged(bool value) {
    setState(() {
      _isDraftExpanded = value;
    });
  }

  void _onLocalExpandedChanged(bool value) {
    setState(() {
      _isLocalExpanded = value;
    });
  }

  void _onPublishedExpandedChanged(bool value) {
    setState(() {
      _isPublishedExpanded = value;
    });
  }

  void _setVisibility() {
    _isPublishedExpanded = _submitted.isNotEmpty;
    _isLocalExpanded = _local.isNotEmpty;
    _isDraftExpanded = _draft.isNotEmpty;
  }
}
