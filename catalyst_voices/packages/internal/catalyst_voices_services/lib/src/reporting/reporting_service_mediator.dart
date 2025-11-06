import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

abstract interface class ReportingServiceMediator {
  factory ReportingServiceMediator(
    ReportingService reportingService,
    UserService userService,
  ) = ReportingServiceMediatorImpl;

  FutureOr<void> dispose();

  FutureOr<void> init();
}

final class ReportingServiceMediatorImpl implements ReportingServiceMediator {
  final ReportingService _reportingService;
  final UserService _userService;

  StreamSubscription<Account?>? _activeAccountSub;

  ReportingServiceMediatorImpl(
    this._reportingService,
    this._userService,
  );

  @override
  FutureOr<void> dispose() async {
    await _activeAccountSub?.cancel();
    _activeAccountSub = null;
  }

  @override
  FutureOr<void> init() {
    assert(_activeAccountSub == null, 'Reporting service already initialized');

    _activeAccountSub = _userService.watchUser
        .map((event) => event.activeAccount)
        .distinct()
        .listen(_onActiveAccountChanged);
  }

  void _onActiveAccountChanged(Account? account) {
    unawaited(_reportingService.reportingAs(account));
  }
}
