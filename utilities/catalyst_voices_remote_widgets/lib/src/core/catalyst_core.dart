import 'package:flutter/material.dart';
import 'package:rfw/rfw.dart';

/// Returns a map of Catalyst core widget definitions.
///
/// The map contains a collection of [LocalWidgetBuilder] functions
/// that define the core widgets used in Catalyst.
Map<String, LocalWidgetBuilder> get _catalystCoreWidgetsDefinitions =>
    <String, LocalWidgetBuilder>{
      'TextField': (BuildContext context, DataSource source) {
        return TextField(
          style: ArgumentDecoders.textStyle(source, ['style']),
          onChanged: source.handler(
            <Object>['onChanged'],
            (HandlerTrigger trigger) => (Object? value) => trigger(
                  <String, Object?>{'value': value},
                ),
          ),
        );
      },
    };

/// Creates a [LocalWidgetLibrary] containing the Catalyst core widgets.
///
/// The [LocalWidgetLibrary] is created using the
/// [_catalystCoreWidgetsDefinitions]
/// map of widget definitions.
LocalWidgetLibrary createCatalystCoreWidgets() =>
    LocalWidgetLibrary(_catalystCoreWidgetsDefinitions);
