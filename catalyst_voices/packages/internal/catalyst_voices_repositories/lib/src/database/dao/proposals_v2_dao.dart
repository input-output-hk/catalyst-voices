import 'dart:math' as math;

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/model/joined_proposal_brief_entity.dart';
import 'package:catalyst_voices_repositories/src/database/table/document_authors.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';

/// Data Access Object for Proposal-specific queries.
///
/// Handles complex queries for retrieving proposals with proper status handling
/// based on proposal actions (draft/final/hide).
///
/// **Status Resolution Logic:**
/// - Draft (default): No action exists, or latest action is 'draft'
/// - Final: Latest action is 'final' with optional ref_ver pointing to specific version
/// - Hide: Latest action is 'hide' - excludes all versions of the proposal
///
/// **Version Selection:**
/// - For draft: Returns latest version by createdAt
/// - For final: Returns version specified in action's ref_ver, or latest if ref_ver is null/empty
/// - For hide: Returns nothing (filtered out)
///
/// **Performance Characteristics:**
/// - Uses composite indices for efficient GROUP BY and JOIN operations
/// - Single-query CTE approach (no N+1 queries)
@DriftAccessor(
  tables: [
    DocumentsV2,
    DocumentAuthors,
    DocumentsLocalMetadata,
  ],
)
class DriftProposalsV2Dao extends DatabaseAccessor<DriftCatalystDatabase>
    with $DriftProposalsV2DaoMixin
    implements ProposalsV2Dao {
  DriftProposalsV2Dao(super.attachedDatabase);

  @override
  Future<DocumentEntityV2?> getProposal(DocumentRef ref) async {
    final query = select(documentsV2)
      ..where((tbl) => tbl.id.equals(ref.id) & tbl.type.equals(DocumentType.proposalDocument.uuid));

    if (ref.isExact) {
      query.where((tbl) => tbl.ver.equals(ref.version!));
    } else {
      query
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
        ..limit(1);
    }

    return query.getSingleOrNull();
  }

  /// Retrieves a paginated list of proposal briefs with filtering, ordering, and status handling.
  ///
  /// **Query Logic:**
  /// 1. Finds latest version of each proposal using MAX(ver) GROUP BY id
  /// 2. Finds latest action for each proposal using MAX(ver) GROUP BY ref_id
  /// 3. Determines effective version based on action type:
  ///    - Hide action: Excludes all versions of that proposal
  ///    - Final action with ref_ver: Uses specific version pointed to by action
  ///    - Final action without ref_ver OR Draft action OR no action: Uses latest version
  /// 4. Joins with templates, comments count, and favorite status
  /// 5. Applies all filters and ordering
  /// 6. Returns paginated results
  ///
  /// **Indices Used:**
  /// - idx_documents_v2_type_id: For latest_proposals CTE (GROUP BY optimization)
  /// - idx_documents_v2_type_ref_id: For latest_actions CTE (GROUP BY optimization)
  /// - idx_documents_v2_type_ref_id_ver: For action_status JOIN
  /// - idx_documents_v2_type_id_ver: For final document retrieval
  ///
  /// **Performance:**
  /// - Single query with CTEs (no N+1 queries)
  ///
  /// **Parameters:**
  /// - [request]: Pagination parameters (page number and size)
  /// - [order]: Sort order for results (default: UpdateDate.desc())
  /// - [filters]: Optional filters.
  ///
  /// **Returns:** Page object containing items, total count, and pagination metadata
  @override
  Future<Page<JoinedProposalBriefEntity>> getProposalsBriefPage({
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

  @override
  Future<Map<DocumentRef, ProposalTemplateTotalAsk>> getProposalTemplatesTotalTask({
    required CampaignFilters filters,
    required NodeId nodeId,
  }) async {
    if (filters.categoriesIds.isEmpty) {
      return {};
    }

    final entries = await _queryProposalTemplatesTotalTask(
      filters: filters,
      nodeId: nodeId,
    ).get();

    return Map.fromEntries(entries);
  }

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
  Stream<Page<JoinedProposalBriefEntity>> watchProposalsBriefPage({
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

    return Rx.combineLatest2<List<JoinedProposalBriefEntity>, int, Page<JoinedProposalBriefEntity>>(
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

  @override
  Stream<Map<DocumentRef, ProposalTemplateTotalAsk>> watchProposalTemplatesTotalTask({
    required CampaignFilters filters,
    required NodeId nodeId,
  }) {
    if (filters.categoriesIds.isEmpty) {
      return Stream.value({});
    }

    return _queryProposalTemplatesTotalTask(
      filters: filters,
      nodeId: nodeId,
    ).watch().map(Map.fromEntries);
  }

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

  /// Builds SQL WHERE clauses from the provided filters.
  ///
  /// Translates high-level filter objects into SQL conditions that can be
  /// injected into the main query.
  ///
  /// **Security:**
  /// - Uses _escapeForSqlLike for LIKE patterns
  /// - Uses _escapeSqlString for direct string comparisons
  /// - Protects against SQL injection through proper escaping
  ///
  /// **Returns:** List of SQL WHERE clause strings (without leading WHERE/AND)
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

    if (filters.author != null) {
      final significant = filters.author!.toSignificant();
      final escapedSignificant = _escapeSqlString(significant.toString());

      clauses.add('''
        EXISTS (
          SELECT 1 FROM document_authors da
          WHERE da.document_id = p.id 
            AND da.document_ver = p.ver
            AND da.author_id_significant = '$escapedSignificant'
        )
      ''');
    }

    if (filters.categoryId != null) {
      final escapedCategory = _escapeSqlString(filters.categoryId!);
      clauses.add("p.category_id = '$escapedCategory'");
    } else if (filters.campaign != null) {
      final escapedIds = filters.campaign!.categoriesIds
          .map((id) => "'${_escapeSqlString(id)}'")
          .join(', ');
      clauses.add('p.category_id IN ($escapedIds)');
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
              AND da.author_username LIKE '%$escapedQuery%' ESCAPE '\\'
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

  /// Builds the ORDER BY clause based on the provided ordering.
  ///
  /// Supports multiple ordering strategies:
  /// - UpdateDate: Sort by createdAt (newest first or oldest first)
  /// - Funds: Sort by requested funds amount extracted from JSON content
  ///
  /// **Returns:** SQL ORDER BY clause string (without leading "ORDER BY")
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

  /// Generates a SQL string of aliased column names for a given table.
  ///
  /// This is used in complex `JOIN` queries where two tables of the same type
  /// (e.g., `documents_v2` for proposals and `documents_v2` for templates) are
  /// joined. To avoid column name collisions in the result set, this function
  /// prefixes each column with a unique identifier.
  ///
  /// Example: `_buildPrefixedColumns('p', 'p')` might produce:
  /// `"p.id as p_id, p.ver as p_ver, ..."`
  ///
  /// - [tableAlias]: The alias used for the table in the SQL query (e.g., 'p').
  /// - [prefix]: The prefix to add to each column name in the `AS` clause (e.g., 'p').
  ///
  /// Returns: A comma-separated string of aliased column names.
  String _buildPrefixedColumns(String tableAlias, String prefix) {
    return documentsV2.$columns
        .map((col) => '$tableAlias.${col.$name} as ${prefix}_${col.$name}')
        .join(', \n      ');
  }

  /// Counts total number of visible (non-hidden) proposals matching the filters.
  ///
  /// Uses the same CTE logic as the main pagination query but stops after
  /// determining the effective proposals set. This ensures the count matches
  /// exactly what would be returned across all pages.
  ///
  /// **Query Strategy:**
  /// - Reuses CTE structure from main query up to effective_proposals
  /// - Applies same filter logic to ensure consistency
  /// - Counts DISTINCT proposal ids (not versions)
  /// - Faster than pagination query since no document joining needed
  ///
  /// **Returns:** Selectable<int> that can be used with getSingle() or watchSingle()
  Selectable<int> _countVisibleProposals({
    required ProposalsFiltersV2 filters,
  }) {
    final filterClauses = _buildFilterClauses(filters);
    final whereClause = filterClauses.isEmpty ? '' : 'AND ${filterClauses.join(' AND ')}';

    final cteQuery =
        '''
    WITH latest_proposals AS (
      SELECT id, MAX(ver) as max_ver
      FROM documents_v2
      WHERE type = ?
      GROUP BY id
    ),
    latest_actions AS (
      SELECT ref_id, MAX(ver) as max_action_ver
      FROM documents_v2
      WHERE type = ?
      GROUP BY ref_id
    ),
    action_status AS (
      SELECT 
        a.ref_id,
        a.ref_ver,
        COALESCE(json_extract(a.content, '\$.action'), 'draft') as action_type
      FROM documents_v2 a
      INNER JOIN latest_actions la ON a.ref_id = la.ref_id AND a.ver = la.max_action_ver
      WHERE a.type = ?
    ),
    effective_proposals AS (
      SELECT 
        lp.id,
        CASE 
          WHEN ast.action_type = 'final' AND ast.ref_ver IS NOT NULL AND ast.ref_ver != '' THEN ast.ref_ver
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
    SELECT COUNT(DISTINCT ep.id) as total
    FROM effective_proposals ep
    INNER JOIN documents_v2 p ON ep.id = p.id AND ep.ver = p.ver
    LEFT JOIN documents_local_metadata dlm ON p.id = dlm.id
    WHERE p.type = ? $whereClause
  ''';

    return customSelect(
      cteQuery,
      variables: [
        Variable.withString(DocumentType.proposalDocument.uuid),
        Variable.withString(DocumentType.proposalActionDocument.uuid),
        Variable.withString(DocumentType.proposalActionDocument.uuid),
        Variable.withString(DocumentType.proposalDocument.uuid),
      ],
      readsFrom: {
        documentsV2,
        if (filters.isFavorite != null) documentsLocalMetadata,
      },
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

  Selectable<MapEntry<DocumentRef, ProposalTemplateTotalAsk>> _queryProposalTemplatesTotalTask({
    required CampaignFilters filters,
    required NodeId nodeId,
  }) {
    final escapedCategories = filters.categoriesIds
        .map((id) => "'${_escapeSqlString(id)}'")
        .join(', ');

    final query =
        '''
    WITH latest_actions AS (
      SELECT ref_id, MAX(ver) as max_action_ver
      FROM documents_v2
      WHERE type = ?
      GROUP BY ref_id
    ),
    action_status AS (
      SELECT 
        a.ref_id,
        a.ref_ver,
        COALESCE(json_extract(a.content, '\$.action'), 'draft') as action_type
      FROM documents_v2 a
      INNER JOIN latest_actions la ON a.ref_id = la.ref_id AND a.ver = la.max_action_ver
      WHERE a.type = ?
    ),
    effective_final_proposals AS (
      SELECT 
        ast.ref_id as id,
        ast.ref_ver as ver
      FROM action_status ast
      WHERE ast.action_type = 'final'
        AND ast.ref_ver IS NOT NULL
        AND ast.ref_ver != ''
    )
    SELECT 
      p.template_id,
      p.template_ver,
      SUM(COALESCE(CAST(json_extract(p.content, '\$.${nodeId.value}') AS INTEGER), 0)) as total_ask,
      COUNT(*) as final_proposals_count
    FROM documents_v2 p
    INNER JOIN effective_final_proposals efp ON p.id = efp.id AND p.ver = efp.ver
    WHERE p.type = ?
      AND p.category_id IN ($escapedCategories)
      AND p.template_id IS NOT NULL
      AND p.template_ver IS NOT NULL
    GROUP BY p.template_id, p.template_ver
  ''';

    return customSelect(
      query,
      variables: [
        Variable.withString(DocumentType.proposalActionDocument.uuid),
        Variable.withString(DocumentType.proposalActionDocument.uuid),
        Variable.withString(DocumentType.proposalDocument.uuid),
      ],
      readsFrom: {documentsV2},
    ).map((row) {
      final templateId = row.read<String>('template_id');
      final templateVer = row.read<String>('template_ver');
      final totalAsk = row.read<int>('total_ask');
      final finalProposalsCount = row.read<int>('final_proposals_count');

      final ref = SignedDocumentRef(
        id: templateId,
        version: templateVer,
      );

      final value = ProposalTemplateTotalAsk(
        totalAsk: totalAsk,
        finalProposalsCount: finalProposalsCount,
      );

      return MapEntry(ref, value);
    });
  }

  /// Fetches a page of visible proposals using multi-stage CTE logic.
  ///
  /// **CTE Pipeline:**
  ///
  /// 1. **latest_proposals**
  ///    - Groups all proposals by id and finds MAX(ver)
  ///    - Identifies the newest version of each proposal
  ///    - Uses: idx_documents_v2_type_id
  ///
  /// 2. **version_lists**
  ///    - Collects all version ids for each proposal into comma-separated string
  ///    - Ordered by ver ASC for consistent version history
  ///    - Used to show version dropdown in UI
  ///
  /// 3. **latest_actions**
  ///    - Groups all proposal actions by ref_id and finds MAX(ver)
  ///    - Ensures we only check the most recent action per proposal
  ///    - Uses: idx_documents_v2_type_ref_id
  ///
  /// 4. **action_status**
  ///    - Joins actual action documents with latest_actions
  ///    - Extracts action type ('draft'/'final'/'hide') from JSON content
  ///    - Extracts ref_ver which may point to specific proposal version
  ///    - COALESCE defaults to 'draft' when action field is missing
  ///    - Uses: idx_documents_v2_type_ref_id_ver
  ///
  /// 5. **effective_proposals**
  ///    - Applies version resolution logic:
  ///      * Hide action: Filtered out by WHERE NOT EXISTS
  ///      * Final action with ref_ver: Uses ref_ver (specific pinned version)
  ///      * Final action without ref_ver OR draft OR no action: Uses max_ver (latest)
  ///    - LEFT JOIN ensures proposals without actions are included (default to draft)
  ///
  /// 6. **comments_count**
  ///    - Counts comments per proposal version
  ///    - Joins on both ref_id and ref_ver for version-specific counts
  ///
  /// **Final Query:**
  /// - Joins documents_v2 with effective_proposals to get full document data
  /// - LEFT JOINs with comments, favorites, and template for enrichment
  /// - Applies all user-specified filters
  /// - Orders and paginates results
  ///
  /// **Index Usage:**
  /// - idx_documents_v2_type_id: For GROUP BY in latest_proposals
  /// - idx_documents_v2_type_ref_id: For GROUP BY in latest_actions
  /// - idx_documents_v2_type_ref_id_ver: For action_status JOIN
  /// - idx_documents_v2_type_id_ver: For final document retrieval
  ///
  /// **Returns:** Selectable that can be used with .get() or .watch()
  Selectable<JoinedProposalBriefEntity> _queryVisibleProposalsPage(
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

    final cteQuery =
        '''
   WITH latest_proposals AS (
      SELECT id, MAX(ver) as max_ver
      FROM documents_v2
      WHERE type = ?
      GROUP BY id
    ),
    version_lists AS (
      SELECT 
        id,
        GROUP_CONCAT(ver, ',') as version_ids_str
      FROM (
        SELECT id, ver
        FROM documents_v2
        WHERE type = ?
        ORDER BY id, ver ASC
      )
      GROUP BY id
    ),
    latest_actions AS (
      SELECT ref_id, MAX(ver) as max_action_ver
      FROM documents_v2
      WHERE type = ?
      GROUP BY ref_id
    ),
    action_status AS (
      SELECT 
        a.ref_id,
        a.ref_ver,
        COALESCE(json_extract(a.content, '\$.action'), 'draft') as action_type
      FROM documents_v2 a
      INNER JOIN latest_actions la ON a.ref_id = la.ref_id AND a.ver = la.max_action_ver
      WHERE a.type = ?
    ),
    effective_proposals AS (
      SELECT 
        lp.id,
        CASE 
          WHEN ast.action_type = 'final' AND ast.ref_ver IS NOT NULL AND ast.ref_ver != '' THEN ast.ref_ver
          ELSE lp.max_ver
        END as ver,
        ast.action_type,
        vl.version_ids_str
      FROM latest_proposals lp
      LEFT JOIN action_status ast ON lp.id = ast.ref_id
      LEFT JOIN version_lists vl ON lp.id = vl.id
      WHERE NOT EXISTS (
        SELECT 1 FROM action_status hidden 
        WHERE hidden.ref_id = lp.id AND hidden.action_type = 'hide'
      )
    ),
    comments_count AS (
      SELECT 
        c.ref_id,
        c.ref_ver,
        COUNT(*) as count
      FROM documents_v2 c
      WHERE c.type = ?
      GROUP BY c.ref_id, c.ref_ver
    )
    SELECT 
      $proposalColumns, 
      $templateColumns, 
      ep.action_type, 
      ep.version_ids_str,
      COALESCE(cc.count, 0) as comments_count,
      COALESCE(dlm.is_favorite, 0) as is_favorite
    FROM documents_v2 p
    INNER JOIN effective_proposals ep ON p.id = ep.id AND p.ver = ep.ver
    LEFT JOIN comments_count cc ON p.id = cc.ref_id AND p.ver = cc.ref_ver
    LEFT JOIN documents_local_metadata dlm ON p.id = dlm.id
    LEFT JOIN documents_v2 t ON p.template_id = t.id AND p.template_ver = t.ver AND t.type = ?
    WHERE p.type = ? $whereClause
    ORDER BY $orderByClause
    LIMIT ? OFFSET ?
  ''';

    final readsFromTables = <ResultSetImplementation<dynamic, dynamic>>{
      documentsV2,
      documentsLocalMetadata,
    };

    if (filters.author != null ||
        (filters.searchQuery != null && filters.searchQuery!.isNotEmpty)) {
      readsFromTables.add(documentAuthors);
    }

    return customSelect(
      cteQuery,
      variables: [
        Variable.withString(DocumentType.proposalDocument.uuid),
        Variable.withString(DocumentType.proposalDocument.uuid),
        Variable.withString(DocumentType.proposalActionDocument.uuid),
        Variable.withString(DocumentType.proposalActionDocument.uuid),
        Variable.withString(DocumentType.commentDocument.uuid),
        Variable.withString(DocumentType.proposalTemplate.uuid),
        Variable.withString(DocumentType.proposalDocument.uuid),
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

      return JoinedProposalBriefEntity(
        proposal: proposal,
        template: template,
        actionType: actionType,
        versionIds: versionIds,
        commentsCount: commentsCount,
        isFavorite: isFavorite,
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
  Future<Page<JoinedProposalBriefEntity>> getProposalsBriefPage({
    required PageRequest request,
    ProposalsOrder order,
    ProposalsFiltersV2 filters,
  });

  Future<Map<DocumentRef, ProposalTemplateTotalAsk>> getProposalTemplatesTotalTask({
    required CampaignFilters filters,
    required NodeId nodeId,
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
  Stream<Page<JoinedProposalBriefEntity>> watchProposalsBriefPage({
    required PageRequest request,
    ProposalsOrder order,
    ProposalsFiltersV2 filters,
  });

  Stream<Map<DocumentRef, ProposalTemplateTotalAsk>> watchProposalTemplatesTotalTask({
    required CampaignFilters filters,
    required NodeId nodeId,
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
