import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CampaignDetailsDialog extends StatefulWidget {
  final String id;

  const CampaignDetailsDialog._({
    required this.id,
  });

  static Future<void> show(
    BuildContext context, {
    required String id,
  }) {
    return VoicesDialog.show(
      context: context,
      routeSettings: RouteSettings(name: '/campaign_${id}_details'),
      builder: (context) => CampaignDetailsDialog._(id: id),
      barrierDismissible: true,
    );
  }

  @override
  State<CampaignDetailsDialog> createState() => _CampaignDetailsDialogState();
}

class _CampaignDetailsDialogState extends State<CampaignDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return VoicesDetailsDialog(
      title: 'Boost Social Entrepreneurship',
      titleLabel: 'Campaign',
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(child: Text(index.toString()));
        },
      ),
    );
  }
}
