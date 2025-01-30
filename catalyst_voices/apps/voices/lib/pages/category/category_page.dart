import 'package:catalyst_voices/pages/category/left_side.dart';
import 'package:catalyst_voices/widgets/cards/category_proposals_details_card.dart';
import 'package:catalyst_voices/widgets/cards/create_proposal_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPage extends StatefulWidget {
  final String categoryId;

  const CategoryPage({super.key, required this.categoryId});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsivePadding(
        xs: const EdgeInsets.symmetric(horizontal: 12),
        sm: const EdgeInsets.symmetric(horizontal: 20),
        md: const EdgeInsets.symmetric(horizontal: 120),
        lg: const EdgeInsets.symmetric(horizontal: 120),
        other: const EdgeInsets.symmetric(horizontal: 120),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LeftSide(
                categoryId: widget.categoryId,
              ),
            ),
            const SizedBox(width: 48),
            _CardInformation(
              categoryId: widget.categoryId,
              categoryName: 'Cardano Use Cases: Concept',
              categoryProposalsCount: 256,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardInformation extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final int categoryProposalsCount;
  const _CardInformation({
    required this.categoryId,
    required this.categoryName,
    required this.categoryProposalsCount,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 300),
      child: Column(
        children: [
          const SizedBox(height: 96),
          CategoryProposalsDetailsCard(
            categoryId: categoryId,
            categoryName: categoryName,
            categoryProposalsCount: categoryProposalsCount,
          ),
          const SizedBox(height: 16),
          BlocSelector<SessionCubit, SessionState, bool>(
            selector: (state) {
              final isProposer = state.account?.isProposer ?? false;
              return (isProposer && state.isActive);
            },
            builder: (context, state) {
              return Offstage(
                offstage: !state,
                child: CreateProposalCard(
                  categoryId: categoryId,
                  categoryName: categoryName,
                  categoryRequirements: const [
                    'Based on community need',
                    'Basic prototype required',
                    'Greenfield project',
                  ],
                  submissionCloseDate: DateTime(2025, 2, 15, 8, 24),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
