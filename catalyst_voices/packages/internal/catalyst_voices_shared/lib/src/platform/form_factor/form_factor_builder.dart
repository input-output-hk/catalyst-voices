import 'package:catalyst_voices_shared/src/platform/form_factor/form_factor.dart';
import 'package:flutter/material.dart';

/// A builder which allows to build different widgets per [CatalystFormFactor.current].
class FormFactorBuilder<T> extends StatelessWidget {
  final Widget Function(BuildContext context, T data) builder;
  final Map<CatalystFormFactor, T?> _data;

  FormFactorBuilder({
    super.key,
    required this.builder,
    required T mobile,
    required T desktop,
  }) : _data = {
         CatalystFormFactor.mobile: mobile,
         CatalystFormFactor.desktop: desktop,
       };

  @override
  Widget build(BuildContext context) {
    return builder(context, _getData());
  }

  T _getData() {
    return _data[CatalystFormFactor.current]!;
  }
}
