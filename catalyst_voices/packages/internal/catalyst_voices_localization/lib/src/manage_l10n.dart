// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart manage_arb.dart [--clean] [--sort] [--check]');
    exit(1);
  }

  final clean = args.contains('--clean');
  final sort = args.contains('--sort');
  final check = args.contains('--check');

  if (check && (clean || sort)) {
    print('Error: --check cannot be used with --clean or --sort');
    exit(1);
  }

  ArbManager(
    clean: clean,
    sort: sort,
    check: check,
  ).process();
}

class ArbManager {
  final bool clean;
  final bool sort;
  final bool check;
  late final String _dartContents;
  late final Directory _rootDir;

  ArbManager({
    this.clean = false,
    this.sort = false,
    this.check = false,
  }) {
    _rootDir = _findRootDir();
    final dartFiles = _getAllDartFiles(_rootDir);
    _dartContents = dartFiles.map((f) => f.readAsStringSync()).join('\n');
  }

  void process() {
    final arbFiles =
        _rootDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.arb'));

    var allClean = true;
    var allSorted = true;

    for (final arbFile in arbFiles) {
      if (check) {
        if (!_checkIfClean(arbFile)) {
          allClean = false;
        }
        if (!_checkIfSorted(arbFile)) {
          allSorted = false;
        }
      } else {
        if (clean) {
          _cleanArbFile(arbFile);
        }
        if (sort) {
          _sortArbFile(arbFile);
        }
      }
    }
    print('\n === SUMMARY ===\n');

    if (check) {
      if (allClean && allSorted) {
        print('✅ All files are clean and sorted.');
      }
      exit(allClean && allSorted ? 0 : 1);
    }
  }

  bool _checkIfClean(File arbFile) {
    final original = json.decode(arbFile.readAsStringSync()) as Map<String, dynamic>;
    final usedKeys = _getUsedKeys(original);
    final originalTranslationKeys =
        original.keys.where((k) => !k.contains('@') && !k.contains('.'));

    final unusedKeys = originalTranslationKeys.where((key) => !usedKeys.contains(key)).toList();

    if (unusedKeys.isEmpty) {
      print('✅ ${arbFile.name} is clean - no unused keys found');
      return true;
    } else {
      print('❌ ${arbFile.name} has unused keys:');
      for (final key in unusedKeys) {
        print('   - $key');
      }
      return false;
    }
  }

  bool _checkIfSorted(File arbFile) {
    final content = json.decode(arbFile.readAsStringSync()) as Map<String, dynamic>;
    final keys = content.keys.where((k) => !k.startsWith('@') && !k.startsWith('@@')).toList();
    final sortedKeys = [...keys]..sort();

    final isSorted = _listsEqual(keys, sortedKeys);
    if (isSorted) {
      print('✅ ${arbFile.name} is properly sorted');
      return true;
    } else {
      print('❌ ${arbFile.name} is not sorted');
      return false;
    }
  }

  void _cleanArbFile(File arbFile) {
    final original = json.decode(arbFile.readAsStringSync()) as Map<String, dynamic>;
    final cleaned = <String, dynamic>{};

    final usedKeys = _getUsedKeys(original);
    _printStats(usedKeys, original);

    for (final entry in original.entries) {
      final key = entry.key;

      if (key.startsWith('@@')) {
        cleaned[key] = entry.value;
        continue;
      }

      final isMetadata = key.startsWith('@');
      final baseKey = isMetadata ? key.substring(1) : key;

      if (usedKeys.contains(baseKey)) {
        final value = entry.value;
        if (value is String) {
          cleaned[key] = _normalizeSeparators(value);
        } else {
          cleaned[key] = value;
        }
      }
    }

    final encoded = const JsonEncoder.withIndent('  ').convert(cleaned);
    arbFile.writeAsStringSync(encoded);
  }

  Directory _findRootDir() {
    var current = Directory.current;
    while (current.path != current.parent.path) {
      if (current.path.endsWith('catalyst_voices')) {
        return current;
      }
      current = current.parent;
    }
    throw Exception('Could not find catalyst_voices directory');
  }

  List<File> _getAllDartFiles(Directory dir) {
    return dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();
  }

  Set<String> _getUsedKeys(Map<String, dynamic> original) {
    return <String>{
      for (final key in original.keys)
        if (!key.startsWith('@') &&
            !key.startsWith('@@') &&
            RegExp(r'\.' + RegExp.escape(key) + r'\b').hasMatch(_dartContents))
          key,
    };
  }

  bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  String _normalizeSeparators(String input) {
    return input.replaceAll('\u2028', '\n').replaceAll('\u2029', '\n');
  }

  void _printStats(Set<String> usedKeys, Map<String, dynamic> original) {
    final originalTranslationKeys =
        original.keys.where((k) => !k.contains('@') && !k.contains('.'));
    final percentage = (usedKeys.length / originalTranslationKeys.length) * 100;
    print(
      '🔑 Number of used keys: ${usedKeys.length}/${originalTranslationKeys.length}. Percentage: ${percentage.toStringAsFixed(2)}%',
    );
  }

  void _sortArbFile(File arbFile) {
    final content = json.decode(arbFile.readAsStringSync()) as Map<String, dynamic>;
    final sorted = _sortMapWithMetadata(content);
    final encoded = const JsonEncoder.withIndent('  ').convert(sorted);
    arbFile.writeAsStringSync(encoded);
  }

  Map<String, dynamic> _sortMapWithMetadata(Map<String, dynamic> map) {
    final keys = map.keys.where((k) => !k.startsWith('@') && !k.startsWith('@@')).toList()..sort();
    final special = map.entries.where((e) => e.key.startsWith('@@'));

    final sorted = <String, dynamic>{};

    for (final entry in special) {
      sorted[entry.key] = entry.value;
    }

    for (final key in keys) {
      sorted[key] = map[key];
      final metaKey = '@$key';
      if (map.containsKey(metaKey)) {
        sorted[metaKey] = map[metaKey];
      }
    }

    return sorted;
  }
}

extension on File {
  String get name => uri.pathSegments.last;
}
