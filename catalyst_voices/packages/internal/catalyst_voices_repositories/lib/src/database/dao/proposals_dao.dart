import 'dart:async';

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
import 'package:equatable/equatable.dart';

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
    final author = filters.author;
    final searchQuery = filters.searchQuery;

    final latestProposalRef = alias(documents, 'latestProposalRef');
    final proposal = alias(documents, 'proposal');

    final maxVerHi = latestProposalRef.verHi.max();
    final latestProposalsQuery = selectOnly(latestProposalRef, distinct: true)
      ..addColumns([
        latestProposalRef.idHi,
        latestProposalRef.idLo,
        maxVerHi,
        latestProposalRef.verLo,
      ])
      ..where(latestProposalRef.type.equalsValue(DocumentType.proposalDocument))
      ..groupBy([latestProposalRef.idHi + latestProposalRef.idLo]);

    final verSubquery = Subquery(latestProposalsQuery, 'latestProposalRef');

    final mainQuery = select(proposal).join([
      innerJoin(
        verSubquery,
        Expression.and([
          verSubquery.ref(maxVerHi).equalsExp(proposal.verHi),
          verSubquery.ref(latestProposalRef.verLo).equalsExp(proposal.verLo),
        ]),
        useColumns: false,
      ),
    ])
      ..where(
        Expression.and([
          proposal.type.equalsValue(DocumentType.proposalDocument),
          // Safe check for invalid proposals
          proposal.metadata.jsonExtract(r'$.template').isNotNull(),
          proposal.metadata.jsonExtract(r'$.categoryId').isNotNull(),
        ]),
      )
      ..orderBy([OrderingTerm.asc(proposal.verHi)])
      ..limit(request.size, offset: request.page * request.size);

    final ids = await _getFilterTypeIds(filters.type);

    final include = ids.include;
    if (include != null) {
      final highs = include.map((e) => e.high);
      final lows = include.map((e) => e.low);
      mainQuery.where(
        Expression.and([
          proposal.idHi.isIn(highs),
          proposal.idLo.isIn(lows),
        ]),
      );
    }

    final exclude = ids.exclude;
    if (exclude != null) {
      final highs = exclude.map((e) => e.high);
      final lows = exclude.map((e) => e.low);

      mainQuery.where(
        Expression.and([
          proposal.idHi.isNotIn(highs),
          proposal.idLo.isNotIn(lows),
        ]),
      );
    }

    if ((filters.onlyAuthor ?? false) ||
        filters.type == ProposalsFilterType.my) {
      if (author != null) {
        mainQuery.where(proposal.metadata.isAuthor(author));
      } else {
        return Page(
          page: request.page,
          maxPerPage: request.size,
          total: 0,
          items: List.empty(),
        );
      }
    }

    if (filters.category != null) {
      mainQuery.where(proposal.metadata.isCategory(filters.category!));
    }

    if (searchQuery != null) {
      // TODO(damian-molinski): Check if documentsMetadata can be used.
      mainQuery.where(proposal.content.hasTitle(searchQuery));
    }

    final proposals = await mainQuery
        .map((row) => row.readTable(proposal))
        .get()
        .then((entities) => entities.map(_buildJoinedProposal).toList().wait);

    final total = await watchCount(filters: filters.toCountFilters())
        .first
        .then((count) => count.ofType(filters.type));

    return Page(
      page: request.page,
      maxPerPage: request.size,
      total: total,
      items: proposals,
    );
  }

  @override
  Stream<ProposalsCount> watchCount({
    required ProposalsCountFilters filters,
  }) {
    final stream = _getProposalsRefsStream(filters: filters);

    return _transformRefsStreamToCount(stream, author: filters.author);
  }

  // TODO(damian-molinski): Make this more specialized per case.
  // for example proposals list does not need all versions, just count.
  Future<JoinedProposalEntity> _buildJoinedProposal(
    DocumentEntity proposal,
  ) async {
    assert(
      proposal.type == DocumentType.proposalDocument,
      'Invalid document type',
    );

    var proposalRef = proposal.metadata.selfRef;

    final latestAction =
        await _getProposalsLatestAction(proposalId: proposalRef.id)
            .then((value) => value.singleOrNull);

    var effectiveProposal = proposal;

    if (latestAction != null && latestAction.proposalRef != proposalRef) {
      final latestActionProposal = await _getDocument(latestAction.proposalRef);

      effectiveProposal = latestActionProposal;
    }

    proposalRef = effectiveProposal.metadata.selfRef;

    final templateFuture = _getDocument(effectiveProposal.metadata.template!);
    final actionFuture = _maybeGetDocument(latestAction?.selfRef);
    final commentsCountFuture = _getProposalCommentsCount(proposalRef);
    final versionsFuture = _getProposalVersions(proposalRef.id);

    final (template, action, commentsCount, versions) = await (
      templateFuture,
      actionFuture,
      commentsCountFuture,
      versionsFuture
    ).wait;

    return JoinedProposalEntity(
      proposal: effectiveProposal,
      template: template,
      action: action,
      commentsCount: commentsCount,
      versions: versions,
    );
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

  Future<DocumentEntity> _getDocument(DocumentRef ref) async {
    final document = await _maybeGetDocument(ref);
    assert(document != null, 'Did not found document with ref[$ref]');
    return document!;
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

  Future<_IdsFilter> _getFilterTypeIds(ProposalsFilterType type) {
    switch (type) {
      case ProposalsFilterType.total:
        return _getProposalsLatestAction().then(
          (value) {
            return value
                .where((element) => element.action.isHidden)
                .map((e) => e.proposalRef.id)
                .map(UuidHiLo.from);
          },
        ).then(_IdsFilter.exclude);
      case ProposalsFilterType.drafts:
        return _getProposalsLatestAction().then(
          (value) {
            return value
                .where((element) => element.action.isNotDraft)
                .map((e) => e.proposalRef.id)
                .map(UuidHiLo.from);
          },
        ).then(_IdsFilter.exclude);
      case ProposalsFilterType.finals:
        return _getProposalsLatestAction().then(
          (value) {
            return value
                .where((element) => element.action.isFinal)
                .map((e) => e.proposalRef.id)
                .map(UuidHiLo.from);
          },
        ).then(_IdsFilter.include);
      case ProposalsFilterType.favorites:
        return _getFavoritesRefs()
            .then((value) => value.map((e) => e.id).map(UuidHiLo.from))
            .then(_IdsFilter.include);
      case ProposalsFilterType.my:
        return Future.value(const _IdsFilter());
    }
  }

  Future<List<SignedDocumentRef>> _getFinalProposalsRefs() {
    return _getProposalsLatestAction().then(
      (value) => value
          .where((element) => element.action.isFinal)
          .map((e) => e.proposalRef)
          .toList(),
    );
  }

  Future<int> _getProposalCommentsCount(DocumentRef ref) {
    final id = ref.id;
    final ver = ref.version;

    final amountOfComment = documents.rowId.count();

    final query = selectOnly(documents)
      ..addColumns([
        amountOfComment,
      ])
      ..where(
        Expression.and([
          documents.type.equalsValue(DocumentType.commentDocument),
          documents.metadata.jsonExtract<String>(r'$.ref.id').equals(id),
          if (ver != null)
            documents.metadata
                .jsonExtract<String>(r'$.ref.version')
                .equals(ver),
        ]),
      )
      ..orderBy([OrderingTerm.desc(documents.verHi)]);

    return query
        .map((row) => row.read(amountOfComment))
        .getSingleOrNull()
        .then((value) => value ?? 0);
  }

  Future<List<_ProposalActions>> _getProposalsLatestAction({
    String? proposalId,
  }) {
    final refId = documents.metadata.jsonExtract<String>(r'$.ref.id');
    final refVer = documents.metadata.jsonExtract<String>(r'$.ref.version');
    final query = selectOnly(documents, distinct: true)
      ..addColumns([
        documents.idHi,
        documents.idLo,
        documents.verHi,
        documents.verLo,
        refId,
        refVer,
        documents.content,
      ])
      ..where(
        Expression.and([
          documents.type.equalsValue(DocumentType.proposalActionDocument),
          refId.isNotNull(),
          if (proposalId != null) refId.equals(proposalId),
        ]),
      )
      ..orderBy([OrderingTerm.desc(documents.verHi)]);

    return query
        .map((row) {
          final selfRef = row.readSelfRef(documents);
          final proposalRef = SignedDocumentRef(
            id: row.read(refId)!,
            version: row.read(refVer),
          );

          final content = row.readWithConverter(documents.content);
          final rawAction = content?.data['action'];
          final actionDto = rawAction is String
              ? ProposalSubmissionActionDto.fromJson(rawAction)
              : null;
          final action = actionDto?.toModel();

          if (action == null) {
            return null;
          }

          return _ProposalActions(
            selfRef: selfRef,
            proposalRef: proposalRef,
            action: action,
          );
        })
        .get()
        .then((entities) {
          final grouped = <String, _ProposalActions>{};

          for (final entry in entities.nonNulls) {
            // 1st element per ref is latest. See orderBy.
            final id = entry.proposalRef.id;
            if (!grouped.containsKey(id)) {
              grouped[id] = entry;
            }
          }

          return grouped.values.toList();
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
      ..where(
        Expression.and([
          documents.type.equalsValue(DocumentType.proposalDocument),
          // Safe check for invalid proposals
          documents.metadata.jsonExtract(r'$.template').isNotNull(),
          documents.metadata.jsonExtract(r'$.categoryId').isNotNull(),
        ]),
      )
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

  Future<List<String>> _getProposalVersions(String id) {
    final idHiLo = UuidHiLo.from(id);

    final query = selectOnly(documents)
      ..addColumns([
        documents.verHi,
        documents.verLo,
      ])
      ..where(
        Expression.and([
          documents.idHi.equals(idHiLo.high),
          documents.idLo.equals(idHiLo.low),
        ]),
      )
      ..orderBy([OrderingTerm.desc(documents.verHi)]);

    return query.map((row) {
      final high = row.read(documents.verHi)!;
      final low = row.read(documents.verLo)!;
      return UuidHiLo(high: high, low: low).uuid;
    }).get();
  }

  Future<List<SignedDocumentRef>> _maybeGetAuthorProposalsLooseRefs({
    CatalystId? author,
  }) {
    if (author == null) {
      return Future(List.empty);
    }

    return _getAuthorProposalsLooseRefs(author: author);
  }

  Future<DocumentEntity?> _maybeGetDocument(DocumentRef? ref) {
    if (ref == null) {
      return Future.value(null);
    }

    final id = UuidHiLo.from(ref.id);
    final ver = UuidHiLo.fromNullable(ref.version);

    final query = select(documents)
      ..where(
        (tbl) => Expression.and([
          tbl.idHi.equals(id.high),
          tbl.idLo.equals(id.low),
          if (ver != null) ...[
            tbl.verHi.equals(ver.high),
            tbl.verLo.equals(ver.low),
          ],
        ]),
      )
      ..limit(1);

    return query.getSingleOrNull();
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

final class _IdsFilter extends Equatable {
  final Iterable<UuidHiLo>? include;
  final Iterable<UuidHiLo>? exclude;

  // ignore: unused_element_parameter
  const _IdsFilter({this.include, this.exclude});

  const _IdsFilter.exclude(this.exclude) : include = null;

  const _IdsFilter.include(this.include) : exclude = null;

  @override
  List<Object?> get props => [include, exclude];
}

final class _ProposalActions extends Equatable {
  final SignedDocumentRef selfRef;
  final SignedDocumentRef proposalRef;
  final ProposalSubmissionAction action;

  const _ProposalActions({
    required this.selfRef,
    required this.proposalRef,
    required this.action,
  });

  @override
  List<Object?> get props => [selfRef, proposalRef, action];
}

extension on ProposalSubmissionAction {
  bool get isFinal => this == ProposalSubmissionAction.aFinal;

  bool get isHidden => this == ProposalSubmissionAction.hide;

  bool get isNotDraft => isFinal || isHidden;
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
