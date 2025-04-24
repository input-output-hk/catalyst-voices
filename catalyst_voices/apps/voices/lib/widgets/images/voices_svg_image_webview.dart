import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Displays the SVG picture encoded as data uri with
/// media type "image/svg" in a webview.
///
/// The `flutter_svg` package is not capable of handling all SVG features
/// therefore in cases we don't control the input SVGs (i.e. when we get
/// them from the wallet) we let the webview take care of it.
class VoicesSvgImageWebview extends StatefulWidget {
  final String src;
  final ImageErrorWidgetBuilder errorBuilder;

  const VoicesSvgImageWebview({
    super.key,
    required this.src,
    required this.errorBuilder,
  });

  @override
  State<VoicesSvgImageWebview> createState() => _VoicesSvgImageWebviewState();
}

class _VoicesSvgImageWebviewState extends State<VoicesSvgImageWebview> {
  WebResourceError? _error;

  @override
  Widget build(BuildContext context) {
    final error = _error;
    if (error != null) {
      return widget.errorBuilder(context, error, null);
    }

    return InAppWebView(
      initialData: InAppWebViewInitialData(
        data: _fullScreenSvgHtmlPage(widget.src),
      ),
      onReceivedError: (controller, request, error) {
        if (mounted) {
          setState(() {
            _error = error;
          });
        }
      },
    );
  }

  /// A mocked html page that disables scrollbar and makes sure the [svg]
  /// will fill the entire window.
  String _fullScreenSvgHtmlPage(String svg) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <style>
        html, body {
          margin: 0;
          padding: 0;
          width: 100%;
          height: 100%;
          overflow: hidden; /* disables scrollbars */
        }

        img {
          width: 100%;
          height: 100%;
          object-fit: contain; /* or 'cover' depending on desired scaling */
          display: block;
        }
      </style>
    </head>
    <body>
      <img src="$svg">
    </body>
    </html>
    '''
        .trim();
  }
}
