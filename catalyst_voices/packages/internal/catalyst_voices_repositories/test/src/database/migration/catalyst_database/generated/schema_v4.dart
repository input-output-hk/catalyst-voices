// dart format width=80
import 'dart:typed_data' as i2;
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

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
  late final GeneratedColumn<String> collaborators = GeneratedColumn<String>(
    'collaborators',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> parameters = GeneratedColumn<String>(
    'parameters',
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
    collaborators,
    contentType,
    id,
    parameters,
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
      collaborators: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collaborators'],
      )!,
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      parameters: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parameters'],
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
  final String collaborators;
  final String contentType;
  final String id;
  final String parameters;
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
    required this.collaborators,
    required this.contentType,
    required this.id,
    required this.parameters,
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
    map['collaborators'] = Variable<String>(collaborators);
    map['content_type'] = Variable<String>(contentType);
    map['id'] = Variable<String>(id);
    map['parameters'] = Variable<String>(parameters);
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
      collaborators: serializer.fromJson<String>(json['collaborators']),
      contentType: serializer.fromJson<String>(json['contentType']),
      id: serializer.fromJson<String>(json['id']),
      parameters: serializer.fromJson<String>(json['parameters']),
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
      'collaborators': serializer.toJson<String>(collaborators),
      'contentType': serializer.toJson<String>(contentType),
      'id': serializer.toJson<String>(id),
      'parameters': serializer.toJson<String>(parameters),
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
    String? collaborators,
    String? contentType,
    String? id,
    String? parameters,
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
    collaborators: collaborators ?? this.collaborators,
    contentType: contentType ?? this.contentType,
    id: id ?? this.id,
    parameters: parameters ?? this.parameters,
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
      collaborators: data.collaborators.present
          ? data.collaborators.value
          : this.collaborators,
      contentType: data.contentType.present
          ? data.contentType.value
          : this.contentType,
      id: data.id.present ? data.id.value : this.id,
      parameters: data.parameters.present
          ? data.parameters.value
          : this.parameters,
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
          ..write('collaborators: $collaborators, ')
          ..write('contentType: $contentType, ')
          ..write('id: $id, ')
          ..write('parameters: $parameters, ')
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
    collaborators,
    contentType,
    id,
    parameters,
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
          other.collaborators == this.collaborators &&
          other.contentType == this.contentType &&
          other.id == this.id &&
          other.parameters == this.parameters &&
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
  final Value<String> collaborators;
  final Value<String> contentType;
  final Value<String> id;
  final Value<String> parameters;
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
    this.collaborators = const Value.absent(),
    this.contentType = const Value.absent(),
    this.id = const Value.absent(),
    this.parameters = const Value.absent(),
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
    required String collaborators,
    required String contentType,
    required String id,
    required String parameters,
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
       collaborators = Value(collaborators),
       contentType = Value(contentType),
       id = Value(id),
       parameters = Value(parameters),
       type = Value(type),
       ver = Value(ver),
       createdAt = Value(createdAt);
  static Insertable<DocumentsV2Data> custom({
    Expression<i2.Uint8List>? content,
    Expression<String>? authors,
    Expression<String>? collaborators,
    Expression<String>? contentType,
    Expression<String>? id,
    Expression<String>? parameters,
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
      if (collaborators != null) 'collaborators': collaborators,
      if (contentType != null) 'content_type': contentType,
      if (id != null) 'id': id,
      if (parameters != null) 'parameters': parameters,
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
    Value<String>? collaborators,
    Value<String>? contentType,
    Value<String>? id,
    Value<String>? parameters,
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
      collaborators: collaborators ?? this.collaborators,
      contentType: contentType ?? this.contentType,
      id: id ?? this.id,
      parameters: parameters ?? this.parameters,
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
    if (collaborators.present) {
      map['collaborators'] = Variable<String>(collaborators.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (parameters.present) {
      map['parameters'] = Variable<String>(parameters.value);
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
          ..write('collaborators: $collaborators, ')
          ..write('contentType: $contentType, ')
          ..write('id: $id, ')
          ..write('parameters: $parameters, ')
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
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> accountSignificantId =
      GeneratedColumn<String>(
        'account_significant_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
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
    accountId,
    accountSignificantId,
    username,
    documentId,
    documentVer,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_authors';
  @override
  Set<GeneratedColumn> get $primaryKey => {documentId, documentVer, accountId};
  @override
  DocumentAuthorsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentAuthorsData(
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      accountSignificantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_significant_id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
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
  final String accountId;
  final String accountSignificantId;
  final String? username;
  final String documentId;
  final String documentVer;
  const DocumentAuthorsData({
    required this.accountId,
    required this.accountSignificantId,
    this.username,
    required this.documentId,
    required this.documentVer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_id'] = Variable<String>(accountId);
    map['account_significant_id'] = Variable<String>(accountSignificantId);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
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
      accountId: serializer.fromJson<String>(json['accountId']),
      accountSignificantId: serializer.fromJson<String>(
        json['accountSignificantId'],
      ),
      username: serializer.fromJson<String?>(json['username']),
      documentId: serializer.fromJson<String>(json['documentId']),
      documentVer: serializer.fromJson<String>(json['documentVer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountId': serializer.toJson<String>(accountId),
      'accountSignificantId': serializer.toJson<String>(accountSignificantId),
      'username': serializer.toJson<String?>(username),
      'documentId': serializer.toJson<String>(documentId),
      'documentVer': serializer.toJson<String>(documentVer),
    };
  }

  DocumentAuthorsData copyWith({
    String? accountId,
    String? accountSignificantId,
    Value<String?> username = const Value.absent(),
    String? documentId,
    String? documentVer,
  }) => DocumentAuthorsData(
    accountId: accountId ?? this.accountId,
    accountSignificantId: accountSignificantId ?? this.accountSignificantId,
    username: username.present ? username.value : this.username,
    documentId: documentId ?? this.documentId,
    documentVer: documentVer ?? this.documentVer,
  );
  DocumentAuthorsData copyWithCompanion(DocumentAuthorsCompanion data) {
    return DocumentAuthorsData(
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      accountSignificantId: data.accountSignificantId.present
          ? data.accountSignificantId.value
          : this.accountSignificantId,
      username: data.username.present ? data.username.value : this.username,
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
          ..write('accountId: $accountId, ')
          ..write('accountSignificantId: $accountSignificantId, ')
          ..write('username: $username, ')
          ..write('documentId: $documentId, ')
          ..write('documentVer: $documentVer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    accountId,
    accountSignificantId,
    username,
    documentId,
    documentVer,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentAuthorsData &&
          other.accountId == this.accountId &&
          other.accountSignificantId == this.accountSignificantId &&
          other.username == this.username &&
          other.documentId == this.documentId &&
          other.documentVer == this.documentVer);
}

class DocumentAuthorsCompanion extends UpdateCompanion<DocumentAuthorsData> {
  final Value<String> accountId;
  final Value<String> accountSignificantId;
  final Value<String?> username;
  final Value<String> documentId;
  final Value<String> documentVer;
  final Value<int> rowid;
  const DocumentAuthorsCompanion({
    this.accountId = const Value.absent(),
    this.accountSignificantId = const Value.absent(),
    this.username = const Value.absent(),
    this.documentId = const Value.absent(),
    this.documentVer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentAuthorsCompanion.insert({
    required String accountId,
    required String accountSignificantId,
    this.username = const Value.absent(),
    required String documentId,
    required String documentVer,
    this.rowid = const Value.absent(),
  }) : accountId = Value(accountId),
       accountSignificantId = Value(accountSignificantId),
       documentId = Value(documentId),
       documentVer = Value(documentVer);
  static Insertable<DocumentAuthorsData> custom({
    Expression<String>? accountId,
    Expression<String>? accountSignificantId,
    Expression<String>? username,
    Expression<String>? documentId,
    Expression<String>? documentVer,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (accountSignificantId != null)
        'account_significant_id': accountSignificantId,
      if (username != null) 'username': username,
      if (documentId != null) 'document_id': documentId,
      if (documentVer != null) 'document_ver': documentVer,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentAuthorsCompanion copyWith({
    Value<String>? accountId,
    Value<String>? accountSignificantId,
    Value<String?>? username,
    Value<String>? documentId,
    Value<String>? documentVer,
    Value<int>? rowid,
  }) {
    return DocumentAuthorsCompanion(
      accountId: accountId ?? this.accountId,
      accountSignificantId: accountSignificantId ?? this.accountSignificantId,
      username: username ?? this.username,
      documentId: documentId ?? this.documentId,
      documentVer: documentVer ?? this.documentVer,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (accountSignificantId.present) {
      map['account_significant_id'] = Variable<String>(
        accountSignificantId.value,
      );
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
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
          ..write('accountId: $accountId, ')
          ..write('accountSignificantId: $accountSignificantId, ')
          ..write('username: $username, ')
          ..write('documentId: $documentId, ')
          ..write('documentVer: $documentVer, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DocumentArtifacts extends Table
    with TableInfo<DocumentArtifacts, DocumentArtifactsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DocumentArtifacts(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<i2.Uint8List> data = GeneratedColumn<i2.Uint8List>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  @override
  List<GeneratedColumn> get $columns => [data, id, ver];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_artifacts';
  @override
  Set<GeneratedColumn> get $primaryKey => {id, ver};
  @override
  DocumentArtifactsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentArtifactsData(
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}data'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ver: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ver'],
      )!,
    );
  }

  @override
  DocumentArtifacts createAlias(String alias) {
    return DocumentArtifacts(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'FOREIGN KEY (id, ver) REFERENCES documents_v2(id, ver) ON DELETE CASCADE',
  ];
}

class DocumentArtifactsData extends DataClass
    implements Insertable<DocumentArtifactsData> {
  final i2.Uint8List data;
  final String id;
  final String ver;
  const DocumentArtifactsData({
    required this.data,
    required this.id,
    required this.ver,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['data'] = Variable<i2.Uint8List>(data);
    map['id'] = Variable<String>(id);
    map['ver'] = Variable<String>(ver);
    return map;
  }

  factory DocumentArtifactsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentArtifactsData(
      data: serializer.fromJson<i2.Uint8List>(json['data']),
      id: serializer.fromJson<String>(json['id']),
      ver: serializer.fromJson<String>(json['ver']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'data': serializer.toJson<i2.Uint8List>(data),
      'id': serializer.toJson<String>(id),
      'ver': serializer.toJson<String>(ver),
    };
  }

  DocumentArtifactsData copyWith({
    i2.Uint8List? data,
    String? id,
    String? ver,
  }) => DocumentArtifactsData(
    data: data ?? this.data,
    id: id ?? this.id,
    ver: ver ?? this.ver,
  );
  DocumentArtifactsData copyWithCompanion(DocumentArtifactsCompanion data) {
    return DocumentArtifactsData(
      data: data.data.present ? data.data.value : this.data,
      id: data.id.present ? data.id.value : this.id,
      ver: data.ver.present ? data.ver.value : this.ver,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentArtifactsData(')
          ..write('data: $data, ')
          ..write('id: $id, ')
          ..write('ver: $ver')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash($driftBlobEquality.hash(data), id, ver);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentArtifactsData &&
          $driftBlobEquality.equals(other.data, this.data) &&
          other.id == this.id &&
          other.ver == this.ver);
}

class DocumentArtifactsCompanion
    extends UpdateCompanion<DocumentArtifactsData> {
  final Value<i2.Uint8List> data;
  final Value<String> id;
  final Value<String> ver;
  final Value<int> rowid;
  const DocumentArtifactsCompanion({
    this.data = const Value.absent(),
    this.id = const Value.absent(),
    this.ver = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentArtifactsCompanion.insert({
    required i2.Uint8List data,
    required String id,
    required String ver,
    this.rowid = const Value.absent(),
  }) : data = Value(data),
       id = Value(id),
       ver = Value(ver);
  static Insertable<DocumentArtifactsData> custom({
    Expression<i2.Uint8List>? data,
    Expression<String>? id,
    Expression<String>? ver,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (data != null) 'data': data,
      if (id != null) 'id': id,
      if (ver != null) 'ver': ver,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentArtifactsCompanion copyWith({
    Value<i2.Uint8List>? data,
    Value<String>? id,
    Value<String>? ver,
    Value<int>? rowid,
  }) {
    return DocumentArtifactsCompanion(
      data: data ?? this.data,
      id: id ?? this.id,
      ver: ver ?? this.ver,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (data.present) {
      map['data'] = Variable<i2.Uint8List>(data.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ver.present) {
      map['ver'] = Variable<String>(ver.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentArtifactsCompanion(')
          ..write('data: $data, ')
          ..write('id: $id, ')
          ..write('ver: $ver, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DocumentCollaborators extends Table
    with TableInfo<DocumentCollaborators, DocumentCollaboratorsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DocumentCollaborators(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> accountSignificantId =
      GeneratedColumn<String>(
        'account_significant_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
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
    accountId,
    accountSignificantId,
    username,
    documentId,
    documentVer,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_collaborators';
  @override
  Set<GeneratedColumn> get $primaryKey => {documentId, documentVer, accountId};
  @override
  DocumentCollaboratorsData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentCollaboratorsData(
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      accountSignificantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_significant_id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
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
  DocumentCollaborators createAlias(String alias) {
    return DocumentCollaborators(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'FOREIGN KEY (document_id, document_ver) REFERENCES documents_v2(id, ver) ON DELETE CASCADE',
  ];
}

class DocumentCollaboratorsData extends DataClass
    implements Insertable<DocumentCollaboratorsData> {
  final String accountId;
  final String accountSignificantId;
  final String? username;
  final String documentId;
  final String documentVer;
  const DocumentCollaboratorsData({
    required this.accountId,
    required this.accountSignificantId,
    this.username,
    required this.documentId,
    required this.documentVer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_id'] = Variable<String>(accountId);
    map['account_significant_id'] = Variable<String>(accountSignificantId);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    map['document_id'] = Variable<String>(documentId);
    map['document_ver'] = Variable<String>(documentVer);
    return map;
  }

  factory DocumentCollaboratorsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentCollaboratorsData(
      accountId: serializer.fromJson<String>(json['accountId']),
      accountSignificantId: serializer.fromJson<String>(
        json['accountSignificantId'],
      ),
      username: serializer.fromJson<String?>(json['username']),
      documentId: serializer.fromJson<String>(json['documentId']),
      documentVer: serializer.fromJson<String>(json['documentVer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountId': serializer.toJson<String>(accountId),
      'accountSignificantId': serializer.toJson<String>(accountSignificantId),
      'username': serializer.toJson<String?>(username),
      'documentId': serializer.toJson<String>(documentId),
      'documentVer': serializer.toJson<String>(documentVer),
    };
  }

  DocumentCollaboratorsData copyWith({
    String? accountId,
    String? accountSignificantId,
    Value<String?> username = const Value.absent(),
    String? documentId,
    String? documentVer,
  }) => DocumentCollaboratorsData(
    accountId: accountId ?? this.accountId,
    accountSignificantId: accountSignificantId ?? this.accountSignificantId,
    username: username.present ? username.value : this.username,
    documentId: documentId ?? this.documentId,
    documentVer: documentVer ?? this.documentVer,
  );
  DocumentCollaboratorsData copyWithCompanion(
    DocumentCollaboratorsCompanion data,
  ) {
    return DocumentCollaboratorsData(
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      accountSignificantId: data.accountSignificantId.present
          ? data.accountSignificantId.value
          : this.accountSignificantId,
      username: data.username.present ? data.username.value : this.username,
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
    return (StringBuffer('DocumentCollaboratorsData(')
          ..write('accountId: $accountId, ')
          ..write('accountSignificantId: $accountSignificantId, ')
          ..write('username: $username, ')
          ..write('documentId: $documentId, ')
          ..write('documentVer: $documentVer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    accountId,
    accountSignificantId,
    username,
    documentId,
    documentVer,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentCollaboratorsData &&
          other.accountId == this.accountId &&
          other.accountSignificantId == this.accountSignificantId &&
          other.username == this.username &&
          other.documentId == this.documentId &&
          other.documentVer == this.documentVer);
}

class DocumentCollaboratorsCompanion
    extends UpdateCompanion<DocumentCollaboratorsData> {
  final Value<String> accountId;
  final Value<String> accountSignificantId;
  final Value<String?> username;
  final Value<String> documentId;
  final Value<String> documentVer;
  final Value<int> rowid;
  const DocumentCollaboratorsCompanion({
    this.accountId = const Value.absent(),
    this.accountSignificantId = const Value.absent(),
    this.username = const Value.absent(),
    this.documentId = const Value.absent(),
    this.documentVer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentCollaboratorsCompanion.insert({
    required String accountId,
    required String accountSignificantId,
    this.username = const Value.absent(),
    required String documentId,
    required String documentVer,
    this.rowid = const Value.absent(),
  }) : accountId = Value(accountId),
       accountSignificantId = Value(accountSignificantId),
       documentId = Value(documentId),
       documentVer = Value(documentVer);
  static Insertable<DocumentCollaboratorsData> custom({
    Expression<String>? accountId,
    Expression<String>? accountSignificantId,
    Expression<String>? username,
    Expression<String>? documentId,
    Expression<String>? documentVer,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (accountSignificantId != null)
        'account_significant_id': accountSignificantId,
      if (username != null) 'username': username,
      if (documentId != null) 'document_id': documentId,
      if (documentVer != null) 'document_ver': documentVer,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentCollaboratorsCompanion copyWith({
    Value<String>? accountId,
    Value<String>? accountSignificantId,
    Value<String?>? username,
    Value<String>? documentId,
    Value<String>? documentVer,
    Value<int>? rowid,
  }) {
    return DocumentCollaboratorsCompanion(
      accountId: accountId ?? this.accountId,
      accountSignificantId: accountSignificantId ?? this.accountSignificantId,
      username: username ?? this.username,
      documentId: documentId ?? this.documentId,
      documentVer: documentVer ?? this.documentVer,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (accountSignificantId.present) {
      map['account_significant_id'] = Variable<String>(
        accountSignificantId.value,
      );
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
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
    return (StringBuffer('DocumentCollaboratorsCompanion(')
          ..write('accountId: $accountId, ')
          ..write('accountSignificantId: $accountSignificantId, ')
          ..write('username: $username, ')
          ..write('documentId: $documentId, ')
          ..write('documentVer: $documentVer, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DocumentParameters extends Table
    with TableInfo<DocumentParameters, DocumentParametersData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DocumentParameters(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  @override
  List<GeneratedColumn> get $columns => [documentId, documentVer, id, ver];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_parameters';
  @override
  Set<GeneratedColumn> get $primaryKey => {id, ver, documentId, documentVer};
  @override
  DocumentParametersData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentParametersData(
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      documentVer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_ver'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ver: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ver'],
      )!,
    );
  }

  @override
  DocumentParameters createAlias(String alias) {
    return DocumentParameters(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'FOREIGN KEY (document_id, document_ver) REFERENCES documents_v2(id, ver) ON DELETE CASCADE',
  ];
}

class DocumentParametersData extends DataClass
    implements Insertable<DocumentParametersData> {
  final String documentId;
  final String documentVer;
  final String id;
  final String ver;
  const DocumentParametersData({
    required this.documentId,
    required this.documentVer,
    required this.id,
    required this.ver,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['document_id'] = Variable<String>(documentId);
    map['document_ver'] = Variable<String>(documentVer);
    map['id'] = Variable<String>(id);
    map['ver'] = Variable<String>(ver);
    return map;
  }

  factory DocumentParametersData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentParametersData(
      documentId: serializer.fromJson<String>(json['documentId']),
      documentVer: serializer.fromJson<String>(json['documentVer']),
      id: serializer.fromJson<String>(json['id']),
      ver: serializer.fromJson<String>(json['ver']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'documentId': serializer.toJson<String>(documentId),
      'documentVer': serializer.toJson<String>(documentVer),
      'id': serializer.toJson<String>(id),
      'ver': serializer.toJson<String>(ver),
    };
  }

  DocumentParametersData copyWith({
    String? documentId,
    String? documentVer,
    String? id,
    String? ver,
  }) => DocumentParametersData(
    documentId: documentId ?? this.documentId,
    documentVer: documentVer ?? this.documentVer,
    id: id ?? this.id,
    ver: ver ?? this.ver,
  );
  DocumentParametersData copyWithCompanion(DocumentParametersCompanion data) {
    return DocumentParametersData(
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      documentVer: data.documentVer.present
          ? data.documentVer.value
          : this.documentVer,
      id: data.id.present ? data.id.value : this.id,
      ver: data.ver.present ? data.ver.value : this.ver,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentParametersData(')
          ..write('documentId: $documentId, ')
          ..write('documentVer: $documentVer, ')
          ..write('id: $id, ')
          ..write('ver: $ver')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(documentId, documentVer, id, ver);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentParametersData &&
          other.documentId == this.documentId &&
          other.documentVer == this.documentVer &&
          other.id == this.id &&
          other.ver == this.ver);
}

class DocumentParametersCompanion
    extends UpdateCompanion<DocumentParametersData> {
  final Value<String> documentId;
  final Value<String> documentVer;
  final Value<String> id;
  final Value<String> ver;
  final Value<int> rowid;
  const DocumentParametersCompanion({
    this.documentId = const Value.absent(),
    this.documentVer = const Value.absent(),
    this.id = const Value.absent(),
    this.ver = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentParametersCompanion.insert({
    required String documentId,
    required String documentVer,
    required String id,
    required String ver,
    this.rowid = const Value.absent(),
  }) : documentId = Value(documentId),
       documentVer = Value(documentVer),
       id = Value(id),
       ver = Value(ver);
  static Insertable<DocumentParametersData> custom({
    Expression<String>? documentId,
    Expression<String>? documentVer,
    Expression<String>? id,
    Expression<String>? ver,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (documentId != null) 'document_id': documentId,
      if (documentVer != null) 'document_ver': documentVer,
      if (id != null) 'id': id,
      if (ver != null) 'ver': ver,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentParametersCompanion copyWith({
    Value<String>? documentId,
    Value<String>? documentVer,
    Value<String>? id,
    Value<String>? ver,
    Value<int>? rowid,
  }) {
    return DocumentParametersCompanion(
      documentId: documentId ?? this.documentId,
      documentVer: documentVer ?? this.documentVer,
      id: id ?? this.id,
      ver: ver ?? this.ver,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (documentVer.present) {
      map['document_ver'] = Variable<String>(documentVer.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ver.present) {
      map['ver'] = Variable<String>(ver.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentParametersCompanion(')
          ..write('documentId: $documentId, ')
          ..write('documentVer: $documentVer, ')
          ..write('id: $id, ')
          ..write('ver: $ver, ')
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
  late final GeneratedColumn<String> collaborators = GeneratedColumn<String>(
    'collaborators',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> parameters = GeneratedColumn<String>(
    'parameters',
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
  late final GeneratedColumn<String> authorsNames = GeneratedColumn<String>(
    'authors_names',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> authorsSignificant =
      GeneratedColumn<String>(
        'authors_significant',
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
    collaborators,
    contentType,
    id,
    parameters,
    refId,
    refVer,
    replyId,
    replyVer,
    section,
    templateId,
    templateVer,
    type,
    ver,
    authorsNames,
    authorsSignificant,
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
      collaborators: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collaborators'],
      )!,
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      parameters: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parameters'],
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
      authorsNames: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}authors_names'],
      )!,
      authorsSignificant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}authors_significant'],
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
  final String collaborators;
  final String contentType;
  final String id;
  final String parameters;
  final String? refId;
  final String? refVer;
  final String? replyId;
  final String? replyVer;
  final String? section;
  final String? templateId;
  final String? templateVer;
  final String type;
  final String ver;
  final String authorsNames;
  final String authorsSignificant;
  final DateTime createdAt;
  const LocalDocumentsDraftsData({
    required this.content,
    required this.authors,
    required this.collaborators,
    required this.contentType,
    required this.id,
    required this.parameters,
    this.refId,
    this.refVer,
    this.replyId,
    this.replyVer,
    this.section,
    this.templateId,
    this.templateVer,
    required this.type,
    required this.ver,
    required this.authorsNames,
    required this.authorsSignificant,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content'] = Variable<i2.Uint8List>(content);
    map['authors'] = Variable<String>(authors);
    map['collaborators'] = Variable<String>(collaborators);
    map['content_type'] = Variable<String>(contentType);
    map['id'] = Variable<String>(id);
    map['parameters'] = Variable<String>(parameters);
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
    map['authors_names'] = Variable<String>(authorsNames);
    map['authors_significant'] = Variable<String>(authorsSignificant);
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
      collaborators: serializer.fromJson<String>(json['collaborators']),
      contentType: serializer.fromJson<String>(json['contentType']),
      id: serializer.fromJson<String>(json['id']),
      parameters: serializer.fromJson<String>(json['parameters']),
      refId: serializer.fromJson<String?>(json['refId']),
      refVer: serializer.fromJson<String?>(json['refVer']),
      replyId: serializer.fromJson<String?>(json['replyId']),
      replyVer: serializer.fromJson<String?>(json['replyVer']),
      section: serializer.fromJson<String?>(json['section']),
      templateId: serializer.fromJson<String?>(json['templateId']),
      templateVer: serializer.fromJson<String?>(json['templateVer']),
      type: serializer.fromJson<String>(json['type']),
      ver: serializer.fromJson<String>(json['ver']),
      authorsNames: serializer.fromJson<String>(json['authorsNames']),
      authorsSignificant: serializer.fromJson<String>(
        json['authorsSignificant'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'content': serializer.toJson<i2.Uint8List>(content),
      'authors': serializer.toJson<String>(authors),
      'collaborators': serializer.toJson<String>(collaborators),
      'contentType': serializer.toJson<String>(contentType),
      'id': serializer.toJson<String>(id),
      'parameters': serializer.toJson<String>(parameters),
      'refId': serializer.toJson<String?>(refId),
      'refVer': serializer.toJson<String?>(refVer),
      'replyId': serializer.toJson<String?>(replyId),
      'replyVer': serializer.toJson<String?>(replyVer),
      'section': serializer.toJson<String?>(section),
      'templateId': serializer.toJson<String?>(templateId),
      'templateVer': serializer.toJson<String?>(templateVer),
      'type': serializer.toJson<String>(type),
      'ver': serializer.toJson<String>(ver),
      'authorsNames': serializer.toJson<String>(authorsNames),
      'authorsSignificant': serializer.toJson<String>(authorsSignificant),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalDocumentsDraftsData copyWith({
    i2.Uint8List? content,
    String? authors,
    String? collaborators,
    String? contentType,
    String? id,
    String? parameters,
    Value<String?> refId = const Value.absent(),
    Value<String?> refVer = const Value.absent(),
    Value<String?> replyId = const Value.absent(),
    Value<String?> replyVer = const Value.absent(),
    Value<String?> section = const Value.absent(),
    Value<String?> templateId = const Value.absent(),
    Value<String?> templateVer = const Value.absent(),
    String? type,
    String? ver,
    String? authorsNames,
    String? authorsSignificant,
    DateTime? createdAt,
  }) => LocalDocumentsDraftsData(
    content: content ?? this.content,
    authors: authors ?? this.authors,
    collaborators: collaborators ?? this.collaborators,
    contentType: contentType ?? this.contentType,
    id: id ?? this.id,
    parameters: parameters ?? this.parameters,
    refId: refId.present ? refId.value : this.refId,
    refVer: refVer.present ? refVer.value : this.refVer,
    replyId: replyId.present ? replyId.value : this.replyId,
    replyVer: replyVer.present ? replyVer.value : this.replyVer,
    section: section.present ? section.value : this.section,
    templateId: templateId.present ? templateId.value : this.templateId,
    templateVer: templateVer.present ? templateVer.value : this.templateVer,
    type: type ?? this.type,
    ver: ver ?? this.ver,
    authorsNames: authorsNames ?? this.authorsNames,
    authorsSignificant: authorsSignificant ?? this.authorsSignificant,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalDocumentsDraftsData copyWithCompanion(
    LocalDocumentsDraftsCompanion data,
  ) {
    return LocalDocumentsDraftsData(
      content: data.content.present ? data.content.value : this.content,
      authors: data.authors.present ? data.authors.value : this.authors,
      collaborators: data.collaborators.present
          ? data.collaborators.value
          : this.collaborators,
      contentType: data.contentType.present
          ? data.contentType.value
          : this.contentType,
      id: data.id.present ? data.id.value : this.id,
      parameters: data.parameters.present
          ? data.parameters.value
          : this.parameters,
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
      authorsNames: data.authorsNames.present
          ? data.authorsNames.value
          : this.authorsNames,
      authorsSignificant: data.authorsSignificant.present
          ? data.authorsSignificant.value
          : this.authorsSignificant,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalDocumentsDraftsData(')
          ..write('content: $content, ')
          ..write('authors: $authors, ')
          ..write('collaborators: $collaborators, ')
          ..write('contentType: $contentType, ')
          ..write('id: $id, ')
          ..write('parameters: $parameters, ')
          ..write('refId: $refId, ')
          ..write('refVer: $refVer, ')
          ..write('replyId: $replyId, ')
          ..write('replyVer: $replyVer, ')
          ..write('section: $section, ')
          ..write('templateId: $templateId, ')
          ..write('templateVer: $templateVer, ')
          ..write('type: $type, ')
          ..write('ver: $ver, ')
          ..write('authorsNames: $authorsNames, ')
          ..write('authorsSignificant: $authorsSignificant, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(content),
    authors,
    collaborators,
    contentType,
    id,
    parameters,
    refId,
    refVer,
    replyId,
    replyVer,
    section,
    templateId,
    templateVer,
    type,
    ver,
    authorsNames,
    authorsSignificant,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDocumentsDraftsData &&
          $driftBlobEquality.equals(other.content, this.content) &&
          other.authors == this.authors &&
          other.collaborators == this.collaborators &&
          other.contentType == this.contentType &&
          other.id == this.id &&
          other.parameters == this.parameters &&
          other.refId == this.refId &&
          other.refVer == this.refVer &&
          other.replyId == this.replyId &&
          other.replyVer == this.replyVer &&
          other.section == this.section &&
          other.templateId == this.templateId &&
          other.templateVer == this.templateVer &&
          other.type == this.type &&
          other.ver == this.ver &&
          other.authorsNames == this.authorsNames &&
          other.authorsSignificant == this.authorsSignificant &&
          other.createdAt == this.createdAt);
}

class LocalDocumentsDraftsCompanion
    extends UpdateCompanion<LocalDocumentsDraftsData> {
  final Value<i2.Uint8List> content;
  final Value<String> authors;
  final Value<String> collaborators;
  final Value<String> contentType;
  final Value<String> id;
  final Value<String> parameters;
  final Value<String?> refId;
  final Value<String?> refVer;
  final Value<String?> replyId;
  final Value<String?> replyVer;
  final Value<String?> section;
  final Value<String?> templateId;
  final Value<String?> templateVer;
  final Value<String> type;
  final Value<String> ver;
  final Value<String> authorsNames;
  final Value<String> authorsSignificant;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalDocumentsDraftsCompanion({
    this.content = const Value.absent(),
    this.authors = const Value.absent(),
    this.collaborators = const Value.absent(),
    this.contentType = const Value.absent(),
    this.id = const Value.absent(),
    this.parameters = const Value.absent(),
    this.refId = const Value.absent(),
    this.refVer = const Value.absent(),
    this.replyId = const Value.absent(),
    this.replyVer = const Value.absent(),
    this.section = const Value.absent(),
    this.templateId = const Value.absent(),
    this.templateVer = const Value.absent(),
    this.type = const Value.absent(),
    this.ver = const Value.absent(),
    this.authorsNames = const Value.absent(),
    this.authorsSignificant = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalDocumentsDraftsCompanion.insert({
    required i2.Uint8List content,
    required String authors,
    required String collaborators,
    required String contentType,
    required String id,
    required String parameters,
    this.refId = const Value.absent(),
    this.refVer = const Value.absent(),
    this.replyId = const Value.absent(),
    this.replyVer = const Value.absent(),
    this.section = const Value.absent(),
    this.templateId = const Value.absent(),
    this.templateVer = const Value.absent(),
    required String type,
    required String ver,
    required String authorsNames,
    required String authorsSignificant,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : content = Value(content),
       authors = Value(authors),
       collaborators = Value(collaborators),
       contentType = Value(contentType),
       id = Value(id),
       parameters = Value(parameters),
       type = Value(type),
       ver = Value(ver),
       authorsNames = Value(authorsNames),
       authorsSignificant = Value(authorsSignificant),
       createdAt = Value(createdAt);
  static Insertable<LocalDocumentsDraftsData> custom({
    Expression<i2.Uint8List>? content,
    Expression<String>? authors,
    Expression<String>? collaborators,
    Expression<String>? contentType,
    Expression<String>? id,
    Expression<String>? parameters,
    Expression<String>? refId,
    Expression<String>? refVer,
    Expression<String>? replyId,
    Expression<String>? replyVer,
    Expression<String>? section,
    Expression<String>? templateId,
    Expression<String>? templateVer,
    Expression<String>? type,
    Expression<String>? ver,
    Expression<String>? authorsNames,
    Expression<String>? authorsSignificant,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (content != null) 'content': content,
      if (authors != null) 'authors': authors,
      if (collaborators != null) 'collaborators': collaborators,
      if (contentType != null) 'content_type': contentType,
      if (id != null) 'id': id,
      if (parameters != null) 'parameters': parameters,
      if (refId != null) 'ref_id': refId,
      if (refVer != null) 'ref_ver': refVer,
      if (replyId != null) 'reply_id': replyId,
      if (replyVer != null) 'reply_ver': replyVer,
      if (section != null) 'section': section,
      if (templateId != null) 'template_id': templateId,
      if (templateVer != null) 'template_ver': templateVer,
      if (type != null) 'type': type,
      if (ver != null) 'ver': ver,
      if (authorsNames != null) 'authors_names': authorsNames,
      if (authorsSignificant != null) 'authors_significant': authorsSignificant,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalDocumentsDraftsCompanion copyWith({
    Value<i2.Uint8List>? content,
    Value<String>? authors,
    Value<String>? collaborators,
    Value<String>? contentType,
    Value<String>? id,
    Value<String>? parameters,
    Value<String?>? refId,
    Value<String?>? refVer,
    Value<String?>? replyId,
    Value<String?>? replyVer,
    Value<String?>? section,
    Value<String?>? templateId,
    Value<String?>? templateVer,
    Value<String>? type,
    Value<String>? ver,
    Value<String>? authorsNames,
    Value<String>? authorsSignificant,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalDocumentsDraftsCompanion(
      content: content ?? this.content,
      authors: authors ?? this.authors,
      collaborators: collaborators ?? this.collaborators,
      contentType: contentType ?? this.contentType,
      id: id ?? this.id,
      parameters: parameters ?? this.parameters,
      refId: refId ?? this.refId,
      refVer: refVer ?? this.refVer,
      replyId: replyId ?? this.replyId,
      replyVer: replyVer ?? this.replyVer,
      section: section ?? this.section,
      templateId: templateId ?? this.templateId,
      templateVer: templateVer ?? this.templateVer,
      type: type ?? this.type,
      ver: ver ?? this.ver,
      authorsNames: authorsNames ?? this.authorsNames,
      authorsSignificant: authorsSignificant ?? this.authorsSignificant,
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
    if (collaborators.present) {
      map['collaborators'] = Variable<String>(collaborators.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (parameters.present) {
      map['parameters'] = Variable<String>(parameters.value);
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
    if (authorsNames.present) {
      map['authors_names'] = Variable<String>(authorsNames.value);
    }
    if (authorsSignificant.present) {
      map['authors_significant'] = Variable<String>(authorsSignificant.value);
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
          ..write('collaborators: $collaborators, ')
          ..write('contentType: $contentType, ')
          ..write('id: $id, ')
          ..write('parameters: $parameters, ')
          ..write('refId: $refId, ')
          ..write('refVer: $refVer, ')
          ..write('replyId: $replyId, ')
          ..write('replyVer: $replyVer, ')
          ..write('section: $section, ')
          ..write('templateId: $templateId, ')
          ..write('templateVer: $templateVer, ')
          ..write('type: $type, ')
          ..write('ver: $ver, ')
          ..write('authorsNames: $authorsNames, ')
          ..write('authorsSignificant: $authorsSignificant, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV4 extends GeneratedDatabase {
  DatabaseAtV4(QueryExecutor e) : super(e);
  late final DocumentsV2 documentsV2 = DocumentsV2(this);
  late final DocumentAuthors documentAuthors = DocumentAuthors(this);
  late final DocumentArtifacts documentArtifacts = DocumentArtifacts(this);
  late final DocumentCollaborators documentCollaborators =
      DocumentCollaborators(this);
  late final DocumentParameters documentParameters = DocumentParameters(this);
  late final DocumentsLocalMetadata documentsLocalMetadata =
      DocumentsLocalMetadata(this);
  late final LocalDocumentsDrafts localDocumentsDrafts = LocalDocumentsDrafts(
    this,
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
  late final Index idxDocumentsV2TypeRefIdRefVer = Index(
    'idx_documents_v2_type_ref_id_ref_ver',
    'CREATE INDEX idx_documents_v2_type_ref_id_ref_ver ON documents_v2 (type, ref_id, ref_ver)',
  );
  late final Index idxDocumentsV2TypeCreatedAt = Index(
    'idx_documents_v2_type_created_at',
    'CREATE INDEX idx_documents_v2_type_created_at ON documents_v2 (type, created_at)',
  );
  late final Index idxDocumentsV2TypeTemplate = Index(
    'idx_documents_v2_type_template',
    'CREATE INDEX idx_documents_v2_type_template ON documents_v2 (type, template_id, template_ver)',
  );
  late final Index idxDocumentAuthorsComposite = Index(
    'idx_document_authors_composite',
    'CREATE INDEX idx_document_authors_composite ON document_authors (document_id, document_ver, account_significant_id)',
  );
  late final Index idxDocumentAuthorsIdentity = Index(
    'idx_document_authors_identity',
    'CREATE INDEX idx_document_authors_identity ON document_authors (account_significant_id)',
  );
  late final Index idxDocumentAuthorsUsername = Index(
    'idx_document_authors_username',
    'CREATE INDEX idx_document_authors_username ON document_authors (username)',
  );
  late final Index idxDocumentCollaboratorsComposite = Index(
    'idx_document_collaborators_composite',
    'CREATE INDEX idx_document_collaborators_composite ON document_collaborators (document_id, document_ver, account_significant_id)',
  );
  late final Index idxDocumentCollaboratorsIdentity = Index(
    'idx_document_collaborators_identity',
    'CREATE INDEX idx_document_collaborators_identity ON document_collaborators (account_significant_id)',
  );
  late final Index idxDocumentCollaboratorsUsername = Index(
    'idx_document_collaborators_username',
    'CREATE INDEX idx_document_collaborators_username ON document_collaborators (username)',
  );
  late final Index idxDocumentParametersComposite = Index(
    'idx_document_parameters_composite',
    'CREATE INDEX idx_document_parameters_composite ON document_parameters (document_id, document_ver, id, ver)',
  );
  late final Index idxLocalMetadataFavorite = Index(
    'idx_local_metadata_favorite',
    'CREATE INDEX idx_local_metadata_favorite ON documents_local_metadata (is_favorite)',
  );
  late final Index idxLocalDraftsTypeAuthors = Index(
    'idx_local_drafts_type_authors',
    'CREATE INDEX idx_local_drafts_type_authors ON local_documents_drafts (type, authors_significant)',
  );
  late final Index idxLocalDraftsTypeId = Index(
    'idx_local_drafts_type_id',
    'CREATE INDEX idx_local_drafts_type_id ON local_documents_drafts (type, id)',
  );
  late final Index idxLocalDraftsCreatedAt = Index(
    'idx_local_drafts_created_at',
    'CREATE INDEX idx_local_drafts_created_at ON local_documents_drafts (created_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    documentsV2,
    documentAuthors,
    documentArtifacts,
    documentCollaborators,
    documentParameters,
    documentsLocalMetadata,
    localDocumentsDrafts,
    idxDocumentsV2TypeId,
    idxDocumentsV2TypeIdVer,
    idxDocumentsV2TypeRefId,
    idxDocumentsV2TypeRefIdVer,
    idxDocumentsV2RefIdVer,
    idxDocumentsV2TypeIdCreatedAt,
    idxDocumentsV2TypeRefIdRefVer,
    idxDocumentsV2TypeCreatedAt,
    idxDocumentsV2TypeTemplate,
    idxDocumentAuthorsComposite,
    idxDocumentAuthorsIdentity,
    idxDocumentAuthorsUsername,
    idxDocumentCollaboratorsComposite,
    idxDocumentCollaboratorsIdentity,
    idxDocumentCollaboratorsUsername,
    idxDocumentParametersComposite,
    idxLocalMetadataFavorite,
    idxLocalDraftsTypeAuthors,
    idxLocalDraftsTypeId,
    idxLocalDraftsCreatedAt,
  ];
  @override
  int get schemaVersion => 4;
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}
