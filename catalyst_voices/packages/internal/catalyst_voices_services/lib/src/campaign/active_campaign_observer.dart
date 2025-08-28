import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';

abstract interface class ActiveCampaignObserver {
  Campaign? get campaign;

  set campaign(Campaign? value);

  Stream<Campaign?> get watchCampaign;

  Future<void> dispose();
}

final class ActiveCampaignObserverImpl implements ActiveCampaignObserver {
  Campaign? _campaign;

  final _campaignSC = StreamController<Campaign?>.broadcast();

  ActiveCampaignObserverImpl();

  @override
  Campaign? get campaign => _campaign;

  @override
  set campaign(Campaign? value) {
    if (_campaign == value) {
      return;
    }

    _campaign = value;
    _campaignSC.add(value);
  }

  @override
  Stream<Campaign?> get watchCampaign async* {
    yield _campaign;
    yield* _campaignSC.stream;
  }

  @override
  Future<void> dispose() async {
    await _campaignSC.close();
  }
}
