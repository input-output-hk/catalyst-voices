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

class DocumentsV2 extends Table with TableInfo<DocumentsV2, DocumentsV2Data> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DocumentsV2(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<i2.Uint8List> content =
      GeneratedColumn<i2.Uint8List>(
        'content',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  late final GeneratedColumn<String> authors = GeneratedColumn<String>(
    'authors',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> categoryVer = GeneratedColumn<String>(
    'category_ver',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
    'ref_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> refVer = GeneratedColumn<String>(
    'ref_ver',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> replyId = GeneratedColumn<String>(
    'reply_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> replyVer = GeneratedColumn<String>(
    'reply_ver',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> section = GeneratedColumn<String>(
    'section',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> templateVer = GeneratedColumn<String>(
    'template_ver',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> ver = GeneratedColumn<String>(
    'ver',
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
    content,
    authors,
    categoryId,
    categoryVer,
    id,
    refId,
    refVer,
    replyId,
    replyVer,
    section,
    templateId,
    templateVer,
    type,
    ver,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents_v2';
  @override
  Set<GeneratedColumn> get $primaryKey => {id, ver};
  @override
  DocumentsV2Data map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentsV2Data(
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}content'],
      )!,
      authors: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}authors'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      categoryVer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_ver'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      refId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_id'],
      ),
      refVer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_ver'],
      ),
      replyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_id'],
      ),
      replyVer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_ver'],
      ),
      section: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section'],
      ),
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      ),
      templateVer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_ver'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      ver: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ver'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  DocumentsV2 createAlias(String alias) {
    return DocumentsV2(attachedDatabase, alias);
  }
}

class DocumentsV2Data extends DataClass implements Insertable<DocumentsV2Data> {
  final i2.Uint8List content;
  final String authors;
  final String? categoryId;
  final String? categoryVer;
  final String id;
  final String? refId;
  final String? refVer;
  final String? replyId;
  final String? replyVer;
  final String? section;
  final String? templateId;
  final String? templateVer;
  final String type;
  final String ver;
  final DateTime createdAt;
  const DocumentsV2Data({
    required this.content,
    required this.authors,
    this.categoryId,
    this.categoryVer,
    required this.id,
    this.refId,
    this.refVer,
    this.replyId,
    this.replyVer,
    this.section,
    this.templateId,
    this.templateVer,
    required this.type,
    required this.ver,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content'] = Variable<i2.Uint8List>(content);
    map['authors'] = Variable<String>(authors);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || categoryVer != null) {
      map['category_ver'] = Variable<String>(categoryVer);
    }
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || refId != null) {
      map['ref_id'] = Variable<String>(refId);
    }
    if (!nullToAbsent || refVer != null) {
      map['ref_ver'] = Variable<String>(refVer);
    }
    if (!nullToAbsent || replyId != null) {
      map['reply_id'] = Variable<String>(replyId);
    }
    if (!nullToAbsent || replyVer != null) {
      map['reply_ver'] = Variable<String>(replyVer);
    }
    if (!nullToAbsent || section != null) {
      map['section'] = Variable<String>(section);
    }
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<String>(templateId);
    }
    if (!nullToAbsent || templateVer != null) {
      map['template_ver'] = Variable<String>(templateVer);
    }
    map['type'] = Variable<String>(type);
    map['ver'] = Variable<String>(ver);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  factory DocumentsV2Data.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentsV2Data(
      content: serializer.fromJson<i2.Uint8List>(json['content']),
      authors: serializer.fromJson<String>(json['authors']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      categoryVer: serializer.fromJson<String?>(json['categoryVer']),
      id: serializer.fromJson<String>(json['id']),
      refId: serializer.fromJson<String?>(json['refId']),
      refVer: serializer.fromJson<String?>(json['refVer']),
      replyId: serializer.fromJson<String?>(json['replyId']),
      replyVer: serializer.fromJson<String?>(json['replyVer']),
      section: serializer.fromJson<String?>(json['section']),
      templateId: serializer.fromJson<String?>(json['templateId']),
      templateVer: serializer.fromJson<String?>(json['templateVer']),
      type: serializer.fromJson<String>(json['type']),
      ver: serializer.fromJson<String>(json['ver']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'content': serializer.toJson<i2.Uint8List>(content),
      'authors': serializer.toJson<String>(authors),
      'categoryId': serializer.toJson<String?>(categoryId),
      'categoryVer': serializer.toJson<String?>(categoryVer),
      'id': serializer.toJson<String>(id),
      'refId': serializer.toJson<String?>(refId),
      'refVer': serializer.toJson<String?>(refVer),
      'replyId': serializer.toJson<String?>(replyId),
      'replyVer': serializer.toJson<String?>(replyVer),
      'section': serializer.toJson<String?>(section),
      'templateId': serializer.toJson<String?>(templateId),
      'templateVer': serializer.toJson<String?>(templateVer),
      'type': serializer.toJson<String>(type),
      'ver': serializer.toJson<String>(ver),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DocumentsV2Data copyWith({
    i2.Uint8List? content,
    String? authors,
    Value<String?> categoryId = const Value.absent(),
    Value<String?> categoryVer = const Value.absent(),
    String? id,
    Value<String?> refId = const Value.absent(),
    Value<String?> refVer = const Value.absent(),
    Value<String?> replyId = const Value.absent(),
    Value<String?> replyVer = const Value.absent(),
    Value<String?> section = const Value.absent(),
    Value<String?> templateId = const Value.absent(),
    Value<String?> templateVer = const Value.absent(),
    String? type,
    String? ver,
    DateTime? createdAt,
  }) => DocumentsV2Data(
    content: content ?? this.content,
    authors: authors ?? this.authors,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    categoryVer: categoryVer.present ? categoryVer.value : this.categoryVer,
    id: id ?? this.id,
    refId: refId.present ? refId.value : this.refId,
    refVer: refVer.present ? refVer.value : this.refVer,
    replyId: replyId.present ? replyId.value : this.replyId,
    replyVer: replyVer.present ? replyVer.value : this.replyVer,
    section: section.present ? section.value : this.section,
    templateId: templateId.present ? templateId.value : this.templateId,
    templateVer: templateVer.present ? templateVer.value : this.templateVer,
    type: type ?? this.type,
    ver: ver ?? this.ver,
    createdAt: createdAt ?? this.createdAt,
  );
  DocumentsV2Data copyWithCompanion(DocumentsV2Companion data) {
    return DocumentsV2Data(
      content: data.content.present ? data.content.value : this.content,
      authors: data.authors.present ? data.authors.value : this.authors,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      categoryVer: data.categoryVer.present
          ? data.categoryVer.value
          : this.categoryVer,
      id: data.id.present ? data.id.value : this.id,
      refId: data.refId.present ? data.refId.value : this.refId,
      refVer: data.refVer.present ? data.refVer.value : this.refVer,
      replyId: data.replyId.present ? data.replyId.value : this.replyId,
      replyVer: data.replyVer.present ? data.replyVer.value : this.replyVer,
      section: data.section.present ? data.section.value : this.section,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      templateVer: data.templateVer.present
          ? data.templateVer.value
          : this.templateVer,
      type: data.type.present ? data.type.value : this.type,
      ver: data.ver.present ? data.ver.value : this.ver,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsV2Data(')
          ..write('content: $content, ')
          ..write('authors: $authors, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryVer: $categoryVer, ')
          ..write('id: $id, ')
          ..write('refId: $refId, ')
          ..write('refVer: $refVer, ')
          ..write('replyId: $replyId, ')
          ..write('replyVer: $replyVer, ')
          ..write('section: $section, ')
          ..write('templateId: $templateId, ')
          ..write('templateVer: $templateVer, ')
          ..write('type: $type, ')
          ..write('ver: $ver, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(content),
    authors,
    categoryId,
    categoryVer,
    id,
    refId,
    refVer,
    replyId,
    replyVer,
    section,
    templateId,
    templateVer,
    type,
    ver,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentsV2Data &&
          $driftBlobEquality.equals(other.content, this.content) &&
          other.authors == this.authors &&
          other.categoryId == this.categoryId &&
          other.categoryVer == this.categoryVer &&
          other.id == this.id &&
          other.refId == this.refId &&
          other.refVer == this.refVer &&
          other.replyId == this.replyId &&
          other.replyVer == this.replyVer &&
          other.section == this.section &&
          other.templateId == this.templateId &&
          other.templateVer == this.templateVer &&
          other.type == this.type &&
          other.ver == this.ver &&
          other.createdAt == this.createdAt);
}

class DocumentsV2Companion extends UpdateCompanion<DocumentsV2Data> {
  final Value<i2.Uint8List> content;
  final Value<String> authors;
  final Value<String?> categoryId;
  final Value<String?> categoryVer;
  final Value<String> id;
  final Value<String?> refId;
  final Value<String?> refVer;
  final Value<String?> replyId;
  final Value<String?> replyVer;
  final Value<String?> section;
  final Value<String?> templateId;
  final Value<String?> templateVer;
  final Value<String> type;
  final Value<String> ver;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DocumentsV2Companion({
    this.content = const Value.absent(),
    this.authors = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryVer = const Value.absent(),
    this.id = const Value.absent(),
    this.refId = const Value.absent(),
    this.refVer = const Value.absent(),
    this.replyId = const Value.absent(),
    this.replyVer = const Value.absent(),
    this.section = const Value.absent(),
    this.templateId = const Value.absent(),
    this.templateVer = const Value.absent(),
    this.type = const Value.absent(),
    this.ver = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsV2Companion.insert({
    required i2.Uint8List content,
    required String authors,
    this.categoryId = const Value.absent(),
    this.categoryVer = const Value.absent(),
    required String id,
    this.refId = const Value.absent(),
    this.refVer = const Value.absent(),
    this.replyId = const Value.absent(),
    this.replyVer = const Value.absent(),
    this.section = const Value.absent(),
    this.templateId = const Value.absent(),
    this.templateVer = const Value.absent(),
    required String type,
    required String ver,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : content = Value(content),
       authors = Value(authors),
       id = Value(id),
       type = Value(type),
       ver = Value(ver),
       createdAt = Value(createdAt);
  static Insertable<DocumentsV2Data> custom({
    Expression<i2.Uint8List>? content,
    Expression<String>? authors,
    Expression<String>? categoryId,
    Expression<String>? categoryVer,
    Expression<String>? id,
    Expression<String>? refId,
    Expression<String>? refVer,
    Expression<String>? replyId,
    Expression<String>? replyVer,
    Expression<String>? section,
    Expression<String>? templateId,
    Expression<String>? templateVer,
    Expression<String>? type,
    Expression<String>? ver,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (content != null) 'content': content,
      if (authors != null) 'authors': authors,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryVer != null) 'category_ver': categoryVer,
      if (id != null) 'id': id,
      if (refId != null) 'ref_id': refId,
      if (refVer != null) 'ref_ver': refVer,
      if (replyId != null) 'reply_id': replyId,
      if (replyVer != null) 'reply_ver': replyVer,
      if (section != null) 'section': section,
      if (templateId != null) 'template_id': templateId,
      if (templateVer != null) 'template_ver': templateVer,
      if (type != null) 'type': type,
      if (ver != null) 'ver': ver,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsV2Companion copyWith({
    Value<i2.Uint8List>? content,
    Value<String>? authors,
    Value<String?>? categoryId,
    Value<String?>? categoryVer,
    Value<String>? id,
    Value<String?>? refId,
    Value<String?>? refVer,
    Value<String?>? replyId,
    Value<String?>? replyVer,
    Value<String?>? section,
    Value<String?>? templateId,
    Value<String?>? templateVer,
    Value<String>? type,
    Value<String>? ver,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DocumentsV2Companion(
      content: content ?? this.content,
      authors: authors ?? this.authors,
      categoryId: categoryId ?? this.categoryId,
      categoryVer: categoryVer ?? this.categoryVer,
      id: id ?? this.id,
      refId: refId ?? this.refId,
      refVer: refVer ?? this.refVer,
      replyId: replyId ?? this.replyId,
      replyVer: replyVer ?? this.replyVer,
      section: section ?? this.section,
      templateId: templateId ?? this.templateId,
      templateVer: templateVer ?? this.templateVer,
      type: type ?? this.type,
      ver: ver ?? this.ver,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (content.present) {
      map['content'] = Variable<i2.Uint8List>(content.value);
    }
    if (authors.present) {
      map['authors'] = Variable<String>(authors.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryVer.present) {
      map['category_ver'] = Variable<String>(categoryVer.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (refVer.present) {
      map['ref_ver'] = Variable<String>(refVer.value);
    }
    if (replyId.present) {
      map['reply_id'] = Variable<String>(replyId.value);
    }
    if (replyVer.present) {
      map['reply_ver'] = Variable<String>(replyVer.value);
    }
    if (section.present) {
      map['section'] = Variable<String>(section.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (templateVer.present) {
      map['template_ver'] = Variable<String>(templateVer.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (ver.present) {
      map['ver'] = Variable<String>(ver.value);
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
    return (StringBuffer('DocumentsV2Companion(')
          ..write('content: $content, ')
          ..write('authors: $authors, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryVer: $categoryVer, ')
          ..write('id: $id, ')
          ..write('refId: $refId, ')
          ..write('refVer: $refVer, ')
          ..write('replyId: $replyId, ')
          ..write('replyVer: $replyVer, ')
          ..write('section: $section, ')
          ..write('templateId: $templateId, ')
          ..write('templateVer: $templateVer, ')
          ..write('type: $type, ')
          ..write('ver: $ver, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DocumentAuthors extends Table
    with TableInfo<DocumentAuthors, DocumentAuthorsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DocumentAuthors(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> authorId = GeneratedColumn<String>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> authorIdSignificant =
      GeneratedColumn<String>(
        'author_id_significant',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  late final GeneratedColumn<String> authorUsername = GeneratedColumn<String>(
    'author_username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> documentVer = GeneratedColumn<String>(
    'document_ver',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    authorId,
    authorIdSignificant,
    authorUsername,
    documentId,
    documentVer,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_authors';
  @override
  Set<GeneratedColumn> get $primaryKey => {documentId, documentVer, authorId};
  @override
  DocumentAuthorsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentAuthorsData(
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id'],
      )!,
      authorIdSignificant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_id_significant'],
      )!,
      authorUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_username'],
      ),
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      documentVer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_ver'],
      )!,
    );
  }

  @override
  DocumentAuthors createAlias(String alias) {
    return DocumentAuthors(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'FOREIGN KEY (document_id, document_ver) REFERENCES documents_v2(id, ver) ON DELETE CASCADE',
  ];
}

class DocumentAuthorsData extends DataClass
    implements Insertable<DocumentAuthorsData> {
  final String authorId;
  final String authorIdSignificant;
  final String? authorUsername;
  final String documentId;
  final String documentVer;
  const DocumentAuthorsData({
    required this.authorId,
    required this.authorIdSignificant,
    this.authorUsername,
    required this.documentId,
    required this.documentVer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['author_id'] = Variable<String>(authorId);
    map['author_id_significant'] = Variable<String>(authorIdSignificant);
    if (!nullToAbsent || authorUsername != null) {
      map['author_username'] = Variable<String>(authorUsername);
    }
    map['document_id'] = Variable<String>(documentId);
    map['document_ver'] = Variable<String>(documentVer);
    return map;
  }

  factory DocumentAuthorsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentAuthorsData(
      authorId: serializer.fromJson<String>(json['authorId']),
      authorIdSignificant: serializer.fromJson<String>(
        json['authorIdSignificant'],
      ),
      authorUsername: serializer.fromJson<String?>(json['authorUsername']),
      documentId: serializer.fromJson<String>(json['documentId']),
      documentVer: serializer.fromJson<String>(json['documentVer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'authorId': serializer.toJson<String>(authorId),
      'authorIdSignificant': serializer.toJson<String>(authorIdSignificant),
      'authorUsername': serializer.toJson<String?>(authorUsername),
      'documentId': serializer.toJson<String>(documentId),
      'documentVer': serializer.toJson<String>(documentVer),
    };
  }

  DocumentAuthorsData copyWith({
    String? authorId,
    String? authorIdSignificant,
    Value<String?> authorUsername = const Value.absent(),
    String? documentId,
    String? documentVer,
  }) => DocumentAuthorsData(
    authorId: authorId ?? this.authorId,
    authorIdSignificant: authorIdSignificant ?? this.authorIdSignificant,
    authorUsername: authorUsername.present
        ? authorUsername.value
        : this.authorUsername,
    documentId: documentId ?? this.documentId,
    documentVer: documentVer ?? this.documentVer,
  );
  DocumentAuthorsData copyWithCompanion(DocumentAuthorsCompanion data) {
    return DocumentAuthorsData(
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      authorIdSignificant: data.authorIdSignificant.present
          ? data.authorIdSignificant.value
          : this.authorIdSignificant,
      authorUsername: data.authorUsername.present
          ? data.authorUsername.value
          : this.authorUsername,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      documentVer: data.documentVer.present
          ? data.documentVer.value
          : this.documentVer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentAuthorsData(')
          ..write('authorId: $authorId, ')
          ..write('authorIdSignificant: $authorIdSignificant, ')
          ..write('authorUsername: $authorUsername, ')
          ..write('documentId: $documentId, ')
          ..write('documentVer: $documentVer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    authorId,
    authorIdSignificant,
    authorUsername,
    documentId,
    documentVer,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentAuthorsData &&
          other.authorId == this.authorId &&
          other.authorIdSignificant == this.authorIdSignificant &&
          other.authorUsername == this.authorUsername &&
          other.documentId == this.documentId &&
          other.documentVer == this.documentVer);
}

class DocumentAuthorsCompanion extends UpdateCompanion<DocumentAuthorsData> {
  final Value<String> authorId;
  final Value<String> authorIdSignificant;
  final Value<String?> authorUsername;
  final Value<String> documentId;
  final Value<String> documentVer;
  final Value<int> rowid;
  const DocumentAuthorsCompanion({
    this.authorId = const Value.absent(),
    this.authorIdSignificant = const Value.absent(),
    this.authorUsername = const Value.absent(),
    this.documentId = const Value.absent(),
    this.documentVer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentAuthorsCompanion.insert({
    required String authorId,
    required String authorIdSignificant,
    this.authorUsername = const Value.absent(),
    required String documentId,
    required String documentVer,
    this.rowid = const Value.absent(),
  }) : authorId = Value(authorId),
       authorIdSignificant = Value(authorIdSignificant),
       documentId = Value(documentId),
       documentVer = Value(documentVer);
  static Insertable<DocumentAuthorsData> custom({
    Expression<String>? authorId,
    Expression<String>? authorIdSignificant,
    Expression<String>? authorUsername,
    Expression<String>? documentId,
    Expression<String>? documentVer,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (authorId != null) 'author_id': authorId,
      if (authorIdSignificant != null)
        'author_id_significant': authorIdSignificant,
      if (authorUsername != null) 'author_username': authorUsername,
      if (documentId != null) 'document_id': documentId,
      if (documentVer != null) 'document_ver': documentVer,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentAuthorsCompanion copyWith({
    Value<String>? authorId,
    Value<String>? authorIdSignificant,
    Value<String?>? authorUsername,
    Value<String>? documentId,
    Value<String>? documentVer,
    Value<int>? rowid,
  }) {
    return DocumentAuthorsCompanion(
      authorId: authorId ?? this.authorId,
      authorIdSignificant: authorIdSignificant ?? this.authorIdSignificant,
      authorUsername: authorUsername ?? this.authorUsername,
      documentId: documentId ?? this.documentId,
      documentVer: documentVer ?? this.documentVer,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (authorId.present) {
      map['author_id'] = Variable<String>(authorId.value);
    }
    if (authorIdSignificant.present) {
      map['author_id_significant'] = Variable<String>(
        authorIdSignificant.value,
      );
    }
    if (authorUsername.present) {
      map['author_username'] = Variable<String>(authorUsername.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (documentVer.present) {
      map['document_ver'] = Variable<String>(documentVer.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentAuthorsCompanion(')
          ..write('authorId: $authorId, ')
          ..write('authorIdSignificant: $authorIdSignificant, ')
          ..write('authorUsername: $authorUsername, ')
          ..write('documentId: $documentId, ')
          ..write('documentVer: $documentVer, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DocumentsLocalMetadata extends Table
    with TableInfo<DocumentsLocalMetadata, DocumentsLocalMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DocumentsLocalMetadata(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  @override
  List<GeneratedColumn> get $columns => [id, isFavorite];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents_local_metadata';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentsLocalMetadataData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentsLocalMetadataData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
    );
  }

  @override
  DocumentsLocalMetadata createAlias(String alias) {
    return DocumentsLocalMetadata(attachedDatabase, alias);
  }
}

class DocumentsLocalMetadataData extends DataClass
    implements Insertable<DocumentsLocalMetadataData> {
  final String id;
  final bool isFavorite;
  const DocumentsLocalMetadataData({
    required this.id,
    required this.isFavorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  factory DocumentsLocalMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentsLocalMetadataData(
      id: serializer.fromJson<String>(json['id']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  DocumentsLocalMetadataData copyWith({String? id, bool? isFavorite}) =>
      DocumentsLocalMetadataData(
        id: id ?? this.id,
        isFavorite: isFavorite ?? this.isFavorite,
      );
  DocumentsLocalMetadataData copyWithCompanion(
    DocumentsLocalMetadataCompanion data,
  ) {
    return DocumentsLocalMetadataData(
      id: data.id.present ? data.id.value : this.id,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsLocalMetadataData(')
          ..write('id: $id, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, isFavorite);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentsLocalMetadataData &&
          other.id == this.id &&
          other.isFavorite == this.isFavorite);
}

class DocumentsLocalMetadataCompanion
    extends UpdateCompanion<DocumentsLocalMetadataData> {
  final Value<String> id;
  final Value<bool> isFavorite;
  final Value<int> rowid;
  const DocumentsLocalMetadataCompanion({
    this.id = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsLocalMetadataCompanion.insert({
    required String id,
    required bool isFavorite,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       isFavorite = Value(isFavorite);
  static Insertable<DocumentsLocalMetadataData> custom({
    Expression<String>? id,
    Expression<bool>? isFavorite,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsLocalMetadataCompanion copyWith({
    Value<String>? id,
    Value<bool>? isFavorite,
    Value<int>? rowid,
  }) {
    return DocumentsLocalMetadataCompanion(
      id: id ?? this.id,
      isFavorite: isFavorite ?? this.isFavorite,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsLocalMetadataCompanion(')
          ..write('id: $id, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class LocalDocumentsDrafts extends Table
    with TableInfo<LocalDocumentsDrafts, LocalDocumentsDraftsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  LocalDocumentsDrafts(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<i2.Uint8List> content =
      GeneratedColumn<i2.Uint8List>(
        'content',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  late final GeneratedColumn<String> authors = GeneratedColumn<String>(
    'authors',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> categoryVer = GeneratedColumn<String>(
    'category_ver',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
    'ref_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> refVer = GeneratedColumn<String>(
    'ref_ver',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> replyId = GeneratedColumn<String>(
    'reply_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> replyVer = GeneratedColumn<String>(
    'reply_ver',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> section = GeneratedColumn<String>(
    'section',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> templateVer = GeneratedColumn<String>(
    'template_ver',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> ver = GeneratedColumn<String>(
    'ver',
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
    content,
    authors,
    categoryId,
    categoryVer,
    id,
    refId,
    refVer,
    replyId,
    replyVer,
    section,
    templateId,
    templateVer,
    type,
    ver,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_documents_drafts';
  @override
  Set<GeneratedColumn> get $primaryKey => {id, ver};
  @override
  LocalDocumentsDraftsData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalDocumentsDraftsData(
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}content'],
      )!,
      authors: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}authors'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      categoryVer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_ver'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      refId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_id'],
      ),
      refVer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_ver'],
      ),
      replyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_id'],
      ),
      replyVer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_ver'],
      ),
      section: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section'],
      ),
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      ),
      templateVer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_ver'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      ver: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ver'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  LocalDocumentsDrafts createAlias(String alias) {
    return LocalDocumentsDrafts(attachedDatabase, alias);
  }
}

class LocalDocumentsDraftsData extends DataClass
    implements Insertable<LocalDocumentsDraftsData> {
  final i2.Uint8List content;
  final String authors;
  final String? categoryId;
  final String? categoryVer;
  final String id;
  final String? refId;
  final String? refVer;
  final String? replyId;
  final String? replyVer;
  final String? section;
  final String? templateId;
  final String? templateVer;
  final String type;
  final String ver;
  final DateTime createdAt;
  const LocalDocumentsDraftsData({
    required this.content,
    required this.authors,
    this.categoryId,
    this.categoryVer,
    required this.id,
    this.refId,
    this.refVer,
    this.replyId,
    this.replyVer,
    this.section,
    this.templateId,
    this.templateVer,
    required this.type,
    required this.ver,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content'] = Variable<i2.Uint8List>(content);
    map['authors'] = Variable<String>(authors);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || categoryVer != null) {
      map['category_ver'] = Variable<String>(categoryVer);
    }
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || refId != null) {
      map['ref_id'] = Variable<String>(refId);
    }
    if (!nullToAbsent || refVer != null) {
      map['ref_ver'] = Variable<String>(refVer);
    }
    if (!nullToAbsent || replyId != null) {
      map['reply_id'] = Variable<String>(replyId);
    }
    if (!nullToAbsent || replyVer != null) {
      map['reply_ver'] = Variable<String>(replyVer);
    }
    if (!nullToAbsent || section != null) {
      map['section'] = Variable<String>(section);
    }
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<String>(templateId);
    }
    if (!nullToAbsent || templateVer != null) {
      map['template_ver'] = Variable<String>(templateVer);
    }
    map['type'] = Variable<String>(type);
    map['ver'] = Variable<String>(ver);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  factory LocalDocumentsDraftsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalDocumentsDraftsData(
      content: serializer.fromJson<i2.Uint8List>(json['content']),
      authors: serializer.fromJson<String>(json['authors']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      categoryVer: serializer.fromJson<String?>(json['categoryVer']),
      id: serializer.fromJson<String>(json['id']),
      refId: serializer.fromJson<String?>(json['refId']),
      refVer: serializer.fromJson<String?>(json['refVer']),
      replyId: serializer.fromJson<String?>(json['replyId']),
      replyVer: serializer.fromJson<String?>(json['replyVer']),
      section: serializer.fromJson<String?>(json['section']),
      templateId: serializer.fromJson<String?>(json['templateId']),
      templateVer: serializer.fromJson<String?>(json['templateVer']),
      type: serializer.fromJson<String>(json['type']),
      ver: serializer.fromJson<String>(json['ver']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'content': serializer.toJson<i2.Uint8List>(content),
      'authors': serializer.toJson<String>(authors),
      'categoryId': serializer.toJson<String?>(categoryId),
      'categoryVer': serializer.toJson<String?>(categoryVer),
      'id': serializer.toJson<String>(id),
      'refId': serializer.toJson<String?>(refId),
      'refVer': serializer.toJson<String?>(refVer),
      'replyId': serializer.toJson<String?>(replyId),
      'replyVer': serializer.toJson<String?>(replyVer),
      'section': serializer.toJson<String?>(section),
      'templateId': serializer.toJson<String?>(templateId),
      'templateVer': serializer.toJson<String?>(templateVer),
      'type': serializer.toJson<String>(type),
      'ver': serializer.toJson<String>(ver),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalDocumentsDraftsData copyWith({
    i2.Uint8List? content,
    String? authors,
    Value<String?> categoryId = const Value.absent(),
    Value<String?> categoryVer = const Value.absent(),
    String? id,
    Value<String?> refId = const Value.absent(),
    Value<String?> refVer = const Value.absent(),
    Value<String?> replyId = const Value.absent(),
    Value<String?> replyVer = const Value.absent(),
    Value<String?> section = const Value.absent(),
    Value<String?> templateId = const Value.absent(),
    Value<String?> templateVer = const Value.absent(),
    String? type,
    String? ver,
    DateTime? createdAt,
  }) => LocalDocumentsDraftsData(
    content: content ?? this.content,
    authors: authors ?? this.authors,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    categoryVer: categoryVer.present ? categoryVer.value : this.categoryVer,
    id: id ?? this.id,
    refId: refId.present ? refId.value : this.refId,
    refVer: refVer.present ? refVer.value : this.refVer,
    replyId: replyId.present ? replyId.value : this.replyId,
    replyVer: replyVer.present ? replyVer.value : this.replyVer,
    section: section.present ? section.value : this.section,
    templateId: templateId.present ? templateId.value : this.templateId,
    templateVer: templateVer.present ? templateVer.value : this.templateVer,
    type: type ?? this.type,
    ver: ver ?? this.ver,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalDocumentsDraftsData copyWithCompanion(
    LocalDocumentsDraftsCompanion data,
  ) {
    return LocalDocumentsDraftsData(
      content: data.content.present ? data.content.value : this.content,
      authors: data.authors.present ? data.authors.value : this.authors,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      categoryVer: data.categoryVer.present
          ? data.categoryVer.value
          : this.categoryVer,
      id: data.id.present ? data.id.value : this.id,
      refId: data.refId.present ? data.refId.value : this.refId,
      refVer: data.refVer.present ? data.refVer.value : this.refVer,
      replyId: data.replyId.present ? data.replyId.value : this.replyId,
      replyVer: data.replyVer.present ? data.replyVer.value : this.replyVer,
      section: data.section.present ? data.section.value : this.section,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      templateVer: data.templateVer.present
          ? data.templateVer.value
          : this.templateVer,
      type: data.type.present ? data.type.value : this.type,
      ver: data.ver.present ? data.ver.value : this.ver,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalDocumentsDraftsData(')
          ..write('content: $content, ')
          ..write('authors: $authors, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryVer: $categoryVer, ')
          ..write('id: $id, ')
          ..write('refId: $refId, ')
          ..write('refVer: $refVer, ')
          ..write('replyId: $replyId, ')
          ..write('replyVer: $replyVer, ')
          ..write('section: $section, ')
          ..write('templateId: $templateId, ')
          ..write('templateVer: $templateVer, ')
          ..write('type: $type, ')
          ..write('ver: $ver, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(content),
    authors,
    categoryId,
    categoryVer,
    id,
    refId,
    refVer,
    replyId,
    replyVer,
    section,
    templateId,
    templateVer,
    type,
    ver,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDocumentsDraftsData &&
          $driftBlobEquality.equals(other.content, this.content) &&
          other.authors == this.authors &&
          other.categoryId == this.categoryId &&
          other.categoryVer == this.categoryVer &&
          other.id == this.id &&
          other.refId == this.refId &&
          other.refVer == this.refVer &&
          other.replyId == this.replyId &&
          other.replyVer == this.replyVer &&
          other.section == this.section &&
          other.templateId == this.templateId &&
          other.templateVer == this.templateVer &&
          other.type == this.type &&
          other.ver == this.ver &&
          other.createdAt == this.createdAt);
}

class LocalDocumentsDraftsCompanion
    extends UpdateCompanion<LocalDocumentsDraftsData> {
  final Value<i2.Uint8List> content;
  final Value<String> authors;
  final Value<String?> categoryId;
  final Value<String?> categoryVer;
  final Value<String> id;
  final Value<String?> refId;
  final Value<String?> refVer;
  final Value<String?> replyId;
  final Value<String?> replyVer;
  final Value<String?> section;
  final Value<String?> templateId;
  final Value<String?> templateVer;
  final Value<String> type;
  final Value<String> ver;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalDocumentsDraftsCompanion({
    this.content = const Value.absent(),
    this.authors = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryVer = const Value.absent(),
    this.id = const Value.absent(),
    this.refId = const Value.absent(),
    this.refVer = const Value.absent(),
    this.replyId = const Value.absent(),
    this.replyVer = const Value.absent(),
    this.section = const Value.absent(),
    this.templateId = const Value.absent(),
    this.templateVer = const Value.absent(),
    this.type = const Value.absent(),
    this.ver = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalDocumentsDraftsCompanion.insert({
    required i2.Uint8List content,
    required String authors,
    this.categoryId = const Value.absent(),
    this.categoryVer = const Value.absent(),
    required String id,
    this.refId = const Value.absent(),
    this.refVer = const Value.absent(),
    this.replyId = const Value.absent(),
    this.replyVer = const Value.absent(),
    this.section = const Value.absent(),
    this.templateId = const Value.absent(),
    this.templateVer = const Value.absent(),
    required String type,
    required String ver,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : content = Value(content),
       authors = Value(authors),
       id = Value(id),
       type = Value(type),
       ver = Value(ver),
       createdAt = Value(createdAt);
  static Insertable<LocalDocumentsDraftsData> custom({
    Expression<i2.Uint8List>? content,
    Expression<String>? authors,
    Expression<String>? categoryId,
    Expression<String>? categoryVer,
    Expression<String>? id,
    Expression<String>? refId,
    Expression<String>? refVer,
    Expression<String>? replyId,
    Expression<String>? replyVer,
    Expression<String>? section,
    Expression<String>? templateId,
    Expression<String>? templateVer,
    Expression<String>? type,
    Expression<String>? ver,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (content != null) 'content': content,
      if (authors != null) 'authors': authors,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryVer != null) 'category_ver': categoryVer,
      if (id != null) 'id': id,
      if (refId != null) 'ref_id': refId,
      if (refVer != null) 'ref_ver': refVer,
      if (replyId != null) 'reply_id': replyId,
      if (replyVer != null) 'reply_ver': replyVer,
      if (section != null) 'section': section,
      if (templateId != null) 'template_id': templateId,
      if (templateVer != null) 'template_ver': templateVer,
      if (type != null) 'type': type,
      if (ver != null) 'ver': ver,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalDocumentsDraftsCompanion copyWith({
    Value<i2.Uint8List>? content,
    Value<String>? authors,
    Value<String?>? categoryId,
    Value<String?>? categoryVer,
    Value<String>? id,
    Value<String?>? refId,
    Value<String?>? refVer,
    Value<String?>? replyId,
    Value<String?>? replyVer,
    Value<String?>? section,
    Value<String?>? templateId,
    Value<String?>? templateVer,
    Value<String>? type,
    Value<String>? ver,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalDocumentsDraftsCompanion(
      content: content ?? this.content,
      authors: authors ?? this.authors,
      categoryId: categoryId ?? this.categoryId,
      categoryVer: categoryVer ?? this.categoryVer,
      id: id ?? this.id,
      refId: refId ?? this.refId,
      refVer: refVer ?? this.refVer,
      replyId: replyId ?? this.replyId,
      replyVer: replyVer ?? this.replyVer,
      section: section ?? this.section,
      templateId: templateId ?? this.templateId,
      templateVer: templateVer ?? this.templateVer,
      type: type ?? this.type,
      ver: ver ?? this.ver,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (content.present) {
      map['content'] = Variable<i2.Uint8List>(content.value);
    }
    if (authors.present) {
      map['authors'] = Variable<String>(authors.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryVer.present) {
      map['category_ver'] = Variable<String>(categoryVer.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (refVer.present) {
      map['ref_ver'] = Variable<String>(refVer.value);
    }
    if (replyId.present) {
      map['reply_id'] = Variable<String>(replyId.value);
    }
    if (replyVer.present) {
      map['reply_ver'] = Variable<String>(replyVer.value);
    }
    if (section.present) {
      map['section'] = Variable<String>(section.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (templateVer.present) {
      map['template_ver'] = Variable<String>(templateVer.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (ver.present) {
      map['ver'] = Variable<String>(ver.value);
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
    return (StringBuffer('LocalDocumentsDraftsCompanion(')
          ..write('content: $content, ')
          ..write('authors: $authors, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryVer: $categoryVer, ')
          ..write('id: $id, ')
          ..write('refId: $refId, ')
          ..write('refVer: $refVer, ')
          ..write('replyId: $replyId, ')
          ..write('replyVer: $replyVer, ')
          ..write('section: $section, ')
          ..write('templateId: $templateId, ')
          ..write('templateVer: $templateVer, ')
          ..write('type: $type, ')
          ..write('ver: $ver, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV4 extends GeneratedDatabase {
  DatabaseAtV4(QueryExecutor e) : super(e);
  late final Documents documents = Documents(this);
  late final DocumentsMetadata documentsMetadata = DocumentsMetadata(this);
  late final DocumentsFavorites documentsFavorites = DocumentsFavorites(this);
  late final Drafts drafts = Drafts(this);
  late final DocumentsV2 documentsV2 = DocumentsV2(this);
  late final DocumentAuthors documentAuthors = DocumentAuthors(this);
  late final DocumentsLocalMetadata documentsLocalMetadata =
      DocumentsLocalMetadata(this);
  late final LocalDocumentsDrafts localDocumentsDrafts = LocalDocumentsDrafts(
    this,
  );
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
  late final Index idxDocumentsV2TypeId = Index(
    'idx_documents_v2_type_id',
    'CREATE INDEX idx_documents_v2_type_id ON documents_v2 (type, id)',
  );
  late final Index idxDocumentsV2TypeIdVer = Index(
    'idx_documents_v2_type_id_ver',
    'CREATE INDEX idx_documents_v2_type_id_ver ON documents_v2 (type, id, ver)',
  );
  late final Index idxDocumentsV2TypeRefId = Index(
    'idx_documents_v2_type_ref_id',
    'CREATE INDEX idx_documents_v2_type_ref_id ON documents_v2 (type, ref_id)',
  );
  late final Index idxDocumentsV2TypeRefIdVer = Index(
    'idx_documents_v2_type_ref_id_ver',
    'CREATE INDEX idx_documents_v2_type_ref_id_ver ON documents_v2 (type, ref_id, ver)',
  );
  late final Index idxDocumentsV2RefIdVer = Index(
    'idx_documents_v2_ref_id_ver',
    'CREATE INDEX idx_documents_v2_ref_id_ver ON documents_v2 (ref_id, ver)',
  );
  late final Index idxDocumentsV2TypeIdCreatedAt = Index(
    'idx_documents_v2_type_id_created_at',
    'CREATE INDEX idx_documents_v2_type_id_created_at ON documents_v2 (type, id, created_at)',
  );
  late final Index idxDocumentsV2TypeCategoryId = Index(
    'idx_documents_v2_type_category_id',
    'CREATE INDEX idx_documents_v2_type_category_id ON documents_v2 (type, category_id)',
  );
  late final Index idxDocumentsV2TypeRefIdRefVer = Index(
    'idx_documents_v2_type_ref_id_ref_ver',
    'CREATE INDEX idx_documents_v2_type_ref_id_ref_ver ON documents_v2 (type, ref_id, ref_ver)',
  );
  late final Index idxDocumentAuthorsComposite = Index(
    'idx_document_authors_composite',
    'CREATE INDEX idx_document_authors_composite ON document_authors (document_id, document_ver, author_id_significant)',
  );
  late final Index idxDocumentAuthorsIdentity = Index(
    'idx_document_authors_identity',
    'CREATE INDEX idx_document_authors_identity ON document_authors (author_id_significant)',
  );
  late final Index idxDocumentAuthorsUsername = Index(
    'idx_document_authors_username',
    'CREATE INDEX idx_document_authors_username ON document_authors (author_username)',
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
    documentsV2,
    documentAuthors,
    documentsLocalMetadata,
    localDocumentsDrafts,
    idxDocType,
    idxUniqueVer,
    idxDocMetadataKeyValue,
    idxFavType,
    idxFavUniqueId,
    idxDraftType,
    idxDocumentsV2TypeId,
    idxDocumentsV2TypeIdVer,
    idxDocumentsV2TypeRefId,
    idxDocumentsV2TypeRefIdVer,
    idxDocumentsV2RefIdVer,
    idxDocumentsV2TypeIdCreatedAt,
    idxDocumentsV2TypeCategoryId,
    idxDocumentsV2TypeRefIdRefVer,
    idxDocumentAuthorsComposite,
    idxDocumentAuthorsIdentity,
    idxDocumentAuthorsUsername,
  ];
  @override
  int get schemaVersion => 4;
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}
