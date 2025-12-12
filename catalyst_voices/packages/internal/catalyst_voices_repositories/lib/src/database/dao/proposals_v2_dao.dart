import 'dart:math' as math;

import 'package:catalyst_voices_models/catalyst_voices_models.dart' hide DocumentParameters;
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/model/raw_proposal_brief_entity.dart';
import 'package:catalyst_voices_repositories/src/database/model/signed_document_or_local_draft.dart';
import 'package:catalyst_voices_repositories/src/database/table/converter/document_converters.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_authors.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_authors.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_collaborators.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_parameters.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';

/// Data Access Object for Proposal-specific queries.
///
/// This DAO handles complex retrieval logic for proposals, specifically focusing
/// on resolving the effective state of a proposal based on its associated
/// 'Action' documents (Draft, Final, Hide).
///
/// **Status Resolution Logic:**
///
/// The state of a proposal is determined by the *latest* `proposalActionDocument`
/// that references it (`ref_id`):
///
/// 1.  **Draft (Default):**
///     - No action document exists.
///     - OR the latest action content is 'draft'.
///     - **Result:** The query returns the *latest* version of the proposal
///       (determined by `createdAt`/`ver`).
///
/// 2.  **Final:**
///     - The latest action content is 'final'.
///     - **Result:** The query returns the specific version of the proposal
///       pointed to by the action's `ref_ver`. If `ref_ver` is missing,
///       it falls back to the latest version.
///
/// 3.  **Hidden:**
///     - The latest action content is 'hide'.
///     - **Result:** The proposal (and all its versions) is excluded entirely
///       from the results.
///
/// **Performance Architecture:**
///
/// - **CTE (Common Table Expressions):** Uses a multi-stage CTE pipeline
///   (`latest_proposals` -> `valid_actions` -> `action_status` -> `effective_proposals`)
///   to filter and resolve versions *before* joining full document content.
///   This prevents N+1 query issues and minimizes scanning of BLOB columns.
/// - **Indices:** optimized to hit `idx_documents_v2_type_id`,
///   `idx_documents_v2_type_ref_id`, and `idx_document_authors_composite`.
@DriftAccessor(
  tables: [
    DocumentsV2,
    DocumentAuthors,
    DocumentParameters,
    LocalDocumentsDrafts,
    DocumentCollaborators,
    DocumentsLocalMetadata,
  ],
)
class DriftProposalsV2Dao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftProposalsV2DaoMixin
    implements ProposalsV2Dao {
  DriftProposalsV2Dao(super.attachedDatabase);

  @override
  Future<Map<String, RawProposalCollaboratorsActions>> getCollaboratorsActions({
    required List<DocumentRef> proposalsRefs,
  }) async {
    if (proposalsRefs.isEmpty) return {};

    final idToRef = Map.fromEntries(proposalsRefs.map((e) => MapEntry(e.id, e)));

    final action = alias(documentsV2, 'action');
    final author = alias(documentAuthors, 'author');
    final collaborator = alias(documentCollaborators, 'collab');

    final query =
        select(action).join([
            // 1. Identify the signer of the Action
            innerJoin(
              author,
              Expression.and([
                author.documentId.equalsExp(action.id),
                author.documentVer.equalsExp(action.ver),
              ]),
            ),
            // 2. FILTER: Only if that signer is a collaborator on the PROPOSAL
            // We join on:
            // - collab.documentId == action.refId (The Proposal ID)
            // - collab.accountSignificantId == author.accountSignificantId (The Signer)
            innerJoin(
              collaborator,
              Expression.and([
                collaborator.documentId.equalsExp(action.refId),
                collaborator.documentVer.equalsExp(action.refVer),
                collaborator.accountSignificantId.equalsExp(author.accountSignificantId),
              ]),
            ),
          ])
          ..where(action.type.equalsValue(DocumentType.proposalActionDocument))
          ..where(action.refId.isIn(idToRef.keys))
          // Sort DESC so the first one we see is the latest
          ..orderBy([OrderingTerm.desc(action.createdAt)]);

    return query.get().then((rows) => _processCollaboratorsActions(rows, action, author, idToRef));
  }

  @override
  Future<List<RawProposalBriefEntity>> getLocalDraftsProposalsBrief({
    required CatalystId author,
  }) {
    return _queryLocalDraftsProposalsBrief(author: author).get();
  }

  @override
  Future<DocumentEntityV2?> getProposal(DocumentRef ref) async {
    final query = select(documentsV2)
      ..where((tbl) => tbl.id.equals(ref.id) & tbl.type.equals(DocumentType.proposalDocument.uuid));

    if (ref.isExact) {
      query.where((tbl) => tbl.ver.equals(ref.ver!));
    } else {
      query
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
        ..limit(1);
    }

    return query.getSingleOrNull();
  }

  /// Retrieves a paginated list of proposals with resolved status and enriched data.
  ///
  /// This is the primary method for displaying proposal lists (e.g., Grids/Lists).
  ///
  /// **Query Pipeline:**
  /// 1. **CTE Resolution:** Identifies the "Effective Proposal" (ID + Version)
  ///    based on the latest valid action signed by the author.
  /// 2. **Filtering:** Applies [filters] (search, category, author, favorites)
  ///    to the effective set.
  /// 3. **Pagination:** Applies limit/offset logic.
  /// 4. **Enrichment:** Joins templates, authors, and counts comments via subqueries.
  @override
  Future<Page<RawProposalBriefEntity>> getProposalsBriefPage({
    required PageRequest request,
    ProposalsOrder order = const UpdateDate.desc(),
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) async {
    final effectivePage = math.max(request.page, 0);
    final effectiveSize = request.size.clamp(0, 999);

    final shouldReturn = _shouldReturnEarlyFor(filters: filters, size: effectiveSize);
    if (shouldReturn) {
      return Page.empty(page: effectivePage, maxPerPage: effectiveSize);
    }

    final items = await _queryVisibleProposalsPage(
      effectivePage,
      effectiveSize,
      order: order,
      filters: filters,
    ).get();
    final total = await _countVisibleProposals(filters: filters).getSingle();

    return Page(
      items: items,
      total: total,
      page: effectivePage,
      maxPerPage: effectiveSize,
    );
  }

  /// Calculates the total funds requested ("Total Ask") for **Final** proposals.
  ///
  /// Aggregates data grouped by the proposal's template.
  ///
  /// **Rules:**
  /// - Only includes proposals with a 'Final' action status.
  /// - Uses the specific version pinned by the final action.
  /// - Extracts the fund amount from the JSON content using the provided [nodeId].
  @override
  Future<ProposalsTotalAsk> getProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  }) async {
    if (_totalAskShouldReturnEarlyFor(filters: filters)) {
      return const ProposalsTotalAsk({});
    }

    return _queryProposalsTotalTask(
      filters: filters,
      nodeId: nodeId,
    ).get().then(Map.fromEntries).then(ProposalsTotalAsk.new);
  }

  /// Counts the total number of visible proposals matching the [filters].
  ///
  /// **Consistency:**
  /// This method uses the exact same CTE and filtering logic as [getProposalsBriefPage]
  /// to ensure the count matches the items returned in the paginated list.
  ///
  /// **Optimization:**
  /// It counts `DISTINCT id` from the `effective_proposals` CTE, avoiding the overhead
  /// of joining the full `documents_v2` content blob or sub-querying comments.
  @override
  Future<int> getVisibleProposalsCount({
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) {
    final shouldReturn = _shouldReturnEarlyFor(filters: filters);
    if (shouldReturn) {
      return Future.value(0);
    }

    return _countVisibleProposals(filters: filters).getSingle();
  }

  @override
  Future<void> updateProposalFavorite({
    required String id,
    required bool isFavorite,
  }) async {
    await transaction(
      () async {
        if (!isFavorite) {
          await (delete(documentsLocalMetadata)..where((tbl) => tbl.id.equals(id))).go();
          return;
        }

        final entity = DocumentLocalMetadataEntity(id: id, isFavorite: isFavorite);

        await into(documentsLocalMetadata).insert(entity);
      },
    );
  }

  @override
  Stream<List<RawProposalBriefEntity>> watchLocalDraftsProposalsBrief({
    required CatalystId author,
  }) {
    return _queryLocalDraftsProposalsBrief(author: author).watch();
  }

  /// Reactive stream version of [getProposalsBriefPage].
  ///
  /// Emits a new [Page] whenever:
  /// - Proposal documents change.
  /// - Action documents (Draft/Final) change.
  /// - Local metadata (Favorites) changes.
  /// - Authors change.
  @override
  Stream<Page<RawProposalBriefEntity>> watchProposalsBriefPage({
    required PageRequest request,
    ProposalsOrder order = const UpdateDate.desc(),
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) {
    final effectivePage = math.max(request.page, 0);
    final effectiveSize = request.size.clamp(0, 999);

    final shouldReturn = _shouldReturnEarlyFor(filters: filters, size: effectiveSize);
    if (shouldReturn) {
      return Stream.value(Page.empty(page: effectivePage, maxPerPage: effectiveSize));
    }

    final itemsStream = _queryVisibleProposalsPage(
      effectivePage,
      effectiveSize,
      order: order,
      filters: filters,
    ).watch();
    final totalStream = _countVisibleProposals(filters: filters).watchSingle();

    return Rx.combineLatest2<List<RawProposalBriefEntity>, int, Page<RawProposalBriefEntity>>(
      itemsStream,
      totalStream,
      (items, total) => Page(
        items: items,
        total: total,
        page: effectivePage,
        maxPerPage: effectiveSize,
      ),
    );
  }

  /// Reactive stream version of [getProposalsTotalTask].
  ///
  /// Updates automatically when proposals are finalized or their content changes.
  @override
  Stream<ProposalsTotalAsk> watchProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  }) {
    if (_totalAskShouldReturnEarlyFor(filters: filters)) {
      return Stream.value(const ProposalsTotalAsk({}));
    }

    return _queryProposalsTotalTask(
      nodeId: nodeId,
      filters: filters,
    ).watch().map(Map.fromEntries).map(ProposalsTotalAsk.new);
  }

  /// Reactive stream version of [getVisibleProposalsCount].
  @override
  Stream<int> watchVisibleProposalsCount({
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) {
    final shouldReturn = _shouldReturnEarlyFor(filters: filters);
    if (shouldReturn) {
      return Stream.value(0);
    }

    return _countVisibleProposals(filters: filters).watchSingle();
  }

  /// Translates high-level [ProposalsFiltersV2] into SQL WHERE clauses.
  ///
  /// Handles:
  /// - **Status:** Checks `action_type` from the CTE.
  /// - **Original Author:** Subquery against `document_authors` for the first version (id == ver).
  /// - **Category/Campaign:** Checks existence in `document_parameters`.
  /// - **Search:** `LIKE` query against authors, title, and applicant JSON fields.
  List<String> _buildFilterClauses(ProposalsFiltersV2 filters) {
    final clauses = <String>[];

    if (filters.status != null) {
      if (filters.status == ProposalStatusFilter.draft) {
        // NULL = no action = draft (default), or explicit 'draft' action
        clauses.add("(ep.action_type IS NULL OR ep.action_type = 'draft')");
      } else {
        // Final requires explicit 'final' action
        clauses.add("ep.action_type = 'final'");
      }
    }

    if (filters.isFavorite != null) {
      clauses.add(
        filters.isFavorite!
            ? 'dlm.is_favorite = 1'
            : '(dlm.is_favorite IS NULL OR dlm.is_favorite = 0)',
      );
    }

    if (filters.relationships.isNotEmpty) {
      final relationshipClauses = <String>[];

      for (final rel in filters.relationships) {
        // TODO(damian-molinski): implement clauses
      }

      if (relationshipClauses.isNotEmpty) {
        clauses.add('(${relationshipClauses.join(' OR ')})');
      }
    }

    if (filters.categoryId != null) {
      final escapedCategory = _escapeSqlString(filters.categoryId!);
      clauses.add('''
        EXISTS (
          SELECT 1 FROM document_parameters dp
          WHERE dp.document_id = p.id
            AND dp.document_ver = p.ver
            AND dp.id = '$escapedCategory'
        )
      ''');
    } else if (filters.campaign != null) {
      final escapedIds = filters.campaign!.categoriesIds
          .map((id) => "'${_escapeSqlString(id)}'")
          .join(', ');
      clauses.add('''
        EXISTS (
          SELECT 1 FROM document_parameters dp
          WHERE dp.document_id = p.id
            AND dp.document_ver = p.ver
            AND dp.id IN ($escapedIds)
        )
      ''');
    }

    if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
      final escapedQuery = _escapeForSqlLike(filters.searchQuery!);
      clauses.add(
        '''
        (
          EXISTS (
            SELECT 1 FROM document_authors da
            WHERE da.document_id = p.id 
              AND da.document_ver = p.ver
              AND da.username LIKE '%$escapedQuery%' ESCAPE '\\'
          ) OR
          json_extract(p.content, '\$.setup.proposer.applicant') LIKE '%$escapedQuery%' ESCAPE '\\' OR
          json_extract(p.content, '\$.setup.title.title') LIKE '%$escapedQuery%' ESCAPE '\\'
        )''',
      );
    }

    if (filters.latestUpdate != null) {
      final cutoffTime = DateTime.now().subtract(filters.latestUpdate!);
      final escapedTimestamp = _escapeSqlString(cutoffTime.toIso8601String());
      clauses.add("p.created_at >= '$escapedTimestamp'");
    }

    if (filters.ids != null) {
      final escapedIds = filters.ids!.map((id) => "'${_escapeSqlString(id)}'").join(', ');
      clauses.add('p.id IN ($escapedIds)');
    }

    return clauses;
  }

  List<String> _buildFilterTotalAskClauses(ProposalsTotalAskFilters filters) {
    final clauses = <String>[];

    if (filters.categoryId != null) {
      final escapedCategory = _escapeSqlString(filters.categoryId!);
      clauses.add('''
        EXISTS (
          SELECT 1 FROM document_parameters dp
          WHERE dp.document_id = p.id
            AND dp.document_ver = p.ver
            AND dp.id = '$escapedCategory'
        )
      ''');
    } else if (filters.campaign != null) {
      final escapedIds = filters.campaign!.categoriesIds
          .map((id) => "'${_escapeSqlString(id)}'")
          .join(', ');
      clauses.add('''
        EXISTS (
          SELECT 1 FROM document_parameters dp
          WHERE dp.document_id = p.id
            AND dp.document_ver = p.ver
            AND dp.id IN ($escapedIds)
        )
      ''');
    }

    return clauses;
  }

  /// Constructs the SQL ORDER BY clause.
  ///
  /// - [Alphabetical]: JSON extraction of title.
  /// - [Budget]: JSON extraction of requested funds (cast to INTEGER).
  /// - [UpdateDate]: Uses `ver` (which contains timestamp) for efficient sorting.
  String _buildOrderByClause(ProposalsOrder order) {
    return switch (order) {
      Alphabetical() =>
        "LOWER(NULLIF(json_extract(p.content, '\$.${ProposalDocument.titleNodeId.value}'), '')) ASC NULLS LAST",
      Budget(:final isAscending) =>
        isAscending
            ? "CAST(json_extract(p.content, '\$.${ProposalDocument.requestedFundsNodeId.value}') AS INTEGER) ASC NULLS LAST"
            : "CAST(json_extract(p.content, '\$.${ProposalDocument.requestedFundsNodeId.value}') AS INTEGER) DESC NULLS LAST",
      UpdateDate(:final isAscending) => isAscending ? 'p.ver ASC' : 'p.ver DESC',
    };
  }

  /// Aliases columns for joins (e.g., `p.id as p_id`) to avoid name collisions.
  String _buildPrefixedColumns(String tableAlias, String prefix) {
    return documentsV2.$columns
        .map((col) => '$tableAlias.${col.$name} as ${prefix}_${col.$name}')
        .join(', \n      ');
  }

  /// Internal query to count visible proposals.
  ///
  /// Uses the [_getEffectiveProposalsCTE] to determine the valid set of IDs,
  /// then performs a simple COUNT(DISTINCT id).
  Selectable<int> _countVisibleProposals({
    required ProposalsFiltersV2 filters,
  }) {
    final filterClauses = _buildFilterClauses(filters);
    final whereClause = filterClauses.isEmpty ? '' : 'AND ${filterClauses.join(' AND ')}';

    final effectiveProposals = _getEffectiveProposalsCTE();
    final cteQuery =
        '''
    WITH $effectiveProposals
    SELECT COUNT(DISTINCT ep.id) as total
    FROM effective_proposals ep
    INNER JOIN documents_v2 p ON ep.id = p.id AND ep.ver = p.ver
    LEFT JOIN documents_local_metadata dlm ON p.id = dlm.id
    LEFT JOIN document_authors da ON p.id = da.document_id AND p.ver = da.document_ver
    WHERE p.type = ? $whereClause
  '''
            .trim();

    final readsFromTables = <ResultSetImplementation<dynamic, dynamic>>{
      documentsV2,
      if (filters.isFavorite != null) documentsLocalMetadata,
      if (filters.categoryId != null || filters.campaign != null) documentParameters,
      if (filters.relationships.whereType<OriginalAuthor>().isNotEmpty ||
          (filters.searchQuery != null && filters.searchQuery!.isNotEmpty))
        documentAuthors,
    };

    return customSelect(
      cteQuery,
      variables: [
        Variable.withString(DocumentType.proposalDocument.uuid),
        Variable.withString(DocumentType.proposalActionDocument.uuid),
        Variable.withString(DocumentType.proposalDocument.uuid),
      ],
      readsFrom: readsFromTables,
    ).map((row) => row.readNullable<int>('total') ?? 0);
  }

  /// Escapes a string for use in a SQL `LIKE` clause with a custom escape character.
  ///
  /// This method prepares an input string to be safely used as a pattern in a
  /// 'LIKE' query. It escapes the standard SQL `LIKE` wildcards (`%` and `_`)
  /// and the chosen escape character (`\`) itself, preventing them from being
  /// interpreted as wildcards. It also escapes single quotes to prevent SQL
  /// injection.
  ///
  /// The `ESCAPE '\'` clause must be used in the SQL query where the output of
  /// this function is used.
  ///
  /// Escapes:
  /// - `\` is replaced with `\\`
  /// - `%` is replaced with `\%`
  /// - `_` is replaced with `\_`
  /// - `'` is replaced with `''`
  ///
  /// - [input]: The string to escape.
  ///
  /// Returns: The escaped string, safe for use in a `LIKE` clause.
  String _escapeForSqlLike(String input) {
    return input
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_')
        .replaceAll("'", "''");
  }

  /// Escapes single quotes in a string for safe use in an SQL query.
  ///
  /// Replaces each single quote (`'`) with two single quotes (`''`). This is the
  /// standard way to escape single quotes in SQL strings, preventing unterminated
  /// string literals and SQL injection.
  ///
  /// - [input]: The string to escape.
  ///
  /// Returns: The escaped string.
  String _escapeSqlString(String input) {
    return input.replaceAll("'", "''");
  }

  /// Returns the Common Table Expression (CTE) string defining "Effective Proposals".
  ///
  /// **CTE Stages:**
  /// 1. `latest_proposals`: Finds the newest `ver` for every proposal `id` by creation time.
  /// 2. `valid_actions`: Finds all action documents that are structurally valid
  ///    (have ref_id/ref_ver) AND are signed by the *original author* of the proposal.
  /// 3. `latest_actions_ver`: Finds the newest action `ver` for each proposal `ref_id`.
  /// 4. `action_status`: Joins valid actions to determine the latest `action_type`.
  /// 5. `effective_proposals`:
  ///    - Applies 'Final' logic (use specific `ref_ver`).
  ///    - Applies 'Draft' logic (use `latest_proposals.max_ver`).
  ///    - Applies 'Hide' logic (WHERE NOT EXISTS ... 'hide').
  String _getEffectiveProposalsCTE() {
    return '''
    latest_proposals AS (
      SELECT id, MAX(ver) as max_ver
      FROM documents_v2
      WHERE type = ?
      GROUP BY id
    ),
    ${_getValidActionsCTE()},
    latest_actions_ver AS (
      SELECT ref_id, MAX(ver) as max_action_ver
      FROM valid_actions
      GROUP BY ref_id
    ),
    action_status AS (
      SELECT 
        va.ref_id,
        va.ref_ver,
        COALESCE(json_extract(va.content, '\$.action'), 'draft') as action_type
      FROM valid_actions va
      INNER JOIN latest_actions_ver lav 
        ON va.ref_id = lav.ref_id 
        AND va.ver = lav.max_action_ver
    ),
    effective_proposals AS (
      SELECT 
        lp.id,
        CASE 
          WHEN ast.action_type = 'final' THEN ast.ref_ver
          ELSE lp.max_ver
        END as ver,
        ast.action_type
      FROM latest_proposals lp
      LEFT JOIN action_status ast ON lp.id = ast.ref_id
      WHERE NOT EXISTS (
        SELECT 1 FROM action_status hidden 
        WHERE hidden.ref_id = lp.id AND hidden.action_type = 'hide'
      )
    )
    '''
        .trim();
  }

  /// Returns the `valid_actions` CTE fragment for reuse across queries.
  String _getValidActionsCTE() {
    return '''
    valid_actions AS (
      SELECT 
        action.ver,
        action.ref_id, 
        action.ref_ver,
        action.content
      FROM documents_v2 action
      
      -- 1. GET ACTION SIGNER
      INNER JOIN document_authors action_author 
        ON action.id = action_author.document_id 
        AND action.ver = action_author.document_ver
        
      -- 2. GET ORIGINAL PROPOSAL AUTHOR (first version where id == ver)
      INNER JOIN document_authors original_author
        ON action.ref_id = original_author.document_id
        AND original_author.document_id = original_author.document_ver
      WHERE 
        action.type = ?
        AND action.ref_id IS NOT NULL 
        AND action.ref_ver IS NOT NULL
        -- 3. SECURITY CHECK: Only original author can submit actions
        AND action_author.account_significant_id = original_author.account_significant_id
    )
    '''
        .trim();
  }

  /// Processes a database row from [getCollaboratorsActions] query.
  Map<String, RawProposalCollaboratorsActions> _processCollaboratorsActions(
    List<TypedResult> rows,
    $DocumentsV2Table action,
    $DocumentAuthorsTable author,
    Map<String, DocumentRef> idToRef,
  ) {
    final tempMap = <String, Map<CatalystId, RawCollaboratorAction>>{};

    for (final row in rows) {
      final doc = row.readTable(action);
      final signer = row.readTable(author);

      final refId = doc.refId;
      if (refId == null) continue;

      final ref = SignedDocumentRef(id: refId, ver: doc.refVer);

      final proposalRef = idToRef[ref.id];
      // if proposalRef has specified ver we should only get action for that ver, not latest.
      if (proposalRef == null || !proposalRef.contains(ref)) continue;

      final proposalActions = tempMap.putIfAbsent(refId, () => {});
      final signerFullId = CatalystId.tryParse(signer.accountId);
      final signerId = CatalystId.tryParse(signer.accountSignificantId);

      // Since we ordered by createdAt DESC, if we already have an entry for
      // this signer, it is newer than the current row. We skip the current row.
      if (signerId == null || proposalActions.containsKey(signerId)) continue;

      try {
        final actionData = doc.content.data;
        final action = ProposalSubmissionActionDocumentDto.fromJson(actionData).action.toModel();

        final rawCollaboratorAction = RawCollaboratorAction(
          id: signerFullId ?? signerId,
          proposalId: ref,
          action: action,
        );

        proposalActions[signerId] = rawCollaboratorAction;
      } catch (_) {
        // Gracefully handle malformed JSON means there is no valid action
        proposalActions.remove(signerId);
      }
    }

    return tempMap.map((key, value) => MapEntry(key, RawProposalCollaboratorsActions(value)));
  }

  Selectable<RawProposalBriefEntity> _queryLocalDraftsProposalsBrief({
    required CatalystId author,
  }) {
    final template = alias(documentsV2, 't');

    final query =
        select(localDocumentsDrafts).join([
            leftOuterJoin(
              template,
              Expression.and([
                localDocumentsDrafts.templateId.equalsExp(template.id),
                localDocumentsDrafts.templateVer.equalsExp(template.ver),
                template.type.equalsValue(DocumentType.proposalTemplate),
              ]),
            ),
            leftOuterJoin(
              documentsLocalMetadata,
              documentsLocalMetadata.id.equalsExp(localDocumentsDrafts.id),
            ),
          ])
          ..where(localDocumentsDrafts.type.equalsValue(DocumentType.proposalDocument))
          // comparing exact list since local drafts do have one author
          ..where(localDocumentsDrafts.authorsSignificant.equalsValue([author.toSignificant()]))
          ..orderBy([OrderingTerm.desc(localDocumentsDrafts.createdAt)]);

    return query.map(
      (row) {
        final proposal = row.readTable(localDocumentsDrafts);
        final templateEntity = row.readTableOrNull(template);
        final isFavorite = row.read(documentsLocalMetadata.isFavorite) ?? false;

        return RawProposalBriefEntity(
          proposal: SignedDocumentOrLocalDraft.local(proposal),
          template: templateEntity != null
              ? SignedDocumentOrLocalDraft.signed(templateEntity)
              : null,
          // Local drafts do not have a submission action state
          actionType: null,
          // Local drafts effectively have one version (themselves)
          versionIds: [proposal.ver],
          // Local drafts are not public, so 0 comments
          commentsCount: 0,
          isFavorite: isFavorite,
          originalAuthors: proposal.authors,
        );
      },
    );
  }

  /// Internal query to calculate total ask.
  ///
  /// Similar to the main CTE but filters specifically for `effective_final_proposals`.
  Selectable<MapEntry<DocumentRef, ProposalsTotalAskPerTemplate>> _queryProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  }) {
    final filterClauses = _buildFilterTotalAskClauses(filters);
    final filterWhereClause = filterClauses.isEmpty ? '' : 'AND ${filterClauses.join(' AND ')}';

    final query =
        '''
    WITH ${_getValidActionsCTE()},
    latest_actions_ver AS (
      SELECT ref_id, MAX(ver) as max_action_ver
      FROM valid_actions
      GROUP BY ref_id
    ),
    action_status AS (
      SELECT 
        va.ref_id,
        va.ref_ver,
        COALESCE(json_extract(va.content, '\$.action'), 'draft') as action_type
      FROM valid_actions va
      INNER JOIN latest_actions_ver lav 
        ON va.ref_id = lav.ref_id 
        AND va.ver = lav.max_action_ver
    ),
    effective_final_proposals AS (
      SELECT 
        ast.ref_id as id,
        ast.ref_ver as ver
      FROM action_status ast
      WHERE ast.action_type = 'final' AND ast.ref_ver != ''
    )
    SELECT 
      p.template_id,
      p.template_ver,
      SUM(COALESCE(CAST(json_extract(p.content, '\$.${nodeId.value}') AS INTEGER), 0)) as total_ask,
      COUNT(*) as final_proposals_count
    FROM documents_v2 p
    INNER JOIN effective_final_proposals efp ON p.id = efp.id AND p.ver = efp.ver
    WHERE p.type = ?
      $filterWhereClause
      AND p.template_id IS NOT NULL
      AND p.template_ver IS NOT NULL
    GROUP BY p.template_id, p.template_ver
  ''';

    final readsFromTables = <ResultSetImplementation<dynamic, dynamic>>{
      documentsV2,
      if (filters.categoryId != null || filters.campaign != null) documentParameters,
    };

    return customSelect(
      query,
      variables: [
        Variable.withString(DocumentType.proposalActionDocument.uuid),
        Variable.withString(DocumentType.proposalDocument.uuid),
      ],
      readsFrom: readsFromTables,
    ).map((row) {
      final templateId = row.read<String>('template_id');
      final templateVer = row.read<String>('template_ver');
      final totalAsk = row.read<int>('total_ask');
      final finalProposalsCount = row.read<int>('final_proposals_count');

      final ref = SignedDocumentRef(id: templateId, ver: templateVer);
      final value = ProposalsTotalAskPerTemplate(
        totalAsk: totalAsk,
        finalProposalsCount: finalProposalsCount,
      );

      return MapEntry(ref, value);
    });
  }

  /// The main execution query for [getProposalsBriefPage].
  ///
  /// Joins the `effective_proposals` CTE with:
  /// - `documents_v2` (for content)
  /// - `documents_local_metadata` (for favorites)
  /// - `documents_v2` alias 't' (for template info)
  ///
  /// Also executes efficient subqueries in the SELECT clause for:
  /// - `version_ids_str`: Comma-separated list of all version UUIDs.
  /// - `comments_count`: Count of comments referencing this proposal.
  /// - `original_authors_str`: Authors of the FIRST version (id=ver).
  Selectable<RawProposalBriefEntity> _queryVisibleProposalsPage(
    int page,
    int size, {
    required ProposalsOrder order,
    required ProposalsFiltersV2 filters,
  }) {
    final proposalColumns = _buildPrefixedColumns('p', 'p');
    final templateColumns = _buildPrefixedColumns('t', 't');
    final orderByClause = _buildOrderByClause(order);
    final filterClauses = _buildFilterClauses(filters);
    final whereClause = filterClauses.isEmpty ? '' : 'AND ${filterClauses.join(' AND ')}';

    final effectiveProposals = _getEffectiveProposalsCTE();
    final cteQuery =
        '''
    WITH $effectiveProposals
    SELECT 
      $proposalColumns, 
      $templateColumns, 
      ep.action_type,
      
      (
        SELECT GROUP_CONCAT(v_list.ver, ',')
        FROM (
          SELECT ver 
          FROM documents_v2 v_sub 
          WHERE v_sub.id = p.id AND v_sub.type = ? 
          ORDER BY v_sub.ver ASC
        ) v_list
      ) as version_ids_str,
      
      (
        SELECT COUNT(*) 
        FROM documents_v2 c 
        WHERE c.ref_id = p.id AND c.ref_ver = p.ver AND c.type = ?
      ) as comments_count,
      
      origin.authors as origin_authors,
      COALESCE(dlm.is_favorite, 0) as is_favorite
    FROM documents_v2 p
    INNER JOIN effective_proposals ep ON p.id = ep.id AND p.ver = ep.ver
    LEFT JOIN documents_local_metadata dlm ON p.id = dlm.id
    LEFT JOIN documents_v2 origin ON p.id = origin.id AND origin.id = origin.ver AND origin.type = ?
    LEFT JOIN documents_v2 t ON p.template_id = t.id AND p.template_ver = t.ver AND t.type = ?
    WHERE p.type = ? $whereClause
    ORDER BY $orderByClause
    LIMIT ? OFFSET ?
  ''';

    final readsFromTables = <ResultSetImplementation<dynamic, dynamic>>{
      documentsV2,
      documentsLocalMetadata,
      documentAuthors,
      if (filters.categoryId != null || filters.campaign != null) documentParameters,
    };

    return customSelect(
      cteQuery,
      variables: [
        // CTE Variables
        Variable.withString(DocumentType.proposalDocument.uuid),
        Variable.withString(DocumentType.proposalActionDocument.uuid),
        // Subquery Variables
        Variable.withString(DocumentType.proposalDocument.uuid),
        Variable.withString(DocumentType.commentDocument.uuid),
        // Main Join Variables
        // origin join, template join, main WHERE
        Variable.withString(DocumentType.proposalDocument.uuid),
        Variable.withString(DocumentType.proposalTemplate.uuid),
        Variable.withString(DocumentType.proposalDocument.uuid),
        // Pagination
        Variable.withInt(size),
        Variable.withInt(page * size),
      ],
      readsFrom: readsFromTables,
    ).map((row) {
      final proposalData = {
        for (final col in documentsV2.$columns)
          col.$name: row.readNullableWithType(col.type, 'p_${col.$name}'),
      };
      final proposal = documentsV2.map(proposalData);

      final templateData = {
        for (final col in documentsV2.$columns)
          col.$name: row.readNullableWithType(col.type, 't_${col.$name}'),
      };

      final template = templateData['id'] != null ? documentsV2.map(templateData) : null;

      final actionTypeRaw = row.readNullable<String>('action_type') ?? '';
      final actionType = ProposalSubmissionActionDto.fromJson(actionTypeRaw)?.toModel();

      final versionIdsRaw = row.readNullable<String>('version_ids_str') ?? '';
      final versionIds = versionIdsRaw.split(',');

      final commentsCount = row.readNullable<int>('comments_count') ?? 0;
      final isFavorite = (row.readNullable<int>('is_favorite') ?? 0) == 1;

      final originalAuthorsRaw = row.readNullable<String>('origin_authors');
      final originalAuthors = DocumentConverters.catId.fromSql(originalAuthorsRaw ?? '');

      return RawProposalBriefEntity(
        proposal: SignedDocumentOrLocalDraft.signed(proposal),
        template: template != null ? SignedDocumentOrLocalDraft.signed(template) : null,
        actionType: actionType,
        versionIds: versionIds,
        commentsCount: commentsCount,
        isFavorite: isFavorite,
        originalAuthors: originalAuthors,
      );
    });
  }

  bool _shouldReturnEarlyFor({
    required ProposalsFiltersV2 filters,
    int? size,
  }) {
    if (size != null && size == 0) {
      return true;
    }

    final campaign = filters.campaign;
    if (campaign != null) {
      assert(
        campaign.categoriesIds.length <= 100,
        'Campaign filter with more than 100 categories may impact performance. '
        'Consider pagination or alternative filtering strategy.',
      );

      if (campaign.categoriesIds.isEmpty) {
        return true;
      }

      if (filters.categoryId != null && !campaign.categoriesIds.contains(filters.categoryId)) {
        return true;
      }
    }

    // TODO(damian-molinski): remove when voting is implemented.
    if (filters.voteBy != null) {
      return true;
    }

    return false;
  }

  bool _totalAskShouldReturnEarlyFor({
    required ProposalsTotalAskFilters filters,
  }) {
    final campaign = filters.campaign;
    if (campaign != null) {
      assert(
        campaign.categoriesIds.length <= 100,
        'Campaign filter with more than 100 categories may impact performance. '
        'Consider pagination or alternative filtering strategy.',
      );

      if (campaign.categoriesIds.isEmpty) {
        return true;
      }

      if (filters.categoryId != null && !campaign.categoriesIds.contains(filters.categoryId)) {
        return true;
      }
    }

    return false;
  }
}

/// Public interface for proposal queries.
///
/// Defines the contract for proposal data access with proper status handling.
///
/// **Status Semantics:**
/// - Draft: Proposal is work-in-progress, shows latest version
/// - Final: Proposal is submitted, shows specific or latest version
/// - Hide: Proposal is hidden from all views
abstract interface class ProposalsV2Dao {
  /// Retrieves the latest valid submission actions performed by collaborators for the specified
  /// proposals.
  ///
  /// This method resolves the current collaboration state by:
  /// 1.  **Discovery**: Identifying all [DocumentType.proposalActionDocument]s that reference
  ///     the IDs found in [proposalsRefs].
  /// 2.  **Validation**: Verifying that the signer of the action is explicitly listed as a
  ///     collaborator on the referenced proposal document.
  /// 3.  **Versioning**:
  ///     * If a [DocumentRef] is **exact** (specifies `ver`), only actions targeting that
  ///         specific version are returned.
  ///     * If a [DocumentRef] is **loose** (null `ver`), actions targeting *any* version
  ///         of the proposal ID are considered.
  /// 4.  **Resolution**: Returns only the most recent action (by creation time) for each
  ///     unique collaborator.
  ///
  /// Returns a [Map] where:
  /// * **Key**: The Proposal ID (`String`).
  /// * **Value**: A [RawProposalCollaboratorsActions] container holding the map of
  ///     collaborator IDs to their latest [RawCollaboratorAction].
  Future<Map<String, RawProposalCollaboratorsActions>> getCollaboratorsActions({
    required List<DocumentRef> proposalsRefs,
  });

  /// Simpler version of [getProposalsBriefPage] which returns all local
  /// drafts for given [author]. Locally there is only one version of each proposal
  /// so no need to take into consideration a lot of stuff from [getProposalsBriefPage].
  Future<List<RawProposalBriefEntity>> getLocalDraftsProposalsBrief({
    required CatalystId author,
  });

  /// Retrieves a single proposal by its reference.
  ///
  /// Filters by type == proposalDocument.
  ///
  /// **Parameters:**
  ///   - ref: Document reference with id (required) and version (optional)
  ///
  /// **Behavior:**
  ///   - If ref.isExact (has version): Returns specific version
  ///   - If ref.isLoose (no version): Returns latest version by createdAt
  ///   - Returns null if no matching proposal found
  ///
  /// **Note:** This method does NOT respect proposal actions (draft/final/hide).
  /// It returns the raw document data. Use getProposalsBriefPage for status-aware queries.
  ///
  /// **Returns:** [DocumentEntityV2] or null
  Future<DocumentEntityV2?> getProposal(DocumentRef ref);

  /// Retrieves a paginated page of proposal briefs with filtering and ordering.
  ///
  /// Filters by type == proposalDocument.
  /// Returns latest effective version per id, respecting proposal actions.
  ///
  /// **Status Handling:**
  ///   - Draft (default): Display latest version
  ///   - Final: Display specific version if ref_ver set, else latest
  ///   - Hide: Exclude all versions
  ///
  /// **Pagination:**
  ///   - request.page: 0-based page number
  ///   - request.size: Items per page (clamped to 999 max)
  ///
  /// **Performance:**
  ///   - Single query with CTEs (no N+1 queries)
  ///
  /// **Returns:** Page object with items, total count, and pagination metadata
  Future<Page<RawProposalBriefEntity>> getProposalsBriefPage({
    required PageRequest request,
    ProposalsOrder order,
    ProposalsFiltersV2 filters,
  });

  /// Calculates the total funds requested ("Total Ask") for **Final** proposals.
  ///
  /// Aggregates data grouped by the proposal's template.
  ///
  /// **Rules:**
  /// - Only includes proposals with a 'Final' action status.
  /// - Uses the specific version pinned by the final action.
  /// - Extracts the fund amount from the JSON content using the provided [nodeId].
  Future<ProposalsTotalAsk> getProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  });

  /// Counts the total number of visible proposals that match the given filters.
  ///
  /// This method respects the same status handling logic as [getProposalsBriefPage],
  /// ensuring the count is consistent with the total items that would be paginated.
  /// It is more efficient than fetching all pages to get a total count.
  ///
  /// **Parameters:**
  /// - [filters]: Optional filters to apply before counting.
  ///
  /// **Returns:** The total number of visible proposals.
  Future<int> getVisibleProposalsCount({
    ProposalsFiltersV2 filters,
  });

  /// Updates the favorite status of a proposal.
  ///
  /// Manages local metadata to mark proposals as favorites.
  /// Operates within a transaction for atomicity.
  ///
  /// **Parameters:**
  /// - [id]: The unique identifier of the proposal
  /// - [isFavorite]: Whether to mark as favorite (true) or unfavorite (false)
  ///
  /// **Behavior:**
  /// - If isFavorite is true: Inserts/updates record in documents_local_metadata
  /// - If isFavorite is false: Deletes record from documents_local_metadata
  Future<void> updateProposalFavorite({
    required String id,
    required bool isFavorite,
  });

  /// Reactive stream version of [getLocalDraftsProposalsBrief].
  ///
  /// Updates automatically when local drafts are changing.
  Stream<List<RawProposalBriefEntity>> watchLocalDraftsProposalsBrief({
    required CatalystId author,
  });

  /// Watches for changes and emits paginated pages of proposal briefs.
  ///
  /// Provides a reactive stream that emits a new [Page] whenever the
  /// underlying data changes in the database.
  ///
  /// **Reactivity:**
  /// - Emits new page when documents_v2 changes (proposals, actions)
  /// - Emits new page when documents_local_metadata changes (favorites)
  /// - Combines items and count streams for consistent pagination
  ///
  /// **Performance:**
  /// - Same query optimization as [getProposalsBriefPage]
  ///
  /// **Returns:** Stream of Page objects with current state
  Stream<Page<RawProposalBriefEntity>> watchProposalsBriefPage({
    required PageRequest request,
    ProposalsOrder order,
    ProposalsFiltersV2 filters,
  });

  /// Reactive stream version of [getProposalsTotalTask].
  ///
  /// Updates automatically when proposals are finalized or their content changes.
  Stream<ProposalsTotalAsk> watchProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  });

  /// Watches for changes and emits the total count of visible proposals.
  ///
  /// Provides a reactive stream that emits a new integer count whenever the
  /// underlying data changes in a way that affects the total number of
  /// visible proposals matching the filters.
  ///
  /// **Parameters:**
  /// - [filters]: Optional filters to apply before counting.
  ///
  /// **Reactivity:**
  /// - Emits new count when documents_v2 changes (proposals, actions)
  ///   that match the filter criteria.
  Stream<int> watchVisibleProposalsCount({
    ProposalsFiltersV2 filters,
  });
}
