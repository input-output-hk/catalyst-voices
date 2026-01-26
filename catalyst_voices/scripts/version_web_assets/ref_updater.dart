import 'dart:io';

import 'package:path/path.dart' as p;

class DirectRefUpdater extends RefUpdater {
  const DirectRefUpdater();

  @override
  bool canHandle(String path) {
    return path.contains('canvaskit') ||
        p.basename(path).contains('index.html') ||
        path.contains('flutter_service_worker');
  }

  @override
  Future<void> updateReference({
    required File file,
    required Map<String, String> versionMap,
  }) async {
    String content = await file.readAsString();
    final updatedContent = _updateContent(content, file.path, versionMap);

    if (content != updatedContent) {
      await file.writeAsString(updatedContent);
    }
  }

  bool _isInSameDirectory(String filePath, String originalPath) {
    final fileDir = p.dirname(filePath);
    final originalFileDir = p.dirname(originalPath);
    return fileDir.endsWith(originalFileDir) || originalFileDir == '.';
  }

  String _replaceReference({
    required String content,
    required String filePath,
    required String originalPath,
    required String versionedPath,
  }) {
    if (content.contains(originalPath)) {
      return content.replaceAll(originalPath, versionedPath);
    }

    if (_isInSameDirectory(filePath, originalPath)) {
      final originalFilename = p.basename(originalPath);
      if (content.contains(originalFilename)) {
        return content.replaceAll(originalFilename, p.basename(versionedPath));
      }
    }

    return content;
  }

  String _updateContent(
    String content,
    String filePath,
    Map<String, String> versionMap,
  ) {
    for (final entry in versionMap.entries) {
      content = _replaceReference(
        content: content,
        filePath: filePath,
        originalPath: entry.key,
        versionedPath: entry.value,
      );
    }
    return content;
  }
}

class IndirectRefUpdater extends RefUpdater {
  const IndirectRefUpdater();

  @override
  bool canHandle(String path) {
    return path.contains('main.dart');
  }

  @override
  Future<void> updateReference({
    required File file,
    required Map<String, String> versionMap,
  }) async {
    String content = await file.readAsString();
    bool wasModified = false;

    // Sort by path length (longest first) to handle more specific paths before generic ones
    final sortedEntries = versionMap.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));

    for (final entry in sortedEntries) {
      final originalPath = entry.key;
      final versionedPath = entry.value;

      final parts = p.split(originalPath);

      // file can't reference itself and contains() might replace "part" file so we break here
      if (p.basename(file.path) == versionedPath) break;

      for (int i = 0; i < parts.length; i++) {
        final partialPath = p.joinAll(parts.sublist(i));

        if (content.contains(partialPath)) {
          final versionedParts = p.split(versionedPath);
          final versionedPartialPath = p.joinAll(versionedParts.sublist(i));
          content = content.replaceAll(partialPath, versionedPartialPath);

          wasModified = true;
          break;
        }
      }
    }

    if (wasModified) {
      await file.writeAsString(content);
    }
  }
}

class NoopRefUpdater extends RefUpdater {
  const NoopRefUpdater();

  @override
  bool canHandle(String path) {
    return p.extension(path) == '.wasm' ||
        p.extension(path) == '.symbols' ||
        p.basename(path).contains('version.json') ||
        p.basename(path).contains('drift_worker.js') ||
        p.basename(path).contains('catalyst_compression') ||
        p.basename(path).contains('catalyst_key_derivation') ||
        p.basename(path).contains('package.json');
  }

  @override
  Future<void> updateReference({
    required File file,
    required Map<String, String> versionMap,
  }) async {
    return;
  }
}

class ProxyRefUpdater extends RefUpdater {
  const ProxyRefUpdater();

  @override
  bool canHandle(String path) {
    return path.contains('flutter_bootstrap') || path.contains('flutter.js');
  }

  @override
  Future<void> updateReference({
    required File file,
    required Map<String, String> versionMap,
  }) async {
    String content = await file.readAsString();
    final updatedContent = _updateContent(content, versionMap);

    if (content != updatedContent) {
      await file.writeAsString(updatedContent);
    }
  }

  String _updateContent(String content, Map<String, String> versionMap) {
    for (final entry in versionMap.entries) {
      final originalBasename = p.basename(entry.key);
      final versionedBasename = p.basename(entry.value);

      if (originalBasename.contains('canvaskit')) continue;

      if (content.contains(originalBasename)) {
        content = content.replaceAll(originalBasename, versionedBasename);
      }
    }

    return content;
  }
}

sealed class RefUpdater {
  const RefUpdater();

  bool canHandle(String path);

  Future<void> updateReference({
    required File file,
    required Map<String, String> versionMap,
  });
}

final class RefUpdaterRegistry {
  static const _updaters = [
    ProxyRefUpdater(),
    IndirectRefUpdater(),
    DirectRefUpdater(),
    NoopRefUpdater(),
  ];

  const RefUpdaterRegistry();

  Future<void> updateFileReferences({
    required File file,
    required Map<String, String> versionMap,
  }) async {
    for (final updater in _updaters) {
      if (updater.canHandle(file.path)) {
        await updater.updateReference(file: file, versionMap: versionMap);
        return;
      }
    }
    throw Exception('Ref Updater not found for $file');
  }
}
