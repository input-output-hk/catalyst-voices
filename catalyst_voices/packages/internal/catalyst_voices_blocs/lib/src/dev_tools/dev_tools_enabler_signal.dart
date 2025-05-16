part of 'dev_tools_signal.dart';

final class AlreadyEnabledSignal extends DevToolsEnablerSignal {
  const AlreadyEnabledSignal();
}

final class BecameDeveloperSignal extends DevToolsEnablerSignal {
  const BecameDeveloperSignal();
}

sealed class DevToolsEnablerSignal extends DevToolsSignal {
  const DevToolsEnablerSignal();
}

final class TapsLeftSignal extends DevToolsEnablerSignal {
  final int count;

  const TapsLeftSignal({
    required this.count,
  });
}
