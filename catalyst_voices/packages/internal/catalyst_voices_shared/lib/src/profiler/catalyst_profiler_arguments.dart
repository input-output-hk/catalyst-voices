final class CatalystProfilerTimelineArguments {
  String? operation;
  String? description;
  DateTime? startTimestamp;

  CatalystProfilerTimelineArguments({
    this.operation,
    this.description,
    this.startTimestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      if (operation case final value?) 'operation': value,
      if (description case final value?) 'description': value,
      if (startTimestamp case final value?) 'startTimestamp': value.toIso8601String(),
    };
  }
}

final class CatalystProfilerTimelineFinishArguments {
  String? status;
  DateTime? endTimestamp;
  Object? hint;
  Duration? took;
  Object? throwable;

  CatalystProfilerTimelineFinishArguments({
    this.status,
    this.endTimestamp,
    this.hint,
    this.took,
    this.throwable,
  });

  Map<String, dynamic> toMap() {
    return {
      if (status case final value?) 'status': value,
      if (endTimestamp case final value?) 'startTimestamp': value.toIso8601String(),
      if (hint case final value?) 'hint': value,
      if (took case final value?) 'took': value,
      if (throwable case final value?) 'throwable': value,
    };
  }
}

final class CatalystProfilerTimelineTaskArguments {
  String? description;
  DateTime? startTimestamp;

  CatalystProfilerTimelineTaskArguments({
    this.description,
    this.startTimestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      if (description case final value?) 'description': value,
      if (startTimestamp case final value?) 'startTimestamp': value.toIso8601String(),
    };
  }
}

final class CatalystProfilerTimelineTaskFinishArguments {
  String? status;
  DateTime? endTimestamp;
  Object? hint;
  Duration? took;
  Object? throwable;

  CatalystProfilerTimelineTaskFinishArguments({
    this.status,
    this.endTimestamp,
    this.hint,
    this.took,
    this.throwable,
  });

  Map<String, dynamic> toMap() {
    return {
      if (status case final value?) 'status': value,
      if (endTimestamp case final value?) 'endTimestamp': value.toIso8601String(),
      if (hint case final value?) 'hint': value,
      if (took case final value?) 'took': value,
      if (throwable case final value?) 'throwable': value,
    };
  }
}
