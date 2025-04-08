import 'dart:convert' show utf8;

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_favorite.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';

typedef _ProposalsActions = Map<SignedDocumentRef, ProposalSubmissionAction>;
typedef _RefAction = (SignedDocumentRef ref, ProposalSubmissionAction action);

@DriftAccessor(
  tables: [
    Documents,
    DocumentsMetadata,
    DocumentsFavorites,
  ],
)
class DriftProposalsDao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftProposalsDaoMixin
    implements ProposalsDao {
  DriftProposalsDao(super.attachedDatabase);

  @override
  Future<Page<JoinedProposalEntity>> queryProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
  }) async {
    return Page(
      page: 0,
      maxPerPage: 0,
      total: 0,
      items: [],
    );
  }

  @override
  Stream<ProposalsCount> watchCount({
    required ProposalsCountFilters filters,
  }) async* {
    final author = filters.author;

    final proposalsCount = (documents.idHi + documents.idLo).count(
      distinct: true,
      filter: documents.type.equalsValue(DocumentType.proposalDocument),
    );

    final select = selectOnly(documents)
      ..addColumns([
        proposalsCount,
      ]);

    final stream = select
        .map((row) => row.read(proposalsCount))
        .watchSingleOrNull()
        .map((event) => event ?? 0);

    await for (final total in stream) {
      final finals = await _getFinalProposalsCount();
      final drafts = total - finals;
      final favorites = await _getFavoritesCount();
      final my = await (author != null
          ? _getAuthorProposalsCount(author: author)
          : Future.value(0));

      yield ProposalsCount(
        total: total,
        drafts: drafts,
        finals: finals,
        favorites: favorites,
        my: my,
      );
    }
  }

  Future<int> _getAuthorProposalsCount({required CatalystId author}) {
    final searchId = author.toSignificant().toUri().toStringWithoutScheme();

    final proposalsCount = (documents.idHi + documents.idLo).count(
      distinct: true,
      filter: Expression.and([
        documents.type.equalsValue(DocumentType.proposalDocument),
        CustomExpression<bool>(
          "json_extract(metadata, '\$.authors') LIKE '%$searchId%'",
        ),
      ]),
    );

    final select = selectOnly(documents)
      ..addColumns([
        proposalsCount,
      ]);

    return select
        .map((row) => row.read(proposalsCount))
        .getSingleOrNull()
        .then((value) => value ?? 0);
  }

  Future<int> _getFavoritesCount() {
    final joinedId = documentsFavorites.idHi + documentsFavorites.idLo;
    const docType = DocumentType.proposalDocument;

    final count = (joinedId).count(
      distinct: true,
      filter: Expression.and([
        documentsFavorites.type.equalsValue(docType),
        documentsFavorites.isFavorite.equals(true),
      ]),
    );

    final select = selectOnly(documentsFavorites)..addColumns([count]);

    return select
        .map((row) => row.read(count))
        .getSingleOrNull()
        .then((value) => value ?? 0);
  }

  Future<int> _getFinalProposalsCount() {
    return _getProposalsActions().then(
      (value) {
        return value.values
            .where((element) => element == ProposalSubmissionAction.aFinal)
            .length;
      },
    );
  }

  Future<_ProposalsActions> _getProposalsActions() {
    final refId = documents.metadata.jsonExtract<Uint8List>(r'$.ref.id');
    final refVer = documents.metadata.jsonExtract<Uint8List>(r'$.ref.version');
    final select = selectOnly(documents, distinct: true)
      ..addColumns([
        documents.verHi,
        refId,
        refVer,
        documents.content,
      ])
      ..where(documents.type.equalsValue(DocumentType.proposalActionDocument))
      ..orderBy([OrderingTerm.desc(documents.verHi)]);

    return select
        .map((row) {
          final id = utf8.decode(row.read(refId)!);
          final ver = utf8.decode(row.read(refId)!);
          final proposalRef = SignedDocumentRef(id: id, version: ver);

          final content = row.readWithConverter(documents.content);
          final rawAction = content?.data['action'];
          final actionDto = rawAction is String
              ? ProposalSubmissionActionDto.fromJson(rawAction)
              : null;
          final action = actionDto?.toModel();

          return MapEntry(proposalRef, action);
        })
        .get()
        .then((entities) {
          final grouped = <String, _RefAction>{};

          for (final entry
              in entities.where((element) => element.value != null)) {
            // 1st element per ref is latest. See orderBy.
            final id = entry.key.id;
            if (!grouped.containsKey(id)) {
              grouped[id] = (entry.key, entry.value!);
            }
          }

          return grouped.map((_, value) => MapEntry(value.$1, value.$2));
        });
  }
}

abstract interface class ProposalsDao {
  Future<Page<JoinedProposalEntity>> queryProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
  });

  Stream<ProposalsCount> watchCount({
    required ProposalsCountFilters filters,
  });
}
