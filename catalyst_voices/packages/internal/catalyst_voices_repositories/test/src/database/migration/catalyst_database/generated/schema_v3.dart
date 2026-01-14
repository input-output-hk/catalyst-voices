// dart format width=80
import 'dart:typed_data' as i2;
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class Documents extends Table with TableInfo<Documents, DocumentsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Documents(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<BigInt> idHi = GeneratedColumn<BigInt>(
    'id_hi',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<BigInt> idLo = GeneratedColumn<BigInt>(
    'id_lo',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<BigInt> verHi = GeneratedColumn<BigInt>(
    'ver_hi',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<BigInt> verLo = GeneratedColumn<BigInt>(
    'ver_lo',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<i2.Uint8List> content =
      GeneratedColumn<i2.Uint8List>(
        'content',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  late final GeneratedColumn<i2.Uint8List> metadata =
      GeneratedColumn<i2.Uint8List>(
        'metadata',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idHi,
    idLo,
    verHi,
    verLo,
    content,
    metadata,
    type,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  Set<GeneratedColumn> get $primaryKey => {idHi, idLo, verHi, verLo};
  @override
  DocumentsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentsData(
      idHi: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}id_hi'],
      )!,
      idLo: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}id_lo'],
      )!,
      verHi: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}ver_hi'],
      )!,
      verLo: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}ver_lo'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}content'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}metadata'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  Documents createAlias(String alias) {
    return Documents(attachedDatabase, alias);
  }
}

class DocumentsData extends DataClass implements Insertable<DocumentsData> {
  final BigInt idHi;
  final BigInt idLo;
  final BigInt verHi;
  final BigInt verLo;
  final i2.Uint8List content;
  final i2.Uint8List metadata;
  final String type;
  final DateTime createdAt;
  const DocumentsData({
    required this.idHi,
    required this.idLo,
    required this.verHi,
    required this.verLo,
    required this.content,
    required this.metadata,
    required this.type,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_hi'] = Variable<BigInt>(idHi);
    map['id_lo'] = Variable<BigInt>(idLo);
    map['ver_hi'] = Variable<BigInt>(verHi);
    map['ver_lo'] = Variable<BigInt>(verLo);
    map['content'] = Variable<i2.Uint8List>(content);
    map['metadata'] = Variable<i2.Uint8List>(metadata);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  factory DocumentsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentsData(
      idHi: serializer.fromJson<BigInt>(json['idHi']),
      idLo: serializer.fromJson<BigInt>(json['idLo']),
      verHi: serializer.fromJson<BigInt>(json['verHi']),
      verLo: serializer.fromJson<BigInt>(json['verLo']),
      content: serializer.fromJson<i2.Uint8List>(json['content']),
      metadata: serializer.fromJson<i2.Uint8List>(json['metadata']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idHi': serializer.toJson<BigInt>(idHi),
      'idLo': serializer.toJson<BigInt>(idLo),
      'verHi': serializer.toJson<BigInt>(verHi),
      'verLo': serializer.toJson<BigInt>(verLo),
      'content': serializer.toJson<i2.Uint8List>(content),
      'metadata': serializer.toJson<i2.Uint8List>(metadata),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DocumentsData copyWith({
    BigInt? idHi,
    BigInt? idLo,
    BigInt? verHi,
    BigInt? verLo,
    i2.Uint8List? content,
    i2.Uint8List? metadata,
    String? type,
    DateTime? createdAt,
  }) => DocumentsData(
    idHi: idHi ?? this.idHi,
    idLo: idLo ?? this.idLo,
    verHi: verHi ?? this.verHi,
    verLo: verLo ?? this.verLo,
    content: content ?? this.content,
    metadata: metadata ?? this.metadata,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
  );
  DocumentsData copyWithCompanion(DocumentsCompanion data) {
    return DocumentsData(
      idHi: data.idHi.present ? data.idHi.value : this.idHi,
      idLo: data.idLo.present ? data.idLo.value : this.idLo,
      verHi: data.verHi.present ? data.verHi.value : this.verHi,
      verLo: data.verLo.present ? data.verLo.value : this.verLo,
      content: data.content.present ? data.content.value : this.content,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsData(')
          ..write('idHi: $idHi, ')
          ..write('idLo: $idLo, ')
          ..write('verHi: $verHi, ')
          ..write('verLo: $verLo, ')
          ..write('content: $content, ')
          ..write('metadata: $metadata, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    idHi,
    idLo,
    verHi,
    verLo,
    $driftBlobEquality.hash(content),
    $driftBlobEquality.hash(metadata),
    type,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentsData &&
          other.idHi == this.idHi &&
          other.idLo == this.idLo &&
          other.verHi == this.verHi &&
          other.verLo == this.verLo &&
          $driftBlobEquality.equals(other.content, this.content) &&
          $driftBlobEquality.equals(other.metadata, this.metadata) &&
          other.type == this.type &&
          other.createdAt == this.createdAt);
}

class DocumentsCompanion extends UpdateCompanion<DocumentsData> {
  final Value<BigInt> idHi;
  final Value<BigInt> idLo;
  final Value<BigInt> verHi;
  final Value<BigInt> verLo;
  final Value<i2.Uint8List> content;
  final Value<i2.Uint8List> metadata;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DocumentsCompanion({
    this.idHi = const Value.absent(),
    this.idLo = const Value.absent(),
    this.verHi = const Value.absent(),
    this.verLo = const Value.absent(),
    this.content = const Value.absent(),
    this.metadata = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsCompanion.insert({
    required BigInt idHi,
    required BigInt idLo,
    required BigInt verHi,
    required BigInt verLo,
    required i2.Uint8List content,
    required i2.Uint8List metadata,
    required String type,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : idHi = Value(idHi),
       idLo = Value(idLo),
       verHi = Value(verHi),
       verLo = Value(verLo),
       content = Value(content),
       metadata = Value(metadata),
       type = Value(type),
       createdAt = Value(createdAt);
  static Insertable<DocumentsData> custom({
    Expression<BigInt>? idHi,
    Expression<BigInt>? idLo,
    Expression<BigInt>? verHi,
    Expression<BigInt>? verLo,
    Expression<i2.Uint8List>? content,
    Expression<i2.Uint8List>? metadata,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idHi != null) 'id_hi': idHi,
      if (idLo != null) 'id_lo': idLo,
      if (verHi != null) 'ver_hi': verHi,
      if (verLo != null) 'ver_lo': verLo,
      if (content != null) 'content': content,
      if (metadata != null) 'metadata': metadata,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsCompanion copyWith({
    Value<BigInt>? idHi,
    Value<BigInt>? idLo,
    Value<BigInt>? verHi,
    Value<BigInt>? verLo,
    Value<i2.Uint8List>? content,
    Value<i2.Uint8List>? metadata,
    Value<String>? type,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DocumentsCompanion(
      idHi: idHi ?? this.idHi,
      idLo: idLo ?? this.idLo,
      verHi: verHi ?? this.verHi,
      verLo: verLo ?? this.verLo,
      content: content ?? this.content,
      metadata: metadata ?? this.metadata,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idHi.present) {
      map['id_hi'] = Variable<BigInt>(idHi.value);
    }
    if (idLo.present) {
      map['id_lo'] = Variable<BigInt>(idLo.value);
    }
    if (verHi.present) {
      map['ver_hi'] = Variable<BigInt>(verHi.value);
    }
    if (verLo.present) {
      map['ver_lo'] = Variable<BigInt>(verLo.value);
    }
    if (content.present) {
      map['content'] = Variable<i2.Uint8List>(content.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<i2.Uint8List>(metadata.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('idHi: $idHi, ')
          ..write('idLo: $idLo, ')
          ..write('verHi: $verHi, ')
          ..write('verLo: $verLo, ')
          ..write('content: $content, ')
          ..write('metadata: $metadata, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DocumentsMetadata extends Table
    with TableInfo<DocumentsMetadata, DocumentsMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DocumentsMetadata(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<BigInt> verHi = GeneratedColumn<BigInt>(
    'ver_hi',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<BigInt> verLo = GeneratedColumn<BigInt>(
    'ver_lo',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> fieldKey = GeneratedColumn<String>(
    'field_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> fieldValue = GeneratedColumn<String>(
    'field_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [verHi, verLo, fieldKey, fieldValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents_metadata';
  @override
  Set<GeneratedColumn> get $primaryKey => {verHi, verLo, fieldKey};
  @override
  DocumentsMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentsMetadataData(
      verHi: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}ver_hi'],
      )!,
      verLo: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}ver_lo'],
      )!,
      fieldKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_key'],
      )!,
      fieldValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_value'],
      )!,
    );
  }

  @override
  DocumentsMetadata createAlias(String alias) {
    return DocumentsMetadata(attachedDatabase, alias);
  }
}

class DocumentsMetadataData extends DataClass
    implements Insertable<DocumentsMetadataData> {
  final BigInt verHi;
  final BigInt verLo;
  final String fieldKey;
  final String fieldValue;
  const DocumentsMetadataData({
    required this.verHi,
    required this.verLo,
    required this.fieldKey,
    required this.fieldValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ver_hi'] = Variable<BigInt>(verHi);
    map['ver_lo'] = Variable<BigInt>(verLo);
    map['field_key'] = Variable<String>(fieldKey);
    map['field_value'] = Variable<String>(fieldValue);
    return map;
  }

  factory DocumentsMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentsMetadataData(
      verHi: serializer.fromJson<BigInt>(json['verHi']),
      verLo: serializer.fromJson<BigInt>(json['verLo']),
      fieldKey: serializer.fromJson<String>(json['fieldKey']),
      fieldValue: serializer.fromJson<String>(json['fieldValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'verHi': serializer.toJson<BigInt>(verHi),
      'verLo': serializer.toJson<BigInt>(verLo),
      'fieldKey': serializer.toJson<String>(fieldKey),
      'fieldValue': serializer.toJson<String>(fieldValue),
    };
  }

  DocumentsMetadataData copyWith({
    BigInt? verHi,
    BigInt? verLo,
    String? fieldKey,
    String? fieldValue,
  }) => DocumentsMetadataData(
    verHi: verHi ?? this.verHi,
    verLo: verLo ?? this.verLo,
    fieldKey: fieldKey ?? this.fieldKey,
    fieldValue: fieldValue ?? this.fieldValue,
  );
  DocumentsMetadataData copyWithCompanion(DocumentsMetadataCompanion data) {
    return DocumentsMetadataData(
      verHi: data.verHi.present ? data.verHi.value : this.verHi,
      verLo: data.verLo.present ? data.verLo.value : this.verLo,
      fieldKey: data.fieldKey.present ? data.fieldKey.value : this.fieldKey,
      fieldValue: data.fieldValue.present
          ? data.fieldValue.value
          : this.fieldValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsMetadataData(')
          ..write('verHi: $verHi, ')
          ..write('verLo: $verLo, ')
          ..write('fieldKey: $fieldKey, ')
          ..write('fieldValue: $fieldValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(verHi, verLo, fieldKey, fieldValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentsMetadataData &&
          other.verHi == this.verHi &&
          other.verLo == this.verLo &&
          other.fieldKey == this.fieldKey &&
          other.fieldValue == this.fieldValue);
}

class DocumentsMetadataCompanion
    extends UpdateCompanion<DocumentsMetadataData> {
  final Value<BigInt> verHi;
  final Value<BigInt> verLo;
  final Value<String> fieldKey;
  final Value<String> fieldValue;
  final Value<int> rowid;
  const DocumentsMetadataCompanion({
    this.verHi = const Value.absent(),
    this.verLo = const Value.absent(),
    this.fieldKey = const Value.absent(),
    this.fieldValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsMetadataCompanion.insert({
    required BigInt verHi,
    required BigInt verLo,
    required String fieldKey,
    required String fieldValue,
    this.rowid = const Value.absent(),
  }) : verHi = Value(verHi),
       verLo = Value(verLo),
       fieldKey = Value(fieldKey),
       fieldValue = Value(fieldValue);
  static Insertable<DocumentsMetadataData> custom({
    Expression<BigInt>? verHi,
    Expression<BigInt>? verLo,
    Expression<String>? fieldKey,
    Expression<String>? fieldValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (verHi != null) 'ver_hi': verHi,
      if (verLo != null) 'ver_lo': verLo,
      if (fieldKey != null) 'field_key': fieldKey,
      if (fieldValue != null) 'field_value': fieldValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsMetadataCompanion copyWith({
    Value<BigInt>? verHi,
    Value<BigInt>? verLo,
    Value<String>? fieldKey,
    Value<String>? fieldValue,
    Value<int>? rowid,
  }) {
    return DocumentsMetadataCompanion(
      verHi: verHi ?? this.verHi,
      verLo: verLo ?? this.verLo,
      fieldKey: fieldKey ?? this.fieldKey,
      fieldValue: fieldValue ?? this.fieldValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (verHi.present) {
      map['ver_hi'] = Variable<BigInt>(verHi.value);
    }
    if (verLo.present) {
      map['ver_lo'] = Variable<BigInt>(verLo.value);
    }
    if (fieldKey.present) {
      map['field_key'] = Variable<String>(fieldKey.value);
    }
    if (fieldValue.present) {
      map['field_value'] = Variable<String>(fieldValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsMetadataCompanion(')
          ..write('verHi: $verHi, ')
          ..write('verLo: $verLo, ')
          ..write('fieldKey: $fieldKey, ')
          ..write('fieldValue: $fieldValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DocumentsFavorites extends Table
    with TableInfo<DocumentsFavorites, DocumentsFavoritesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DocumentsFavorites(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<BigInt> idHi = GeneratedColumn<BigInt>(
    'id_hi',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<BigInt> idLo = GeneratedColumn<BigInt>(
    'id_lo',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
  );
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [idHi, idLo, isFavorite, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents_favorites';
  @override
  Set<GeneratedColumn> get $primaryKey => {idHi, idLo};
  @override
  DocumentsFavoritesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentsFavoritesData(
      idHi: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}id_hi'],
      )!,
      idLo: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}id_lo'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  DocumentsFavorites createAlias(String alias) {
    return DocumentsFavorites(attachedDatabase, alias);
  }
}

class DocumentsFavoritesData extends DataClass
    implements Insertable<DocumentsFavoritesData> {
  final BigInt idHi;
  final BigInt idLo;
  final bool isFavorite;
  final String type;
  const DocumentsFavoritesData({
    required this.idHi,
    required this.idLo,
    required this.isFavorite,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_hi'] = Variable<BigInt>(idHi);
    map['id_lo'] = Variable<BigInt>(idLo);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['type'] = Variable<String>(type);
    return map;
  }

  factory DocumentsFavoritesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentsFavoritesData(
      idHi: serializer.fromJson<BigInt>(json['idHi']),
      idLo: serializer.fromJson<BigInt>(json['idLo']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idHi': serializer.toJson<BigInt>(idHi),
      'idLo': serializer.toJson<BigInt>(idLo),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'type': serializer.toJson<String>(type),
    };
  }

  DocumentsFavoritesData copyWith({
    BigInt? idHi,
    BigInt? idLo,
    bool? isFavorite,
    String? type,
  }) => DocumentsFavoritesData(
    idHi: idHi ?? this.idHi,
    idLo: idLo ?? this.idLo,
    isFavorite: isFavorite ?? this.isFavorite,
    type: type ?? this.type,
  );
  DocumentsFavoritesData copyWithCompanion(DocumentsFavoritesCompanion data) {
    return DocumentsFavoritesData(
      idHi: data.idHi.present ? data.idHi.value : this.idHi,
      idLo: data.idLo.present ? data.idLo.value : this.idLo,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsFavoritesData(')
          ..write('idHi: $idHi, ')
          ..write('idLo: $idLo, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idHi, idLo, isFavorite, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentsFavoritesData &&
          other.idHi == this.idHi &&
          other.idLo == this.idLo &&
          other.isFavorite == this.isFavorite &&
          other.type == this.type);
}

class DocumentsFavoritesCompanion
    extends UpdateCompanion<DocumentsFavoritesData> {
  final Value<BigInt> idHi;
  final Value<BigInt> idLo;
  final Value<bool> isFavorite;
  final Value<String> type;
  final Value<int> rowid;
  const DocumentsFavoritesCompanion({
    this.idHi = const Value.absent(),
    this.idLo = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsFavoritesCompanion.insert({
    required BigInt idHi,
    required BigInt idLo,
    required bool isFavorite,
    required String type,
    this.rowid = const Value.absent(),
  }) : idHi = Value(idHi),
       idLo = Value(idLo),
       isFavorite = Value(isFavorite),
       type = Value(type);
  static Insertable<DocumentsFavoritesData> custom({
    Expression<BigInt>? idHi,
    Expression<BigInt>? idLo,
    Expression<bool>? isFavorite,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idHi != null) 'id_hi': idHi,
      if (idLo != null) 'id_lo': idLo,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsFavoritesCompanion copyWith({
    Value<BigInt>? idHi,
    Value<BigInt>? idLo,
    Value<bool>? isFavorite,
    Value<String>? type,
    Value<int>? rowid,
  }) {
    return DocumentsFavoritesCompanion(
      idHi: idHi ?? this.idHi,
      idLo: idLo ?? this.idLo,
      isFavorite: isFavorite ?? this.isFavorite,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idHi.present) {
      map['id_hi'] = Variable<BigInt>(idHi.value);
    }
    if (idLo.present) {
      map['id_lo'] = Variable<BigInt>(idLo.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsFavoritesCompanion(')
          ..write('idHi: $idHi, ')
          ..write('idLo: $idLo, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Drafts extends Table with TableInfo<Drafts, DraftsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Drafts(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<BigInt> idHi = GeneratedColumn<BigInt>(
    'id_hi',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<BigInt> idLo = GeneratedColumn<BigInt>(
    'id_lo',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<BigInt> verHi = GeneratedColumn<BigInt>(
    'ver_hi',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<BigInt> verLo = GeneratedColumn<BigInt>(
    'ver_lo',
    aliasedName,
    false,
    type: DriftSqlType.bigInt,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<i2.Uint8List> content =
      GeneratedColumn<i2.Uint8List>(
        'content',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  late final GeneratedColumn<i2.Uint8List> metadata =
      GeneratedColumn<i2.Uint8List>(
        'metadata',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idHi,
    idLo,
    verHi,
    verLo,
    content,
    metadata,
    type,
    title,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drafts';
  @override
  Set<GeneratedColumn> get $primaryKey => {idHi, idLo, verHi, verLo};
  @override
  DraftsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DraftsData(
      idHi: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}id_hi'],
      )!,
      idLo: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}id_lo'],
      )!,
      verHi: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}ver_hi'],
      )!,
      verLo: attachedDatabase.typeMapping.read(
        DriftSqlType.bigInt,
        data['${effectivePrefix}ver_lo'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}content'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}metadata'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
    );
  }

  @override
  Drafts createAlias(String alias) {
    return Drafts(attachedDatabase, alias);
  }
}

class DraftsData extends DataClass implements Insertable<DraftsData> {
  final BigInt idHi;
  final BigInt idLo;
  final BigInt verHi;
  final BigInt verLo;
  final i2.Uint8List content;
  final i2.Uint8List metadata;
  final String type;
  final String title;
  const DraftsData({
    required this.idHi,
    required this.idLo,
    required this.verHi,
    required this.verLo,
    required this.content,
    required this.metadata,
    required this.type,
    required this.title,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_hi'] = Variable<BigInt>(idHi);
    map['id_lo'] = Variable<BigInt>(idLo);
    map['ver_hi'] = Variable<BigInt>(verHi);
    map['ver_lo'] = Variable<BigInt>(verLo);
    map['content'] = Variable<i2.Uint8List>(content);
    map['metadata'] = Variable<i2.Uint8List>(metadata);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    return map;
  }

  factory DraftsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DraftsData(
      idHi: serializer.fromJson<BigInt>(json['idHi']),
      idLo: serializer.fromJson<BigInt>(json['idLo']),
      verHi: serializer.fromJson<BigInt>(json['verHi']),
      verLo: serializer.fromJson<BigInt>(json['verLo']),
      content: serializer.fromJson<i2.Uint8List>(json['content']),
      metadata: serializer.fromJson<i2.Uint8List>(json['metadata']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idHi': serializer.toJson<BigInt>(idHi),
      'idLo': serializer.toJson<BigInt>(idLo),
      'verHi': serializer.toJson<BigInt>(verHi),
      'verLo': serializer.toJson<BigInt>(verLo),
      'content': serializer.toJson<i2.Uint8List>(content),
      'metadata': serializer.toJson<i2.Uint8List>(metadata),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
    };
  }

  DraftsData copyWith({
    BigInt? idHi,
    BigInt? idLo,
    BigInt? verHi,
    BigInt? verLo,
    i2.Uint8List? content,
    i2.Uint8List? metadata,
    String? type,
    String? title,
  }) => DraftsData(
    idHi: idHi ?? this.idHi,
    idLo: idLo ?? this.idLo,
    verHi: verHi ?? this.verHi,
    verLo: verLo ?? this.verLo,
    content: content ?? this.content,
    metadata: metadata ?? this.metadata,
    type: type ?? this.type,
    title: title ?? this.title,
  );
  DraftsData copyWithCompanion(DraftsCompanion data) {
    return DraftsData(
      idHi: data.idHi.present ? data.idHi.value : this.idHi,
      idLo: data.idLo.present ? data.idLo.value : this.idLo,
      verHi: data.verHi.present ? data.verHi.value : this.verHi,
      verLo: data.verLo.present ? data.verLo.value : this.verLo,
      content: data.content.present ? data.content.value : this.content,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DraftsData(')
          ..write('idHi: $idHi, ')
          ..write('idLo: $idLo, ')
          ..write('verHi: $verHi, ')
          ..write('verLo: $verLo, ')
          ..write('content: $content, ')
          ..write('metadata: $metadata, ')
          ..write('type: $type, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    idHi,
    idLo,
    verHi,
    verLo,
    $driftBlobEquality.hash(content),
    $driftBlobEquality.hash(metadata),
    type,
    title,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DraftsData &&
          other.idHi == this.idHi &&
          other.idLo == this.idLo &&
          other.verHi == this.verHi &&
          other.verLo == this.verLo &&
          $driftBlobEquality.equals(other.content, this.content) &&
          $driftBlobEquality.equals(other.metadata, this.metadata) &&
          other.type == this.type &&
          other.title == this.title);
}

class DraftsCompanion extends UpdateCompanion<DraftsData> {
  final Value<BigInt> idHi;
  final Value<BigInt> idLo;
  final Value<BigInt> verHi;
  final Value<BigInt> verLo;
  final Value<i2.Uint8List> content;
  final Value<i2.Uint8List> metadata;
  final Value<String> type;
  final Value<String> title;
  final Value<int> rowid;
  const DraftsCompanion({
    this.idHi = const Value.absent(),
    this.idLo = const Value.absent(),
    this.verHi = const Value.absent(),
    this.verLo = const Value.absent(),
    this.content = const Value.absent(),
    this.metadata = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DraftsCompanion.insert({
    required BigInt idHi,
    required BigInt idLo,
    required BigInt verHi,
    required BigInt verLo,
    required i2.Uint8List content,
    required i2.Uint8List metadata,
    required String type,
    required String title,
    this.rowid = const Value.absent(),
  }) : idHi = Value(idHi),
       idLo = Value(idLo),
       verHi = Value(verHi),
       verLo = Value(verLo),
       content = Value(content),
       metadata = Value(metadata),
       type = Value(type),
       title = Value(title);
  static Insertable<DraftsData> custom({
    Expression<BigInt>? idHi,
    Expression<BigInt>? idLo,
    Expression<BigInt>? verHi,
    Expression<BigInt>? verLo,
    Expression<i2.Uint8List>? content,
    Expression<i2.Uint8List>? metadata,
    Expression<String>? type,
    Expression<String>? title,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idHi != null) 'id_hi': idHi,
      if (idLo != null) 'id_lo': idLo,
      if (verHi != null) 'ver_hi': verHi,
      if (verLo != null) 'ver_lo': verLo,
      if (content != null) 'content': content,
      if (metadata != null) 'metadata': metadata,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DraftsCompanion copyWith({
    Value<BigInt>? idHi,
    Value<BigInt>? idLo,
    Value<BigInt>? verHi,
    Value<BigInt>? verLo,
    Value<i2.Uint8List>? content,
    Value<i2.Uint8List>? metadata,
    Value<String>? type,
    Value<String>? title,
    Value<int>? rowid,
  }) {
    return DraftsCompanion(
      idHi: idHi ?? this.idHi,
      idLo: idLo ?? this.idLo,
      verHi: verHi ?? this.verHi,
      verLo: verLo ?? this.verLo,
      content: content ?? this.content,
      metadata: metadata ?? this.metadata,
      type: type ?? this.type,
      title: title ?? this.title,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idHi.present) {
      map['id_hi'] = Variable<BigInt>(idHi.value);
    }
    if (idLo.present) {
      map['id_lo'] = Variable<BigInt>(idLo.value);
    }
    if (verHi.present) {
      map['ver_hi'] = Variable<BigInt>(verHi.value);
    }
    if (verLo.present) {
      map['ver_lo'] = Variable<BigInt>(verLo.value);
    }
    if (content.present) {
      map['content'] = Variable<i2.Uint8List>(content.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<i2.Uint8List>(metadata.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DraftsCompanion(')
          ..write('idHi: $idHi, ')
          ..write('idLo: $idLo, ')
          ..write('verHi: $verHi, ')
          ..write('verLo: $verLo, ')
          ..write('content: $content, ')
          ..write('metadata: $metadata, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV3 extends GeneratedDatabase {
  DatabaseAtV3(QueryExecutor e) : super(e);
  late final Documents documents = Documents(this);
  late final DocumentsMetadata documentsMetadata = DocumentsMetadata(this);
  late final DocumentsFavorites documentsFavorites = DocumentsFavorites(this);
  late final Drafts drafts = Drafts(this);
  late final Index idxDocType = Index(
    'idx_doc_type',
    'CREATE INDEX idx_doc_type ON documents (type)',
  );
  late final Index idxUniqueVer = Index(
    'idx_unique_ver',
    'CREATE UNIQUE INDEX idx_unique_ver ON documents (ver_hi, ver_lo)',
  );
  late final Index idxDocMetadataKeyValue = Index(
    'idx_doc_metadata_key_value',
    'CREATE INDEX idx_doc_metadata_key_value ON documents_metadata (field_key, field_value)',
  );
  late final Index idxFavType = Index(
    'idx_fav_type',
    'CREATE INDEX idx_fav_type ON documents_favorites (type)',
  );
  late final Index idxFavUniqueId = Index(
    'idx_fav_unique_id',
    'CREATE UNIQUE INDEX idx_fav_unique_id ON documents_favorites (id_hi, id_lo)',
  );
  late final Index idxDraftType = Index(
    'idx_draft_type',
    'CREATE INDEX idx_draft_type ON drafts (type)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    documents,
    documentsMetadata,
    documentsFavorites,
    drafts,
    idxDocType,
    idxUniqueVer,
    idxDocMetadataKeyValue,
    idxFavType,
    idxFavUniqueId,
    idxDraftType,
  ];
  @override
  int get schemaVersion => 3;
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}
