import 'dart:io';

void main() {
  // Ensure the processed directory exists
  final processedDir = Directory('openapi/processed');
  if (!processedDir.existsSync()) {
    processedDir.createSync(recursive: true);
  }

  // Create empty placeholder files for each source JSON
  final sourceDir = Directory('openapi');
  if (sourceDir.existsSync()) {
    for (final entity in sourceDir.listSync()) {
      if (entity is File && entity.path.endsWith('.json')) {
        final baseName = entity.path.split('/').last.replaceAll('.json', '');
        final placeholderPath = 'openapi/processed/$baseName.processed.json';
        File(placeholderPath).writeAsStringSync('{}');
      }
    }
  }
}
