import 'dart:convert' show utf8;

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/query/jsonb_expressions.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents.drift.dart'
    show $DocumentsTable;
import 'package:catalyst_voices_repositories/src/database/table/documents_favorite.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_metadata.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';

typedef _ProposalsActions = Map<SignedDocumentRef, ProposalSubmissionAction>;
typedef _RefAction = ({SignedDocumentRef ref, ProposalSubmissionAction action});

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
    return const Page(
      page: 0,
      maxPerPage: 0,
      total: 0,
      items: [],
    );
  }

  @override
  Stream<ProposalsCount> watchCount({
    required ProposalsCountFilters filters,
  }) {
    final stream = _getProposalsRefsStream(filters: filters);

    return _transformRefsStreamToCount(stream, author: filters.author);
  }

  Future<List<SignedDocumentRef>> _getAuthorProposalsLooseRefs({
    required CatalystId author,
  }) {
    final query = selectOnly(documents)
      ..addColumns([
        documents.idHi,
        documents.idLo,
      ])
      ..where(
        Expression.and([
          documents.type.equalsValue(DocumentType.proposalDocument),
          documents.metadata.isAuthor(author),
        ]),
      );

    return query.map((row) {
      final id = UuidHiLo(
        high: row.read(documents.idHi)!,
        low: row.read(documents.idLo)!,
      );

      return SignedDocumentRef.loose(id: id.uuid);
    }).get();
  }

  Future<List<SignedDocumentRef>> _getFavoritesRefs() {
    final query = selectOnly(documentsFavorites)
      ..addColumns([
        documentsFavorites.idHi,
        documentsFavorites.idLo,
      ])
      ..where(
        Expression.and([
          documentsFavorites.type.equalsValue(DocumentType.proposalDocument),
          documentsFavorites.isFavorite.equals(true),
        ]),
      );

    return query.map((row) {
      final id = UuidHiLo(
        high: row.read(documentsFavorites.idHi)!,
        low: row.read(documentsFavorites.idLo)!,
      );

      return SignedDocumentRef.loose(id: id.uuid);
    }).get();
  }

  Future<List<SignedDocumentRef>> _getFinalProposalsRefs() {
    return _getProposalsLatestAction().then(
      (value) => value.entries
          .where((element) => element.value.isFinal)
          .map((e) => e.key)
          .toList(),
    );
  }

  Future<_ProposalsActions> _getProposalsLatestAction() {
    final refId = documents.metadata.jsonExtract<Uint8List>(r'$.ref.id');
    final refVer = documents.metadata.jsonExtract<Uint8List>(r'$.ref.version');
    final query = selectOnly(documents, distinct: true)
      ..addColumns([
        documents.verHi,
        refId,
        refVer,
        documents.content,
      ])
      ..where(documents.type.equalsValue(DocumentType.proposalActionDocument))
      ..orderBy([OrderingTerm.desc(documents.verHi)]);

    return query
        .map((row) {
          final rawId = row.read(refId);
          final rawVer = row.read(refVer);

          final id = rawId != null ? utf8.decode(rawId) : null;
          final ver = rawVer != null ? utf8.decode(rawVer) : null;

          if (id == null) {
            return null;
          }

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
              in entities.nonNulls.where((element) => element.value != null)) {
            // 1st element per ref is latest. See orderBy.
            final id = entry.key.id;
            if (!grouped.containsKey(id)) {
              grouped[id] = (ref: entry.key, action: entry.value!);
            }
          }

          return grouped.map((_, value) => MapEntry(value.ref, value.action));
        });
  }

  Stream<List<SignedDocumentRef>> _getProposalsRefsStream({
    ProposalsCountFilters? filters,
  }) {
    final author = filters?.author;
    final searchQuery = filters?.searchQuery;

    final query = selectOnly(documents)
      ..addColumns([
        documents.idHi,
        documents.idLo,
        documents.verHi,
        documents.verLo,
      ])
      ..where(documents.type.equalsValue(DocumentType.proposalDocument))
      ..orderBy([OrderingTerm.desc(documents.verHi)])
      ..groupBy([documents.idHi + documents.idLo]);

    if ((filters?.onlyAuthor ?? false) && author != null) {
      query.where(documents.metadata.isAuthor(author));
    }

    if (filters?.category != null) {
      query.where(documents.metadata.isCategory(filters!.category!));
    }

    if (searchQuery != null) {
      // TODO(damian-molinski): Check if documentsMetadata can be used.
      query.where(documents.content.hasTitle(searchQuery));
    }

    return query.map((row) => row.readSelfRef(documents)).watch();
  }

  Future<List<SignedDocumentRef>> _maybeGetAuthorProposalsLooseRefs({
    CatalystId? author,
  }) {
    if (author == null) {
      return Future(List.empty);
    }

    return _getAuthorProposalsLooseRefs(author: author);
  }

  Stream<ProposalsCount> _transformRefsStreamToCount(
    Stream<List<SignedDocumentRef>> source, {
    CatalystId? author,
  }) async* {
    await for (final allRefs in source) {
      final finalsRefs = await _getFinalProposalsRefs();
      final favoritesRefs = await _getFavoritesRefs();
      final myRefs = await _maybeGetAuthorProposalsLooseRefs(author: author);

      final total = allRefs.length;
      final finals = allRefs.where(finalsRefs.contains).length;
      final drafts = total - finals;
      final favorites = allRefs
          .where((ref) => favoritesRefs.any((fav) => fav.id == ref.id))
          .length;
      final my = allRefs
          .where((ref) => myRefs.any((myRef) => myRef.id == ref.id))
          .length;

      yield ProposalsCount(
        total: total,
        drafts: drafts,
        finals: finals,
        favorites: favorites,
        my: my,
      );
    }
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

extension on ProposalSubmissionAction {
  bool get isFinal => this == ProposalSubmissionAction.aFinal;
}

extension on TypedResult {
  SignedDocumentRef readSelfRef($DocumentsTable table) {
    final idHiLo = (read(table.idHi)!, read(table.idLo)!);
    final verHiLo = (read(table.verHi)!, read(table.verLo)!);

    final id = UuidHiLo(high: idHiLo.$1, low: idHiLo.$2).uuid;
    final ver = UuidHiLo(high: verHiLo.$1, low: verHiLo.$2).uuid;

    return SignedDocumentRef(id: id, version: ver);
  }
}
