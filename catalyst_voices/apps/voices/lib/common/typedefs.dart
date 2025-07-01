import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

/// Useful when rendering screen states in a Stack and some have to be hidden, like
/// ListView of items when error happened.
typedef DataVisibilityState<T> = ({bool show, T data});

/// Commonly used version of [DataVisibilityState] with [LocalizedException].
typedef ErrorVisibilityState = DataVisibilityState<LocalizedException?>;
