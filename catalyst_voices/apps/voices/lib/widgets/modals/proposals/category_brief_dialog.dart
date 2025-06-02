import 'package:catalyst_voices/pages/category/category_compact_detail_view.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CategoryBriefDialog extends StatefulWidget {
  final CampaignCategoryDetailsViewModel category;

  const CategoryBriefDialog({super.key, required this.category});

  @override
  State<CategoryBriefDialog> createState() => _CategoryBriefDialogState();

  static Future<void> show(
    BuildContext context, {
    required CampaignCategoryDetailsViewModel category,
  }) async {
    return VoicesDialog.show(
      context: context,
      builder: (context) => VoicesSinglePaneDialog(
        constraints: const BoxConstraints(
          maxWidth: 900,
          maxHeight: 768,
        ),
        child: CategoryBriefDialog(category: category),
      ),
      routeSettings: const RouteSettings(name: '/category-brief-dialog'),
    );
  }
}

class _CategoryBriefDialogState extends State<CategoryBriefDialog> {
  late final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return VoicesScrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: CategoryCompactDetailView(category: widget.category),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }
}
