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
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

/// Exposes only public operation on proposals, and related tables.
/// This is a wrapper around [DocumentsDao] and [DraftsDao] to provide a single interface for proposals.
/// Since proposals are composed of multiple documents (template, action, comments, etc.) we need to
/// join multiple tables to get all the information about a proposal, which make sense to create this specialized dao.
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

  // TODO(dt-iohk): it seems that this method doesn't correctly filter by ProposalsFilterType.my
  // since it does not check for author, consider to use another type which doesn't have "my" case.

  // TODO(damian-molinski): filters is only used for campaign and type.
  @override
  Future<List<JoinedProposalEntity>> queryProposals({
    SignedDocumentRef? categoryRef,
    required ProposalsFilters filters,
  }) async {
    if (<Object?>[
      filters.author,
      filters.onlyAuthor,
      filters.category,
      filters.searchQuery,
      filters.maxAge,
    ].nonNulls.isNotEmpty) {
      if (kDebugMode) {
        print('queryProposals supports only campaign and type filters');
      }
    }

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

    final mainQuery =
        select(proposal).join([
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
              proposal.metadata.jsonExtract(r'$.template').isNotNull(),
              Expression.or([
                proposal.metadata.jsonExtract(r'$.categoryId').isNotNull(),
                proposal.metadata.jsonExtract(r'$.parameters').isNotNull(),
              ]),
              if (filters.campaign != null)
                proposal.metadata.isInCategoryList(filters.campaign!.categoriesIds),
            ]),
          )
          ..orderBy([OrderingTerm.asc(proposal.verHi)]);

    if (categoryRef != null) {
      mainQuery.where(proposal.metadata.isCategory(categoryRef));
    }

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

    final proposals = await mainQuery
        .map((row) => row.readTable(proposal))
        .get()
        .then((entities) => entities.map(_buildJoinedProposal).toList().wait);

    return proposals;
  }

  @override
  Future<Page<JoinedProposalEntity>> queryProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
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

    final mainQuery =
        select(proposal).join([
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
              Expression.or([
                proposal.metadata.jsonExtract(r'$.categoryId').isNotNull(),
                proposal.metadata.jsonExtract(r'$.parameters').isNotNull(),
              ]),
              if (filters.campaign != null)
                proposal.metadata.isInCategoryList(filters.campaign!.categoriesIds),
            ]),
          )
          ..orderBy(order.terms(proposal))
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

    if ((filters.onlyAuthor ?? false) || filters.type.isMy) {
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
      mainQuery.where(proposal.search(searchQuery));
    }

    final maxAge = filters.maxAge;
    if (maxAge != null) {
      final now = DateTimeExt.now(utc: true);
      final oldestDateTime = now.subtract(maxAge);
      final uuid = UuidUtils.buildV7At(oldestDateTime);
      final hiLo = UuidHiLo.from(uuid);
      mainQuery.where(proposal.verHi.isBiggerThanValue(hiLo.high));
    }

    final proposals = await mainQuery
        .map((row) => row.readTable(proposal))
        .get()
        .then((entities) => entities.map(_buildJoinedProposal).wait);

    final total = await watchCount(
      filters: filters.toCountFilters(),
    ).first.then((count) => count.ofType(filters.type));

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

  @override
  Stream<Page<JoinedProposalEntity>> watchProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
  }) async* {
    yield await queryProposalsPage(request: request, filters: filters, order: order);

    yield* connection.streamQueries
        .updatesForSync(TableUpdateQuery.onAllTables([documents, documentsFavorites]))
        .debounceTime(const Duration(milliseconds: 10))
        .asyncMap((event) {
          return queryProposalsPage(request: request, filters: filters, order: order);
        });
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

    final latestAction = await _getProposalsLatestAction(
      proposalId: proposalRef.id,
    ).then((value) => value.singleOrNull);

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
      versionsFuture,
    ).wait;

    return JoinedProposalEntity(
      proposal: effectiveProposal,
      template: template,
      action: action,
      commentsCount: commentsCount,
      versions: versions,
    );
  }

  Future<_IdsFilter> _excludeHiddenProposalsFilter() {
    return _getProposalsLatestAction()
        .then((value) {
          return value
              .where((e) => e.action.isHidden)
              .map((e) => e.proposalRef.id)
              .map(UuidHiLo.from);
        })
        .then(_IdsFilter.exclude);
  }

  Future<_IdsFilter> _excludeNotDraftProposalsFilter() {
    return _getProposalsLatestAction()
        .then(
          (value) {
            return value
                .where((element) => !element.action.isDraft)
                .map((e) => e.proposalRef.id)
                .map(UuidHiLo.from);
          },
        )
        .then(_IdsFilter.exclude);
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
        return _excludeHiddenProposalsFilter();
      case ProposalsFilterType.drafts:
        return _excludeNotDraftProposalsFilter();
      case ProposalsFilterType.finals:
        return _includeFinalProposalsFilter();
      case ProposalsFilterType.favorites:
        return _includeFavoriteRefsExcludingHiddenProposalsFilter();
      case ProposalsFilterType.favoritesFinals:
        return _includeFinalFavoriteRefsProposalsFilter();
      case ProposalsFilterType.my:
        return _excludeHiddenProposalsFilter();
      case ProposalsFilterType.myFinals:
        return _includeFinalProposalsFilter();
      case ProposalsFilterType.voted:
        return _includeVotedRefsExcludingHiddenProposalsFilter();
    }
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
          if (ver != null) documents.metadata.jsonExtract<String>(r'$.ref.version').equals(ver),
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

          return _ProposalActions(
            selfRef: selfRef,
            proposalRef: proposalRef,
            action: action ?? ProposalSubmissionAction.draft,
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
          Expression.or([
            documents.metadata.jsonExtract(r'$.categoryId').isNotNull(),
            documents.metadata.jsonExtract(r'$.parameters').isNotNull(),
          ]),
          if (filters?.campaign != null)
            documents.metadata.isInCategoryList(filters!.campaign!.categoriesIds),
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
      query.where(documents.search(searchQuery));
    }

    final maxAge = filters?.maxAge;
    if (maxAge != null) {
      final now = DateTimeExt.now(utc: true);
      final oldestDateTime = now.subtract(maxAge);
      final uuid = UuidUtils.buildV7At(oldestDateTime);
      final hiLo = UuidHiLo.from(uuid);
      query.where(documents.verHi.isBiggerThanValue(hiLo.high));
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

  Future<List<SignedDocumentRef>> _getVotedRefs() async {
    // TODO(dt-iohk): query refs of voted proposals
    return [];
  }

  Future<_IdsFilter> _includeFavoriteRefsExcludingHiddenProposalsFilter() {
    return _getFavoritesRefs()
        .then((favoriteRefs) {
          return _getProposalsLatestAction().then((actions) async {
            final hiddenProposalsIds = actions
                .where((e) => e.action.isHidden)
                .map((e) => e.proposalRef.id);

            return favoriteRefs
                .map((e) => e.id)
                .whereNot(hiddenProposalsIds.contains)
                .map(UuidHiLo.from);
          });
        })
        .then(_IdsFilter.include);
  }

  Future<_IdsFilter> _includeFinalFavoriteRefsProposalsFilter() {
    return _getFavoritesRefs()
        .then((favoriteRefs) {
          return _getProposalsLatestAction().then((actions) async {
            final finalProposalIds = actions
                .where((e) => e.action.isFinal)
                .map((e) => e.proposalRef.id);

            return favoriteRefs
                .map((e) => e.id)
                .where(finalProposalIds.contains)
                .map(UuidHiLo.from);
          });
        })
        .then(_IdsFilter.include);
  }

  Future<_IdsFilter> _includeFinalProposalsFilter() {
    return _getProposalsLatestAction()
        .then(
          (value) {
            return value
                .where((element) => element.action.isFinal)
                .map((e) => e.proposalRef.id)
                .map(UuidHiLo.from);
          },
        )
        .then(_IdsFilter.include);
  }

  Future<_IdsFilter> _includeVotedRefsExcludingHiddenProposalsFilter() {
    return _getVotedRefs()
        .then((votedRefs) {
          return _getProposalsLatestAction().then((actions) async {
            final hiddenProposalsIds = actions
                .where((e) => e.action.isHidden)
                .map((e) => e.proposalRef.id);

            return votedRefs
                .map((e) => e.id)
                .whereNot(hiddenProposalsIds.contains)
                .map(UuidHiLo.from);
          });
        })
        .then(_IdsFilter.include);
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
      return Future.value();
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
  }) {
    return source.asyncMap((allRefs) async {
      final latestActions = await _getProposalsLatestAction();
      final hiddenRefs = latestActions
          .where((element) => element.action.isHidden)
          .map((e) => e.proposalRef);
      final finalsRefs = latestActions
          .where((element) => element.action.isFinal)
          .map((e) => e.proposalRef);

      final favoritesRefs = await _getFavoritesRefs();
      final votedRefs = await _getVotedRefs();
      final myRefs = await _maybeGetAuthorProposalsLooseRefs(author: author);

      final notHidden = allRefs.where((ref) => hiddenRefs.none((myRef) => myRef.id == ref.id));

      final total = notHidden;
      final finals = notHidden.where((ref) => finalsRefs.any((myRef) => myRef.id == ref.id));
      final favorites = notHidden.where((ref) => favoritesRefs.any((fav) => fav.id == ref.id));
      final favoritesFinals = finals.where((ref) => favoritesRefs.any((fav) => fav.id == ref.id));
      final my = notHidden.where((ref) => myRefs.any((myRef) => myRef.id == ref.id));
      final myFinals = my.where((ref) => finalsRefs.any((myRef) => myRef.id == ref.id));
      final votedOn = notHidden.where((ref) => votedRefs.any((voted) => voted.id == ref.id));

      return ProposalsCount(
        total: total.length,
        drafts: total.length - finals.length,
        finals: finals.length,
        favorites: favorites.length,
        favoritesFinals: favoritesFinals.length,
        my: my.length,
        myFinals: myFinals.length,
        voted: votedOn.length,
      );
    });
  }
}

abstract interface class ProposalsDao {
  Future<List<JoinedProposalEntity>> queryProposals({
    SignedDocumentRef? categoryRef,
    required ProposalsFilters filters,
  });

  Future<Page<JoinedProposalEntity>> queryProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
  });

  Stream<ProposalsCount> watchCount({
    required ProposalsCountFilters filters,
  });

  Stream<Page<JoinedProposalEntity>> watchProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
    required ProposalsOrder order,
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
  bool get isDraft => this == ProposalSubmissionAction.draft;

  bool get isFinal => this == ProposalSubmissionAction.aFinal;

  bool get isHidden => this == ProposalSubmissionAction.hide;
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

extension on ProposalsOrder {
  List<OrderingTerm> terms($DocumentsTable table) {
    return switch (this) {
      Alphabetical() => [
        OrderingTerm.asc(table.content.title.collate(Collate.noCase), nulls: NullsOrder.last),
        OrderingTerm.desc(table.verHi),
      ],
      Budget(:final isAscending) => [
        OrderingTerm(
          expression: table.content.requestedFunds,
          mode: isAscending ? OrderingMode.asc : OrderingMode.desc,
          nulls: NullsOrder.last,
        ),
        OrderingTerm.desc(table.verHi),
      ],
      UpdateDate(:final isAscending) => [
        OrderingTerm(
          expression: table.verHi,
          mode: isAscending ? OrderingMode.asc : OrderingMode.desc,
        ),
      ],
    };
  }
}
