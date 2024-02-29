import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final filePath = 'public/home_page.rfw';
  final file = File(filePath);

  if (await file.exists()) {
    final bytes = await file.readAsBytes();

    print('Serving bytes: $bytes');

    return Response.bytes(
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'rfw',
      },
      body: bytes,
    );
  } else {
    return Response(
      body: 'File not found',
      headers: {
        'Access-Control-Allow-Origin': '*',
      },
      statusCode: 404,
    );
  }
}
