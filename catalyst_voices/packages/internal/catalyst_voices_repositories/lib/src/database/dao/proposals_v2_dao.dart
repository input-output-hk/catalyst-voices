import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/model/joined_proposal_brief_entity.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:drift/drift.dart';

/// Data Access Object for Proposal-specific queries.
///
/// This DAO handles complex queries for retrieving proposals with proper status handling.
///
/// See PROPOSALS_QUERY_GUIDE.md for detailed explanation of query logic.
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
  Future<Page<JoinedProposalBriefEntity>> getProposalsBriefPage(PageRequest request) async {
    final effectivePage = request.page.clamp(0, double.infinity).toInt();
    final effectiveSize = request.size.clamp(0, 999);

    if (effectiveSize == 0) {
      return Page(items: const [], total: 0, page: effectivePage, maxPerPage: effectiveSize);
    }

    final items = await _queryVisibleProposalsPage(effectivePage, effectiveSize);
    final total = await _countVisibleProposals();

    return Page(
      items: items,
      total: total,
      page: effectivePage,
      maxPerPage: effectiveSize,
    );
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
  /// Expected Performance:
  /// - ~10-20ms for 10k documents with proper indices
  /// - Must match pagination query's filtering logic exactly eg.[_queryVisibleProposalsPage]
  ///
  /// Returns: Total count of visible proposals (not including hidden)
  Future<int> _countVisibleProposals() async {
    const cteQuery = r'''
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
        json_extract(a.content, '$.action') as action_type
      FROM documents_v2 a
      INNER JOIN latest_actions la ON a.ref_id = la.ref_id AND a.ver = la.max_action_ver
      WHERE a.type = ?
    ),
    hidden_proposals AS (
      SELECT ref_id
      FROM action_status
      WHERE action_type = 'hide'
    )
    SELECT COUNT(DISTINCT lp.id) as total
    FROM latest_proposals lp
    WHERE lp.id NOT IN (SELECT ref_id FROM hidden_proposals)
  ''';

    return customSelect(
      cteQuery,
      variables: [
        Variable.withString(DocumentType.proposalDocument.uuid),
        Variable.withString(DocumentType.proposalActionDocument.uuid),
        Variable.withString(DocumentType.proposalActionDocument.uuid),
      ],
      readsFrom: {documentsV2},
    ).map((row) => row.readNullable<int>('total') ?? 0).getSingle();
  }

  /// Fetches paginated proposal pages using complex CTE logic.
  ///
  /// CTE 1 - latest_proposals:
  ///   Groups all proposals by id and finds the maximum version.
  ///   This identifies the newest version of each proposal.
  ///
  /// CTE 2 - latest_actions:
  ///   Groups all proposal actions by ref_id and finds the maximum version.
  ///   This ensures we only check the most recent action for each proposal.
  ///
  /// CTE 3 - action_status:
  ///   Joins actual action documents with latest_actions to extract the action type
  ///   (draft/final/hide) from JSON content using json_extract.
  ///   Also includes ref_ver which may point to a specific proposal version.
  ///
  /// CTE 4 - hidden_proposals:
  ///   Identifies proposals with 'hide' action. ALL versions are hidden.
  ///
  /// CTE 5 - effective_proposals:
  ///   Applies COALESCE logic to determine display version:
  ///   - If action_type='final' AND ref_ver IS NOT NULL: Use ref_ver (specific final version)
  ///   - Else: Use latest version (max_ver)
  ///   - Exclude any proposal in hidden_proposals
  ///
  /// Final Join:
  ///   Retrieves full document records and orders by version descending.
  ///   Uses idx_documents_v2_type_id_ver for efficient lookup.
  ///
  /// Parameters:
  ///   - proposalType: UUID string for proposalDocument type
  ///   - actionType: UUID string for proposalActionDocument type
  ///   - page: 0-based page number
  ///   - pageSize: Items per page (max 999)
  ///
  /// Returns: List of [JoinedProposalBriefEntity] mapped from raw rows of customSelect
  Future<List<JoinedProposalBriefEntity>> _queryVisibleProposalsPage(int page, int size) async {
    const cteQuery = r'''
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
        COALESCE(json_extract(a.content, '$.action'), 'draft') as action_type
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
      p.*, 
      ep.action_type, 
      ep.version_ids_str,
      COALESCE(cc.count, 0) as comments_count
    FROM documents_v2 p
    INNER JOIN effective_proposals ep ON p.id = ep.id AND p.ver = ep.ver
    LEFT JOIN comments_count cc ON p.id = cc.ref_id AND p.ver = cc.ref_ver
    WHERE p.type = ?
    ORDER BY p.ver DESC
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
        Variable.withString(DocumentType.proposalDocument.uuid),
        Variable.withInt(size),
        Variable.withInt(page * size),
      ],
      readsFrom: {documentsV2},
    ).map((row) {
      final proposal = documentsV2.map(row.data);

      final actionTypeRaw = row.readNullable<String>('action_type') ?? '';
      final actionType = ProposalSubmissionActionDto.fromJson(actionTypeRaw)?.toModel();

      final versionIdsRaw = row.readNullable<String>('version_ids_str') ?? '';
      final versionIds = versionIdsRaw.split(',');

      final commentsCount = row.readNullable<int>('comments_count') ?? 0;

      return JoinedProposalBriefEntity(
        proposal: proposal,
        actionType: actionType,
        versionIds: versionIds,
        commentsCount: commentsCount,
      );
    }).get();
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
  Future<Page<JoinedProposalBriefEntity>> getProposalsBriefPage(PageRequest request);
}
