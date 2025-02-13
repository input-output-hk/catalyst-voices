import 'package:flutter_bloc/flutter_bloc.dart';

/// Filters out duplicate events and processes events sequentially.
EventTransformer<Event> uniqueEvents<Event>() {
  return (events, mapper) => events.distinct().asyncExpand(mapper);
}
