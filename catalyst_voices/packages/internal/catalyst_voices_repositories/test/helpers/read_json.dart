import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;

  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  print(dir);
  return File('$dir/$name').readAsStringSync();
}
