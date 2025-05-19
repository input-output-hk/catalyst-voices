import 'dart:math' as math;

import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// https://github.com/input-output-hk/catalyst-libs/blob/main/docs/src/architecture/08_concepts/signed_doc/types.md#document-base-types
enum DocumentBaseType {
  action(uuid: _Constants.action, priority: 900),
  brand(uuid: _Constants.brand),
  campaign(uuid: _Constants.campaign),
  category(uuid: _Constants.category),
  comment(uuid: _Constants.comment),
  decision(uuid: _Constants.decision),
  moderationAction(uuid: _Constants.moderationAction),
  proposal(uuid: _Constants.proposal),
  submissionAction(uuid: _Constants.submissionAction),
  template(uuid: _Constants.template, priority: 1000);

  /// Constant uuid value to this base type.
  final String uuid;

  /// Can be used to order documents synchronisation.
  ///
  /// The bigger then more important.
  final int priority;

  const DocumentBaseType({
    required this.uuid,
    this.priority = 0,
  });
}

/// :)
final class DocumentType extends Equatable {
  // Helper function. Eventually may be removed.
  static const proposalDocument = DocumentType(_Constants.proposalDocument);
  static const proposalTemplate = DocumentType(_Constants.proposalTemplate);
  static const commentDocument = DocumentType(_Constants.commentDocument);
  static const commentTemplate = DocumentType(_Constants.commentTemplate);
  static const categoryParametersDocument = DocumentType(_Constants.categoryParametersDocument);
  static const campaignParametersDocument = DocumentType(_Constants.campaignParametersDocument);
  static const brandParametersDocument = DocumentType(_Constants.brandParametersDocument);
  static const proposalActionDocument = DocumentType(_Constants.proposalActionDocument);

  /// UUIDs
  final List<String> value;

  ///
  const DocumentType(List<String> value) : this._(value);

  const DocumentType.empty() : this(const []);

  factory DocumentType.fromJson(dynamic json) {
    if (json is String) {
      return DocumentType(json.split(','));
    }

    if (json is List<dynamic>) {
      return DocumentType(json.whereType<String>().toList());
    }

    throw ArgumentError.value(json, 'json', 'not supported type for DocumentType');
  }

  /// 1.25
  const DocumentType._(this.value);

  /// Returns found [DocumentBaseType] in [value].
  List<DocumentBaseType> get baseTypes {
    final overrideBaseTypes = _def?._overrideBaseTypes;
    if (overrideBaseTypes != null) {
      return overrideBaseTypes;
    }
    return DocumentBaseType.values.where((baseType) => value.contains(baseType.uuid)).toList();
  }

  bool get isCategory => _def == _DocumentTypeDef.categoryParametersDocument;

  /// Calculates priority based on found [DocumentBaseType] in [value].
  int get priority {
    return baseTypes.fold(
      0,
      (previousValue, element) => math.max(previousValue, element.priority),
    );
  }

  @override
  List<Object?> get props => [value];

  DocumentType? get template {
    final def = _def;
    final templateDef = def?.template;
    if (templateDef == null) {
      print('$def not not template');
      return null;
    }

    print('$def -> template $templateDef');
    return DocumentType(templateDef.value);
  }

  _DocumentTypeDef? get _def {
    return _DocumentTypeDef.values.firstWhereOrNull((def) => listEquals(def.value, value));
  }

  String toJson() => value.join(',');

  @override
  String toString() {
    return '${_def?.name.capitalize() ?? 'Unknown'}(${toJson()})';
  }
}

// TODO(damian-molinski): At the moment we have const uuids for concrete DocumentType's as single
// value but later we'll use only base types and resolve DocumentType against those
abstract final class _Constants {
  // Document Base Types
  // https://github.com/input-output-hk/catalyst-libs/blob/main/docs/src/architecture/08_concepts/signed_doc/types.md#document-base-types
  static const action = '5e60e623-ad02-4a1b-a1ac-406db978ee48';
  static const brand = 'ebcabeeb-5bc5-4f95-91e8-cab8ca724172';
  static const campaign = '5ef32d5d-f240-462c-a7a4-ba4af221fa23';
  static const category = '818938c3-3139-4daa-afe6-974c78488e95';
  static const comment = 'b679ded3-0e7c-41ba-89f8-da62a17898ea';
  static const decision = '788ff4c6-d65a-451f-bb33-575fe056b411';
  static const moderationAction = 'a5d232b8-5e03-4117-9afd-be32b878fcdd';
  static const proposal = '7808d2ba-d511-40af-84e8-c0d1625fdfdc';
  static const submissionAction = '78927329-cfd9-4ea1-9c71-0e019b126a65';
  static const template = '0ce8ab38-9258-4fbc-a62e-7faa6e58318f';

  // Document Types
  // https://github.com/input-output-hk/catalyst-libs/blob/main/docs/src/architecture/08_concepts/signed_doc/types.md#document-types
  static const proposalDocument = ['7808d2ba-d511-40af-84e8-c0d1625fdfdc'];
  static const proposalTemplate = ['0ce8ab38-9258-4fbc-a62e-7faa6e58318f'];
  static const commentDocument = ['b679ded3-0e7c-41ba-89f8-da62a17898ea'];
  static const commentTemplate = ['0b8424d4-ebfd-46e3-9577-1775a69d290c'];
  static const reviewDocument = ['e4caf5f0-098b-45fd-94f3-0702a4573db5'];
  static const reviewTemplate = ['ebe5d0bf-5d86-4577-af4d-008fddbe2edc'];
  static const categoryParametersDocument = ['48c20109-362a-4d32-9bba-e0a9cf8b45be'];
  static const categoryParametersTemplate = ['65b1e8b0-51f1-46a5-9970-72cdf26884be'];
  static const campaignParametersDocument = ['0110ea96-a555-47ce-8408-36efe6ed6f7c'];
  static const campaignParametersTemplate = ['7e8f5fa2-44ce-49c8-bfd5-02af42c179a3'];
  static const brandParametersDocument = ['3e4808cc-c86e-467b-9702-d60baa9d1fca'];
  static const brandParametersTemplate = ['fd3c1735-80b1-4eea-8d63-5f436d97ea31'];
  static const proposalActionDocument = ['5e60e623-ad02-4a1b-a1ac-406db978ee48'];

  const _Constants._();
}

enum _DocumentTypeDef {
  proposalDocument(_Constants.proposalDocument),
  proposalTemplate(_Constants.proposalTemplate, overrideBaseTypes: [DocumentBaseType.template]),
  commentDocument(_Constants.commentDocument),
  commentTemplate(_Constants.commentTemplate, overrideBaseTypes: [DocumentBaseType.template]),
  reviewDocument(_Constants.reviewDocument),
  reviewTemplate(_Constants.reviewTemplate, overrideBaseTypes: [DocumentBaseType.template]),
  categoryParametersDocument(_Constants.categoryParametersDocument),
  categoryParametersTemplate(
    _Constants.categoryParametersTemplate,
    overrideBaseTypes: [DocumentBaseType.template],
  ),
  campaignParametersDocument(_Constants.campaignParametersDocument),
  campaignParametersTemplate(
    _Constants.campaignParametersTemplate,
    overrideBaseTypes: [DocumentBaseType.template],
  ),
  brandParametersDocument(_Constants.brandParametersDocument),
  brandParametersTemplate(
    _Constants.brandParametersTemplate,
    overrideBaseTypes: [DocumentBaseType.template],
  ),
  proposalActionDocument(
    _Constants.proposalActionDocument,
    overrideBaseTypes: [DocumentBaseType.action],
  );

  final List<String> value;

  // TODO(damian-molinski): remove it after values migration to BaseTypes
  final List<DocumentBaseType>? _overrideBaseTypes;

  const _DocumentTypeDef(
    this.value, {
    List<DocumentBaseType>? overrideBaseTypes,
  }) : _overrideBaseTypes = overrideBaseTypes;

  _DocumentTypeDef? get template {
    return switch (this) {
      _DocumentTypeDef.proposalDocument ||
      _DocumentTypeDef.proposalTemplate =>
        _DocumentTypeDef.proposalTemplate,
      _DocumentTypeDef.commentDocument ||
      _DocumentTypeDef.commentTemplate =>
        _DocumentTypeDef.commentTemplate,
      _DocumentTypeDef.reviewDocument ||
      _DocumentTypeDef.reviewTemplate =>
        _DocumentTypeDef.reviewTemplate,
      _DocumentTypeDef.categoryParametersDocument ||
      _DocumentTypeDef.categoryParametersTemplate =>
        _DocumentTypeDef.categoryParametersTemplate,
      _DocumentTypeDef.campaignParametersDocument ||
      _DocumentTypeDef.campaignParametersTemplate =>
        _DocumentTypeDef.campaignParametersTemplate,
      _DocumentTypeDef.brandParametersDocument ||
      _DocumentTypeDef.brandParametersTemplate =>
        _DocumentTypeDef.brandParametersTemplate,
      _DocumentTypeDef.proposalActionDocument => null,
    };
  }
}
