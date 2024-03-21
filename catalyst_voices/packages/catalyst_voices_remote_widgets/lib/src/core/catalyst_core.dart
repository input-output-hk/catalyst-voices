import 'package:flutter/material.dart';
import 'package:rfw/rfw.dart';

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

LocalWidgetLibrary createCatalystCoreWidgets() =>
    LocalWidgetLibrary(_catalystCoreWidgetsDefinitions);
