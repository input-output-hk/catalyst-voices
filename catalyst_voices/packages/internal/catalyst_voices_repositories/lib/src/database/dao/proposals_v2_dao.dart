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
    final effectivePage = request.page;
    final effectiveSize = request.size;

    assert(effectiveSize < 1000, 'Max query size is 999');

    if (effectiveSize == 0) {
      return Page(items: const [], total: 0, page: effectivePage, maxPerPage: effectiveSize);
    }

    final proposals = alias(documentsV2, 'proposals');
    final latestVer = alias(documentsV2, 'latestVer');

    final maxVer = latestVer.ver.max();
    final proposalLatestQuery = selectOnly(latestVer)
      ..where(latestVer.type.equals(DocumentType.proposalDocument.uuid))
      ..addColumns([latestVer.id, maxVer])
      ..groupBy([latestVer.id]);
    final proposalLatestSubquery = Subquery(proposalLatestQuery, 'proposalLatest');

    SimpleSelectStatement<DocumentsV2, DocumentEntityV2> hiddenCheckSubquery(String name) {
      final subActions = alias(documentsV2, name);

      final maxVerSubquery = subqueryExpression<String>(
        selectOnly(subActions)
          ..addColumns([subActions.ver.max()])
          ..where(subActions.type.equals(DocumentType.proposalActionDocument.uuid))
          ..where(subActions.refId.equalsExp(proposals.id)),
      );

      return select(subActions)
        ..where((tbl) => tbl.type.equals(DocumentType.proposalActionDocument.uuid))
        ..where((tbl) => tbl.refId.equalsExp(proposals.id))
        ..where((tbl) => tbl.ver.equalsExp(maxVerSubquery))
        ..where((tbl) => tbl.content.jsonExtract<String>(r'$.action').equals('hide'))
        ..limit(1);
    }

    final proposalsQuery =
        select(proposals).join([
            innerJoin(
              proposalLatestSubquery,
              Expression.and([
                proposalLatestSubquery.ref(latestVer.id).equalsExp(proposals.id),
                proposalLatestSubquery.ref(maxVer).equalsExp(proposals.ver),
              ]),
              useColumns: false,
            ),
          ])
          ..where(proposals.type.equalsValue(DocumentType.proposalDocument))
          ..where(existsQuery(hiddenCheckSubquery('hidden_check')).not())
          ..orderBy([OrderingTerm.desc(proposals.ver)])
          ..limit(effectiveSize, offset: effectivePage * effectiveSize);

    final items = await proposalsQuery.map((row) {
      final proposal = row.readTable(proposals);

      return JoinedProposalBriefEntity(proposal: proposal);
    }).get();

    // Separate total count
    final proposalsTotal = alias(documentsV2, 'proposals');
    final totalQuery = selectOnly(proposalsTotal)
      // TODO(damian-molinski): Maybe bring it back later
      /* ..join([
        innerJoin(
          proposalLatestSubquery,
          Expression.and([
            proposalLatestSubquery.ref(latestVer.id).equalsExp(proposalsTotal.id),
            proposalLatestSubquery.ref(maxVer).equalsExp(proposalsTotal.ver),
          ]),
          useColumns: false,
        ),
      ])*/
      ..where(proposalsTotal.type.equals(DocumentType.proposalDocument.uuid))
      ..where(existsQuery(hiddenCheckSubquery('total_hidden_check')).not())
      ..addColumns([proposalsTotal.id.count(distinct: true)]);

    final total = await totalQuery
        .map((row) => row.read(proposalsTotal.id.count(distinct: true)) ?? 0)
        .getSingle();

    return Page(
      items: items,
      total: total,
      page: effectivePage,
      maxPerPage: effectiveSize,
    );
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
