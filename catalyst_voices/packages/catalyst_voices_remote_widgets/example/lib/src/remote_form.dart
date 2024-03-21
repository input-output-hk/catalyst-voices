import 'dart:async';

import 'package:catalyst_voices_remote_widgets/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rfw/rfw.dart';

const _remoteWidgetOneUrl =
    'https://github.com/minikin/minikin.github.io/raw/main/rfw/remote_widget.rfw';

const _remoteWidgetTwoUrl =
    'https://github.com/minikin/minikin.github.io/raw/main/rfw/new_remote_widget.rfw';

class RemoteForm extends StatefulWidget {
  const RemoteForm({super.key});

  @override
  State<RemoteForm> createState() => _RemoteFormState();
}

class _RemoteFormState extends State<RemoteForm> {
  static const remoteName = LibraryName(['remote']);
  static const catalystCore = LibraryName(['core', 'catalyst']);
  static const widgets = LibraryName(['core', 'widgets']);
  static const material = LibraryName(['core', 'material']);

  final _runtime = Runtime();
  final _data = DynamicContent();

  String _remoteWidgetUrl = _remoteWidgetOneUrl;
  late final Future<void> _widgetFuture;

  bool _showInitialWidget = true;

  void _toggleShowWidget() {
    setState(() {
      _showInitialWidget = !_showInitialWidget;
    });
    if (_showInitialWidget) {
      _remoteWidgetUrl = _remoteWidgetOneUrl;
    } else {
      _remoteWidgetUrl = _remoteWidgetTwoUrl;
    }
    _fetchWidget();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _widgetFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              RemoteWidget(
                runtime: _runtime,
                data: _data,
                widget: const FullyQualifiedWidgetName(remoteName, 'root'),
                onEvent: onEvent,
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                tooltip: 'Fetch new remote widget',
                onPressed: () => _toggleShowWidget(),
                child: const Icon(Icons.refresh),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _registerWidgets();
    _widgetFuture = _fetchWidget();
  }

  @override
  void reassemble() {
    super.reassemble();
    _fetchWidget();
  }

  Future<void> onEvent(String name, DynamicMap arguments) async {
    debugPrint('user triggered event "$name" with data: $arguments');
  }

  void _configure() {
    _widgetFuture = _fetchWidget();
  }

  Future<void> _fetchWidget() async {
    final res = await http.get(
      Uri.parse(
        _remoteWidgetUrl,
      ),
    );

    if (res.statusCode == 200) {
      final remoteWidget = decodeLibraryBlob(res.bodyBytes);
      _runtime.update(remoteName, remoteWidget);
    }
  }

  void _registerWidgets() {
    _runtime
      ..update(
        widgets,
        createCoreWidgets(),
      )
      ..update(
        material,
        createMaterialWidgets(),
      )
      ..update(
        catalystCore,
        core.createCatalystCoreWidgets(),
      );
  }
}
