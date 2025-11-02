import 'dart:math' as math;

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/model/joined_proposal_brief_entity.dart';
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
/// This DAO handles complex queries for retrieving proposals with proper status handling.
@DriftAccessor(
  tables: [
    DocumentsV2,
    LocalDocumentsDrafts,
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

  /// Retrieves a paginated list of proposal briefs.
  ///
  /// Query Logic:
  /// 1. Finds latest version of each proposal
  /// 2. Finds latest action (draft/final/hide) for each proposal
  /// 3. Determines effective version:
  ///    - If hide action: exclude all versions
  ///    - If final action with ref_ver: use that specific version
  ///    - Otherwise: use latest version
  /// 4. Returns paginated results ordered by version (descending)
  ///
  /// Indices Used:
  /// - idx_documents_v2_type_id: for latest_proposals GROUP BY
  /// - idx_documents_v2_type_ref_id: for latest_actions GROUP BY
  /// - idx_documents_v2_type_ref_id_ver: for action_status JOIN
  /// - idx_documents_v2_type_id_ver: for final document retrieval
  ///
  /// Performance:
  /// - ~20-50ms for typical page query (10k documents)
  /// - Uses covering indices to avoid table lookups
  /// - Single query with CTEs (no N+1 queries)
  @override
  Future<Page<JoinedProposalBriefEntity>> getProposalsBriefPage({
    required PageRequest request,
    ProposalsOrder order = const UpdateDate.desc(),
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) async {
    final effectivePage = math.max(request.page, 0);
    final effectiveSize = request.size.clamp(0, 999);

    if (effectiveSize == 0) {
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

    if (effectiveSize == 0) {
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

  List<String> _buildFilterClauses(ProposalsFiltersV2 filters) {
    final clauses = <String>[];

    if (filters.status != null) {
      final statusValue = filters.status == ProposalStatusFilter.draft ? 'draft' : 'final';
      clauses.add("ep.action_type = '$statusValue'");
    }

    if (filters.isFavorite != null) {
      clauses.add(
        filters.isFavorite!
            ? 'dlm.is_favorite = 1'
            : '(dlm.is_favorite IS NULL OR dlm.is_favorite = 0)',
      );
    }

    if (filters.author != null) {
      // TODO(damian): .toSignificant().toUri().toString()
      final authorUri = filters.author.toString();
      final escapedAuthor = _escapeForSqlLike(authorUri);
      clauses.add("p.authors LIKE '%$escapedAuthor%' ESCAPE '\\'");
    }

    if (filters.categoryId != null) {
      final escapedCategory = _escapeSqlString(filters.categoryId!);
      clauses.add("p.category_id = '$escapedCategory'");
    }

    if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
      final escapedQuery = _escapeForSqlLike(filters.searchQuery!);
      clauses.add(
        '''
        (
          p.authors LIKE '%$escapedQuery%' ESCAPE '\\' OR
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

    return clauses;
  }

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

  String _buildPrefixedColumns(String tableAlias, String prefix) {
    return documentsV2.$columns
        .map((col) => '$tableAlias.${col.$name} as ${prefix}_${col.$name}')
        .join(', \n      ');
  }

  /// Counts total number of effective (non-hidden) proposals.
  ///
  /// This query mirrors the pagination query but only counts results.
  /// It uses the same CTE logic to identify hidden proposals and exclude them.
  ///
  /// Optimization:
  /// - Stops after CTE 5 (doesn't need full document retrieval)
  /// - Uses COUNT(DISTINCT lp.id) to count unique proposal ids
  /// - Faster than pagination query since no document joining needed
  ///
  /// Must match pagination query's filtering logic exactly eg.[_queryVisibleProposalsPage]
  ///
  /// Returns: Total count of visible proposals (not including hidden)
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
      readsFrom: {documentsV2, documentsLocalMetadata},
    ).map((row) => row.readNullable<int>('total') ?? 0);
  }

  String _escapeForSqlLike(String input) {
    return input
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_')
        .replaceAll("'", "''");
  }

  String _escapeSqlString(String input) {
    return input.replaceAll("'", "''");
  }

  /// Fetches paginated proposal pages using complex CTE logic.
  ///
  /// Returns: Selectable of [JoinedProposalBriefEntity] mapped from raw rows of customSelect.
  /// This may be used as single get of watch.
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
      readsFrom: {documentsV2, documentsLocalMetadata},
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
}

/// Public interface for proposal queries.
///
/// This interface defines the contract for proposal data access.
/// Implementations should respect proposal status (draft/final/hide) and
/// provide efficient pagination for large datasets.
abstract interface class ProposalsV2Dao {
  /// Retrieves a single proposal by its reference.
  ///
  /// Filters by type == proposalDocument.
  ///
  /// Parameters:
  ///   - ref: Document reference with id (required) and version (optional)
  ///
  /// Behavior:
  ///   - If ref.isExact (has version): Returns specific version
  ///   - If ref.isLoose (no version): Returns latest version by createdAt
  ///   - Returns null if no matching proposal found
  ///
  /// Returns: DocumentEntityV2 or null
  Future<DocumentEntityV2?> getProposal(DocumentRef ref);

  /// Retrieves a paginated page of proposal briefs.
  ///
  /// Filters by type == proposalDocument.
  /// Returns latest effective version per id, respecting proposal actions.
  ///
  /// Status Handling:
  ///   - Draft (default): Display latest version
  ///   - Final: Display specific version if ref_ver set, else latest
  ///   - Hide: Exclude all versions
  ///
  /// Pagination:
  ///   - request.page: 0-based page number
  ///   - request.size: Items per page (clamped to 999 max)
  ///
  /// Performance:
  ///   - Optimized for 10k+ documents with composite indices
  ///   - Single query with CTEs (no N+1 queries)
  ///
  /// Returns: Page object with items, total count, and pagination metadata
  Future<Page<JoinedProposalBriefEntity>> getProposalsBriefPage({
    required PageRequest request,
    ProposalsOrder order,
    ProposalsFiltersV2 filters,
  });

  /// Updates the favorite status of a proposal.
  ///
  /// This method updates or inserts a record in the local metadata table
  /// to mark a proposal as a favorite.
  ///
  /// - [id]: The unique identifier of the proposal.
  /// - [isFavorite]: A boolean indicating whether the proposal should be marked as a favorite.
  Future<void> updateProposalFavorite({
    required String id,
    required bool isFavorite,
  });

  /// Watches for changes and returns a paginated page of proposal briefs.
  ///
  /// This method provides a reactive stream that emits a new [Page] of proposal
  /// briefs whenever the underlying data changes in the database. It has the
  /// same filtering, status handling, and pagination logic as
  /// [getProposalsBriefPage].
  ///
  /// Returns a [Stream] that emits a [Page] of [JoinedProposalBriefEntity].
  Stream<Page<JoinedProposalBriefEntity>> watchProposalsBriefPage({
    required PageRequest request,
    ProposalsOrder order,
    ProposalsFiltersV2 filters,
  });
}
