@JS('catalyst_cose')
library catalyst_cose_interop;

import 'dart:js_interop';

/// Signs the message [bytes] and returns a resulting COSE signature.
@JS()
external JSPromise<JSString> signMessage(JSString bytes);
