import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao_paging_strategy.dart';
import 'package:catalyst_voices_repositories/src/database/model/joined_proposal_brief_entity.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';

final class ProposalsV2DaoPagingStrategyDsl extends DatabaseAccessor<DriftCatalystDatabase>
    implements ProposalsV2DaoPagingStrategy {
  ProposalsV2DaoPagingStrategyDsl(super.attachedDatabase);

  $DocumentsV2Table get documents => attachedDatabase.documentsV2;

  @override
  Future<int> countVisibleProposals() async {
    final proposalTable = alias(documents, 'total_proposals');
    final totalExpr = proposalTable.id.count(distinct: true);

    final query = selectOnly(proposalTable)
      ..where(proposalTable.type.equalsValue(DocumentType.proposalDocument))
      ..where(_isNotHiddenCondition(proposalTable))
      ..addColumns([totalExpr]);

    return query.map((row) => row.read(totalExpr) ?? 0).getSingle();
  }

  @override
  Future<List<JoinedProposalBriefEntity>> queryVisibleProposalsPage(int page, int size) async {
    final proposalTable = alias(documents, 'proposals');
    final latestProposalSubquery = _buildLatestProposalSubquery();
    final finalActionSubquery = _buildFinalActionSubquery();

    final lpTable = alias(documents, 'lp');
    final maxProposalVer = lpTable.ver.max();
    final faTable = alias(documents, 'fa');

    final query =
        select(proposalTable).join([
            innerJoin(
              latestProposalSubquery,
              Expression.and([
                latestProposalSubquery.ref(lpTable.id).equalsExp(proposalTable.id),
                latestProposalSubquery.ref(maxProposalVer).equalsExp(proposalTable.ver),
              ]),
              useColumns: false,
            ),
            leftOuterJoin(
              finalActionSubquery,
              finalActionSubquery.ref(faTable.refId).equalsExp(proposalTable.id),
              useColumns: false,
            ),
          ])
          ..where(proposalTable.type.equalsValue(DocumentType.proposalDocument))
          ..where(_isNotHiddenCondition(proposalTable))
          ..where(_matchesFinalActionOrLatest(proposalTable, finalActionSubquery, faTable))
          ..orderBy([OrderingTerm.desc(proposalTable.ver)])
          ..limit(size, offset: page * size);

    return query.map((row) {
      final proposal = row.readTable(proposalTable);
      return JoinedProposalBriefEntity(proposal: proposal);
    }).get();
  }

  Subquery<TypedResult> _buildFinalActionSubquery() {
    final faTable = alias(documents, 'fa');
    final faLatestTable = alias(documents, 'fa_latest');
    final maxActionVer = faLatestTable.ver.max();

    final latestActionSubquery = selectOnly(faLatestTable)
      ..where(faLatestTable.type.equals(DocumentType.proposalActionDocument.uuid))
      ..addColumns([faLatestTable.refId, maxActionVer])
      ..groupBy([faLatestTable.refId]);

    final latestActionSub = Subquery(latestActionSubquery, 'fa_latest_sub');

    final query =
        selectOnly(faTable).join([
            innerJoin(
              latestActionSub,
              Expression.and([
                latestActionSub.ref(faLatestTable.refId).equalsExp(faTable.refId),
                latestActionSub.ref(maxActionVer).equalsExp(faTable.ver),
              ]),
              useColumns: false,
            ),
          ])
          ..where(faTable.type.equals(DocumentType.proposalActionDocument.uuid))
          ..where(faTable.content.jsonExtract<String>(r'$.action').equals('final'))
          ..addColumns([
            faTable.refId,
            faTable.refVer,
          ]);

    return Subquery(query, 'final_action');
  }

  SimpleSelectStatement<DocumentsV2, DocumentEntityV2> _buildLatestHideActionSubquery(
    $DocumentsV2Table proposalTable,
  ) {
    final actionTable = alias(documents, 'action_check');

    final maxActionVerSubquery = subqueryExpression<String>(
      selectOnly(actionTable)
        ..addColumns([actionTable.ver.max()])
        ..where(actionTable.type.equals(DocumentType.proposalActionDocument.uuid))
        ..where(actionTable.refId.equalsExp(proposalTable.id)),
    );

    return select(actionTable)
      ..where((tbl) => tbl.type.equals(DocumentType.proposalActionDocument.uuid))
      ..where((tbl) => tbl.refId.equalsExp(proposalTable.id))
      ..where((tbl) => tbl.ver.equalsExp(maxActionVerSubquery))
      ..where((tbl) => tbl.content.jsonExtract<String>(r'$.action').equals('hide'))
      ..limit(1);
  }

  Subquery<TypedResult> _buildLatestProposalSubquery() {
    final lpTable = alias(documents, 'lp');
    final maxProposalVer = lpTable.ver.max();

    final query = selectOnly(lpTable)
      ..where(lpTable.type.equalsValue(DocumentType.proposalDocument))
      ..addColumns([lpTable.id, maxProposalVer])
      ..groupBy([lpTable.id]);

    return Subquery(query, 'latest_proposal');
  }

  Expression<bool> _isNotHiddenCondition($DocumentsV2Table proposalTable) {
    return existsQuery(_buildLatestHideActionSubquery(proposalTable)).not();
  }

  Expression<bool> _matchesFinalActionOrLatest(
    $DocumentsV2Table proposalTable,
    Subquery<TypedResult> finalActionSubquery,
    $DocumentsV2Table faTable,
  ) {
    final finalActionRefVer = finalActionSubquery.ref(faTable.refVer);

    return finalActionRefVer.isNull() | finalActionRefVer.equalsExp(proposalTable.ver);
  }
}
