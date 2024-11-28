import 'dart:async';

import 'package:catalyst_voices/pages/campaign/details/widgets/campaign_header.dart';
import 'package:catalyst_voices/pages/campaign/details/widgets/campaign_sections_list_view.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final _bloc = CampaignDetailsBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(LoadCampaign(id: widget.id));
  }

  @override
  void didUpdateWidget(covariant CampaignDetailsDialog oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.id != oldWidget.id) {
      _bloc.add(LoadCampaign(id: widget.id));
    }
  }

  @override
  void dispose() {
    unawaited(_bloc.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: const VoicesDetailsDialog(
        header: CampaignHeader(),
        body: CampaignSectionsListView(),
      ),
    );
  }
}
