import 'dart:convert';
import 'dart:typed_data';

import 'package:catalyst_voices_repositories/src/api/api_services.dart';
import 'package:catalyst_voices_repositories/src/api/dio_client.dart';
import 'package:catalyst_voices_repositories/src/api/models/current_page.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_index_list.dart';
import 'package:catalyst_voices_repositories/src/api/models/document_index_query_filter.dart';
import 'package:catalyst_voices_repositories/src/api/models/full_stake_info.dart';
import 'package:catalyst_voices_repositories/src/api/models/network.dart';
import 'package:catalyst_voices_repositories/src/api/models/rbac_registration_chain.dart';
import 'package:catalyst_voices_repositories/src/common/content_types.dart';
import 'package:catalyst_voices_repositories/src/common/http_headers.dart';
import 'package:catalyst_voices_repositories/src/dto/config/remote_config.dart';
import 'package:dio/dio.dart';

/// # Catalyst Gateway API.
/// The Catalyst Gateway API provides realtime data for all prior, current and future Catalyst Voices voting events.
///
/// Based on OpenAPI Catalyst Gateway API version 0.9.0
/// catalyst-openapi/v0.9.0 - https://github.com/input-output-hk/catalyst-voices/releases/tag/catalyst-openapi%2Fv0.9.0
abstract interface class CatGatewayService {
  factory CatGatewayService.dio({
    required String baseUrl,
    BaseOptions? options,
    List<Interceptor> interceptors = const [],
    InterceptClient? interceptClient,
  }) {
    final dio = Dio(
      options?.copyWith(baseUrl: baseUrl) ?? BaseOptions(baseUrl: baseUrl),
    )..interceptors.addAll(interceptors);
    interceptClient?.call(dio);
    final dioClient = DioClient(dio);
    return DioCatGatewayService(dioClient);
  }

  void close();

  /// Post A Signed Document Index Query (v2).
  /// Produces a summary of signed documents that meet the criteria
  /// defined in the request body for new signed document versions of v0.0.4.
  ///
  /// It does not return the actual documents, just an index of the document identifiers
  /// which allows the documents to be retrieved by the `GET document` endpoint.
  ///
  /// [page] The page number of the data.
  /// The size of each page, and its offset within the complete data set is determined by the [limit] parameter.
  /// [limit] The size [limit] of each [page] of results.
  /// Determines the maximum amount of data that can be returned in a valid response.
  ///
  /// This [limit] of records of data will always be returned unless there is less data to return
  /// than allowed for by the [limit] and [page].
  ///
  /// *Exceeding the [page]/[limit] of all available records will not return `404`, it will return an
  /// empty response.*
  ///
  /// [filter] Document Index Query Filter
  /// A Query Filter which causes documents whose metadata matches the provided
  /// fields to be returned in the index list response.
  ///
  /// Fields which are not set, are not used to filter documents based on those metadata
  /// fields. This is equivalent to returning documents where those metadata fields either
  /// do not exist, or do exist, but have any value.
  Future<DocumentIndexList> documentIndex({
    required DocumentIndexQueryFilter filter,
    int? page,
    int? limit,
  });

  /// Get the configuration for the frontend.
  /// Get the frontend configuration for the requesting client.
  ///
  /// ### Security
  ///
  /// Does not require any Catalyst RBAC Token to access.
  Future<RemoteConfig> frontendConfig();

  /// Get A Signed Document.
  /// This endpoint returns either a specific or latest version of a registered signed document.
  ///
  /// [documentId] UUIDv7 Document ID to retrieve.
  /// [version] UUIDv7 Version of the Document to retrieve, if omitted, returns the latest version.
  Future<Uint8List> getDocument({
    required String documentId,
    String? version,
  });

  /// Get RBAC registrations V2.
  /// This endpoint returns RBAC registrations by provided auth Catalyst Id credentials
  /// or by the [lookup] argument if provided.
  ///
  /// [lookup] Stake address or Catalyst ID to get the RBAC registration for.
  /// [showAllInvalid] If this parameter is set to `true`, then all the invalid registrations are
  /// returned. Otherwise, only the invalid registrations after the last valid one
  /// are shown. Defaults to `false` if not present.
  Future<RbacRegistrationChain> rbacRegistration({
    String? lookup,
    bool? showAllInvalid,
  });

  /// Get staked assets v2.
  /// This endpoint returns the total Cardano's staked assets to the corresponded
  /// user's stake address.
  ///
  /// [stakeAddress] Cardano stake address, also known as a reward address. An optional stake address of the user.
  /// Should be a valid Bech32 encoded address followed by the https://cips.cardano.org/cip/CIP-19/#stake-addresses.
  /// If missing, a list of associated stake addresses is taken using the RBAC token (for one RBAC registration
  /// chain could be assigned multiple different cardano stake addresses). An aggregated response would be returned
  /// (total ADA sum across all stake addresses, an aggregated native tokens list across all stake addresses etc.)
  /// [network] Cardano network type.
  /// If omitted network type is identified from the stake address.
  /// If specified it must be correspondent to the network type encoded in the stake address.
  /// As `preprod` and `preview` network types in the stake address encoded as a
  /// `testnet`, to specify `preprod` or `preview` network type use this
  /// query parameter.
  /// [asat] A time point at which the assets should be calculated.
  /// If omitted latest slot number is used.
  Future<FullStakeInfo> stakeAssets({
    String? stakeAddress,
    Network? network,
    String? asat,
    String? authorization,
  });

  /// Put A Signed Document.
  /// This endpoint returns OK if the document is valid, able to be put by the
  /// submitter, and if it already exists, is identical to the existing document.
  Future<void> uploadDocument({
    required Uint8List body,
  });
}

final class DioCatGatewayService implements CatGatewayService {
  final DioClient _dio;

  const DioCatGatewayService(this._dio);

  @override
  void close() => _dio.close();

  @override
  Future<DocumentIndexList> documentIndex({
    required DocumentIndexQueryFilter filter,
    int? limit,
    int? page,
  }) {
    return _dio.post<dynamic, DocumentIndexList>(
      '/v2/document/index',
      queryParameters: {
        'limit': ?limit,
        'page': ?page,
      },
      body: filter.toJson(),
      mapper: (response) {
        if (response is Map<String, dynamic>) {
          return DocumentIndexList.fromJson(response);
        }

        return const DocumentIndexList(
          docs: [],
          page: CurrentPage(page: 0, limit: 0, remaining: 0),
        );
      },
    );
  }

  @override
  Future<RemoteConfig> frontendConfig() {
    return _dio.get<dynamic, RemoteConfig>(
      '/v1/config/frontend',
      mapper: (response) {
        if (response is Map<String, dynamic>) {
          return RemoteConfig.fromJson(response);
        }

        if (response is String) {
          return RemoteConfig.fromJson(jsonDecode(response) as Map<String, dynamic>);
        }

        return const RemoteConfig();
      },
    );
  }

  @override
  Future<Uint8List> getDocument({
    required String documentId,
    String? version,
  }) {
    return _dio.get<Uint8List, Uint8List>(
      '/v1/document/$documentId',
      queryParameters: {'version': ?version},
      options: Options(responseType: ResponseType.bytes),
      mapper: (response) => response,
    );
  }

  @override
  Future<RbacRegistrationChain> rbacRegistration({
    String? lookup,
    bool? showAllInvalid = false,
  }) {
    return _dio.get<Map<String, dynamic>, RbacRegistrationChain>(
      '/v2/rbac/registration',
      queryParameters: {
        'lookup': ?lookup,
        'show_all_invalid': ?showAllInvalid,
      },
      mapper: RbacRegistrationChain.fromJson,
    );
  }

  @override
  Future<FullStakeInfo> stakeAssets({
    String? stakeAddress,
    Network? network,
    String? asat,
    String? authorization,
  }) {
    return _dio.get<Map<String, dynamic>, FullStakeInfo>(
      '/v2/cardano/assets',
      queryParameters: {
        'stake_address': ?stakeAddress,
        'network': ?network?.value,
        'asat': ?asat,
      },
      options: Options(
        headers: {
          HttpHeaders.authorization: ?authorization,
        },
      ),
      mapper: FullStakeInfo.fromJson,
    );
  }

  @override
  Future<void> uploadDocument({
    required Uint8List body,
  }) {
    return _dio.put<void, void>(
      '/v1/document',
      body: body,
      options: Options(
        headers: {
          Headers.contentTypeHeader: ContentTypes.applicationCbor,
        },
      ),
      mapper: (response) {},
    );
  }
}
