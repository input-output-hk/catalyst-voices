import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

typedef DataVisibilityState<T> = ({bool show, T data});

typedef DataWidgetBuilder<T> = Widget Function(BuildContext context, T data);

typedef VisibilityState = ({bool show, LocalizedException? error});
