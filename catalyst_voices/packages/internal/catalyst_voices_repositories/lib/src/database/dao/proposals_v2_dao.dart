import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/database/catalyst_database.dart';
import 'package:catalyst_voices_repositories/src/database/dao/proposals_v2_dao.drift.dart';
import 'package:catalyst_voices_repositories/src/database/model/joined_proposal_brief_entity.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_local_metadata.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.dart';
import 'package:catalyst_voices_repositories/src/database/table/documents_v2.drift.dart';
import 'package:catalyst_voices_repositories/src/database/table/local_documents_drafts.dart';
import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';

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

  @override
  Future<Page<JoinedProposalBriefEntity>> getProposalsBriefPage(PageRequest request) async {
    final effectivePage = request.page.clamp(0, double.infinity).toInt();
    final effectiveSize = request.size.clamp(0, 999);

    assert(effectiveSize < 1000, 'Max query size is 999');

    if (effectiveSize == 0) {
      return Page(items: const [], total: 0, page: effectivePage, maxPerPage: effectiveSize);
    }

    // Aliases because we're querying same table multiple times, and for clarity.
    final proposalTable = alias(documentsV2, 'proposals');
    final latestProposalVerTable = alias(documentsV2, 'latestVer');

    // Subquery: Groups by id to find max ver (latest) for proposals.
    final maxProposalVer = latestProposalVerTable.ver.max();
    final latestProposalQuery = selectOnly(latestProposalVerTable)
      ..where(latestProposalVerTable.type.equalsValue(DocumentType.proposalDocument))
      ..addColumns([latestProposalVerTable.id, maxProposalVer])
      ..groupBy([latestProposalVerTable.id]);
    final latestProposalSubquery = Subquery(latestProposalQuery, 'latestProposal');

    // Main paginated query: Latest proposals, filtered by non-hidden.
    final proposalsQuery =
        select(proposalTable).join([
            innerJoin(
              latestProposalSubquery,
              Expression.and([
                latestProposalSubquery.ref(latestProposalVerTable.id).equalsExp(proposalTable.id),
                latestProposalSubquery.ref(maxProposalVer).equalsExp(proposalTable.ver),
              ]),
              useColumns: false,
            ),
          ])
          ..where(proposalTable.type.equalsValue(DocumentType.proposalDocument))
          ..where(existsQuery(_hiddenCheckSubquery('hidden_check', proposalTable)).not())
          ..orderBy([OrderingTerm.desc(proposalTable.ver)])
          ..limit(effectiveSize, offset: effectivePage * effectiveSize);

    final items = await proposalsQuery.map((row) {
      final proposal = row.readTable(proposalTable);

      return JoinedProposalBriefEntity(proposal: proposal);
    }).get();

    // Total count query: Mirror the main query for distinct non-hidden latest proposal IDs.
    final totalProposalTable = alias(documentsV2, 'proposals');
    final totalExpr = totalProposalTable.id.count(distinct: true);
    final totalQuery = selectOnly(totalProposalTable)
      ..where(totalProposalTable.type.equalsValue(DocumentType.proposalDocument))
      ..where(existsQuery(_hiddenCheckSubquery('total_hidden_check', totalProposalTable)).not())
      ..addColumns([totalExpr]);

    final total = await totalQuery.map((row) => row.read(totalExpr) ?? 0).getSingle();

    return Page(
      items: items,
      total: total,
      page: effectivePage,
      maxPerPage: effectiveSize,
    );
  }

  /// Extracted helper: Reusable correlated subquery for "exists latest hide action".
  SimpleSelectStatement<DocumentsV2, DocumentEntityV2> _hiddenCheckSubquery(
    String name,
    $DocumentsV2Table outerTable,
  ) {
    final subActions = alias(documentsV2, name);

    final maxVerSubquery = subqueryExpression<String>(
      selectOnly(subActions)
        ..addColumns([subActions.ver.max()])
        ..where(subActions.type.equals(DocumentType.proposalActionDocument.uuid))
        ..where(subActions.refId.equalsExp(outerTable.id)),
    );

    return select(subActions)
      ..where((tbl) => tbl.type.equals(DocumentType.proposalActionDocument.uuid))
      ..where((tbl) => tbl.refId.equalsExp(outerTable.id))
      ..where((tbl) => tbl.ver.equalsExp(maxVerSubquery))
      ..where((tbl) => tbl.content.jsonExtract<String>(r'$.action').equals('hide'))
      ..limit(1);
  }
}

abstract interface class ProposalsV2Dao {
  /// Retrieves a proposal by its reference.
  ///
  /// Filters by type == proposalDocument.
  /// If [ref] is exact (has version), returns the specific version.
  /// If loose (no version), returns the latest version by createdAt.
  /// Returns null if no matching proposal is found.
  Future<DocumentEntityV2?> getProposal(DocumentRef ref);

  /// Retrieves a paginated page of brief proposals (lightweight for lists/UI).
  ///
  /// Filters by type == proposalDocument.
  /// Returns latest version per id, ordered by descending ver (UUIDv7 lexical).
  /// Handles pagination via request.page (0-based) and request.size.
  /// Each item is a [JoinedProposalBriefEntity] (extensible for joins).
  Future<Page<JoinedProposalBriefEntity>> getProposalsBriefPage(PageRequest request);
}
