# Catalyst Voices Remote Widgets Example

* [Catalyst Voices Remote Widgets Example](#catalyst-voices-remote-widgets-example)
  * [Create a desire widget in Flutter](#create-a-desire-widget-in-flutter)
  * [Create `rfwtxt` file](#create-rfwtxt-file)
  * [Convert rfwtxt to rfw](#convert-rfwtxt-to-rfw)
  * [Upload rfw file to backend](#upload-rfw-file-to-backend)
  * [Use a remote widget in your app](#use-a-remote-widget-in-your-app)

## Create a desire widget in Flutter

```dart
import 'package:flutter/material.dart';

class LocalWidget extends StatelessWidget {
  const LocalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 350,
        width: 500,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF66AACC),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'First Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 24),
                const Text(
                  'Second Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextField(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFFF1F09),
                  ),
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## Create `rfwtxt` file

Create `remote_widget.rfwtxt` and copy your widget code  after `return` keyword
and adjust the code to be in the format of `rfwtxt` file.
For more about
`rfwtxt` visit [rfw](https://github.com/flutter/packages/tree/main/packages/rfw) repository.

```rfwtxt
import core.widgets;
import core.material;
import core.catalyst;

widget root = Center(
      child: SizedBox(
        height: 350.0,
        width: 500.0,
        child: Card(
          child: Padding(
            padding: [ 16.0 ],
            child: Column(
              mainAxisSize: "min",
              crossAxisAlignment: "start",
              children: [
                Center(
                  child: Text(
                   text: "Sign In",
                   style : {
                      fontSize: 32.0,
                      fontWeight: "w700",
                      color: 0xFF66AACC,
                   }
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  text: "First Name",
                  style: {
                    fontSize: 16.0,
                    fontWeight: "w700",
                  },
                ),
                SizedBox(height: 8.0),
                TextField(
                  style: {
                    fontSize: 16.0,
                    fontWeight: "w700",
                  },
                   onChanged: event 'firstNameHasChanged' { },
                ),
                SizedBox(height: 24.0),
                Text(
                  text:"Second Name",
                  style: {
                    fontSize: 16.0,
                    fontWeight: "w700",
                  },
                ),
                TextField(
                  style: {
                    fontSize: 16.0,
                    color: 0xFFFF1F09,
                  },
                  onChanged: event 'secondNameHasChanged' { },
                ),
                Text(text: data.counter,
                  style: {
                  fontSize: 32.0,
                    color: 0xFF0000FF,
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

```

## Convert rfwtxt to rfw

```sh
dart run bin/main.dart
```

You might need to update the `bin/main.dart` file to point to the correct `rfwtxt` file.

## Upload rfw file to backend

## Use a remote widget in your app

```dart
import 'dart:async';

import 'package:catalyst_voices_remote_widgets/core.dart' as core;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rfw/rfw.dart';

// Remote widget URLs
const _remoteWidgetOneUrl =
    'https://github.com/minikin/utils/raw/main/remote_widget.rfw';

const _remoteWidgetTwoUrl =
    'https://github.com/minikin/utils/raw/main/new_remote_widget.rfw';

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
  String _remoteText = '';
  int _counter = 0;

  void _updateCounter() {
    _counter += 1;
    _data.update('counter', _counter.toString());
  }

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _remoteText,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 227, 17, 38),
                ),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              FloatingActionButton(
                tooltip: 'Send data to remote widget from host',
                onPressed: () => _updateCounter(),
                child: const Icon(Icons.add),
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
    setState(() {
      _remoteText = 'User triggered event "$name" with data: $arguments';
    });
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
```
