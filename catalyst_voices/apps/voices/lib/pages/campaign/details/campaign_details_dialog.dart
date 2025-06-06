import 'dart:async';

import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/pages/campaign/details/widgets/campaign_header.dart';
import 'package:catalyst_voices/pages/campaign/details/widgets/campaign_sections_list_view.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class CampaignDetailsDialog extends StatefulWidget {
  final String id;

  const CampaignDetailsDialog._({
    required this.id,
  });

  @override
  State<CampaignDetailsDialog> createState() => _CampaignDetailsDialogState();

  static Future<void> show(
    BuildContext context, {
    required String id,
  }) {
    return VoicesDialog.show(
      context: context,
      routeSettings: RouteSettings(name: '/campaign/$id'),
      builder: (context) => CampaignDetailsDialog._(id: id),
    );
  }
}

class _CampaignDetailsDialogState extends State<CampaignDetailsDialog> {
  late final CampaignDetailsBloc _bloc;

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

  @override
  void didUpdateWidget(CampaignDetailsDialog oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.id != oldWidget.id) {
      _bloc.add(LoadCampaignEvent(id: widget.id));
    }
  }

  @override
  void dispose() {
    unawaited(_bloc.close());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _bloc = Dependencies.instance.get();
    _bloc.add(LoadCampaignEvent(id: widget.id));
  }
}
