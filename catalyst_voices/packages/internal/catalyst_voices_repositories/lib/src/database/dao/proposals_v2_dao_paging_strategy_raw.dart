import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao_paging_strategy.dart';
import 'package:catalyst_voices_repositories/src/database/model/joined_proposal_brief_entity.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:drift/drift.dart';

final class ProposalsV2DaoPagingStrategyRaw extends DatabaseAccessor<DriftCatalystDatabase>
    implements ProposalsV2DaoPagingStrategy {
  ProposalsV2DaoPagingStrategyRaw(super.attachedDatabase);

  $DocumentsV2Table get _documents => attachedDatabase.documentsV2;

  @override
  Future<int> countVisibleProposals() async {
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

    final result = await customSelect(
      cteQuery,
      variables: [
        Variable.withString(DocumentType.proposalDocument.uuid),
        Variable.withString(DocumentType.proposalActionDocument.uuid),
        Variable.withString(DocumentType.proposalActionDocument.uuid),
      ],
      readsFrom: {_documents},
    ).getSingle();

    return result.read<int>('total');
  }

  @override
  Future<List<JoinedProposalBriefEntity>> queryVisibleProposalsPage(int page, int size) async {
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
        a.ref_ver,
        json_extract(a.content, '$.action') as action_type
      FROM documents_v2 a
      INNER JOIN latest_actions la ON a.ref_id = la.ref_id AND a.ver = la.max_action_ver
      WHERE a.type = ?
    ),
    hidden_proposals AS (
      SELECT ref_id
      FROM action_status
      WHERE action_type = 'hide'
    ),
    final_proposals AS (
      SELECT 
        ast.ref_id as proposal_id,
        ast.ref_ver as proposal_ver
      FROM action_status ast
      WHERE ast.action_type = 'final'
        AND ast.ref_ver IS NOT NULL
    ),
    effective_proposals AS (
      SELECT 
        COALESCE(fp.proposal_id, lp.id) as id,
        COALESCE(fp.proposal_ver, lp.max_ver) as ver
      FROM latest_proposals lp
      LEFT JOIN final_proposals fp ON lp.id = fp.proposal_id
      WHERE lp.id NOT IN (SELECT ref_id FROM hidden_proposals)
    )
    SELECT p.*
    FROM documents_v2 p
    INNER JOIN effective_proposals ep ON p.id = ep.id AND p.ver = ep.ver
    WHERE p.type = ?
    ORDER BY p.ver DESC
    LIMIT ? OFFSET ?
  ''';

    final results = await customSelect(
      cteQuery,
      variables: [
        Variable.withString(DocumentType.proposalDocument.uuid),
        Variable.withString(DocumentType.proposalActionDocument.uuid),
        Variable.withString(DocumentType.proposalActionDocument.uuid),
        Variable.withString(DocumentType.proposalDocument.uuid),
        Variable.withInt(size),
        Variable.withInt(page * size),
      ],
      readsFrom: {_documents},
    ).map((row) => _documents.map(row.data)).get();

    return results.map((p) => JoinedProposalBriefEntity(proposal: p)).toList();
  }
}
