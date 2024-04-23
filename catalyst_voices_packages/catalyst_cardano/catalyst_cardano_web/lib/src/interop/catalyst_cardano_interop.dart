@JS('catalyst_cardano')
library catalyst_cardano_interop;

import 'dart:js_interop';

@JS('encode_arbitrary_bytes_as_metadatum')
// TODO(dtscalac): replace with functions from cardano multiplatform lib that we
// need.
// ignore: public_member_api_docs
external JSAny encodeArbitraryBytesAsMetadatum(JSUint8Array bytes);

/// A initializer function to bootstrap the internals
/// of the Cardano Multiplatform Lib.
///
/// Must be called and awaited exactly once before any
/// additional interaction with lib is made.
@JS('init')
external JSPromise init();
