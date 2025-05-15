import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class DocumentBuilderTheme extends InheritedTheme {
  final DocumentBuilderThemeData data;

  const DocumentBuilderTheme({
    super.key,
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(DocumentBuilderTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DocumentBuilderTheme(data: data, child: child);
  }

  static DocumentBuilderThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DocumentBuilderTheme>()?.data;
  }

  static DocumentBuilderThemeData of(BuildContext context) {
    final data = maybeOf(context);
    assert(data != null, 'Could not find DocumentBuilderTheme in widget tree');
    return data!;
  }
}

class DocumentBuilderThemeData extends Equatable {
  final bool? shouldDebounceChange;

  const DocumentBuilderThemeData({
    this.shouldDebounceChange,
  });

  @override
  List<Object?> get props => [
        shouldDebounceChange,
      ];
}
