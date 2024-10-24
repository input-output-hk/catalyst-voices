@JS('catalyst_key_derivation')
library catalyst_key_derivation_interop;

import 'dart:js_interop';

/// Derives the master key from a [mnemonic].
@JS()
external JSPromise<JSString> deriveMasterKey(JSString mnemonic);
