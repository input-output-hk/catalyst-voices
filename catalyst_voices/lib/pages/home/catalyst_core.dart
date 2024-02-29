import 'package:flutter/material.dart';
import 'package:rfw/rfw.dart';

Map<String, LocalWidgetBuilder> get _catalystCoreWidgetsDefinitions =>
    <String, LocalWidgetBuilder>{
      'TextField': (BuildContext context, DataSource source) {
        return TextField(
          controller: source.v<TextEditingController>(['controller']),
          focusNode: source.v<FocusNode>(['focusNode']),
          undoController: source.v<UndoHistoryController>(['undoController']),
          decoration: source.v<InputDecoration>(['decoration']),
          keyboardType: source.v<TextInputType>(['keyboardType']),
          textInputAction: source.v<TextInputAction>(['textInputAction']),
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
