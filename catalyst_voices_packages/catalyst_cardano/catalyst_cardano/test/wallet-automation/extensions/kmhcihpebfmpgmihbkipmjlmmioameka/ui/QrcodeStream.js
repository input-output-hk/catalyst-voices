import { dp as getDefaultExportFromCjs, dv as process$1, dm as global, d as defineComponent, a9 as useQuasar, o as openBlock, c as createElementBlock, e as createBaseVNode, aC as renderSlot } from "./index.js";
import { k as keepScanning } from "./scanner.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
function _mergeNamespaces(n, m) {
  for (var i = 0; i < m.length; i++) {
    const e2 = m[i];
    if (typeof e2 !== "string" && !Array.isArray(e2)) {
      for (const k in e2) {
        if (k !== "default" && !(k in n)) {
          const d = Object.getOwnPropertyDescriptor(e2, k);
          if (d) {
            Object.defineProperty(n, k, d.get ? d : {
              enumerable: true,
              get: () => e2[k]
            });
          }
        }
      }
    }
  }
  return Object.freeze(Object.defineProperty(n, Symbol.toStringTag, { value: "Module" }));
}
class StreamApiNotSupportedError extends Error {
  constructor() {
    super("this browser has no Stream API support");
    this.name = "StreamApiNotSupportedError";
  }
}
class InsecureContextError extends Error {
  constructor() {
    super(
      "camera access is only permitted in secure context. Use HTTPS or localhost rather than HTTP."
    );
    this.name = "InsecureContextError";
  }
}
var e = function(e2, r2, n) {
  var t, i;
  void 0 === n && (n = "error");
  var o = new Promise(function(e3, r3) {
    t = e3, i = r3;
  });
  return e2.addEventListener(r2, t), e2.addEventListener(n, i), o.finally(function() {
    e2.removeEventListener(r2, t), e2.removeEventListener(n, i);
  }), o;
}, r = function(e2) {
  return new Promise(function(r2) {
    return setTimeout(r2, e2);
  });
};
let logDisabled_ = true;
let deprecationWarnings_ = true;
function extractVersion(uastring, expr, pos) {
  const match = uastring.match(expr);
  return match && match.length >= pos && parseInt(match[pos], 10);
}
function wrapPeerConnectionEvent(window2, eventNameToWrap, wrapper) {
  if (!window2.RTCPeerConnection) {
    return;
  }
  const proto = window2.RTCPeerConnection.prototype;
  const nativeAddEventListener = proto.addEventListener;
  proto.addEventListener = function(nativeEventName, cb) {
    if (nativeEventName !== eventNameToWrap) {
      return nativeAddEventListener.apply(this, arguments);
    }
    const wrappedCallback = (e2) => {
      const modifiedEvent = wrapper(e2);
      if (modifiedEvent) {
        if (cb.handleEvent) {
          cb.handleEvent(modifiedEvent);
        } else {
          cb(modifiedEvent);
        }
      }
    };
    this._eventMap = this._eventMap || {};
    if (!this._eventMap[eventNameToWrap]) {
      this._eventMap[eventNameToWrap] = /* @__PURE__ */ new Map();
    }
    this._eventMap[eventNameToWrap].set(cb, wrappedCallback);
    return nativeAddEventListener.apply(this, [
      nativeEventName,
      wrappedCallback
    ]);
  };
  const nativeRemoveEventListener = proto.removeEventListener;
  proto.removeEventListener = function(nativeEventName, cb) {
    if (nativeEventName !== eventNameToWrap || !this._eventMap || !this._eventMap[eventNameToWrap]) {
      return nativeRemoveEventListener.apply(this, arguments);
    }
    if (!this._eventMap[eventNameToWrap].has(cb)) {
      return nativeRemoveEventListener.apply(this, arguments);
    }
    const unwrappedCb = this._eventMap[eventNameToWrap].get(cb);
    this._eventMap[eventNameToWrap].delete(cb);
    if (this._eventMap[eventNameToWrap].size === 0) {
      delete this._eventMap[eventNameToWrap];
    }
    if (Object.keys(this._eventMap).length === 0) {
      delete this._eventMap;
    }
    return nativeRemoveEventListener.apply(this, [
      nativeEventName,
      unwrappedCb
    ]);
  };
  Object.defineProperty(proto, "on" + eventNameToWrap, {
    get() {
      return this["_on" + eventNameToWrap];
    },
    set(cb) {
      if (this["_on" + eventNameToWrap]) {
        this.removeEventListener(
          eventNameToWrap,
          this["_on" + eventNameToWrap]
        );
        delete this["_on" + eventNameToWrap];
      }
      if (cb) {
        this.addEventListener(
          eventNameToWrap,
          this["_on" + eventNameToWrap] = cb
        );
      }
    },
    enumerable: true,
    configurable: true
  });
}
function disableLog(bool) {
  if (typeof bool !== "boolean") {
    return new Error("Argument type: " + typeof bool + ". Please use a boolean.");
  }
  logDisabled_ = bool;
  return bool ? "adapter.js logging disabled" : "adapter.js logging enabled";
}
function disableWarnings(bool) {
  if (typeof bool !== "boolean") {
    return new Error("Argument type: " + typeof bool + ". Please use a boolean.");
  }
  deprecationWarnings_ = !bool;
  return "adapter.js deprecation warnings " + (bool ? "disabled" : "enabled");
}
function log() {
  if (typeof window === "object") {
    if (logDisabled_) {
      return;
    }
    if (typeof console !== "undefined" && typeof console.log === "function") {
      console.log.apply(console, arguments);
    }
  }
}
function deprecated(oldMethod, newMethod) {
  if (!deprecationWarnings_) {
    return;
  }
  console.warn(oldMethod + " is deprecated, please use " + newMethod + " instead.");
}
function detectBrowser(window2) {
  const result = { browser: null, version: null };
  if (typeof window2 === "undefined" || !window2.navigator || !window2.navigator.userAgent) {
    result.browser = "Not a browser.";
    return result;
  }
  const { navigator: navigator2 } = window2;
  if (navigator2.userAgentData && navigator2.userAgentData.brands) {
    const chromium = navigator2.userAgentData.brands.find((brand) => {
      return brand.brand === "Chromium";
    });
    if (chromium) {
      return { browser: "chrome", version: parseInt(chromium.version, 10) };
    }
  }
  if (navigator2.mozGetUserMedia) {
    result.browser = "firefox";
    result.version = extractVersion(
      navigator2.userAgent,
      /Firefox\/(\d+)\./,
      1
    );
  } else if (navigator2.webkitGetUserMedia || window2.isSecureContext === false && window2.webkitRTCPeerConnection) {
    result.browser = "chrome";
    result.version = extractVersion(
      navigator2.userAgent,
      /Chrom(e|ium)\/(\d+)\./,
      2
    );
  } else if (window2.RTCPeerConnection && navigator2.userAgent.match(/AppleWebKit\/(\d+)\./)) {
    result.browser = "safari";
    result.version = extractVersion(
      navigator2.userAgent,
      /AppleWebKit\/(\d+)\./,
      1
    );
    result.supportsUnifiedPlan = window2.RTCRtpTransceiver && "currentDirection" in window2.RTCRtpTransceiver.prototype;
  } else {
    result.browser = "Not a supported browser.";
    return result;
  }
  return result;
}
function isObject(val) {
  return Object.prototype.toString.call(val) === "[object Object]";
}
function compactObject(data) {
  if (!isObject(data)) {
    return data;
  }
  return Object.keys(data).reduce(function(accumulator, key) {
    const isObj = isObject(data[key]);
    const value = isObj ? compactObject(data[key]) : data[key];
    const isEmptyObject = isObj && !Object.keys(value).length;
    if (value === void 0 || isEmptyObject) {
      return accumulator;
    }
    return Object.assign(accumulator, { [key]: value });
  }, {});
}
function walkStats(stats, base, resultSet) {
  if (!base || resultSet.has(base.id)) {
    return;
  }
  resultSet.set(base.id, base);
  Object.keys(base).forEach((name) => {
    if (name.endsWith("Id")) {
      walkStats(stats, stats.get(base[name]), resultSet);
    } else if (name.endsWith("Ids")) {
      base[name].forEach((id) => {
        walkStats(stats, stats.get(id), resultSet);
      });
    }
  });
}
function filterStats(result, track, outbound) {
  const streamStatsType = outbound ? "outbound-rtp" : "inbound-rtp";
  const filteredResult = /* @__PURE__ */ new Map();
  if (track === null) {
    return filteredResult;
  }
  const trackStats = [];
  result.forEach((value) => {
    if (value.type === "track" && value.trackIdentifier === track.id) {
      trackStats.push(value);
    }
  });
  trackStats.forEach((trackStat) => {
    result.forEach((stats) => {
      if (stats.type === streamStatsType && stats.trackId === trackStat.id) {
        walkStats(result, stats, filteredResult);
      }
    });
  });
  return filteredResult;
}
const logging = log;
function shimGetUserMedia$3(window2, browserDetails) {
  const navigator2 = window2 && window2.navigator;
  if (!navigator2.mediaDevices) {
    return;
  }
  const constraintsToChrome_ = function(c) {
    if (typeof c !== "object" || c.mandatory || c.optional) {
      return c;
    }
    const cc = {};
    Object.keys(c).forEach((key) => {
      if (key === "require" || key === "advanced" || key === "mediaSource") {
        return;
      }
      const r2 = typeof c[key] === "object" ? c[key] : { ideal: c[key] };
      if (r2.exact !== void 0 && typeof r2.exact === "number") {
        r2.min = r2.max = r2.exact;
      }
      const oldname_ = function(prefix, name) {
        if (prefix) {
          return prefix + name.charAt(0).toUpperCase() + name.slice(1);
        }
        return name === "deviceId" ? "sourceId" : name;
      };
      if (r2.ideal !== void 0) {
        cc.optional = cc.optional || [];
        let oc = {};
        if (typeof r2.ideal === "number") {
          oc[oldname_("min", key)] = r2.ideal;
          cc.optional.push(oc);
          oc = {};
          oc[oldname_("max", key)] = r2.ideal;
          cc.optional.push(oc);
        } else {
          oc[oldname_("", key)] = r2.ideal;
          cc.optional.push(oc);
        }
      }
      if (r2.exact !== void 0 && typeof r2.exact !== "number") {
        cc.mandatory = cc.mandatory || {};
        cc.mandatory[oldname_("", key)] = r2.exact;
      } else {
        ["min", "max"].forEach((mix) => {
          if (r2[mix] !== void 0) {
            cc.mandatory = cc.mandatory || {};
            cc.mandatory[oldname_(mix, key)] = r2[mix];
          }
        });
      }
    });
    if (c.advanced) {
      cc.optional = (cc.optional || []).concat(c.advanced);
    }
    return cc;
  };
  const shimConstraints_ = function(constraints, func) {
    if (browserDetails.version >= 61) {
      return func(constraints);
    }
    constraints = JSON.parse(JSON.stringify(constraints));
    if (constraints && typeof constraints.audio === "object") {
      const remap = function(obj, a, b) {
        if (a in obj && !(b in obj)) {
          obj[b] = obj[a];
          delete obj[a];
        }
      };
      constraints = JSON.parse(JSON.stringify(constraints));
      remap(constraints.audio, "autoGainControl", "googAutoGainControl");
      remap(constraints.audio, "noiseSuppression", "googNoiseSuppression");
      constraints.audio = constraintsToChrome_(constraints.audio);
    }
    if (constraints && typeof constraints.video === "object") {
      let face = constraints.video.facingMode;
      face = face && (typeof face === "object" ? face : { ideal: face });
      const getSupportedFacingModeLies = browserDetails.version < 66;
      if (face && (face.exact === "user" || face.exact === "environment" || face.ideal === "user" || face.ideal === "environment") && !(navigator2.mediaDevices.getSupportedConstraints && navigator2.mediaDevices.getSupportedConstraints().facingMode && !getSupportedFacingModeLies)) {
        delete constraints.video.facingMode;
        let matches;
        if (face.exact === "environment" || face.ideal === "environment") {
          matches = ["back", "rear"];
        } else if (face.exact === "user" || face.ideal === "user") {
          matches = ["front"];
        }
        if (matches) {
          return navigator2.mediaDevices.enumerateDevices().then((devices) => {
            devices = devices.filter((d) => d.kind === "videoinput");
            let dev = devices.find((d) => matches.some((match) => d.label.toLowerCase().includes(match)));
            if (!dev && devices.length && matches.includes("back")) {
              dev = devices[devices.length - 1];
            }
            if (dev) {
              constraints.video.deviceId = face.exact ? { exact: dev.deviceId } : { ideal: dev.deviceId };
            }
            constraints.video = constraintsToChrome_(constraints.video);
            logging("chrome: " + JSON.stringify(constraints));
            return func(constraints);
          });
        }
      }
      constraints.video = constraintsToChrome_(constraints.video);
    }
    logging("chrome: " + JSON.stringify(constraints));
    return func(constraints);
  };
  const shimError_ = function(e2) {
    if (browserDetails.version >= 64) {
      return e2;
    }
    return {
      name: {
        PermissionDeniedError: "NotAllowedError",
        PermissionDismissedError: "NotAllowedError",
        InvalidStateError: "NotAllowedError",
        DevicesNotFoundError: "NotFoundError",
        ConstraintNotSatisfiedError: "OverconstrainedError",
        TrackStartError: "NotReadableError",
        MediaDeviceFailedDueToShutdown: "NotAllowedError",
        MediaDeviceKillSwitchOn: "NotAllowedError",
        TabCaptureError: "AbortError",
        ScreenCaptureError: "AbortError",
        DeviceCaptureError: "AbortError"
      }[e2.name] || e2.name,
      message: e2.message,
      constraint: e2.constraint || e2.constraintName,
      toString() {
        return this.name + (this.message && ": ") + this.message;
      }
    };
  };
  const getUserMedia_ = function(constraints, onSuccess, onError) {
    shimConstraints_(constraints, (c) => {
      navigator2.webkitGetUserMedia(c, onSuccess, (e2) => {
        if (onError) {
          onError(shimError_(e2));
        }
      });
    });
  };
  navigator2.getUserMedia = getUserMedia_.bind(navigator2);
  if (navigator2.mediaDevices.getUserMedia) {
    const origGetUserMedia = navigator2.mediaDevices.getUserMedia.bind(navigator2.mediaDevices);
    navigator2.mediaDevices.getUserMedia = function(cs) {
      return shimConstraints_(cs, (c) => origGetUserMedia(c).then((stream) => {
        if (c.audio && !stream.getAudioTracks().length || c.video && !stream.getVideoTracks().length) {
          stream.getTracks().forEach((track) => {
            track.stop();
          });
          throw new DOMException("", "NotFoundError");
        }
        return stream;
      }, (e2) => Promise.reject(shimError_(e2))));
    };
  }
}
function shimMediaStream(window2) {
  window2.MediaStream = window2.MediaStream || window2.webkitMediaStream;
}
function shimOnTrack$1(window2) {
  if (typeof window2 === "object" && window2.RTCPeerConnection && !("ontrack" in window2.RTCPeerConnection.prototype)) {
    Object.defineProperty(window2.RTCPeerConnection.prototype, "ontrack", {
      get() {
        return this._ontrack;
      },
      set(f) {
        if (this._ontrack) {
          this.removeEventListener("track", this._ontrack);
        }
        this.addEventListener("track", this._ontrack = f);
      },
      enumerable: true,
      configurable: true
    });
    const origSetRemoteDescription = window2.RTCPeerConnection.prototype.setRemoteDescription;
    window2.RTCPeerConnection.prototype.setRemoteDescription = function setRemoteDescription() {
      if (!this._ontrackpoly) {
        this._ontrackpoly = (e2) => {
          e2.stream.addEventListener("addtrack", (te) => {
            let receiver;
            if (window2.RTCPeerConnection.prototype.getReceivers) {
              receiver = this.getReceivers().find((r2) => r2.track && r2.track.id === te.track.id);
            } else {
              receiver = { track: te.track };
            }
            const event = new Event("track");
            event.track = te.track;
            event.receiver = receiver;
            event.transceiver = { receiver };
            event.streams = [e2.stream];
            this.dispatchEvent(event);
          });
          e2.stream.getTracks().forEach((track) => {
            let receiver;
            if (window2.RTCPeerConnection.prototype.getReceivers) {
              receiver = this.getReceivers().find((r2) => r2.track && r2.track.id === track.id);
            } else {
              receiver = { track };
            }
            const event = new Event("track");
            event.track = track;
            event.receiver = receiver;
            event.transceiver = { receiver };
            event.streams = [e2.stream];
            this.dispatchEvent(event);
          });
        };
        this.addEventListener("addstream", this._ontrackpoly);
      }
      return origSetRemoteDescription.apply(this, arguments);
    };
  } else {
    wrapPeerConnectionEvent(window2, "track", (e2) => {
      if (!e2.transceiver) {
        Object.defineProperty(
          e2,
          "transceiver",
          { value: { receiver: e2.receiver } }
        );
      }
      return e2;
    });
  }
}
function shimGetSendersWithDtmf(window2) {
  if (typeof window2 === "object" && window2.RTCPeerConnection && !("getSenders" in window2.RTCPeerConnection.prototype) && "createDTMFSender" in window2.RTCPeerConnection.prototype) {
    const shimSenderWithDtmf = function(pc, track) {
      return {
        track,
        get dtmf() {
          if (this._dtmf === void 0) {
            if (track.kind === "audio") {
              this._dtmf = pc.createDTMFSender(track);
            } else {
              this._dtmf = null;
            }
          }
          return this._dtmf;
        },
        _pc: pc
      };
    };
    if (!window2.RTCPeerConnection.prototype.getSenders) {
      window2.RTCPeerConnection.prototype.getSenders = function getSenders() {
        this._senders = this._senders || [];
        return this._senders.slice();
      };
      const origAddTrack = window2.RTCPeerConnection.prototype.addTrack;
      window2.RTCPeerConnection.prototype.addTrack = function addTrack(track, stream) {
        let sender = origAddTrack.apply(this, arguments);
        if (!sender) {
          sender = shimSenderWithDtmf(this, track);
          this._senders.push(sender);
        }
        return sender;
      };
      const origRemoveTrack = window2.RTCPeerConnection.prototype.removeTrack;
      window2.RTCPeerConnection.prototype.removeTrack = function removeTrack(sender) {
        origRemoveTrack.apply(this, arguments);
        const idx = this._senders.indexOf(sender);
        if (idx !== -1) {
          this._senders.splice(idx, 1);
        }
      };
    }
    const origAddStream = window2.RTCPeerConnection.prototype.addStream;
    window2.RTCPeerConnection.prototype.addStream = function addStream(stream) {
      this._senders = this._senders || [];
      origAddStream.apply(this, [stream]);
      stream.getTracks().forEach((track) => {
        this._senders.push(shimSenderWithDtmf(this, track));
      });
    };
    const origRemoveStream = window2.RTCPeerConnection.prototype.removeStream;
    window2.RTCPeerConnection.prototype.removeStream = function removeStream(stream) {
      this._senders = this._senders || [];
      origRemoveStream.apply(this, [stream]);
      stream.getTracks().forEach((track) => {
        const sender = this._senders.find((s) => s.track === track);
        if (sender) {
          this._senders.splice(this._senders.indexOf(sender), 1);
        }
      });
    };
  } else if (typeof window2 === "object" && window2.RTCPeerConnection && "getSenders" in window2.RTCPeerConnection.prototype && "createDTMFSender" in window2.RTCPeerConnection.prototype && window2.RTCRtpSender && !("dtmf" in window2.RTCRtpSender.prototype)) {
    const origGetSenders = window2.RTCPeerConnection.prototype.getSenders;
    window2.RTCPeerConnection.prototype.getSenders = function getSenders() {
      const senders = origGetSenders.apply(this, []);
      senders.forEach((sender) => sender._pc = this);
      return senders;
    };
    Object.defineProperty(window2.RTCRtpSender.prototype, "dtmf", {
      get() {
        if (this._dtmf === void 0) {
          if (this.track.kind === "audio") {
            this._dtmf = this._pc.createDTMFSender(this.track);
          } else {
            this._dtmf = null;
          }
        }
        return this._dtmf;
      }
    });
  }
}
function shimSenderReceiverGetStats(window2) {
  if (!(typeof window2 === "object" && window2.RTCPeerConnection && window2.RTCRtpSender && window2.RTCRtpReceiver)) {
    return;
  }
  if (!("getStats" in window2.RTCRtpSender.prototype)) {
    const origGetSenders = window2.RTCPeerConnection.prototype.getSenders;
    if (origGetSenders) {
      window2.RTCPeerConnection.prototype.getSenders = function getSenders() {
        const senders = origGetSenders.apply(this, []);
        senders.forEach((sender) => sender._pc = this);
        return senders;
      };
    }
    const origAddTrack = window2.RTCPeerConnection.prototype.addTrack;
    if (origAddTrack) {
      window2.RTCPeerConnection.prototype.addTrack = function addTrack() {
        const sender = origAddTrack.apply(this, arguments);
        sender._pc = this;
        return sender;
      };
    }
    window2.RTCRtpSender.prototype.getStats = function getStats() {
      const sender = this;
      return this._pc.getStats().then((result) => (
        /* Note: this will include stats of all senders that
         *   send a track with the same id as sender.track as
         *   it is not possible to identify the RTCRtpSender.
         */
        filterStats(result, sender.track, true)
      ));
    };
  }
  if (!("getStats" in window2.RTCRtpReceiver.prototype)) {
    const origGetReceivers = window2.RTCPeerConnection.prototype.getReceivers;
    if (origGetReceivers) {
      window2.RTCPeerConnection.prototype.getReceivers = function getReceivers() {
        const receivers = origGetReceivers.apply(this, []);
        receivers.forEach((receiver) => receiver._pc = this);
        return receivers;
      };
    }
    wrapPeerConnectionEvent(window2, "track", (e2) => {
      e2.receiver._pc = e2.srcElement;
      return e2;
    });
    window2.RTCRtpReceiver.prototype.getStats = function getStats() {
      const receiver = this;
      return this._pc.getStats().then((result) => filterStats(result, receiver.track, false));
    };
  }
  if (!("getStats" in window2.RTCRtpSender.prototype && "getStats" in window2.RTCRtpReceiver.prototype)) {
    return;
  }
  const origGetStats = window2.RTCPeerConnection.prototype.getStats;
  window2.RTCPeerConnection.prototype.getStats = function getStats() {
    if (arguments.length > 0 && arguments[0] instanceof window2.MediaStreamTrack) {
      const track = arguments[0];
      let sender;
      let receiver;
      let err;
      this.getSenders().forEach((s) => {
        if (s.track === track) {
          if (sender) {
            err = true;
          } else {
            sender = s;
          }
        }
      });
      this.getReceivers().forEach((r2) => {
        if (r2.track === track) {
          if (receiver) {
            err = true;
          } else {
            receiver = r2;
          }
        }
        return r2.track === track;
      });
      if (err || sender && receiver) {
        return Promise.reject(new DOMException(
          "There are more than one sender or receiver for the track.",
          "InvalidAccessError"
        ));
      } else if (sender) {
        return sender.getStats();
      } else if (receiver) {
        return receiver.getStats();
      }
      return Promise.reject(new DOMException(
        "There is no sender or receiver for the track.",
        "InvalidAccessError"
      ));
    }
    return origGetStats.apply(this, arguments);
  };
}
function shimAddTrackRemoveTrackWithNative(window2) {
  window2.RTCPeerConnection.prototype.getLocalStreams = function getLocalStreams() {
    this._shimmedLocalStreams = this._shimmedLocalStreams || {};
    return Object.keys(this._shimmedLocalStreams).map((streamId) => this._shimmedLocalStreams[streamId][0]);
  };
  const origAddTrack = window2.RTCPeerConnection.prototype.addTrack;
  window2.RTCPeerConnection.prototype.addTrack = function addTrack(track, stream) {
    if (!stream) {
      return origAddTrack.apply(this, arguments);
    }
    this._shimmedLocalStreams = this._shimmedLocalStreams || {};
    const sender = origAddTrack.apply(this, arguments);
    if (!this._shimmedLocalStreams[stream.id]) {
      this._shimmedLocalStreams[stream.id] = [stream, sender];
    } else if (this._shimmedLocalStreams[stream.id].indexOf(sender) === -1) {
      this._shimmedLocalStreams[stream.id].push(sender);
    }
    return sender;
  };
  const origAddStream = window2.RTCPeerConnection.prototype.addStream;
  window2.RTCPeerConnection.prototype.addStream = function addStream(stream) {
    this._shimmedLocalStreams = this._shimmedLocalStreams || {};
    stream.getTracks().forEach((track) => {
      const alreadyExists = this.getSenders().find((s) => s.track === track);
      if (alreadyExists) {
        throw new DOMException(
          "Track already exists.",
          "InvalidAccessError"
        );
      }
    });
    const existingSenders = this.getSenders();
    origAddStream.apply(this, arguments);
    const newSenders = this.getSenders().filter((newSender) => existingSenders.indexOf(newSender) === -1);
    this._shimmedLocalStreams[stream.id] = [stream].concat(newSenders);
  };
  const origRemoveStream = window2.RTCPeerConnection.prototype.removeStream;
  window2.RTCPeerConnection.prototype.removeStream = function removeStream(stream) {
    this._shimmedLocalStreams = this._shimmedLocalStreams || {};
    delete this._shimmedLocalStreams[stream.id];
    return origRemoveStream.apply(this, arguments);
  };
  const origRemoveTrack = window2.RTCPeerConnection.prototype.removeTrack;
  window2.RTCPeerConnection.prototype.removeTrack = function removeTrack(sender) {
    this._shimmedLocalStreams = this._shimmedLocalStreams || {};
    if (sender) {
      Object.keys(this._shimmedLocalStreams).forEach((streamId) => {
        const idx = this._shimmedLocalStreams[streamId].indexOf(sender);
        if (idx !== -1) {
          this._shimmedLocalStreams[streamId].splice(idx, 1);
        }
        if (this._shimmedLocalStreams[streamId].length === 1) {
          delete this._shimmedLocalStreams[streamId];
        }
      });
    }
    return origRemoveTrack.apply(this, arguments);
  };
}
function shimAddTrackRemoveTrack(window2, browserDetails) {
  if (!window2.RTCPeerConnection) {
    return;
  }
  if (window2.RTCPeerConnection.prototype.addTrack && browserDetails.version >= 65) {
    return shimAddTrackRemoveTrackWithNative(window2);
  }
  const origGetLocalStreams = window2.RTCPeerConnection.prototype.getLocalStreams;
  window2.RTCPeerConnection.prototype.getLocalStreams = function getLocalStreams() {
    const nativeStreams = origGetLocalStreams.apply(this);
    this._reverseStreams = this._reverseStreams || {};
    return nativeStreams.map((stream) => this._reverseStreams[stream.id]);
  };
  const origAddStream = window2.RTCPeerConnection.prototype.addStream;
  window2.RTCPeerConnection.prototype.addStream = function addStream(stream) {
    this._streams = this._streams || {};
    this._reverseStreams = this._reverseStreams || {};
    stream.getTracks().forEach((track) => {
      const alreadyExists = this.getSenders().find((s) => s.track === track);
      if (alreadyExists) {
        throw new DOMException(
          "Track already exists.",
          "InvalidAccessError"
        );
      }
    });
    if (!this._reverseStreams[stream.id]) {
      const newStream = new window2.MediaStream(stream.getTracks());
      this._streams[stream.id] = newStream;
      this._reverseStreams[newStream.id] = stream;
      stream = newStream;
    }
    origAddStream.apply(this, [stream]);
  };
  const origRemoveStream = window2.RTCPeerConnection.prototype.removeStream;
  window2.RTCPeerConnection.prototype.removeStream = function removeStream(stream) {
    this._streams = this._streams || {};
    this._reverseStreams = this._reverseStreams || {};
    origRemoveStream.apply(this, [this._streams[stream.id] || stream]);
    delete this._reverseStreams[this._streams[stream.id] ? this._streams[stream.id].id : stream.id];
    delete this._streams[stream.id];
  };
  window2.RTCPeerConnection.prototype.addTrack = function addTrack(track, stream) {
    if (this.signalingState === "closed") {
      throw new DOMException(
        "The RTCPeerConnection's signalingState is 'closed'.",
        "InvalidStateError"
      );
    }
    const streams = [].slice.call(arguments, 1);
    if (streams.length !== 1 || !streams[0].getTracks().find((t) => t === track)) {
      throw new DOMException(
        "The adapter.js addTrack polyfill only supports a single  stream which is associated with the specified track.",
        "NotSupportedError"
      );
    }
    const alreadyExists = this.getSenders().find((s) => s.track === track);
    if (alreadyExists) {
      throw new DOMException(
        "Track already exists.",
        "InvalidAccessError"
      );
    }
    this._streams = this._streams || {};
    this._reverseStreams = this._reverseStreams || {};
    const oldStream = this._streams[stream.id];
    if (oldStream) {
      oldStream.addTrack(track);
      Promise.resolve().then(() => {
        this.dispatchEvent(new Event("negotiationneeded"));
      });
    } else {
      const newStream = new window2.MediaStream([track]);
      this._streams[stream.id] = newStream;
      this._reverseStreams[newStream.id] = stream;
      this.addStream(newStream);
    }
    return this.getSenders().find((s) => s.track === track);
  };
  function replaceInternalStreamId(pc, description) {
    let sdp2 = description.sdp;
    Object.keys(pc._reverseStreams || []).forEach((internalId) => {
      const externalStream = pc._reverseStreams[internalId];
      const internalStream = pc._streams[externalStream.id];
      sdp2 = sdp2.replace(
        new RegExp(internalStream.id, "g"),
        externalStream.id
      );
    });
    return new RTCSessionDescription({
      type: description.type,
      sdp: sdp2
    });
  }
  function replaceExternalStreamId(pc, description) {
    let sdp2 = description.sdp;
    Object.keys(pc._reverseStreams || []).forEach((internalId) => {
      const externalStream = pc._reverseStreams[internalId];
      const internalStream = pc._streams[externalStream.id];
      sdp2 = sdp2.replace(
        new RegExp(externalStream.id, "g"),
        internalStream.id
      );
    });
    return new RTCSessionDescription({
      type: description.type,
      sdp: sdp2
    });
  }
  ["createOffer", "createAnswer"].forEach(function(method) {
    const nativeMethod = window2.RTCPeerConnection.prototype[method];
    const methodObj = { [method]() {
      const args = arguments;
      const isLegacyCall = arguments.length && typeof arguments[0] === "function";
      if (isLegacyCall) {
        return nativeMethod.apply(this, [
          (description) => {
            const desc = replaceInternalStreamId(this, description);
            args[0].apply(null, [desc]);
          },
          (err) => {
            if (args[1]) {
              args[1].apply(null, err);
            }
          },
          arguments[2]
        ]);
      }
      return nativeMethod.apply(this, arguments).then((description) => replaceInternalStreamId(this, description));
    } };
    window2.RTCPeerConnection.prototype[method] = methodObj[method];
  });
  const origSetLocalDescription = window2.RTCPeerConnection.prototype.setLocalDescription;
  window2.RTCPeerConnection.prototype.setLocalDescription = function setLocalDescription() {
    if (!arguments.length || !arguments[0].type) {
      return origSetLocalDescription.apply(this, arguments);
    }
    arguments[0] = replaceExternalStreamId(this, arguments[0]);
    return origSetLocalDescription.apply(this, arguments);
  };
  const origLocalDescription = Object.getOwnPropertyDescriptor(
    window2.RTCPeerConnection.prototype,
    "localDescription"
  );
  Object.defineProperty(
    window2.RTCPeerConnection.prototype,
    "localDescription",
    {
      get() {
        const description = origLocalDescription.get.apply(this);
        if (description.type === "") {
          return description;
        }
        return replaceInternalStreamId(this, description);
      }
    }
  );
  window2.RTCPeerConnection.prototype.removeTrack = function removeTrack(sender) {
    if (this.signalingState === "closed") {
      throw new DOMException(
        "The RTCPeerConnection's signalingState is 'closed'.",
        "InvalidStateError"
      );
    }
    if (!sender._pc) {
      throw new DOMException("Argument 1 of RTCPeerConnection.removeTrack does not implement interface RTCRtpSender.", "TypeError");
    }
    const isLocal = sender._pc === this;
    if (!isLocal) {
      throw new DOMException(
        "Sender was not created by this connection.",
        "InvalidAccessError"
      );
    }
    this._streams = this._streams || {};
    let stream;
    Object.keys(this._streams).forEach((streamid) => {
      const hasTrack = this._streams[streamid].getTracks().find((track) => sender.track === track);
      if (hasTrack) {
        stream = this._streams[streamid];
      }
    });
    if (stream) {
      if (stream.getTracks().length === 1) {
        this.removeStream(this._reverseStreams[stream.id]);
      } else {
        stream.removeTrack(sender.track);
      }
      this.dispatchEvent(new Event("negotiationneeded"));
    }
  };
}
function shimPeerConnection$1(window2, browserDetails) {
  if (!window2.RTCPeerConnection && window2.webkitRTCPeerConnection) {
    window2.RTCPeerConnection = window2.webkitRTCPeerConnection;
  }
  if (!window2.RTCPeerConnection) {
    return;
  }
  if (browserDetails.version < 53) {
    ["setLocalDescription", "setRemoteDescription", "addIceCandidate"].forEach(function(method) {
      const nativeMethod = window2.RTCPeerConnection.prototype[method];
      const methodObj = { [method]() {
        arguments[0] = new (method === "addIceCandidate" ? window2.RTCIceCandidate : window2.RTCSessionDescription)(arguments[0]);
        return nativeMethod.apply(this, arguments);
      } };
      window2.RTCPeerConnection.prototype[method] = methodObj[method];
    });
  }
}
function fixNegotiationNeeded(window2, browserDetails) {
  wrapPeerConnectionEvent(window2, "negotiationneeded", (e2) => {
    const pc = e2.target;
    if (browserDetails.version < 72 || pc.getConfiguration && pc.getConfiguration().sdpSemantics === "plan-b") {
      if (pc.signalingState !== "stable") {
        return;
      }
    }
    return e2;
  });
}
const chromeShim = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  fixNegotiationNeeded,
  shimAddTrackRemoveTrack,
  shimAddTrackRemoveTrackWithNative,
  shimGetSendersWithDtmf,
  shimGetUserMedia: shimGetUserMedia$3,
  shimMediaStream,
  shimOnTrack: shimOnTrack$1,
  shimPeerConnection: shimPeerConnection$1,
  shimSenderReceiverGetStats
}, Symbol.toStringTag, { value: "Module" }));
function shimGetUserMedia$2(window2, browserDetails) {
  const navigator2 = window2 && window2.navigator;
  const MediaStreamTrack = window2 && window2.MediaStreamTrack;
  navigator2.getUserMedia = function(constraints, onSuccess, onError) {
    deprecated(
      "navigator.getUserMedia",
      "navigator.mediaDevices.getUserMedia"
    );
    navigator2.mediaDevices.getUserMedia(constraints).then(onSuccess, onError);
  };
  if (!(browserDetails.version > 55 && "autoGainControl" in navigator2.mediaDevices.getSupportedConstraints())) {
    const remap = function(obj, a, b) {
      if (a in obj && !(b in obj)) {
        obj[b] = obj[a];
        delete obj[a];
      }
    };
    const nativeGetUserMedia = navigator2.mediaDevices.getUserMedia.bind(navigator2.mediaDevices);
    navigator2.mediaDevices.getUserMedia = function(c) {
      if (typeof c === "object" && typeof c.audio === "object") {
        c = JSON.parse(JSON.stringify(c));
        remap(c.audio, "autoGainControl", "mozAutoGainControl");
        remap(c.audio, "noiseSuppression", "mozNoiseSuppression");
      }
      return nativeGetUserMedia(c);
    };
    if (MediaStreamTrack && MediaStreamTrack.prototype.getSettings) {
      const nativeGetSettings = MediaStreamTrack.prototype.getSettings;
      MediaStreamTrack.prototype.getSettings = function() {
        const obj = nativeGetSettings.apply(this, arguments);
        remap(obj, "mozAutoGainControl", "autoGainControl");
        remap(obj, "mozNoiseSuppression", "noiseSuppression");
        return obj;
      };
    }
    if (MediaStreamTrack && MediaStreamTrack.prototype.applyConstraints) {
      const nativeApplyConstraints = MediaStreamTrack.prototype.applyConstraints;
      MediaStreamTrack.prototype.applyConstraints = function(c) {
        if (this.kind === "audio" && typeof c === "object") {
          c = JSON.parse(JSON.stringify(c));
          remap(c, "autoGainControl", "mozAutoGainControl");
          remap(c, "noiseSuppression", "mozNoiseSuppression");
        }
        return nativeApplyConstraints.apply(this, [c]);
      };
    }
  }
}
function shimGetDisplayMedia(window2, preferredMediaSource) {
  if (window2.navigator.mediaDevices && "getDisplayMedia" in window2.navigator.mediaDevices) {
    return;
  }
  if (!window2.navigator.mediaDevices) {
    return;
  }
  window2.navigator.mediaDevices.getDisplayMedia = function getDisplayMedia(constraints) {
    if (!(constraints && constraints.video)) {
      const err = new DOMException("getDisplayMedia without video constraints is undefined");
      err.name = "NotFoundError";
      err.code = 8;
      return Promise.reject(err);
    }
    if (constraints.video === true) {
      constraints.video = { mediaSource: preferredMediaSource };
    } else {
      constraints.video.mediaSource = preferredMediaSource;
    }
    return window2.navigator.mediaDevices.getUserMedia(constraints);
  };
}
function shimOnTrack(window2) {
  if (typeof window2 === "object" && window2.RTCTrackEvent && "receiver" in window2.RTCTrackEvent.prototype && !("transceiver" in window2.RTCTrackEvent.prototype)) {
    Object.defineProperty(window2.RTCTrackEvent.prototype, "transceiver", {
      get() {
        return { receiver: this.receiver };
      }
    });
  }
}
function shimPeerConnection(window2, browserDetails) {
  if (typeof window2 !== "object" || !(window2.RTCPeerConnection || window2.mozRTCPeerConnection)) {
    return;
  }
  if (!window2.RTCPeerConnection && window2.mozRTCPeerConnection) {
    window2.RTCPeerConnection = window2.mozRTCPeerConnection;
  }
  if (browserDetails.version < 53) {
    ["setLocalDescription", "setRemoteDescription", "addIceCandidate"].forEach(function(method) {
      const nativeMethod = window2.RTCPeerConnection.prototype[method];
      const methodObj = { [method]() {
        arguments[0] = new (method === "addIceCandidate" ? window2.RTCIceCandidate : window2.RTCSessionDescription)(arguments[0]);
        return nativeMethod.apply(this, arguments);
      } };
      window2.RTCPeerConnection.prototype[method] = methodObj[method];
    });
  }
  const modernStatsTypes = {
    inboundrtp: "inbound-rtp",
    outboundrtp: "outbound-rtp",
    candidatepair: "candidate-pair",
    localcandidate: "local-candidate",
    remotecandidate: "remote-candidate"
  };
  const nativeGetStats = window2.RTCPeerConnection.prototype.getStats;
  window2.RTCPeerConnection.prototype.getStats = function getStats() {
    const [selector, onSucc, onErr] = arguments;
    return nativeGetStats.apply(this, [selector || null]).then((stats) => {
      if (browserDetails.version < 53 && !onSucc) {
        try {
          stats.forEach((stat) => {
            stat.type = modernStatsTypes[stat.type] || stat.type;
          });
        } catch (e2) {
          if (e2.name !== "TypeError") {
            throw e2;
          }
          stats.forEach((stat, i) => {
            stats.set(i, Object.assign({}, stat, {
              type: modernStatsTypes[stat.type] || stat.type
            }));
          });
        }
      }
      return stats;
    }).then(onSucc, onErr);
  };
}
function shimSenderGetStats(window2) {
  if (!(typeof window2 === "object" && window2.RTCPeerConnection && window2.RTCRtpSender)) {
    return;
  }
  if (window2.RTCRtpSender && "getStats" in window2.RTCRtpSender.prototype) {
    return;
  }
  const origGetSenders = window2.RTCPeerConnection.prototype.getSenders;
  if (origGetSenders) {
    window2.RTCPeerConnection.prototype.getSenders = function getSenders() {
      const senders = origGetSenders.apply(this, []);
      senders.forEach((sender) => sender._pc = this);
      return senders;
    };
  }
  const origAddTrack = window2.RTCPeerConnection.prototype.addTrack;
  if (origAddTrack) {
    window2.RTCPeerConnection.prototype.addTrack = function addTrack() {
      const sender = origAddTrack.apply(this, arguments);
      sender._pc = this;
      return sender;
    };
  }
  window2.RTCRtpSender.prototype.getStats = function getStats() {
    return this.track ? this._pc.getStats(this.track) : Promise.resolve(/* @__PURE__ */ new Map());
  };
}
function shimReceiverGetStats(window2) {
  if (!(typeof window2 === "object" && window2.RTCPeerConnection && window2.RTCRtpSender)) {
    return;
  }
  if (window2.RTCRtpSender && "getStats" in window2.RTCRtpReceiver.prototype) {
    return;
  }
  const origGetReceivers = window2.RTCPeerConnection.prototype.getReceivers;
  if (origGetReceivers) {
    window2.RTCPeerConnection.prototype.getReceivers = function getReceivers() {
      const receivers = origGetReceivers.apply(this, []);
      receivers.forEach((receiver) => receiver._pc = this);
      return receivers;
    };
  }
  wrapPeerConnectionEvent(window2, "track", (e2) => {
    e2.receiver._pc = e2.srcElement;
    return e2;
  });
  window2.RTCRtpReceiver.prototype.getStats = function getStats() {
    return this._pc.getStats(this.track);
  };
}
function shimRemoveStream(window2) {
  if (!window2.RTCPeerConnection || "removeStream" in window2.RTCPeerConnection.prototype) {
    return;
  }
  window2.RTCPeerConnection.prototype.removeStream = function removeStream(stream) {
    deprecated("removeStream", "removeTrack");
    this.getSenders().forEach((sender) => {
      if (sender.track && stream.getTracks().includes(sender.track)) {
        this.removeTrack(sender);
      }
    });
  };
}
function shimRTCDataChannel(window2) {
  if (window2.DataChannel && !window2.RTCDataChannel) {
    window2.RTCDataChannel = window2.DataChannel;
  }
}
function shimAddTransceiver(window2) {
  if (!(typeof window2 === "object" && window2.RTCPeerConnection)) {
    return;
  }
  const origAddTransceiver = window2.RTCPeerConnection.prototype.addTransceiver;
  if (origAddTransceiver) {
    window2.RTCPeerConnection.prototype.addTransceiver = function addTransceiver() {
      this.setParametersPromises = [];
      let sendEncodings = arguments[1] && arguments[1].sendEncodings;
      if (sendEncodings === void 0) {
        sendEncodings = [];
      }
      sendEncodings = [...sendEncodings];
      const shouldPerformCheck = sendEncodings.length > 0;
      if (shouldPerformCheck) {
        sendEncodings.forEach((encodingParam) => {
          if ("rid" in encodingParam) {
            const ridRegex = /^[a-z0-9]{0,16}$/i;
            if (!ridRegex.test(encodingParam.rid)) {
              throw new TypeError("Invalid RID value provided.");
            }
          }
          if ("scaleResolutionDownBy" in encodingParam) {
            if (!(parseFloat(encodingParam.scaleResolutionDownBy) >= 1)) {
              throw new RangeError("scale_resolution_down_by must be >= 1.0");
            }
          }
          if ("maxFramerate" in encodingParam) {
            if (!(parseFloat(encodingParam.maxFramerate) >= 0)) {
              throw new RangeError("max_framerate must be >= 0.0");
            }
          }
        });
      }
      const transceiver = origAddTransceiver.apply(this, arguments);
      if (shouldPerformCheck) {
        const { sender } = transceiver;
        const params = sender.getParameters();
        if (!("encodings" in params) || // Avoid being fooled by patched getParameters() below.
        params.encodings.length === 1 && Object.keys(params.encodings[0]).length === 0) {
          params.encodings = sendEncodings;
          sender.sendEncodings = sendEncodings;
          this.setParametersPromises.push(
            sender.setParameters(params).then(() => {
              delete sender.sendEncodings;
            }).catch(() => {
              delete sender.sendEncodings;
            })
          );
        }
      }
      return transceiver;
    };
  }
}
function shimGetParameters(window2) {
  if (!(typeof window2 === "object" && window2.RTCRtpSender)) {
    return;
  }
  const origGetParameters = window2.RTCRtpSender.prototype.getParameters;
  if (origGetParameters) {
    window2.RTCRtpSender.prototype.getParameters = function getParameters() {
      const params = origGetParameters.apply(this, arguments);
      if (!("encodings" in params)) {
        params.encodings = [].concat(this.sendEncodings || [{}]);
      }
      return params;
    };
  }
}
function shimCreateOffer(window2) {
  if (!(typeof window2 === "object" && window2.RTCPeerConnection)) {
    return;
  }
  const origCreateOffer = window2.RTCPeerConnection.prototype.createOffer;
  window2.RTCPeerConnection.prototype.createOffer = function createOffer() {
    if (this.setParametersPromises && this.setParametersPromises.length) {
      return Promise.all(this.setParametersPromises).then(() => {
        return origCreateOffer.apply(this, arguments);
      }).finally(() => {
        this.setParametersPromises = [];
      });
    }
    return origCreateOffer.apply(this, arguments);
  };
}
function shimCreateAnswer(window2) {
  if (!(typeof window2 === "object" && window2.RTCPeerConnection)) {
    return;
  }
  const origCreateAnswer = window2.RTCPeerConnection.prototype.createAnswer;
  window2.RTCPeerConnection.prototype.createAnswer = function createAnswer() {
    if (this.setParametersPromises && this.setParametersPromises.length) {
      return Promise.all(this.setParametersPromises).then(() => {
        return origCreateAnswer.apply(this, arguments);
      }).finally(() => {
        this.setParametersPromises = [];
      });
    }
    return origCreateAnswer.apply(this, arguments);
  };
}
const firefoxShim = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  shimAddTransceiver,
  shimCreateAnswer,
  shimCreateOffer,
  shimGetDisplayMedia,
  shimGetParameters,
  shimGetUserMedia: shimGetUserMedia$2,
  shimOnTrack,
  shimPeerConnection,
  shimRTCDataChannel,
  shimReceiverGetStats,
  shimRemoveStream,
  shimSenderGetStats
}, Symbol.toStringTag, { value: "Module" }));
function shimLocalStreamsAPI(window2) {
  if (typeof window2 !== "object" || !window2.RTCPeerConnection) {
    return;
  }
  if (!("getLocalStreams" in window2.RTCPeerConnection.prototype)) {
    window2.RTCPeerConnection.prototype.getLocalStreams = function getLocalStreams() {
      if (!this._localStreams) {
        this._localStreams = [];
      }
      return this._localStreams;
    };
  }
  if (!("addStream" in window2.RTCPeerConnection.prototype)) {
    const _addTrack = window2.RTCPeerConnection.prototype.addTrack;
    window2.RTCPeerConnection.prototype.addStream = function addStream(stream) {
      if (!this._localStreams) {
        this._localStreams = [];
      }
      if (!this._localStreams.includes(stream)) {
        this._localStreams.push(stream);
      }
      stream.getAudioTracks().forEach((track) => _addTrack.call(
        this,
        track,
        stream
      ));
      stream.getVideoTracks().forEach((track) => _addTrack.call(
        this,
        track,
        stream
      ));
    };
    window2.RTCPeerConnection.prototype.addTrack = function addTrack(track, ...streams) {
      if (streams) {
        streams.forEach((stream) => {
          if (!this._localStreams) {
            this._localStreams = [stream];
          } else if (!this._localStreams.includes(stream)) {
            this._localStreams.push(stream);
          }
        });
      }
      return _addTrack.apply(this, arguments);
    };
  }
  if (!("removeStream" in window2.RTCPeerConnection.prototype)) {
    window2.RTCPeerConnection.prototype.removeStream = function removeStream(stream) {
      if (!this._localStreams) {
        this._localStreams = [];
      }
      const index = this._localStreams.indexOf(stream);
      if (index === -1) {
        return;
      }
      this._localStreams.splice(index, 1);
      const tracks = stream.getTracks();
      this.getSenders().forEach((sender) => {
        if (tracks.includes(sender.track)) {
          this.removeTrack(sender);
        }
      });
    };
  }
}
function shimRemoteStreamsAPI(window2) {
  if (typeof window2 !== "object" || !window2.RTCPeerConnection) {
    return;
  }
  if (!("getRemoteStreams" in window2.RTCPeerConnection.prototype)) {
    window2.RTCPeerConnection.prototype.getRemoteStreams = function getRemoteStreams() {
      return this._remoteStreams ? this._remoteStreams : [];
    };
  }
  if (!("onaddstream" in window2.RTCPeerConnection.prototype)) {
    Object.defineProperty(window2.RTCPeerConnection.prototype, "onaddstream", {
      get() {
        return this._onaddstream;
      },
      set(f) {
        if (this._onaddstream) {
          this.removeEventListener("addstream", this._onaddstream);
          this.removeEventListener("track", this._onaddstreampoly);
        }
        this.addEventListener("addstream", this._onaddstream = f);
        this.addEventListener("track", this._onaddstreampoly = (e2) => {
          e2.streams.forEach((stream) => {
            if (!this._remoteStreams) {
              this._remoteStreams = [];
            }
            if (this._remoteStreams.includes(stream)) {
              return;
            }
            this._remoteStreams.push(stream);
            const event = new Event("addstream");
            event.stream = stream;
            this.dispatchEvent(event);
          });
        });
      }
    });
    const origSetRemoteDescription = window2.RTCPeerConnection.prototype.setRemoteDescription;
    window2.RTCPeerConnection.prototype.setRemoteDescription = function setRemoteDescription() {
      const pc = this;
      if (!this._onaddstreampoly) {
        this.addEventListener("track", this._onaddstreampoly = function(e2) {
          e2.streams.forEach((stream) => {
            if (!pc._remoteStreams) {
              pc._remoteStreams = [];
            }
            if (pc._remoteStreams.indexOf(stream) >= 0) {
              return;
            }
            pc._remoteStreams.push(stream);
            const event = new Event("addstream");
            event.stream = stream;
            pc.dispatchEvent(event);
          });
        });
      }
      return origSetRemoteDescription.apply(pc, arguments);
    };
  }
}
function shimCallbacksAPI(window2) {
  if (typeof window2 !== "object" || !window2.RTCPeerConnection) {
    return;
  }
  const prototype = window2.RTCPeerConnection.prototype;
  const origCreateOffer = prototype.createOffer;
  const origCreateAnswer = prototype.createAnswer;
  const setLocalDescription = prototype.setLocalDescription;
  const setRemoteDescription = prototype.setRemoteDescription;
  const addIceCandidate = prototype.addIceCandidate;
  prototype.createOffer = function createOffer(successCallback, failureCallback) {
    const options = arguments.length >= 2 ? arguments[2] : arguments[0];
    const promise = origCreateOffer.apply(this, [options]);
    if (!failureCallback) {
      return promise;
    }
    promise.then(successCallback, failureCallback);
    return Promise.resolve();
  };
  prototype.createAnswer = function createAnswer(successCallback, failureCallback) {
    const options = arguments.length >= 2 ? arguments[2] : arguments[0];
    const promise = origCreateAnswer.apply(this, [options]);
    if (!failureCallback) {
      return promise;
    }
    promise.then(successCallback, failureCallback);
    return Promise.resolve();
  };
  let withCallback = function(description, successCallback, failureCallback) {
    const promise = setLocalDescription.apply(this, [description]);
    if (!failureCallback) {
      return promise;
    }
    promise.then(successCallback, failureCallback);
    return Promise.resolve();
  };
  prototype.setLocalDescription = withCallback;
  withCallback = function(description, successCallback, failureCallback) {
    const promise = setRemoteDescription.apply(this, [description]);
    if (!failureCallback) {
      return promise;
    }
    promise.then(successCallback, failureCallback);
    return Promise.resolve();
  };
  prototype.setRemoteDescription = withCallback;
  withCallback = function(candidate, successCallback, failureCallback) {
    const promise = addIceCandidate.apply(this, [candidate]);
    if (!failureCallback) {
      return promise;
    }
    promise.then(successCallback, failureCallback);
    return Promise.resolve();
  };
  prototype.addIceCandidate = withCallback;
}
function shimGetUserMedia$1(window2) {
  const navigator2 = window2 && window2.navigator;
  if (navigator2.mediaDevices && navigator2.mediaDevices.getUserMedia) {
    const mediaDevices = navigator2.mediaDevices;
    const _getUserMedia = mediaDevices.getUserMedia.bind(mediaDevices);
    navigator2.mediaDevices.getUserMedia = (constraints) => {
      return _getUserMedia(shimConstraints(constraints));
    };
  }
  if (!navigator2.getUserMedia && navigator2.mediaDevices && navigator2.mediaDevices.getUserMedia) {
    navigator2.getUserMedia = (function getUserMedia(constraints, cb, errcb) {
      navigator2.mediaDevices.getUserMedia(constraints).then(cb, errcb);
    }).bind(navigator2);
  }
}
function shimConstraints(constraints) {
  if (constraints && constraints.video !== void 0) {
    return Object.assign(
      {},
      constraints,
      { video: compactObject(constraints.video) }
    );
  }
  return constraints;
}
function shimRTCIceServerUrls(window2) {
  if (!window2.RTCPeerConnection) {
    return;
  }
  const OrigPeerConnection = window2.RTCPeerConnection;
  window2.RTCPeerConnection = function RTCPeerConnection(pcConfig, pcConstraints) {
    if (pcConfig && pcConfig.iceServers) {
      const newIceServers = [];
      for (let i = 0; i < pcConfig.iceServers.length; i++) {
        let server = pcConfig.iceServers[i];
        if (server.urls === void 0 && server.url) {
          deprecated("RTCIceServer.url", "RTCIceServer.urls");
          server = JSON.parse(JSON.stringify(server));
          server.urls = server.url;
          delete server.url;
          newIceServers.push(server);
        } else {
          newIceServers.push(pcConfig.iceServers[i]);
        }
      }
      pcConfig.iceServers = newIceServers;
    }
    return new OrigPeerConnection(pcConfig, pcConstraints);
  };
  window2.RTCPeerConnection.prototype = OrigPeerConnection.prototype;
  if ("generateCertificate" in OrigPeerConnection) {
    Object.defineProperty(window2.RTCPeerConnection, "generateCertificate", {
      get() {
        return OrigPeerConnection.generateCertificate;
      }
    });
  }
}
function shimTrackEventTransceiver(window2) {
  if (typeof window2 === "object" && window2.RTCTrackEvent && "receiver" in window2.RTCTrackEvent.prototype && !("transceiver" in window2.RTCTrackEvent.prototype)) {
    Object.defineProperty(window2.RTCTrackEvent.prototype, "transceiver", {
      get() {
        return { receiver: this.receiver };
      }
    });
  }
}
function shimCreateOfferLegacy(window2) {
  const origCreateOffer = window2.RTCPeerConnection.prototype.createOffer;
  window2.RTCPeerConnection.prototype.createOffer = function createOffer(offerOptions) {
    if (offerOptions) {
      if (typeof offerOptions.offerToReceiveAudio !== "undefined") {
        offerOptions.offerToReceiveAudio = !!offerOptions.offerToReceiveAudio;
      }
      const audioTransceiver = this.getTransceivers().find((transceiver) => transceiver.receiver.track.kind === "audio");
      if (offerOptions.offerToReceiveAudio === false && audioTransceiver) {
        if (audioTransceiver.direction === "sendrecv") {
          if (audioTransceiver.setDirection) {
            audioTransceiver.setDirection("sendonly");
          } else {
            audioTransceiver.direction = "sendonly";
          }
        } else if (audioTransceiver.direction === "recvonly") {
          if (audioTransceiver.setDirection) {
            audioTransceiver.setDirection("inactive");
          } else {
            audioTransceiver.direction = "inactive";
          }
        }
      } else if (offerOptions.offerToReceiveAudio === true && !audioTransceiver) {
        this.addTransceiver("audio", { direction: "recvonly" });
      }
      if (typeof offerOptions.offerToReceiveVideo !== "undefined") {
        offerOptions.offerToReceiveVideo = !!offerOptions.offerToReceiveVideo;
      }
      const videoTransceiver = this.getTransceivers().find((transceiver) => transceiver.receiver.track.kind === "video");
      if (offerOptions.offerToReceiveVideo === false && videoTransceiver) {
        if (videoTransceiver.direction === "sendrecv") {
          if (videoTransceiver.setDirection) {
            videoTransceiver.setDirection("sendonly");
          } else {
            videoTransceiver.direction = "sendonly";
          }
        } else if (videoTransceiver.direction === "recvonly") {
          if (videoTransceiver.setDirection) {
            videoTransceiver.setDirection("inactive");
          } else {
            videoTransceiver.direction = "inactive";
          }
        }
      } else if (offerOptions.offerToReceiveVideo === true && !videoTransceiver) {
        this.addTransceiver("video", { direction: "recvonly" });
      }
    }
    return origCreateOffer.apply(this, arguments);
  };
}
function shimAudioContext(window2) {
  if (typeof window2 !== "object" || window2.AudioContext) {
    return;
  }
  window2.AudioContext = window2.webkitAudioContext;
}
const safariShim = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  shimAudioContext,
  shimCallbacksAPI,
  shimConstraints,
  shimCreateOfferLegacy,
  shimGetUserMedia: shimGetUserMedia$1,
  shimLocalStreamsAPI,
  shimRTCIceServerUrls,
  shimRemoteStreamsAPI,
  shimTrackEventTransceiver
}, Symbol.toStringTag, { value: "Module" }));
var sdp$1 = { exports: {} };
(function(module) {
  const SDPUtils2 = {};
  SDPUtils2.generateIdentifier = function() {
    return Math.random().toString(36).substring(2, 12);
  };
  SDPUtils2.localCName = SDPUtils2.generateIdentifier();
  SDPUtils2.splitLines = function(blob) {
    return blob.trim().split("\n").map((line) => line.trim());
  };
  SDPUtils2.splitSections = function(blob) {
    const parts = blob.split("\nm=");
    return parts.map((part, index) => (index > 0 ? "m=" + part : part).trim() + "\r\n");
  };
  SDPUtils2.getDescription = function(blob) {
    const sections = SDPUtils2.splitSections(blob);
    return sections && sections[0];
  };
  SDPUtils2.getMediaSections = function(blob) {
    const sections = SDPUtils2.splitSections(blob);
    sections.shift();
    return sections;
  };
  SDPUtils2.matchPrefix = function(blob, prefix) {
    return SDPUtils2.splitLines(blob).filter((line) => line.indexOf(prefix) === 0);
  };
  SDPUtils2.parseCandidate = function(line) {
    let parts;
    if (line.indexOf("a=candidate:") === 0) {
      parts = line.substring(12).split(" ");
    } else {
      parts = line.substring(10).split(" ");
    }
    const candidate = {
      foundation: parts[0],
      component: { 1: "rtp", 2: "rtcp" }[parts[1]] || parts[1],
      protocol: parts[2].toLowerCase(),
      priority: parseInt(parts[3], 10),
      ip: parts[4],
      address: parts[4],
      // address is an alias for ip.
      port: parseInt(parts[5], 10),
      // skip parts[6] == 'typ'
      type: parts[7]
    };
    for (let i = 8; i < parts.length; i += 2) {
      switch (parts[i]) {
        case "raddr":
          candidate.relatedAddress = parts[i + 1];
          break;
        case "rport":
          candidate.relatedPort = parseInt(parts[i + 1], 10);
          break;
        case "tcptype":
          candidate.tcpType = parts[i + 1];
          break;
        case "ufrag":
          candidate.ufrag = parts[i + 1];
          candidate.usernameFragment = parts[i + 1];
          break;
        default:
          if (candidate[parts[i]] === void 0) {
            candidate[parts[i]] = parts[i + 1];
          }
          break;
      }
    }
    return candidate;
  };
  SDPUtils2.writeCandidate = function(candidate) {
    const sdp2 = [];
    sdp2.push(candidate.foundation);
    const component = candidate.component;
    if (component === "rtp") {
      sdp2.push(1);
    } else if (component === "rtcp") {
      sdp2.push(2);
    } else {
      sdp2.push(component);
    }
    sdp2.push(candidate.protocol.toUpperCase());
    sdp2.push(candidate.priority);
    sdp2.push(candidate.address || candidate.ip);
    sdp2.push(candidate.port);
    const type = candidate.type;
    sdp2.push("typ");
    sdp2.push(type);
    if (type !== "host" && candidate.relatedAddress && candidate.relatedPort) {
      sdp2.push("raddr");
      sdp2.push(candidate.relatedAddress);
      sdp2.push("rport");
      sdp2.push(candidate.relatedPort);
    }
    if (candidate.tcpType && candidate.protocol.toLowerCase() === "tcp") {
      sdp2.push("tcptype");
      sdp2.push(candidate.tcpType);
    }
    if (candidate.usernameFragment || candidate.ufrag) {
      sdp2.push("ufrag");
      sdp2.push(candidate.usernameFragment || candidate.ufrag);
    }
    return "candidate:" + sdp2.join(" ");
  };
  SDPUtils2.parseIceOptions = function(line) {
    return line.substring(14).split(" ");
  };
  SDPUtils2.parseRtpMap = function(line) {
    let parts = line.substring(9).split(" ");
    const parsed = {
      payloadType: parseInt(parts.shift(), 10)
      // was: id
    };
    parts = parts[0].split("/");
    parsed.name = parts[0];
    parsed.clockRate = parseInt(parts[1], 10);
    parsed.channels = parts.length === 3 ? parseInt(parts[2], 10) : 1;
    parsed.numChannels = parsed.channels;
    return parsed;
  };
  SDPUtils2.writeRtpMap = function(codec) {
    let pt = codec.payloadType;
    if (codec.preferredPayloadType !== void 0) {
      pt = codec.preferredPayloadType;
    }
    const channels = codec.channels || codec.numChannels || 1;
    return "a=rtpmap:" + pt + " " + codec.name + "/" + codec.clockRate + (channels !== 1 ? "/" + channels : "") + "\r\n";
  };
  SDPUtils2.parseExtmap = function(line) {
    const parts = line.substring(9).split(" ");
    return {
      id: parseInt(parts[0], 10),
      direction: parts[0].indexOf("/") > 0 ? parts[0].split("/")[1] : "sendrecv",
      uri: parts[1],
      attributes: parts.slice(2).join(" ")
    };
  };
  SDPUtils2.writeExtmap = function(headerExtension) {
    return "a=extmap:" + (headerExtension.id || headerExtension.preferredId) + (headerExtension.direction && headerExtension.direction !== "sendrecv" ? "/" + headerExtension.direction : "") + " " + headerExtension.uri + (headerExtension.attributes ? " " + headerExtension.attributes : "") + "\r\n";
  };
  SDPUtils2.parseFmtp = function(line) {
    const parsed = {};
    let kv;
    const parts = line.substring(line.indexOf(" ") + 1).split(";");
    for (let j = 0; j < parts.length; j++) {
      kv = parts[j].trim().split("=");
      parsed[kv[0].trim()] = kv[1];
    }
    return parsed;
  };
  SDPUtils2.writeFmtp = function(codec) {
    let line = "";
    let pt = codec.payloadType;
    if (codec.preferredPayloadType !== void 0) {
      pt = codec.preferredPayloadType;
    }
    if (codec.parameters && Object.keys(codec.parameters).length) {
      const params = [];
      Object.keys(codec.parameters).forEach((param) => {
        if (codec.parameters[param] !== void 0) {
          params.push(param + "=" + codec.parameters[param]);
        } else {
          params.push(param);
        }
      });
      line += "a=fmtp:" + pt + " " + params.join(";") + "\r\n";
    }
    return line;
  };
  SDPUtils2.parseRtcpFb = function(line) {
    const parts = line.substring(line.indexOf(" ") + 1).split(" ");
    return {
      type: parts.shift(),
      parameter: parts.join(" ")
    };
  };
  SDPUtils2.writeRtcpFb = function(codec) {
    let lines = "";
    let pt = codec.payloadType;
    if (codec.preferredPayloadType !== void 0) {
      pt = codec.preferredPayloadType;
    }
    if (codec.rtcpFeedback && codec.rtcpFeedback.length) {
      codec.rtcpFeedback.forEach((fb) => {
        lines += "a=rtcp-fb:" + pt + " " + fb.type + (fb.parameter && fb.parameter.length ? " " + fb.parameter : "") + "\r\n";
      });
    }
    return lines;
  };
  SDPUtils2.parseSsrcMedia = function(line) {
    const sp = line.indexOf(" ");
    const parts = {
      ssrc: parseInt(line.substring(7, sp), 10)
    };
    const colon = line.indexOf(":", sp);
    if (colon > -1) {
      parts.attribute = line.substring(sp + 1, colon);
      parts.value = line.substring(colon + 1);
    } else {
      parts.attribute = line.substring(sp + 1);
    }
    return parts;
  };
  SDPUtils2.parseSsrcGroup = function(line) {
    const parts = line.substring(13).split(" ");
    return {
      semantics: parts.shift(),
      ssrcs: parts.map((ssrc) => parseInt(ssrc, 10))
    };
  };
  SDPUtils2.getMid = function(mediaSection) {
    const mid = SDPUtils2.matchPrefix(mediaSection, "a=mid:")[0];
    if (mid) {
      return mid.substring(6);
    }
  };
  SDPUtils2.parseFingerprint = function(line) {
    const parts = line.substring(14).split(" ");
    return {
      algorithm: parts[0].toLowerCase(),
      // algorithm is case-sensitive in Edge.
      value: parts[1].toUpperCase()
      // the definition is upper-case in RFC 4572.
    };
  };
  SDPUtils2.getDtlsParameters = function(mediaSection, sessionpart) {
    const lines = SDPUtils2.matchPrefix(
      mediaSection + sessionpart,
      "a=fingerprint:"
    );
    return {
      role: "auto",
      fingerprints: lines.map(SDPUtils2.parseFingerprint)
    };
  };
  SDPUtils2.writeDtlsParameters = function(params, setupType) {
    let sdp2 = "a=setup:" + setupType + "\r\n";
    params.fingerprints.forEach((fp) => {
      sdp2 += "a=fingerprint:" + fp.algorithm + " " + fp.value + "\r\n";
    });
    return sdp2;
  };
  SDPUtils2.parseCryptoLine = function(line) {
    const parts = line.substring(9).split(" ");
    return {
      tag: parseInt(parts[0], 10),
      cryptoSuite: parts[1],
      keyParams: parts[2],
      sessionParams: parts.slice(3)
    };
  };
  SDPUtils2.writeCryptoLine = function(parameters) {
    return "a=crypto:" + parameters.tag + " " + parameters.cryptoSuite + " " + (typeof parameters.keyParams === "object" ? SDPUtils2.writeCryptoKeyParams(parameters.keyParams) : parameters.keyParams) + (parameters.sessionParams ? " " + parameters.sessionParams.join(" ") : "") + "\r\n";
  };
  SDPUtils2.parseCryptoKeyParams = function(keyParams) {
    if (keyParams.indexOf("inline:") !== 0) {
      return null;
    }
    const parts = keyParams.substring(7).split("|");
    return {
      keyMethod: "inline",
      keySalt: parts[0],
      lifeTime: parts[1],
      mkiValue: parts[2] ? parts[2].split(":")[0] : void 0,
      mkiLength: parts[2] ? parts[2].split(":")[1] : void 0
    };
  };
  SDPUtils2.writeCryptoKeyParams = function(keyParams) {
    return keyParams.keyMethod + ":" + keyParams.keySalt + (keyParams.lifeTime ? "|" + keyParams.lifeTime : "") + (keyParams.mkiValue && keyParams.mkiLength ? "|" + keyParams.mkiValue + ":" + keyParams.mkiLength : "");
  };
  SDPUtils2.getCryptoParameters = function(mediaSection, sessionpart) {
    const lines = SDPUtils2.matchPrefix(
      mediaSection + sessionpart,
      "a=crypto:"
    );
    return lines.map(SDPUtils2.parseCryptoLine);
  };
  SDPUtils2.getIceParameters = function(mediaSection, sessionpart) {
    const ufrag = SDPUtils2.matchPrefix(
      mediaSection + sessionpart,
      "a=ice-ufrag:"
    )[0];
    const pwd = SDPUtils2.matchPrefix(
      mediaSection + sessionpart,
      "a=ice-pwd:"
    )[0];
    if (!(ufrag && pwd)) {
      return null;
    }
    return {
      usernameFragment: ufrag.substring(12),
      password: pwd.substring(10)
    };
  };
  SDPUtils2.writeIceParameters = function(params) {
    let sdp2 = "a=ice-ufrag:" + params.usernameFragment + "\r\na=ice-pwd:" + params.password + "\r\n";
    if (params.iceLite) {
      sdp2 += "a=ice-lite\r\n";
    }
    return sdp2;
  };
  SDPUtils2.parseRtpParameters = function(mediaSection) {
    const description = {
      codecs: [],
      headerExtensions: [],
      fecMechanisms: [],
      rtcp: []
    };
    const lines = SDPUtils2.splitLines(mediaSection);
    const mline = lines[0].split(" ");
    description.profile = mline[2];
    for (let i = 3; i < mline.length; i++) {
      const pt = mline[i];
      const rtpmapline = SDPUtils2.matchPrefix(
        mediaSection,
        "a=rtpmap:" + pt + " "
      )[0];
      if (rtpmapline) {
        const codec = SDPUtils2.parseRtpMap(rtpmapline);
        const fmtps = SDPUtils2.matchPrefix(
          mediaSection,
          "a=fmtp:" + pt + " "
        );
        codec.parameters = fmtps.length ? SDPUtils2.parseFmtp(fmtps[0]) : {};
        codec.rtcpFeedback = SDPUtils2.matchPrefix(
          mediaSection,
          "a=rtcp-fb:" + pt + " "
        ).map(SDPUtils2.parseRtcpFb);
        description.codecs.push(codec);
        switch (codec.name.toUpperCase()) {
          case "RED":
          case "ULPFEC":
            description.fecMechanisms.push(codec.name.toUpperCase());
            break;
        }
      }
    }
    SDPUtils2.matchPrefix(mediaSection, "a=extmap:").forEach((line) => {
      description.headerExtensions.push(SDPUtils2.parseExtmap(line));
    });
    const wildcardRtcpFb = SDPUtils2.matchPrefix(mediaSection, "a=rtcp-fb:* ").map(SDPUtils2.parseRtcpFb);
    description.codecs.forEach((codec) => {
      wildcardRtcpFb.forEach((fb) => {
        const duplicate = codec.rtcpFeedback.find((existingFeedback) => {
          return existingFeedback.type === fb.type && existingFeedback.parameter === fb.parameter;
        });
        if (!duplicate) {
          codec.rtcpFeedback.push(fb);
        }
      });
    });
    return description;
  };
  SDPUtils2.writeRtpDescription = function(kind, caps) {
    let sdp2 = "";
    sdp2 += "m=" + kind + " ";
    sdp2 += caps.codecs.length > 0 ? "9" : "0";
    sdp2 += " " + (caps.profile || "UDP/TLS/RTP/SAVPF") + " ";
    sdp2 += caps.codecs.map((codec) => {
      if (codec.preferredPayloadType !== void 0) {
        return codec.preferredPayloadType;
      }
      return codec.payloadType;
    }).join(" ") + "\r\n";
    sdp2 += "c=IN IP4 0.0.0.0\r\n";
    sdp2 += "a=rtcp:9 IN IP4 0.0.0.0\r\n";
    caps.codecs.forEach((codec) => {
      sdp2 += SDPUtils2.writeRtpMap(codec);
      sdp2 += SDPUtils2.writeFmtp(codec);
      sdp2 += SDPUtils2.writeRtcpFb(codec);
    });
    let maxptime = 0;
    caps.codecs.forEach((codec) => {
      if (codec.maxptime > maxptime) {
        maxptime = codec.maxptime;
      }
    });
    if (maxptime > 0) {
      sdp2 += "a=maxptime:" + maxptime + "\r\n";
    }
    if (caps.headerExtensions) {
      caps.headerExtensions.forEach((extension) => {
        sdp2 += SDPUtils2.writeExtmap(extension);
      });
    }
    return sdp2;
  };
  SDPUtils2.parseRtpEncodingParameters = function(mediaSection) {
    const encodingParameters = [];
    const description = SDPUtils2.parseRtpParameters(mediaSection);
    const hasRed = description.fecMechanisms.indexOf("RED") !== -1;
    const hasUlpfec = description.fecMechanisms.indexOf("ULPFEC") !== -1;
    const ssrcs = SDPUtils2.matchPrefix(mediaSection, "a=ssrc:").map((line) => SDPUtils2.parseSsrcMedia(line)).filter((parts) => parts.attribute === "cname");
    const primarySsrc = ssrcs.length > 0 && ssrcs[0].ssrc;
    let secondarySsrc;
    const flows = SDPUtils2.matchPrefix(mediaSection, "a=ssrc-group:FID").map((line) => {
      const parts = line.substring(17).split(" ");
      return parts.map((part) => parseInt(part, 10));
    });
    if (flows.length > 0 && flows[0].length > 1 && flows[0][0] === primarySsrc) {
      secondarySsrc = flows[0][1];
    }
    description.codecs.forEach((codec) => {
      if (codec.name.toUpperCase() === "RTX" && codec.parameters.apt) {
        let encParam = {
          ssrc: primarySsrc,
          codecPayloadType: parseInt(codec.parameters.apt, 10)
        };
        if (primarySsrc && secondarySsrc) {
          encParam.rtx = { ssrc: secondarySsrc };
        }
        encodingParameters.push(encParam);
        if (hasRed) {
          encParam = JSON.parse(JSON.stringify(encParam));
          encParam.fec = {
            ssrc: primarySsrc,
            mechanism: hasUlpfec ? "red+ulpfec" : "red"
          };
          encodingParameters.push(encParam);
        }
      }
    });
    if (encodingParameters.length === 0 && primarySsrc) {
      encodingParameters.push({
        ssrc: primarySsrc
      });
    }
    let bandwidth = SDPUtils2.matchPrefix(mediaSection, "b=");
    if (bandwidth.length) {
      if (bandwidth[0].indexOf("b=TIAS:") === 0) {
        bandwidth = parseInt(bandwidth[0].substring(7), 10);
      } else if (bandwidth[0].indexOf("b=AS:") === 0) {
        bandwidth = parseInt(bandwidth[0].substring(5), 10) * 1e3 * 0.95 - 50 * 40 * 8;
      } else {
        bandwidth = void 0;
      }
      encodingParameters.forEach((params) => {
        params.maxBitrate = bandwidth;
      });
    }
    return encodingParameters;
  };
  SDPUtils2.parseRtcpParameters = function(mediaSection) {
    const rtcpParameters = {};
    const remoteSsrc = SDPUtils2.matchPrefix(mediaSection, "a=ssrc:").map((line) => SDPUtils2.parseSsrcMedia(line)).filter((obj) => obj.attribute === "cname")[0];
    if (remoteSsrc) {
      rtcpParameters.cname = remoteSsrc.value;
      rtcpParameters.ssrc = remoteSsrc.ssrc;
    }
    const rsize = SDPUtils2.matchPrefix(mediaSection, "a=rtcp-rsize");
    rtcpParameters.reducedSize = rsize.length > 0;
    rtcpParameters.compound = rsize.length === 0;
    const mux = SDPUtils2.matchPrefix(mediaSection, "a=rtcp-mux");
    rtcpParameters.mux = mux.length > 0;
    return rtcpParameters;
  };
  SDPUtils2.writeRtcpParameters = function(rtcpParameters) {
    let sdp2 = "";
    if (rtcpParameters.reducedSize) {
      sdp2 += "a=rtcp-rsize\r\n";
    }
    if (rtcpParameters.mux) {
      sdp2 += "a=rtcp-mux\r\n";
    }
    if (rtcpParameters.ssrc !== void 0 && rtcpParameters.cname) {
      sdp2 += "a=ssrc:" + rtcpParameters.ssrc + " cname:" + rtcpParameters.cname + "\r\n";
    }
    return sdp2;
  };
  SDPUtils2.parseMsid = function(mediaSection) {
    let parts;
    const spec = SDPUtils2.matchPrefix(mediaSection, "a=msid:");
    if (spec.length === 1) {
      parts = spec[0].substring(7).split(" ");
      return { stream: parts[0], track: parts[1] };
    }
    const planB = SDPUtils2.matchPrefix(mediaSection, "a=ssrc:").map((line) => SDPUtils2.parseSsrcMedia(line)).filter((msidParts) => msidParts.attribute === "msid");
    if (planB.length > 0) {
      parts = planB[0].value.split(" ");
      return { stream: parts[0], track: parts[1] };
    }
  };
  SDPUtils2.parseSctpDescription = function(mediaSection) {
    const mline = SDPUtils2.parseMLine(mediaSection);
    const maxSizeLine = SDPUtils2.matchPrefix(mediaSection, "a=max-message-size:");
    let maxMessageSize;
    if (maxSizeLine.length > 0) {
      maxMessageSize = parseInt(maxSizeLine[0].substring(19), 10);
    }
    if (isNaN(maxMessageSize)) {
      maxMessageSize = 65536;
    }
    const sctpPort = SDPUtils2.matchPrefix(mediaSection, "a=sctp-port:");
    if (sctpPort.length > 0) {
      return {
        port: parseInt(sctpPort[0].substring(12), 10),
        protocol: mline.fmt,
        maxMessageSize
      };
    }
    const sctpMapLines = SDPUtils2.matchPrefix(mediaSection, "a=sctpmap:");
    if (sctpMapLines.length > 0) {
      const parts = sctpMapLines[0].substring(10).split(" ");
      return {
        port: parseInt(parts[0], 10),
        protocol: parts[1],
        maxMessageSize
      };
    }
  };
  SDPUtils2.writeSctpDescription = function(media, sctp) {
    let output = [];
    if (media.protocol !== "DTLS/SCTP") {
      output = [
        "m=" + media.kind + " 9 " + media.protocol + " " + sctp.protocol + "\r\n",
        "c=IN IP4 0.0.0.0\r\n",
        "a=sctp-port:" + sctp.port + "\r\n"
      ];
    } else {
      output = [
        "m=" + media.kind + " 9 " + media.protocol + " " + sctp.port + "\r\n",
        "c=IN IP4 0.0.0.0\r\n",
        "a=sctpmap:" + sctp.port + " " + sctp.protocol + " 65535\r\n"
      ];
    }
    if (sctp.maxMessageSize !== void 0) {
      output.push("a=max-message-size:" + sctp.maxMessageSize + "\r\n");
    }
    return output.join("");
  };
  SDPUtils2.generateSessionId = function() {
    return Math.random().toString().substr(2, 22);
  };
  SDPUtils2.writeSessionBoilerplate = function(sessId, sessVer, sessUser) {
    let sessionId;
    const version = sessVer !== void 0 ? sessVer : 2;
    if (sessId) {
      sessionId = sessId;
    } else {
      sessionId = SDPUtils2.generateSessionId();
    }
    const user = sessUser || "thisisadapterortc";
    return "v=0\r\no=" + user + " " + sessionId + " " + version + " IN IP4 127.0.0.1\r\ns=-\r\nt=0 0\r\n";
  };
  SDPUtils2.getDirection = function(mediaSection, sessionpart) {
    const lines = SDPUtils2.splitLines(mediaSection);
    for (let i = 0; i < lines.length; i++) {
      switch (lines[i]) {
        case "a=sendrecv":
        case "a=sendonly":
        case "a=recvonly":
        case "a=inactive":
          return lines[i].substring(2);
      }
    }
    if (sessionpart) {
      return SDPUtils2.getDirection(sessionpart);
    }
    return "sendrecv";
  };
  SDPUtils2.getKind = function(mediaSection) {
    const lines = SDPUtils2.splitLines(mediaSection);
    const mline = lines[0].split(" ");
    return mline[0].substring(2);
  };
  SDPUtils2.isRejected = function(mediaSection) {
    return mediaSection.split(" ", 2)[1] === "0";
  };
  SDPUtils2.parseMLine = function(mediaSection) {
    const lines = SDPUtils2.splitLines(mediaSection);
    const parts = lines[0].substring(2).split(" ");
    return {
      kind: parts[0],
      port: parseInt(parts[1], 10),
      protocol: parts[2],
      fmt: parts.slice(3).join(" ")
    };
  };
  SDPUtils2.parseOLine = function(mediaSection) {
    const line = SDPUtils2.matchPrefix(mediaSection, "o=")[0];
    const parts = line.substring(2).split(" ");
    return {
      username: parts[0],
      sessionId: parts[1],
      sessionVersion: parseInt(parts[2], 10),
      netType: parts[3],
      addressType: parts[4],
      address: parts[5]
    };
  };
  SDPUtils2.isValidSDP = function(blob) {
    if (typeof blob !== "string" || blob.length === 0) {
      return false;
    }
    const lines = SDPUtils2.splitLines(blob);
    for (let i = 0; i < lines.length; i++) {
      if (lines[i].length < 2 || lines[i].charAt(1) !== "=") {
        return false;
      }
    }
    return true;
  };
  {
    module.exports = SDPUtils2;
  }
})(sdp$1);
var sdpExports = sdp$1.exports;
const SDPUtils = /* @__PURE__ */ getDefaultExportFromCjs(sdpExports);
const sdp = /* @__PURE__ */ _mergeNamespaces({
  __proto__: null,
  default: SDPUtils
}, [sdpExports]);
function shimRTCIceCandidate(window2) {
  if (!window2.RTCIceCandidate || window2.RTCIceCandidate && "foundation" in window2.RTCIceCandidate.prototype) {
    return;
  }
  const NativeRTCIceCandidate = window2.RTCIceCandidate;
  window2.RTCIceCandidate = function RTCIceCandidate(args) {
    if (typeof args === "object" && args.candidate && args.candidate.indexOf("a=") === 0) {
      args = JSON.parse(JSON.stringify(args));
      args.candidate = args.candidate.substring(2);
    }
    if (args.candidate && args.candidate.length) {
      const nativeCandidate = new NativeRTCIceCandidate(args);
      const parsedCandidate = SDPUtils.parseCandidate(args.candidate);
      for (const key in parsedCandidate) {
        if (!(key in nativeCandidate)) {
          Object.defineProperty(
            nativeCandidate,
            key,
            { value: parsedCandidate[key] }
          );
        }
      }
      nativeCandidate.toJSON = function toJSON() {
        return {
          candidate: nativeCandidate.candidate,
          sdpMid: nativeCandidate.sdpMid,
          sdpMLineIndex: nativeCandidate.sdpMLineIndex,
          usernameFragment: nativeCandidate.usernameFragment
        };
      };
      return nativeCandidate;
    }
    return new NativeRTCIceCandidate(args);
  };
  window2.RTCIceCandidate.prototype = NativeRTCIceCandidate.prototype;
  wrapPeerConnectionEvent(window2, "icecandidate", (e2) => {
    if (e2.candidate) {
      Object.defineProperty(e2, "candidate", {
        value: new window2.RTCIceCandidate(e2.candidate),
        writable: "false"
      });
    }
    return e2;
  });
}
function shimRTCIceCandidateRelayProtocol(window2) {
  if (!window2.RTCIceCandidate || window2.RTCIceCandidate && "relayProtocol" in window2.RTCIceCandidate.prototype) {
    return;
  }
  wrapPeerConnectionEvent(window2, "icecandidate", (e2) => {
    if (e2.candidate) {
      const parsedCandidate = SDPUtils.parseCandidate(e2.candidate.candidate);
      if (parsedCandidate.type === "relay") {
        e2.candidate.relayProtocol = {
          0: "tls",
          1: "tcp",
          2: "udp"
        }[parsedCandidate.priority >> 24];
      }
    }
    return e2;
  });
}
function shimMaxMessageSize(window2, browserDetails) {
  if (!window2.RTCPeerConnection) {
    return;
  }
  if (!("sctp" in window2.RTCPeerConnection.prototype)) {
    Object.defineProperty(window2.RTCPeerConnection.prototype, "sctp", {
      get() {
        return typeof this._sctp === "undefined" ? null : this._sctp;
      }
    });
  }
  const sctpInDescription = function(description) {
    if (!description || !description.sdp) {
      return false;
    }
    const sections = SDPUtils.splitSections(description.sdp);
    sections.shift();
    return sections.some((mediaSection) => {
      const mLine = SDPUtils.parseMLine(mediaSection);
      return mLine && mLine.kind === "application" && mLine.protocol.indexOf("SCTP") !== -1;
    });
  };
  const getRemoteFirefoxVersion = function(description) {
    const match = description.sdp.match(/mozilla...THIS_IS_SDPARTA-(\d+)/);
    if (match === null || match.length < 2) {
      return -1;
    }
    const version = parseInt(match[1], 10);
    return version !== version ? -1 : version;
  };
  const getCanSendMaxMessageSize = function(remoteIsFirefox) {
    let canSendMaxMessageSize = 65536;
    if (browserDetails.browser === "firefox") {
      if (browserDetails.version < 57) {
        if (remoteIsFirefox === -1) {
          canSendMaxMessageSize = 16384;
        } else {
          canSendMaxMessageSize = 2147483637;
        }
      } else if (browserDetails.version < 60) {
        canSendMaxMessageSize = browserDetails.version === 57 ? 65535 : 65536;
      } else {
        canSendMaxMessageSize = 2147483637;
      }
    }
    return canSendMaxMessageSize;
  };
  const getMaxMessageSize = function(description, remoteIsFirefox) {
    let maxMessageSize = 65536;
    if (browserDetails.browser === "firefox" && browserDetails.version === 57) {
      maxMessageSize = 65535;
    }
    const match = SDPUtils.matchPrefix(
      description.sdp,
      "a=max-message-size:"
    );
    if (match.length > 0) {
      maxMessageSize = parseInt(match[0].substring(19), 10);
    } else if (browserDetails.browser === "firefox" && remoteIsFirefox !== -1) {
      maxMessageSize = 2147483637;
    }
    return maxMessageSize;
  };
  const origSetRemoteDescription = window2.RTCPeerConnection.prototype.setRemoteDescription;
  window2.RTCPeerConnection.prototype.setRemoteDescription = function setRemoteDescription() {
    this._sctp = null;
    if (browserDetails.browser === "chrome" && browserDetails.version >= 76) {
      const { sdpSemantics } = this.getConfiguration();
      if (sdpSemantics === "plan-b") {
        Object.defineProperty(this, "sctp", {
          get() {
            return typeof this._sctp === "undefined" ? null : this._sctp;
          },
          enumerable: true,
          configurable: true
        });
      }
    }
    if (sctpInDescription(arguments[0])) {
      const isFirefox = getRemoteFirefoxVersion(arguments[0]);
      const canSendMMS = getCanSendMaxMessageSize(isFirefox);
      const remoteMMS = getMaxMessageSize(arguments[0], isFirefox);
      let maxMessageSize;
      if (canSendMMS === 0 && remoteMMS === 0) {
        maxMessageSize = Number.POSITIVE_INFINITY;
      } else if (canSendMMS === 0 || remoteMMS === 0) {
        maxMessageSize = Math.max(canSendMMS, remoteMMS);
      } else {
        maxMessageSize = Math.min(canSendMMS, remoteMMS);
      }
      const sctp = {};
      Object.defineProperty(sctp, "maxMessageSize", {
        get() {
          return maxMessageSize;
        }
      });
      this._sctp = sctp;
    }
    return origSetRemoteDescription.apply(this, arguments);
  };
}
function shimSendThrowTypeError(window2) {
  if (!(window2.RTCPeerConnection && "createDataChannel" in window2.RTCPeerConnection.prototype)) {
    return;
  }
  function wrapDcSend(dc, pc) {
    const origDataChannelSend = dc.send;
    dc.send = function send() {
      const data = arguments[0];
      const length = data.length || data.size || data.byteLength;
      if (dc.readyState === "open" && pc.sctp && length > pc.sctp.maxMessageSize) {
        throw new TypeError("Message too large (can send a maximum of " + pc.sctp.maxMessageSize + " bytes)");
      }
      return origDataChannelSend.apply(dc, arguments);
    };
  }
  const origCreateDataChannel = window2.RTCPeerConnection.prototype.createDataChannel;
  window2.RTCPeerConnection.prototype.createDataChannel = function createDataChannel() {
    const dataChannel = origCreateDataChannel.apply(this, arguments);
    wrapDcSend(dataChannel, this);
    return dataChannel;
  };
  wrapPeerConnectionEvent(window2, "datachannel", (e2) => {
    wrapDcSend(e2.channel, e2.target);
    return e2;
  });
}
function shimConnectionState(window2) {
  if (!window2.RTCPeerConnection || "connectionState" in window2.RTCPeerConnection.prototype) {
    return;
  }
  const proto = window2.RTCPeerConnection.prototype;
  Object.defineProperty(proto, "connectionState", {
    get() {
      return {
        completed: "connected",
        checking: "connecting"
      }[this.iceConnectionState] || this.iceConnectionState;
    },
    enumerable: true,
    configurable: true
  });
  Object.defineProperty(proto, "onconnectionstatechange", {
    get() {
      return this._onconnectionstatechange || null;
    },
    set(cb) {
      if (this._onconnectionstatechange) {
        this.removeEventListener(
          "connectionstatechange",
          this._onconnectionstatechange
        );
        delete this._onconnectionstatechange;
      }
      if (cb) {
        this.addEventListener(
          "connectionstatechange",
          this._onconnectionstatechange = cb
        );
      }
    },
    enumerable: true,
    configurable: true
  });
  ["setLocalDescription", "setRemoteDescription"].forEach((method) => {
    const origMethod = proto[method];
    proto[method] = function() {
      if (!this._connectionstatechangepoly) {
        this._connectionstatechangepoly = (e2) => {
          const pc = e2.target;
          if (pc._lastConnectionState !== pc.connectionState) {
            pc._lastConnectionState = pc.connectionState;
            const newEvent = new Event("connectionstatechange", e2);
            pc.dispatchEvent(newEvent);
          }
          return e2;
        };
        this.addEventListener(
          "iceconnectionstatechange",
          this._connectionstatechangepoly
        );
      }
      return origMethod.apply(this, arguments);
    };
  });
}
function removeExtmapAllowMixed(window2, browserDetails) {
  if (!window2.RTCPeerConnection) {
    return;
  }
  if (browserDetails.browser === "chrome" && browserDetails.version >= 71) {
    return;
  }
  if (browserDetails.browser === "safari" && browserDetails.version >= 605) {
    return;
  }
  const nativeSRD = window2.RTCPeerConnection.prototype.setRemoteDescription;
  window2.RTCPeerConnection.prototype.setRemoteDescription = function setRemoteDescription(desc) {
    if (desc && desc.sdp && desc.sdp.indexOf("\na=extmap-allow-mixed") !== -1) {
      const sdp2 = desc.sdp.split("\n").filter((line) => {
        return line.trim() !== "a=extmap-allow-mixed";
      }).join("\n");
      if (window2.RTCSessionDescription && desc instanceof window2.RTCSessionDescription) {
        arguments[0] = new window2.RTCSessionDescription({
          type: desc.type,
          sdp: sdp2
        });
      } else {
        desc.sdp = sdp2;
      }
    }
    return nativeSRD.apply(this, arguments);
  };
}
function shimAddIceCandidateNullOrEmpty(window2, browserDetails) {
  if (!(window2.RTCPeerConnection && window2.RTCPeerConnection.prototype)) {
    return;
  }
  const nativeAddIceCandidate = window2.RTCPeerConnection.prototype.addIceCandidate;
  if (!nativeAddIceCandidate || nativeAddIceCandidate.length === 0) {
    return;
  }
  window2.RTCPeerConnection.prototype.addIceCandidate = function addIceCandidate() {
    if (!arguments[0]) {
      if (arguments[1]) {
        arguments[1].apply(null);
      }
      return Promise.resolve();
    }
    if ((browserDetails.browser === "chrome" && browserDetails.version < 78 || browserDetails.browser === "firefox" && browserDetails.version < 68 || browserDetails.browser === "safari") && arguments[0] && arguments[0].candidate === "") {
      return Promise.resolve();
    }
    return nativeAddIceCandidate.apply(this, arguments);
  };
}
function shimParameterlessSetLocalDescription(window2, browserDetails) {
  if (!(window2.RTCPeerConnection && window2.RTCPeerConnection.prototype)) {
    return;
  }
  const nativeSetLocalDescription = window2.RTCPeerConnection.prototype.setLocalDescription;
  if (!nativeSetLocalDescription || nativeSetLocalDescription.length === 0) {
    return;
  }
  window2.RTCPeerConnection.prototype.setLocalDescription = function setLocalDescription() {
    let desc = arguments[0] || {};
    if (typeof desc !== "object" || desc.type && desc.sdp) {
      return nativeSetLocalDescription.apply(this, arguments);
    }
    desc = { type: desc.type, sdp: desc.sdp };
    if (!desc.type) {
      switch (this.signalingState) {
        case "stable":
        case "have-local-offer":
        case "have-remote-pranswer":
          desc.type = "offer";
          break;
        default:
          desc.type = "answer";
          break;
      }
    }
    if (desc.sdp || desc.type !== "offer" && desc.type !== "answer") {
      return nativeSetLocalDescription.apply(this, [desc]);
    }
    const func = desc.type === "offer" ? this.createOffer : this.createAnswer;
    return func.apply(this).then((d) => nativeSetLocalDescription.apply(this, [d]));
  };
}
const commonShim = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  removeExtmapAllowMixed,
  shimAddIceCandidateNullOrEmpty,
  shimConnectionState,
  shimMaxMessageSize,
  shimParameterlessSetLocalDescription,
  shimRTCIceCandidate,
  shimRTCIceCandidateRelayProtocol,
  shimSendThrowTypeError
}, Symbol.toStringTag, { value: "Module" }));
function adapterFactory({ window: window2 } = {}, options = {
  shimChrome: true,
  shimFirefox: true,
  shimSafari: true
}) {
  const logging2 = log;
  const browserDetails = detectBrowser(window2);
  const adapter = {
    browserDetails,
    commonShim,
    extractVersion,
    disableLog,
    disableWarnings,
    // Expose sdp as a convenience. For production apps include directly.
    sdp
  };
  switch (browserDetails.browser) {
    case "chrome":
      if (!chromeShim || !shimPeerConnection$1 || !options.shimChrome) {
        logging2("Chrome shim is not included in this adapter release.");
        return adapter;
      }
      if (browserDetails.version === null) {
        logging2("Chrome shim can not determine version, not shimming.");
        return adapter;
      }
      logging2("adapter.js shimming chrome.");
      adapter.browserShim = chromeShim;
      shimAddIceCandidateNullOrEmpty(window2, browserDetails);
      shimParameterlessSetLocalDescription(window2);
      shimGetUserMedia$3(window2, browserDetails);
      shimMediaStream(window2);
      shimPeerConnection$1(window2, browserDetails);
      shimOnTrack$1(window2);
      shimAddTrackRemoveTrack(window2, browserDetails);
      shimGetSendersWithDtmf(window2);
      shimSenderReceiverGetStats(window2);
      fixNegotiationNeeded(window2, browserDetails);
      shimRTCIceCandidate(window2);
      shimRTCIceCandidateRelayProtocol(window2);
      shimConnectionState(window2);
      shimMaxMessageSize(window2, browserDetails);
      shimSendThrowTypeError(window2);
      removeExtmapAllowMixed(window2, browserDetails);
      break;
    case "firefox":
      if (!firefoxShim || !shimPeerConnection || !options.shimFirefox) {
        logging2("Firefox shim is not included in this adapter release.");
        return adapter;
      }
      logging2("adapter.js shimming firefox.");
      adapter.browserShim = firefoxShim;
      shimAddIceCandidateNullOrEmpty(window2, browserDetails);
      shimParameterlessSetLocalDescription(window2);
      shimGetUserMedia$2(window2, browserDetails);
      shimPeerConnection(window2, browserDetails);
      shimOnTrack(window2);
      shimRemoveStream(window2);
      shimSenderGetStats(window2);
      shimReceiverGetStats(window2);
      shimRTCDataChannel(window2);
      shimAddTransceiver(window2);
      shimGetParameters(window2);
      shimCreateOffer(window2);
      shimCreateAnswer(window2);
      shimRTCIceCandidate(window2);
      shimConnectionState(window2);
      shimMaxMessageSize(window2, browserDetails);
      shimSendThrowTypeError(window2);
      break;
    case "safari":
      if (!safariShim || !options.shimSafari) {
        logging2("Safari shim is not included in this adapter release.");
        return adapter;
      }
      logging2("adapter.js shimming safari.");
      adapter.browserShim = safariShim;
      shimAddIceCandidateNullOrEmpty(window2, browserDetails);
      shimParameterlessSetLocalDescription(window2);
      shimRTCIceServerUrls(window2);
      shimCreateOfferLegacy(window2);
      shimCallbacksAPI(window2);
      shimLocalStreamsAPI(window2);
      shimRemoteStreamsAPI(window2);
      shimTrackEventTransceiver(window2);
      shimGetUserMedia$1(window2);
      shimAudioContext(window2);
      shimRTCIceCandidate(window2);
      shimRTCIceCandidateRelayProtocol(window2);
      shimMaxMessageSize(window2, browserDetails);
      shimSendThrowTypeError(window2);
      removeExtmapAllowMixed(window2, browserDetails);
      break;
    default:
      logging2("Unsupported browser!");
      break;
  }
  return adapter;
}
adapterFactory({ window: typeof window === "undefined" ? void 0 : window });
const indempotent = (action) => {
  let called = false;
  let result = void 0;
  return (...args) => {
    if (called) {
      return result;
    } else {
      result = action(...args);
      called = true;
      return result;
    }
  };
};
const shimGetUserMedia = indempotent(() => {
  const { browser } = detectBrowser(window);
  switch (browser) {
    case "edge":
    case "chrome":
      shimGetUserMedia$3(window, browser);
      break;
    case "firefox":
      shimGetUserMedia$2(window, browser);
      break;
    case "safari":
      shimGetUserMedia$1(window);
      break;
    default:
      throw new StreamApiNotSupportedError();
  }
});
class Camera {
  constructor(videoEl, stream) {
    this.videoEl = videoEl;
    this.stream = stream;
  }
  stop() {
    this.videoEl.srcObject = null;
    this.stream.getTracks().forEach((track) => {
      this.stream.removeTrack(track);
      track.stop();
    });
  }
  getCapabilities() {
    var _a;
    const [track] = this.stream.getVideoTracks();
    return ((_a = track == null ? void 0 : track.getCapabilities) == null ? void 0 : _a.call(track)) ?? {};
  }
}
const narrowDownFacingMode = async (camera) => {
  const devices = (await navigator.mediaDevices.enumerateDevices()).filter(
    ({ kind }) => kind === "videoinput"
  );
  if (devices.length > 1) {
    const frontCamera = devices[0];
    const rearCamera = devices[devices.length - 1];
    switch (camera) {
      case "auto":
        return { deviceId: { exact: rearCamera.deviceId } };
      case "rear":
        return { deviceId: { exact: rearCamera.deviceId } };
      case "front":
        return { deviceId: { exact: frontCamera.deviceId } };
      default:
        return void 0;
    }
  } else {
    switch (camera) {
      case "auto":
        return { facingMode: { ideal: "environment" } };
      case "rear":
        return { facingMode: { ideal: "environment" } };
      case "front":
        return { facingMode: { ideal: "user" } };
      default:
        return void 0;
    }
  }
};
async function Camera$1(videoEl, { camera, torch }) {
  var _a;
  if (window.isSecureContext !== true) {
    throw new InsecureContextError();
  }
  if (((_a = navigator == null ? void 0 : navigator.mediaDevices) == null ? void 0 : _a.getUserMedia) === void 0) {
    throw new StreamApiNotSupportedError();
  }
  await shimGetUserMedia();
  const constraints = {
    audio: false,
    video: {
      width: { min: 360, ideal: 640, max: 1920 },
      height: { min: 240, ideal: 480, max: 1080 },
      ...await narrowDownFacingMode(camera)
    }
  };
  const stream = await navigator.mediaDevices.getUserMedia(constraints);
  if (videoEl.srcObject !== void 0) {
    videoEl.srcObject = stream;
  } else if (videoEl.mozSrcObject !== void 0) {
    videoEl.mozSrcObject = stream;
  } else if (window.URL.createObjectURL) {
    videoEl.src = window.URL.createObjectURL(stream);
  } else if (window.webkitURL) {
    videoEl.src = window.webkitURL.createObjectURL(stream);
  } else {
    videoEl.src = stream;
  }
  await e(videoEl, "loadeddata");
  await r(500);
  if (torch) {
    const [track] = stream.getVideoTracks();
    const capabilities = track.getCapabilities();
    if (capabilities.torch) {
      track.applyConstraints({ advanced: [{ torch: true }] });
    } else {
      console.warn("device does not support torch capability");
    }
  }
  return new Camera(videoEl, stream);
}
var Je = (i, f, y) => {
  if (!f.has(i))
    throw TypeError("Cannot " + y);
};
var ue = (i, f, y) => (Je(i, f, "read from private field"), y ? y.call(i) : f.get(i)), Ke = (i, f, y) => {
  if (f.has(i))
    throw TypeError("Cannot add the same private member more than once");
  f instanceof WeakSet ? f.add(i) : f.set(i, y);
}, tr = (i, f, y, c) => (Je(i, f, "write to private field"), c ? c.call(i, y) : f.set(i, y), y);
const er = [
  "Aztec",
  "Codabar",
  "Code128",
  "Code39",
  "Code93",
  "DataBar",
  "DataBarExpanded",
  "DataMatrix",
  "DXFilmEdge",
  "EAN-13",
  "EAN-8",
  "ITF",
  "Linear-Codes",
  "Matrix-Codes",
  "MaxiCode",
  "MicroQRCode",
  "None",
  "PDF417",
  "QRCode",
  "rMQRCode",
  "UPC-A",
  "UPC-E"
];
function Ua(i) {
  return i.join("|");
}
function La(i) {
  const f = rr(i);
  let y = 0, c = er.length - 1;
  for (; y <= c; ) {
    const g = Math.floor((y + c) / 2), $ = er[g], H = rr($);
    if (H === f)
      return $;
    H < f ? y = g + 1 : c = g - 1;
  }
  return "None";
}
function rr(i) {
  return i.toLowerCase().replace(/_-\[\]/g, "");
}
function Va(i, f) {
  return i.Binarizer[f];
}
function Ya(i, f) {
  return i.CharacterSet[f];
}
const za = [
  "Text",
  "Binary",
  "Mixed",
  "GS1",
  "ISO15434",
  "UnknownECI"
];
function Na(i) {
  return za[i.value];
}
function Ga(i, f) {
  return i.EanAddOnSymbol[f];
}
function Xa(i, f) {
  return i.TextMode[f];
}
const dt = {
  formats: [],
  tryHarder: true,
  tryRotate: true,
  tryInvert: true,
  tryDownscale: true,
  binarizer: "LocalAverage",
  isPure: false,
  downscaleFactor: 3,
  downscaleThreshold: 500,
  minLineCount: 2,
  maxNumberOfSymbols: 255,
  tryCode39ExtendedMode: false,
  validateCode39CheckSum: false,
  validateITFCheckSum: false,
  returnCodabarStartEnd: false,
  returnErrors: false,
  eanAddOnSymbol: "Read",
  textMode: "Plain",
  characterSet: "Unknown"
};
function ar(i, f) {
  return {
    ...f,
    formats: Ua(f.formats),
    binarizer: Va(i, f.binarizer),
    eanAddOnSymbol: Ga(
      i,
      f.eanAddOnSymbol
    ),
    textMode: Xa(i, f.textMode),
    characterSet: Ya(
      i,
      f.characterSet
    )
  };
}
function or(i) {
  return {
    ...i,
    format: La(i.format),
    eccLevel: i.eccLevel,
    contentType: Na(i.contentType)
  };
}
const qa = {
  locateFile: (i, f) => {
    const y = i.match(/_(.+?)\.wasm$/);
    return y ? `https://fastly.jsdelivr.net/npm/zxing-wasm@1.2.11/dist/${y[1]}/${i}` : f + i;
  }
};
let ce = /* @__PURE__ */ new WeakMap();
function le(i, f) {
  var y;
  const c = ce.get(i);
  if (c != null && c.modulePromise && f === void 0)
    return c.modulePromise;
  const g = (y = c == null ? void 0 : c.moduleOverrides) != null ? y : qa, $ = i({
    ...g
  });
  return ce.set(i, {
    moduleOverrides: g,
    modulePromise: $
  }), $;
}
async function Za(i, f, y = dt) {
  const c = {
    ...dt,
    ...y
  }, g = await le(i), { size: $ } = f, H = new Uint8Array(await f.arrayBuffer()), U = g._malloc($);
  g.HEAPU8.set(H, U);
  const V = g.readBarcodesFromImage(
    U,
    $,
    ar(g, c)
  );
  g._free(U);
  const B = [];
  for (let L = 0; L < V.size(); ++L)
    B.push(
      or(V.get(L))
    );
  return B;
}
async function Ja(i, f, y = dt) {
  const c = {
    ...dt,
    ...y
  }, g = await le(i), {
    data: $,
    width: H,
    height: U,
    data: { byteLength: V }
  } = f, B = g._malloc(V);
  g.HEAPU8.set($, B);
  const L = g.readBarcodesFromPixmap(
    B,
    H,
    U,
    ar(g, c)
  );
  g._free(B);
  const Y = [];
  for (let S = 0; S < L.size(); ++S)
    Y.push(
      or(L.get(S))
    );
  return Y;
}
({
  ...dt,
  formats: [...dt.formats]
});
var Ut = (() => {
  var i = typeof document < "u" && document.currentScript ? document.currentScript.src : void 0;
  return function(f = {}) {
    var y, c = f, g, $;
    c.ready = new Promise((e2, t) => {
      g = e2, $ = t;
    });
    var H = Object.assign({}, c), U = "./this.program", V = typeof window == "object", B = typeof Bun < "u", L = typeof ((y = globalThis.WebAssembly) == null ? void 0 : y.instantiate) == "function", Y = typeof importScripts == "function";
    typeof process$1 == "object" && typeof process$1.versions == "object" && process$1.versions.node;
    var S = "";
    function ht(e2) {
      return c.locateFile ? c.locateFile(e2, S) : S + e2;
    }
    var at;
    (V || Y || B) && (Y ? S = self.location.href : typeof document < "u" && document.currentScript && (S = document.currentScript.src), i && (S = i), S.startsWith("blob:") ? S = "" : S = S.substr(0, S.replace(/[?#].*/, "").lastIndexOf("/") + 1), Y && (at = (e2) => {
      var t = new XMLHttpRequest();
      return t.open("GET", e2, false), t.responseType = "arraybuffer", t.send(null), new Uint8Array(t.response);
    }));
    var _t = c.print || console.log.bind(console), K = c.printErr || console.error.bind(console);
    Object.assign(c, H), H = null, c.arguments && c.arguments, c.thisProgram && (U = c.thisProgram), c.quit && c.quit;
    var tt;
    c.wasmBinary && (tt = c.wasmBinary);
    var Tt, de = false, z, R, ot, ft, W, _, he, fe;
    function pe() {
      var e2 = Tt.buffer;
      c.HEAP8 = z = new Int8Array(e2), c.HEAP16 = ot = new Int16Array(e2), c.HEAPU8 = R = new Uint8Array(e2), c.HEAPU16 = ft = new Uint16Array(e2), c.HEAP32 = W = new Int32Array(e2), c.HEAPU32 = _ = new Uint32Array(e2), c.HEAPF32 = he = new Float32Array(e2), c.HEAPF64 = fe = new Float64Array(e2);
    }
    var me = [], ye = [], ve = [];
    function yr() {
      if (c.preRun)
        for (typeof c.preRun == "function" && (c.preRun = [c.preRun]); c.preRun.length; )
          wr(c.preRun.shift());
      Vt(me);
    }
    function vr() {
      Vt(ye);
    }
    function gr() {
      if (c.postRun)
        for (typeof c.postRun == "function" && (c.postRun = [c.postRun]); c.postRun.length; )
          br(c.postRun.shift());
      Vt(ve);
    }
    function wr(e2) {
      me.unshift(e2);
    }
    function $r(e2) {
      ye.unshift(e2);
    }
    function br(e2) {
      ve.unshift(e2);
    }
    var et = 0, pt = null;
    function Cr(e2) {
      var t;
      et++, (t = c.monitorRunDependencies) === null || t === void 0 || t.call(c, et);
    }
    function _r(e2) {
      var t;
      if (et--, (t = c.monitorRunDependencies) === null || t === void 0 || t.call(c, et), et == 0 && pt) {
        var r2 = pt;
        pt = null, r2();
      }
    }
    function Lt(e2) {
      var t;
      (t = c.onAbort) === null || t === void 0 || t.call(c, e2), e2 = "Aborted(" + e2 + ")", K(e2), de = true, e2 += ". Build with -sASSERTIONS for more info.";
      var r2 = new WebAssembly.RuntimeError(e2);
      throw $(r2), r2;
    }
    var Tr = "data:application/octet-stream;base64,", ge = (e2) => e2.startsWith(Tr), it;
    it = "zxing_reader.wasm", ge(it) || (it = ht(it));
    function we(e2) {
      if (e2 == it && tt)
        return new Uint8Array(tt);
      if (at)
        return at(e2);
      throw "both async and sync fetching of the wasm failed";
    }
    function Pr(e2) {
      return !tt && (V || Y || B || L) && typeof fetch == "function" ? fetch(e2, {
        credentials: "same-origin"
      }).then((t) => {
        if (!t.ok)
          throw `failed to load wasm binary file at '${e2}'`;
        return t.arrayBuffer();
      }).catch(() => we(e2)) : Promise.resolve().then(() => we(e2));
    }
    function $e(e2, t, r2) {
      return Pr(e2).then((n) => WebAssembly.instantiate(n, t)).then(r2, (n) => {
        K(`failed to asynchronously prepare wasm: ${n}`), Lt(n);
      });
    }
    function Er(e2, t, r2, n) {
      return !e2 && typeof WebAssembly.instantiateStreaming == "function" && !ge(t) && typeof fetch == "function" ? fetch(t, {
        credentials: "same-origin"
      }).then((a) => {
        var o = WebAssembly.instantiateStreaming(a, r2);
        return o.then(n, function(s) {
          return K(`wasm streaming compile failed: ${s}`), K("falling back to ArrayBuffer instantiation"), $e(t, r2, n);
        });
      }) : $e(t, r2, n);
    }
    function Ar() {
      var e2 = {
        a: wa
      };
      function t(n, a) {
        return A = n.exports, Tt = A.ma, pe(), De = A.qa, $r(A.na), _r(), A;
      }
      Cr();
      function r2(n) {
        t(n.instance);
      }
      if (c.instantiateWasm)
        try {
          return c.instantiateWasm(e2, t);
        } catch (n) {
          K(`Module.instantiateWasm callback failed with error: ${n}`), $(n);
        }
      return Er(tt, it, e2, r2).catch($), {};
    }
    var Vt = (e2) => {
      for (; e2.length > 0; )
        e2.shift()(c);
    };
    c.noExitRuntime;
    var Pt = [], Et = 0, Fr = (e2) => {
      var t = new Yt(e2);
      return t.get_caught() || (t.set_caught(true), Et--), t.set_rethrown(false), Pt.push(t), Ye(t.excPtr), t.get_exception_ptr();
    }, q = 0, Dr = () => {
      T(0, 0);
      var e2 = Pt.pop();
      Ve(e2.excPtr), q = 0;
    };
    class Yt {
      constructor(t) {
        this.excPtr = t, this.ptr = t - 24;
      }
      set_type(t) {
        _[this.ptr + 4 >> 2] = t;
      }
      get_type() {
        return _[this.ptr + 4 >> 2];
      }
      set_destructor(t) {
        _[this.ptr + 8 >> 2] = t;
      }
      get_destructor() {
        return _[this.ptr + 8 >> 2];
      }
      set_caught(t) {
        t = t ? 1 : 0, z[this.ptr + 12] = t;
      }
      get_caught() {
        return z[this.ptr + 12] != 0;
      }
      set_rethrown(t) {
        t = t ? 1 : 0, z[this.ptr + 13] = t;
      }
      get_rethrown() {
        return z[this.ptr + 13] != 0;
      }
      init(t, r2) {
        this.set_adjusted_ptr(0), this.set_type(t), this.set_destructor(r2);
      }
      set_adjusted_ptr(t) {
        _[this.ptr + 16 >> 2] = t;
      }
      get_adjusted_ptr() {
        return _[this.ptr + 16 >> 2];
      }
      get_exception_ptr() {
        var t = Ne(this.get_type());
        if (t)
          return _[this.excPtr >> 2];
        var r2 = this.get_adjusted_ptr();
        return r2 !== 0 ? r2 : this.excPtr;
      }
    }
    var xr = (e2) => {
      throw q || (q = e2), q;
    }, zt = (e2) => {
      var t = q;
      if (!t)
        return Ct(0), 0;
      var r2 = new Yt(t);
      r2.set_adjusted_ptr(t);
      var n = r2.get_type();
      if (!n)
        return Ct(0), t;
      for (var a in e2) {
        var o = e2[a];
        if (o === 0 || o === n)
          break;
        var s = r2.ptr + 16;
        if (ze(o, n, s))
          return Ct(o), t;
      }
      return Ct(n), t;
    }, Or = () => zt([]), Mr = (e2) => zt([e2]), Sr = (e2, t) => zt([e2, t]), jr = () => {
      var e2 = Pt.pop();
      e2 || Lt("no exception to throw");
      var t = e2.excPtr;
      throw e2.get_rethrown() || (Pt.push(e2), e2.set_rethrown(true), e2.set_caught(false), Et++), q = t, q;
    }, Ir = (e2, t, r2) => {
      var n = new Yt(e2);
      throw n.init(t, r2), q = e2, Et++, q;
    }, Rr = () => Et, At = {}, Nt = (e2) => {
      for (; e2.length; ) {
        var t = e2.pop(), r2 = e2.pop();
        r2(t);
      }
    };
    function mt(e2) {
      return this.fromWireType(_[e2 >> 2]);
    }
    var st = {}, rt = {}, Ft = {}, be, Dt = (e2) => {
      throw new be(e2);
    }, nt = (e2, t, r2) => {
      e2.forEach(function(u) {
        Ft[u] = t;
      });
      function n(u) {
        var l = r2(u);
        l.length !== e2.length && Dt("Mismatched type converter count");
        for (var h = 0; h < e2.length; ++h)
          G(e2[h], l[h]);
      }
      var a = new Array(t.length), o = [], s = 0;
      t.forEach((u, l) => {
        rt.hasOwnProperty(u) ? a[l] = rt[u] : (o.push(u), st.hasOwnProperty(u) || (st[u] = []), st[u].push(() => {
          a[l] = rt[u], ++s, s === o.length && n(a);
        }));
      }), o.length === 0 && n(a);
    }, Wr = (e2) => {
      var t = At[e2];
      delete At[e2];
      var r2 = t.rawConstructor, n = t.rawDestructor, a = t.fields, o = a.map((s) => s.getterReturnType).concat(a.map((s) => s.setterArgumentType));
      nt([e2], o, (s) => {
        var u = {};
        return a.forEach((l, h) => {
          var p = l.fieldName, w = s[h], v = l.getter, b = l.getterContext, x = s[h + a.length], k = l.setter, P = l.setterContext;
          u[p] = {
            read: (j) => w.fromWireType(v(b, j)),
            write: (j, d) => {
              var m = [];
              k(P, j, x.toWireType(m, d)), Nt(m);
            }
          };
        }), [{
          name: t.name,
          fromWireType: (l) => {
            var h = {};
            for (var p in u)
              h[p] = u[p].read(l);
            return n(l), h;
          },
          toWireType: (l, h) => {
            for (var p in u)
              if (!(p in h))
                throw new TypeError(`Missing field: "${p}"`);
            var w = r2();
            for (p in u)
              u[p].write(w, h[p]);
            return l !== null && l.push(n, w), w;
          },
          argPackAdvance: X,
          readValueFromPointer: mt,
          destructorFunction: n
        }];
      });
    }, kr = (e2, t, r2, n, a) => {
    }, Hr = () => {
      for (var e2 = new Array(256), t = 0; t < 256; ++t)
        e2[t] = String.fromCharCode(t);
      Ce = e2;
    }, Ce, I = (e2) => {
      for (var t = "", r2 = e2; R[r2]; )
        t += Ce[R[r2++]];
      return t;
    }, ut, C = (e2) => {
      throw new ut(e2);
    };
    function Br(e2, t) {
      let r2 = arguments.length > 2 && arguments[2] !== void 0 ? arguments[2] : {};
      var n = t.name;
      if (e2 || C(`type "${n}" must have a positive integer typeid pointer`), rt.hasOwnProperty(e2)) {
        if (r2.ignoreDuplicateRegistrations)
          return;
        C(`Cannot register type '${n}' twice`);
      }
      if (rt[e2] = t, delete Ft[e2], st.hasOwnProperty(e2)) {
        var a = st[e2];
        delete st[e2], a.forEach((o) => o());
      }
    }
    function G(e2, t) {
      let r2 = arguments.length > 2 && arguments[2] !== void 0 ? arguments[2] : {};
      if (!("argPackAdvance" in t))
        throw new TypeError("registerType registeredInstance requires argPackAdvance");
      return Br(e2, t, r2);
    }
    var X = 8, Ur = (e2, t, r2, n) => {
      t = I(t), G(e2, {
        name: t,
        fromWireType: function(a) {
          return !!a;
        },
        toWireType: function(a, o) {
          return o ? r2 : n;
        },
        argPackAdvance: X,
        readValueFromPointer: function(a) {
          return this.fromWireType(R[a]);
        },
        destructorFunction: null
      });
    }, Lr = (e2) => ({
      count: e2.count,
      deleteScheduled: e2.deleteScheduled,
      preservePointerOnDelete: e2.preservePointerOnDelete,
      ptr: e2.ptr,
      ptrType: e2.ptrType,
      smartPtr: e2.smartPtr,
      smartPtrType: e2.smartPtrType
    }), Gt = (e2) => {
      function t(r2) {
        return r2.$$.ptrType.registeredClass.name;
      }
      C(t(e2) + " instance already deleted");
    }, Xt = false, _e = (e2) => {
    }, Vr = (e2) => {
      e2.smartPtr ? e2.smartPtrType.rawDestructor(e2.smartPtr) : e2.ptrType.registeredClass.rawDestructor(e2.ptr);
    }, Te = (e2) => {
      e2.count.value -= 1;
      var t = e2.count.value === 0;
      t && Vr(e2);
    }, Pe = (e2, t, r2) => {
      if (t === r2)
        return e2;
      if (r2.baseClass === void 0)
        return null;
      var n = Pe(e2, t, r2.baseClass);
      return n === null ? null : r2.downcast(n);
    }, Ee = {}, Yr = () => Object.keys(gt).length, zr = () => {
      var e2 = [];
      for (var t in gt)
        gt.hasOwnProperty(t) && e2.push(gt[t]);
      return e2;
    }, yt = [], qt = () => {
      for (; yt.length; ) {
        var e2 = yt.pop();
        e2.$$.deleteScheduled = false, e2.delete();
      }
    }, vt, Nr = (e2) => {
      vt = e2, yt.length && vt && vt(qt);
    }, Gr = () => {
      c.getInheritedInstanceCount = Yr, c.getLiveInheritedInstances = zr, c.flushPendingDeletes = qt, c.setDelayFunction = Nr;
    }, gt = {}, Xr = (e2, t) => {
      for (t === void 0 && C("ptr should not be undefined"); e2.baseClass; )
        t = e2.upcast(t), e2 = e2.baseClass;
      return t;
    }, qr = (e2, t) => (t = Xr(e2, t), gt[t]), xt = (e2, t) => {
      (!t.ptrType || !t.ptr) && Dt("makeClassHandle requires ptr and ptrType");
      var r2 = !!t.smartPtrType, n = !!t.smartPtr;
      return r2 !== n && Dt("Both smartPtrType and smartPtr must be specified"), t.count = {
        value: 1
      }, wt(Object.create(e2, {
        $$: {
          value: t,
          writable: true
        }
      }));
    };
    function Qr(e2) {
      var t = this.getPointee(e2);
      if (!t)
        return this.destructor(e2), null;
      var r2 = qr(this.registeredClass, t);
      if (r2 !== void 0) {
        if (r2.$$.count.value === 0)
          return r2.$$.ptr = t, r2.$$.smartPtr = e2, r2.clone();
        var n = r2.clone();
        return this.destructor(e2), n;
      }
      function a() {
        return this.isSmartPointer ? xt(this.registeredClass.instancePrototype, {
          ptrType: this.pointeeType,
          ptr: t,
          smartPtrType: this,
          smartPtr: e2
        }) : xt(this.registeredClass.instancePrototype, {
          ptrType: this,
          ptr: e2
        });
      }
      var o = this.registeredClass.getActualType(t), s = Ee[o];
      if (!s)
        return a.call(this);
      var u;
      this.isConst ? u = s.constPointerType : u = s.pointerType;
      var l = Pe(t, this.registeredClass, u.registeredClass);
      return l === null ? a.call(this) : this.isSmartPointer ? xt(u.registeredClass.instancePrototype, {
        ptrType: u,
        ptr: l,
        smartPtrType: this,
        smartPtr: e2
      }) : xt(u.registeredClass.instancePrototype, {
        ptrType: u,
        ptr: l
      });
    }
    var wt = (e2) => typeof FinalizationRegistry > "u" ? (wt = (t) => t, e2) : (Xt = new FinalizationRegistry((t) => {
      Te(t.$$);
    }), wt = (t) => {
      var r2 = t.$$, n = !!r2.smartPtr;
      if (n) {
        var a = {
          $$: r2
        };
        Xt.register(t, a, t);
      }
      return t;
    }, _e = (t) => Xt.unregister(t), wt(e2)), Zr = () => {
      Object.assign(Ot.prototype, {
        isAliasOf(e2) {
          if (!(this instanceof Ot) || !(e2 instanceof Ot))
            return false;
          var t = this.$$.ptrType.registeredClass, r2 = this.$$.ptr;
          e2.$$ = e2.$$;
          for (var n = e2.$$.ptrType.registeredClass, a = e2.$$.ptr; t.baseClass; )
            r2 = t.upcast(r2), t = t.baseClass;
          for (; n.baseClass; )
            a = n.upcast(a), n = n.baseClass;
          return t === n && r2 === a;
        },
        clone() {
          if (this.$$.ptr || Gt(this), this.$$.preservePointerOnDelete)
            return this.$$.count.value += 1, this;
          var e2 = wt(Object.create(Object.getPrototypeOf(this), {
            $$: {
              value: Lr(this.$$)
            }
          }));
          return e2.$$.count.value += 1, e2.$$.deleteScheduled = false, e2;
        },
        delete() {
          this.$$.ptr || Gt(this), this.$$.deleteScheduled && !this.$$.preservePointerOnDelete && C("Object already scheduled for deletion"), _e(this), Te(this.$$), this.$$.preservePointerOnDelete || (this.$$.smartPtr = void 0, this.$$.ptr = void 0);
        },
        isDeleted() {
          return !this.$$.ptr;
        },
        deleteLater() {
          return this.$$.ptr || Gt(this), this.$$.deleteScheduled && !this.$$.preservePointerOnDelete && C("Object already scheduled for deletion"), yt.push(this), yt.length === 1 && vt && vt(qt), this.$$.deleteScheduled = true, this;
        }
      });
    };
    function Ot() {
    }
    var $t = (e2, t) => Object.defineProperty(t, "name", {
      value: e2
    }), Ae = (e2, t, r2) => {
      if (e2[t].overloadTable === void 0) {
        var n = e2[t];
        e2[t] = function() {
          for (var a = arguments.length, o = new Array(a), s = 0; s < a; s++)
            o[s] = arguments[s];
          return e2[t].overloadTable.hasOwnProperty(o.length) || C(`Function '${r2}' called with an invalid number of arguments (${o.length}) - expects one of (${e2[t].overloadTable})!`), e2[t].overloadTable[o.length].apply(this, o);
        }, e2[t].overloadTable = [], e2[t].overloadTable[n.argCount] = n;
      }
    }, Qt = (e2, t, r2) => {
      c.hasOwnProperty(e2) ? ((r2 === void 0 || c[e2].overloadTable !== void 0 && c[e2].overloadTable[r2] !== void 0) && C(`Cannot register public name '${e2}' twice`), Ae(c, e2, e2), c.hasOwnProperty(r2) && C(`Cannot register multiple overloads of a function with the same number of arguments (${r2})!`), c[e2].overloadTable[r2] = t) : (c[e2] = t, r2 !== void 0 && (c[e2].numArguments = r2));
    }, Jr = 48, Kr = 57, tn = (e2) => {
      if (e2 === void 0)
        return "_unknown";
      e2 = e2.replace(/[^a-zA-Z0-9_]/g, "$");
      var t = e2.charCodeAt(0);
      return t >= Jr && t <= Kr ? `_${e2}` : e2;
    };
    function en(e2, t, r2, n, a, o, s, u) {
      this.name = e2, this.constructor = t, this.instancePrototype = r2, this.rawDestructor = n, this.baseClass = a, this.getActualType = o, this.upcast = s, this.downcast = u, this.pureVirtualFunctions = [];
    }
    var Zt = (e2, t, r2) => {
      for (; t !== r2; )
        t.upcast || C(`Expected null or instance of ${r2.name}, got an instance of ${t.name}`), e2 = t.upcast(e2), t = t.baseClass;
      return e2;
    };
    function rn(e2, t) {
      if (t === null)
        return this.isReference && C(`null is not a valid ${this.name}`), 0;
      t.$$ || C(`Cannot pass "${ne(t)}" as a ${this.name}`), t.$$.ptr || C(`Cannot pass deleted object as a pointer of type ${this.name}`);
      var r2 = t.$$.ptrType.registeredClass, n = Zt(t.$$.ptr, r2, this.registeredClass);
      return n;
    }
    function nn(e2, t) {
      var r2;
      if (t === null)
        return this.isReference && C(`null is not a valid ${this.name}`), this.isSmartPointer ? (r2 = this.rawConstructor(), e2 !== null && e2.push(this.rawDestructor, r2), r2) : 0;
      (!t || !t.$$) && C(`Cannot pass "${ne(t)}" as a ${this.name}`), t.$$.ptr || C(`Cannot pass deleted object as a pointer of type ${this.name}`), !this.isConst && t.$$.ptrType.isConst && C(`Cannot convert argument of type ${t.$$.smartPtrType ? t.$$.smartPtrType.name : t.$$.ptrType.name} to parameter type ${this.name}`);
      var n = t.$$.ptrType.registeredClass;
      if (r2 = Zt(t.$$.ptr, n, this.registeredClass), this.isSmartPointer)
        switch (t.$$.smartPtr === void 0 && C("Passing raw pointer to smart pointer is illegal"), this.sharingPolicy) {
          case 0:
            t.$$.smartPtrType === this ? r2 = t.$$.smartPtr : C(`Cannot convert argument of type ${t.$$.smartPtrType ? t.$$.smartPtrType.name : t.$$.ptrType.name} to parameter type ${this.name}`);
            break;
          case 1:
            r2 = t.$$.smartPtr;
            break;
          case 2:
            if (t.$$.smartPtrType === this)
              r2 = t.$$.smartPtr;
            else {
              var a = t.clone();
              r2 = this.rawShare(r2, Z.toHandle(() => a.delete())), e2 !== null && e2.push(this.rawDestructor, r2);
            }
            break;
          default:
            C("Unsupporting sharing policy");
        }
      return r2;
    }
    function an(e2, t) {
      if (t === null)
        return this.isReference && C(`null is not a valid ${this.name}`), 0;
      t.$$ || C(`Cannot pass "${ne(t)}" as a ${this.name}`), t.$$.ptr || C(`Cannot pass deleted object as a pointer of type ${this.name}`), t.$$.ptrType.isConst && C(`Cannot convert argument of type ${t.$$.ptrType.name} to parameter type ${this.name}`);
      var r2 = t.$$.ptrType.registeredClass, n = Zt(t.$$.ptr, r2, this.registeredClass);
      return n;
    }
    var on = () => {
      Object.assign(Mt.prototype, {
        getPointee(e2) {
          return this.rawGetPointee && (e2 = this.rawGetPointee(e2)), e2;
        },
        destructor(e2) {
          var t;
          (t = this.rawDestructor) === null || t === void 0 || t.call(this, e2);
        },
        argPackAdvance: X,
        readValueFromPointer: mt,
        fromWireType: Qr
      });
    };
    function Mt(e2, t, r2, n, a, o, s, u, l, h, p) {
      this.name = e2, this.registeredClass = t, this.isReference = r2, this.isConst = n, this.isSmartPointer = a, this.pointeeType = o, this.sharingPolicy = s, this.rawGetPointee = u, this.rawConstructor = l, this.rawShare = h, this.rawDestructor = p, !a && t.baseClass === void 0 ? n ? (this.toWireType = rn, this.destructorFunction = null) : (this.toWireType = an, this.destructorFunction = null) : this.toWireType = nn;
    }
    var Fe = (e2, t, r2) => {
      c.hasOwnProperty(e2) || Dt("Replacing nonexistent public symbol"), c[e2].overloadTable !== void 0 && r2 !== void 0 ? c[e2].overloadTable[r2] = t : (c[e2] = t, c[e2].argCount = r2);
    }, sn = (e2, t, r2) => {
      var n = c["dynCall_" + e2];
      return n(t, ...r2);
    }, St = [], De, E = (e2) => {
      var t = St[e2];
      return t || (e2 >= St.length && (St.length = e2 + 1), St[e2] = t = De.get(e2)), t;
    }, un = function(e2, t) {
      let r2 = arguments.length > 2 && arguments[2] !== void 0 ? arguments[2] : [];
      if (e2.includes("j"))
        return sn(e2, t, r2);
      var n = E(t)(...r2);
      return n;
    }, cn = (e2, t) => function() {
      for (var r2 = arguments.length, n = new Array(r2), a = 0; a < r2; a++)
        n[a] = arguments[a];
      return un(e2, t, n);
    }, N = (e2, t) => {
      e2 = I(e2);
      function r2() {
        return e2.includes("j") ? cn(e2, t) : E(t);
      }
      var n = r2();
      return typeof n != "function" && C(`unknown function pointer with signature ${e2}: ${t}`), n;
    }, ln = (e2, t) => {
      var r2 = $t(t, function(n) {
        this.name = t, this.message = n;
        var a = new Error(n).stack;
        a !== void 0 && (this.stack = this.toString() + `
` + a.replace(/^Error(:[^\n]*)?\n/, ""));
      });
      return r2.prototype = Object.create(e2.prototype), r2.prototype.constructor = r2, r2.prototype.toString = function() {
        return this.message === void 0 ? this.name : `${this.name}: ${this.message}`;
      }, r2;
    }, xe, Oe = (e2) => {
      var t = Le(e2), r2 = I(t);
      return J(t), r2;
    }, jt = (e2, t) => {
      var r2 = [], n = {};
      function a(o) {
        if (!n[o] && !rt[o]) {
          if (Ft[o]) {
            Ft[o].forEach(a);
            return;
          }
          r2.push(o), n[o] = true;
        }
      }
      throw t.forEach(a), new xe(`${e2}: ` + r2.map(Oe).join([", "]));
    }, dn = (e2, t, r2, n, a, o, s, u, l, h, p, w, v) => {
      p = I(p), o = N(a, o), u && (u = N(s, u)), h && (h = N(l, h)), v = N(w, v);
      var b = tn(p);
      Qt(b, function() {
        jt(`Cannot construct ${p} due to unbound types`, [n]);
      }), nt([e2, t, r2], n ? [n] : [], (x) => {
        x = x[0];
        var k, P;
        n ? (k = x.registeredClass, P = k.instancePrototype) : P = Ot.prototype;
        var j = $t(p, function() {
          if (Object.getPrototypeOf(this) !== d)
            throw new ut("Use 'new' to construct " + p);
          if (m.constructor_body === void 0)
            throw new ut(p + " has no accessible constructor");
          for (var Qe = arguments.length, kt = new Array(Qe), Ht = 0; Ht < Qe; Ht++)
            kt[Ht] = arguments[Ht];
          var Ze = m.constructor_body[kt.length];
          if (Ze === void 0)
            throw new ut(`Tried to invoke ctor of ${p} with invalid number of parameters (${kt.length}) - expected (${Object.keys(m.constructor_body).toString()}) parameters instead!`);
          return Ze.apply(this, kt);
        }), d = Object.create(P, {
          constructor: {
            value: j
          }
        });
        j.prototype = d;
        var m = new en(p, j, d, v, k, o, u, h);
        if (m.baseClass) {
          var O, M;
          (M = (O = m.baseClass).__derivedClasses) !== null && M !== void 0 || (O.__derivedClasses = []), m.baseClass.__derivedClasses.push(m);
        }
        var ct = new Mt(p, m, true, false, false), Wt = new Mt(p + "*", m, false, false, false), qe = new Mt(p + " const*", m, false, true, false);
        return Ee[e2] = {
          pointerType: Wt,
          constPointerType: qe
        }, Fe(b, j), [ct, Wt, qe];
      });
    }, Jt = (e2, t) => {
      for (var r2 = [], n = 0; n < e2; n++)
        r2.push(_[t + n * 4 >> 2]);
      return r2;
    };
    function hn(e2) {
      for (var t = 1; t < e2.length; ++t)
        if (e2[t] !== null && e2[t].destructorFunction === void 0)
          return true;
      return false;
    }
    function Kt(e2, t, r2, n, a, o) {
      var s = t.length;
      s < 2 && C("argTypes array size mismatch! Must at least get return value and 'this' types!");
      var u = t[1] !== null && r2 !== null, l = hn(t), h = t[0].name !== "void", p = s - 2, w = new Array(p), v = [], b = [], x = function() {
        arguments.length !== p && C(`function ${e2} called with ${arguments.length} arguments, expected ${p}`), b.length = 0;
        var k;
        v.length = u ? 2 : 1, v[0] = a, u && (k = t[1].toWireType(b, this), v[1] = k);
        for (var P = 0; P < p; ++P)
          w[P] = t[P + 2].toWireType(b, P < 0 || arguments.length <= P ? void 0 : arguments[P]), v.push(w[P]);
        var j = n(...v);
        function d(m) {
          if (l)
            Nt(b);
          else
            for (var O = u ? 1 : 2; O < t.length; O++) {
              var M = O === 1 ? k : w[O - 2];
              t[O].destructorFunction !== null && t[O].destructorFunction(M);
            }
          if (h)
            return t[0].fromWireType(m);
        }
        return d(j);
      };
      return $t(e2, x);
    }
    var fn = (e2, t, r2, n, a, o) => {
      var s = Jt(t, r2);
      a = N(n, a), nt([], [e2], (u) => {
        u = u[0];
        var l = `constructor ${u.name}`;
        if (u.registeredClass.constructor_body === void 0 && (u.registeredClass.constructor_body = []), u.registeredClass.constructor_body[t - 1] !== void 0)
          throw new ut(`Cannot register multiple constructors with identical number of parameters (${t - 1}) for class '${u.name}'! Overload resolution is currently only performed using the parameter count, not actual type info!`);
        return u.registeredClass.constructor_body[t - 1] = () => {
          jt(`Cannot construct ${u.name} due to unbound types`, s);
        }, nt([], s, (h) => (h.splice(1, 0, null), u.registeredClass.constructor_body[t - 1] = Kt(l, h, null, a, o), [])), [];
      });
    }, Me = (e2) => {
      e2 = e2.trim();
      const t = e2.indexOf("(");
      return t !== -1 ? e2.substr(0, t) : e2;
    }, pn = (e2, t, r2, n, a, o, s, u, l) => {
      var h = Jt(r2, n);
      t = I(t), t = Me(t), o = N(a, o), nt([], [e2], (p) => {
        p = p[0];
        var w = `${p.name}.${t}`;
        t.startsWith("@@") && (t = Symbol[t.substring(2)]), u && p.registeredClass.pureVirtualFunctions.push(t);
        function v() {
          jt(`Cannot call ${w} due to unbound types`, h);
        }
        var b = p.registeredClass.instancePrototype, x = b[t];
        return x === void 0 || x.overloadTable === void 0 && x.className !== p.name && x.argCount === r2 - 2 ? (v.argCount = r2 - 2, v.className = p.name, b[t] = v) : (Ae(b, t, w), b[t].overloadTable[r2 - 2] = v), nt([], h, (k) => {
          var P = Kt(w, k, p, o, s);
          return b[t].overloadTable === void 0 ? (P.argCount = r2 - 2, b[t] = P) : b[t].overloadTable[r2 - 2] = P, [];
        }), [];
      });
    }, te = [], Q = [], ee = (e2) => {
      e2 > 9 && --Q[e2 + 1] === 0 && (Q[e2] = void 0, te.push(e2));
    }, mn = () => Q.length / 2 - 5 - te.length, yn = () => {
      Q.push(0, 1, void 0, 1, null, 1, true, 1, false, 1), c.count_emval_handles = mn;
    }, Z = {
      toValue: (e2) => (e2 || C("Cannot use deleted val. handle = " + e2), Q[e2]),
      toHandle: (e2) => {
        switch (e2) {
          case void 0:
            return 2;
          case null:
            return 4;
          case true:
            return 6;
          case false:
            return 8;
          default: {
            const t = te.pop() || Q.length;
            return Q[t] = e2, Q[t + 1] = 1, t;
          }
        }
      }
    }, vn = {
      name: "emscripten::val",
      fromWireType: (e2) => {
        var t = Z.toValue(e2);
        return ee(e2), t;
      },
      toWireType: (e2, t) => Z.toHandle(t),
      argPackAdvance: X,
      readValueFromPointer: mt,
      destructorFunction: null
    }, Se = (e2) => G(e2, vn), gn = (e2, t, r2) => {
      switch (t) {
        case 1:
          return r2 ? function(n) {
            return this.fromWireType(z[n]);
          } : function(n) {
            return this.fromWireType(R[n]);
          };
        case 2:
          return r2 ? function(n) {
            return this.fromWireType(ot[n >> 1]);
          } : function(n) {
            return this.fromWireType(ft[n >> 1]);
          };
        case 4:
          return r2 ? function(n) {
            return this.fromWireType(W[n >> 2]);
          } : function(n) {
            return this.fromWireType(_[n >> 2]);
          };
        default:
          throw new TypeError(`invalid integer width (${t}): ${e2}`);
      }
    }, wn = (e2, t, r2, n) => {
      t = I(t);
      function a() {
      }
      a.values = {}, G(e2, {
        name: t,
        constructor: a,
        fromWireType: function(o) {
          return this.constructor.values[o];
        },
        toWireType: (o, s) => s.value,
        argPackAdvance: X,
        readValueFromPointer: gn(t, r2, n),
        destructorFunction: null
      }), Qt(t, a);
    }, re = (e2, t) => {
      var r2 = rt[e2];
      return r2 === void 0 && C(`${t} has unknown type ${Oe(e2)}`), r2;
    }, $n = (e2, t, r2) => {
      var n = re(e2, "enum");
      t = I(t);
      var a = n.constructor, o = Object.create(n.constructor.prototype, {
        value: {
          value: r2
        },
        constructor: {
          value: $t(`${n.name}_${t}`, function() {
          })
        }
      });
      a.values[r2] = o, a[t] = o;
    }, ne = (e2) => {
      if (e2 === null)
        return "null";
      var t = typeof e2;
      return t === "object" || t === "array" || t === "function" ? e2.toString() : "" + e2;
    }, bn = (e2, t) => {
      switch (t) {
        case 4:
          return function(r2) {
            return this.fromWireType(he[r2 >> 2]);
          };
        case 8:
          return function(r2) {
            return this.fromWireType(fe[r2 >> 3]);
          };
        default:
          throw new TypeError(`invalid float width (${t}): ${e2}`);
      }
    }, Cn = (e2, t, r2) => {
      t = I(t), G(e2, {
        name: t,
        fromWireType: (n) => n,
        toWireType: (n, a) => a,
        argPackAdvance: X,
        readValueFromPointer: bn(t, r2),
        destructorFunction: null
      });
    }, _n = (e2, t, r2, n, a, o, s) => {
      var u = Jt(t, r2);
      e2 = I(e2), e2 = Me(e2), a = N(n, a), Qt(e2, function() {
        jt(`Cannot call ${e2} due to unbound types`, u);
      }, t - 1), nt([], u, (l) => {
        var h = [l[0], null].concat(l.slice(1));
        return Fe(e2, Kt(e2, h, null, a, o), t - 1), [];
      });
    }, Tn = (e2, t, r2) => {
      switch (t) {
        case 1:
          return r2 ? (n) => z[n] : (n) => R[n];
        case 2:
          return r2 ? (n) => ot[n >> 1] : (n) => ft[n >> 1];
        case 4:
          return r2 ? (n) => W[n >> 2] : (n) => _[n >> 2];
        default:
          throw new TypeError(`invalid integer width (${t}): ${e2}`);
      }
    }, Pn = (e2, t, r2, n, a) => {
      t = I(t);
      var o = (p) => p;
      if (n === 0) {
        var s = 32 - 8 * r2;
        o = (p) => p << s >>> s;
      }
      var u = t.includes("unsigned"), l = (p, w) => {
      }, h;
      u ? h = function(p, w) {
        return l(w, this.name), w >>> 0;
      } : h = function(p, w) {
        return l(w, this.name), w;
      }, G(e2, {
        name: t,
        fromWireType: o,
        toWireType: h,
        argPackAdvance: X,
        readValueFromPointer: Tn(t, r2, n !== 0),
        destructorFunction: null
      });
    }, En = (e2, t, r2) => {
      var n = [Int8Array, Uint8Array, Int16Array, Uint16Array, Int32Array, Uint32Array, Float32Array, Float64Array], a = n[t];
      function o(s) {
        var u = _[s >> 2], l = _[s + 4 >> 2];
        return new a(z.buffer, l, u);
      }
      r2 = I(r2), G(e2, {
        name: r2,
        fromWireType: o,
        argPackAdvance: X,
        readValueFromPointer: o
      }, {
        ignoreDuplicateRegistrations: true
      });
    }, An = (e2, t) => {
      Se(e2);
    }, je = (e2, t, r2, n) => {
      if (!(n > 0))
        return 0;
      for (var a = r2, o = r2 + n - 1, s = 0; s < e2.length; ++s) {
        var u = e2.charCodeAt(s);
        if (u >= 55296 && u <= 57343) {
          var l = e2.charCodeAt(++s);
          u = 65536 + ((u & 1023) << 10) | l & 1023;
        }
        if (u <= 127) {
          if (r2 >= o)
            break;
          t[r2++] = u;
        } else if (u <= 2047) {
          if (r2 + 1 >= o)
            break;
          t[r2++] = 192 | u >> 6, t[r2++] = 128 | u & 63;
        } else if (u <= 65535) {
          if (r2 + 2 >= o)
            break;
          t[r2++] = 224 | u >> 12, t[r2++] = 128 | u >> 6 & 63, t[r2++] = 128 | u & 63;
        } else {
          if (r2 + 3 >= o)
            break;
          t[r2++] = 240 | u >> 18, t[r2++] = 128 | u >> 12 & 63, t[r2++] = 128 | u >> 6 & 63, t[r2++] = 128 | u & 63;
        }
      }
      return t[r2] = 0, r2 - a;
    }, Fn = (e2, t, r2) => je(e2, R, t, r2), Ie = (e2) => {
      for (var t = 0, r2 = 0; r2 < e2.length; ++r2) {
        var n = e2.charCodeAt(r2);
        n <= 127 ? t++ : n <= 2047 ? t += 2 : n >= 55296 && n <= 57343 ? (t += 4, ++r2) : t += 3;
      }
      return t;
    }, Re = typeof TextDecoder < "u" ? new TextDecoder("utf8") : void 0, We = (e2, t, r2) => {
      for (var n = t + r2, a = t; e2[a] && !(a >= n); )
        ++a;
      if (a - t > 16 && e2.buffer && Re)
        return Re.decode(e2.subarray(t, a));
      for (var o = ""; t < a; ) {
        var s = e2[t++];
        if (!(s & 128)) {
          o += String.fromCharCode(s);
          continue;
        }
        var u = e2[t++] & 63;
        if ((s & 224) == 192) {
          o += String.fromCharCode((s & 31) << 6 | u);
          continue;
        }
        var l = e2[t++] & 63;
        if ((s & 240) == 224 ? s = (s & 15) << 12 | u << 6 | l : s = (s & 7) << 18 | u << 12 | l << 6 | e2[t++] & 63, s < 65536)
          o += String.fromCharCode(s);
        else {
          var h = s - 65536;
          o += String.fromCharCode(55296 | h >> 10, 56320 | h & 1023);
        }
      }
      return o;
    }, ae = (e2, t) => e2 ? We(R, e2, t) : "", Dn = (e2, t) => {
      t = I(t);
      var r2 = t === "std::string";
      G(e2, {
        name: t,
        fromWireType(n) {
          var a = _[n >> 2], o = n + 4, s;
          if (r2)
            for (var u = o, l = 0; l <= a; ++l) {
              var h = o + l;
              if (l == a || R[h] == 0) {
                var p = h - u, w = ae(u, p);
                s === void 0 ? s = w : (s += "\0", s += w), u = h + 1;
              }
            }
          else {
            for (var v = new Array(a), l = 0; l < a; ++l)
              v[l] = String.fromCharCode(R[o + l]);
            s = v.join("");
          }
          return J(n), s;
        },
        toWireType(n, a) {
          a instanceof ArrayBuffer && (a = new Uint8Array(a));
          var o, s = typeof a == "string";
          s || a instanceof Uint8Array || a instanceof Uint8ClampedArray || a instanceof Int8Array || C("Cannot pass non-string to std::string"), r2 && s ? o = Ie(a) : o = a.length;
          var u = se(4 + o + 1), l = u + 4;
          if (_[u >> 2] = o, r2 && s)
            Fn(a, l, o + 1);
          else if (s)
            for (var h = 0; h < o; ++h) {
              var p = a.charCodeAt(h);
              p > 255 && (J(l), C("String has UTF-16 code units that do not fit in 8 bits")), R[l + h] = p;
            }
          else
            for (var h = 0; h < o; ++h)
              R[l + h] = a[h];
          return n !== null && n.push(J, u), u;
        },
        argPackAdvance: X,
        readValueFromPointer: mt,
        destructorFunction(n) {
          J(n);
        }
      });
    }, ke = typeof TextDecoder < "u" ? new TextDecoder("utf-16le") : void 0, xn = (e2, t) => {
      for (var r2 = e2, n = r2 >> 1, a = n + t / 2; !(n >= a) && ft[n]; )
        ++n;
      if (r2 = n << 1, r2 - e2 > 32 && ke)
        return ke.decode(R.subarray(e2, r2));
      for (var o = "", s = 0; !(s >= t / 2); ++s) {
        var u = ot[e2 + s * 2 >> 1];
        if (u == 0)
          break;
        o += String.fromCharCode(u);
      }
      return o;
    }, On = (e2, t, r2) => {
      var n;
      if ((n = r2) !== null && n !== void 0 || (r2 = 2147483647), r2 < 2)
        return 0;
      r2 -= 2;
      for (var a = t, o = r2 < e2.length * 2 ? r2 / 2 : e2.length, s = 0; s < o; ++s) {
        var u = e2.charCodeAt(s);
        ot[t >> 1] = u, t += 2;
      }
      return ot[t >> 1] = 0, t - a;
    }, Mn = (e2) => e2.length * 2, Sn = (e2, t) => {
      for (var r2 = 0, n = ""; !(r2 >= t / 4); ) {
        var a = W[e2 + r2 * 4 >> 2];
        if (a == 0)
          break;
        if (++r2, a >= 65536) {
          var o = a - 65536;
          n += String.fromCharCode(55296 | o >> 10, 56320 | o & 1023);
        } else
          n += String.fromCharCode(a);
      }
      return n;
    }, jn = (e2, t, r2) => {
      var n;
      if ((n = r2) !== null && n !== void 0 || (r2 = 2147483647), r2 < 4)
        return 0;
      for (var a = t, o = a + r2 - 4, s = 0; s < e2.length; ++s) {
        var u = e2.charCodeAt(s);
        if (u >= 55296 && u <= 57343) {
          var l = e2.charCodeAt(++s);
          u = 65536 + ((u & 1023) << 10) | l & 1023;
        }
        if (W[t >> 2] = u, t += 4, t + 4 > o)
          break;
      }
      return W[t >> 2] = 0, t - a;
    }, In = (e2) => {
      for (var t = 0, r2 = 0; r2 < e2.length; ++r2) {
        var n = e2.charCodeAt(r2);
        n >= 55296 && n <= 57343 && ++r2, t += 4;
      }
      return t;
    }, Rn = (e2, t, r2) => {
      r2 = I(r2);
      var n, a, o, s;
      t === 2 ? (n = xn, a = On, s = Mn, o = (u) => ft[u >> 1]) : t === 4 && (n = Sn, a = jn, s = In, o = (u) => _[u >> 2]), G(e2, {
        name: r2,
        fromWireType: (u) => {
          for (var l = _[u >> 2], h, p = u + 4, w = 0; w <= l; ++w) {
            var v = u + 4 + w * t;
            if (w == l || o(v) == 0) {
              var b = v - p, x = n(p, b);
              h === void 0 ? h = x : (h += "\0", h += x), p = v + t;
            }
          }
          return J(u), h;
        },
        toWireType: (u, l) => {
          typeof l != "string" && C(`Cannot pass non-string to C++ string type ${r2}`);
          var h = s(l), p = se(4 + h + t);
          return _[p >> 2] = h / t, a(l, p + 4, h + t), u !== null && u.push(J, p), p;
        },
        argPackAdvance: X,
        readValueFromPointer: mt,
        destructorFunction(u) {
          J(u);
        }
      });
    }, Wn = (e2, t, r2, n, a, o) => {
      At[e2] = {
        name: I(t),
        rawConstructor: N(r2, n),
        rawDestructor: N(a, o),
        fields: []
      };
    }, kn = (e2, t, r2, n, a, o, s, u, l, h) => {
      At[e2].fields.push({
        fieldName: I(t),
        getterReturnType: r2,
        getter: N(n, a),
        getterContext: o,
        setterArgumentType: s,
        setter: N(u, l),
        setterContext: h
      });
    }, Hn = (e2, t) => {
      t = I(t), G(e2, {
        isVoid: true,
        name: t,
        argPackAdvance: 0,
        fromWireType: () => {
        },
        toWireType: (r2, n) => {
        }
      });
    }, oe = [], Bn = (e2, t, r2, n) => (e2 = oe[e2], t = Z.toValue(t), e2(null, t, r2, n)), Un = {}, Ln = (e2) => {
      var t = Un[e2];
      return t === void 0 ? I(e2) : t;
    }, He = () => {
      if (typeof globalThis == "object")
        return globalThis;
      function e2(t) {
        t.$$$embind_global$$$ = t;
        var r2 = typeof $$$embind_global$$$ == "object" && t.$$$embind_global$$$ == t;
        return r2 || delete t.$$$embind_global$$$, r2;
      }
      if (typeof $$$embind_global$$$ == "object" || (typeof global == "object" && e2(global) ? $$$embind_global$$$ = global : typeof self == "object" && e2(self) && ($$$embind_global$$$ = self), typeof $$$embind_global$$$ == "object"))
        return $$$embind_global$$$;
      throw Error("unable to get global object.");
    }, Vn = (e2) => e2 === 0 ? Z.toHandle(He()) : (e2 = Ln(e2), Z.toHandle(He()[e2])), Yn = (e2) => {
      var t = oe.length;
      return oe.push(e2), t;
    }, zn = (e2, t) => {
      for (var r2 = new Array(e2), n = 0; n < e2; ++n)
        r2[n] = re(_[t + n * 4 >> 2], "parameter " + n);
      return r2;
    }, Nn = Reflect.construct, Gn = (e2, t, r2) => {
      var n = [], a = e2.toWireType(n, r2);
      return n.length && (_[t >> 2] = Z.toHandle(n)), a;
    }, Xn = (e2, t, r2) => {
      var n = zn(e2, t), a = n.shift();
      e2--;
      var o = new Array(e2), s = (l, h, p, w) => {
        for (var v = 0, b = 0; b < e2; ++b)
          o[b] = n[b].readValueFromPointer(w + v), v += n[b].argPackAdvance;
        var x = r2 === 1 ? Nn(h, o) : h.apply(l, o);
        return Gn(a, p, x);
      }, u = `methodCaller<(${n.map((l) => l.name).join(", ")}) => ${a.name}>`;
      return Yn($t(u, s));
    }, qn = (e2) => {
      e2 > 9 && (Q[e2 + 1] += 1);
    }, Qn = (e2) => {
      var t = Z.toValue(e2);
      Nt(t), ee(e2);
    }, Zn = (e2, t) => {
      e2 = re(e2, "_emval_take_value");
      var r2 = e2.readValueFromPointer(t);
      return Z.toHandle(r2);
    }, Jn = () => {
      Lt("");
    }, Kn = (e2, t, r2) => R.copyWithin(e2, t, t + r2), ta = () => 2147483648, ea = (e2) => {
      var t = Tt.buffer, r2 = (e2 - t.byteLength + 65535) / 65536;
      try {
        return Tt.grow(r2), pe(), 1;
      } catch {
      }
    }, ra = (e2) => {
      var t = R.length;
      e2 >>>= 0;
      var r2 = ta();
      if (e2 > r2)
        return false;
      for (var n = (l, h) => l + (h - l % h) % h, a = 1; a <= 4; a *= 2) {
        var o = t * (1 + 0.2 / a);
        o = Math.min(o, e2 + 100663296);
        var s = Math.min(r2, n(Math.max(e2, o), 65536)), u = ea(s);
        if (u)
          return true;
      }
      return false;
    }, ie = {}, na = () => U || "./this.program", bt = () => {
      if (!bt.strings) {
        var e2 = (typeof navigator == "object" && navigator.languages && navigator.languages[0] || "C").replace("-", "_") + ".UTF-8", t = {
          USER: "web_user",
          LOGNAME: "web_user",
          PATH: "/",
          PWD: "/",
          HOME: "/home/web_user",
          LANG: e2,
          _: na()
        };
        for (var r2 in ie)
          ie[r2] === void 0 ? delete t[r2] : t[r2] = ie[r2];
        var n = [];
        for (var r2 in t)
          n.push(`${r2}=${t[r2]}`);
        bt.strings = n;
      }
      return bt.strings;
    }, aa = (e2, t) => {
      for (var r2 = 0; r2 < e2.length; ++r2)
        z[t++] = e2.charCodeAt(r2);
      z[t] = 0;
    }, oa = (e2, t) => {
      var r2 = 0;
      return bt().forEach((n, a) => {
        var o = t + r2;
        _[e2 + a * 4 >> 2] = o, aa(n, o), r2 += n.length + 1;
      }), 0;
    }, ia = (e2, t) => {
      var r2 = bt();
      _[e2 >> 2] = r2.length;
      var n = 0;
      return r2.forEach((a) => n += a.length + 1), _[t >> 2] = n, 0;
    }, sa = (e2) => 52;
    function ua(e2, t, r2, n, a) {
      return 70;
    }
    var ca = [null, [], []], la = (e2, t) => {
      var r2 = ca[e2];
      t === 0 || t === 10 ? ((e2 === 1 ? _t : K)(We(r2, 0)), r2.length = 0) : r2.push(t);
    }, da = (e2, t, r2, n) => {
      for (var a = 0, o = 0; o < r2; o++) {
        var s = _[t >> 2], u = _[t + 4 >> 2];
        t += 8;
        for (var l = 0; l < u; l++)
          la(e2, R[s + l]);
        a += u;
      }
      return _[n >> 2] = a, 0;
    }, ha = (e2) => e2, It = (e2) => e2 % 4 === 0 && (e2 % 100 !== 0 || e2 % 400 === 0), fa = (e2, t) => {
      for (var r2 = 0, n = 0; n <= t; r2 += e2[n++])
        ;
      return r2;
    }, Be = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31], Ue = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31], pa = (e2, t) => {
      for (var r2 = new Date(e2.getTime()); t > 0; ) {
        var n = It(r2.getFullYear()), a = r2.getMonth(), o = (n ? Be : Ue)[a];
        if (t > o - r2.getDate())
          t -= o - r2.getDate() + 1, r2.setDate(1), a < 11 ? r2.setMonth(a + 1) : (r2.setMonth(0), r2.setFullYear(r2.getFullYear() + 1));
        else
          return r2.setDate(r2.getDate() + t), r2;
      }
      return r2;
    };
    function ma(e2, t, r2) {
      var n = Ie(e2) + 1, a = new Array(n);
      return je(e2, a, 0, a.length), a;
    }
    var ya = (e2, t) => {
      z.set(e2, t);
    }, va = (e2, t, r2, n) => {
      var a = _[n + 40 >> 2], o = {
        tm_sec: W[n >> 2],
        tm_min: W[n + 4 >> 2],
        tm_hour: W[n + 8 >> 2],
        tm_mday: W[n + 12 >> 2],
        tm_mon: W[n + 16 >> 2],
        tm_year: W[n + 20 >> 2],
        tm_wday: W[n + 24 >> 2],
        tm_yday: W[n + 28 >> 2],
        tm_isdst: W[n + 32 >> 2],
        tm_gmtoff: W[n + 36 >> 2],
        tm_zone: a ? ae(a) : ""
      }, s = ae(r2), u = {
        "%c": "%a %b %d %H:%M:%S %Y",
        "%D": "%m/%d/%y",
        "%F": "%Y-%m-%d",
        "%h": "%b",
        "%r": "%I:%M:%S %p",
        "%R": "%H:%M",
        "%T": "%H:%M:%S",
        "%x": "%m/%d/%y",
        "%X": "%H:%M:%S",
        "%Ec": "%c",
        "%EC": "%C",
        "%Ex": "%m/%d/%y",
        "%EX": "%H:%M:%S",
        "%Ey": "%y",
        "%EY": "%Y",
        "%Od": "%d",
        "%Oe": "%e",
        "%OH": "%H",
        "%OI": "%I",
        "%Om": "%m",
        "%OM": "%M",
        "%OS": "%S",
        "%Ou": "%u",
        "%OU": "%U",
        "%OV": "%V",
        "%Ow": "%w",
        "%OW": "%W",
        "%Oy": "%y"
      };
      for (var l in u)
        s = s.replace(new RegExp(l, "g"), u[l]);
      var h = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], p = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
      function w(d, m, O) {
        for (var M = typeof d == "number" ? d.toString() : d || ""; M.length < m; )
          M = O[0] + M;
        return M;
      }
      function v(d, m) {
        return w(d, m, "0");
      }
      function b(d, m) {
        function O(ct) {
          return ct < 0 ? -1 : ct > 0 ? 1 : 0;
        }
        var M;
        return (M = O(d.getFullYear() - m.getFullYear())) === 0 && (M = O(d.getMonth() - m.getMonth())) === 0 && (M = O(d.getDate() - m.getDate())), M;
      }
      function x(d) {
        switch (d.getDay()) {
          case 0:
            return new Date(d.getFullYear() - 1, 11, 29);
          case 1:
            return d;
          case 2:
            return new Date(d.getFullYear(), 0, 3);
          case 3:
            return new Date(d.getFullYear(), 0, 2);
          case 4:
            return new Date(d.getFullYear(), 0, 1);
          case 5:
            return new Date(d.getFullYear() - 1, 11, 31);
          case 6:
            return new Date(d.getFullYear() - 1, 11, 30);
        }
      }
      function k(d) {
        var m = pa(new Date(d.tm_year + 1900, 0, 1), d.tm_yday), O = new Date(m.getFullYear(), 0, 4), M = new Date(m.getFullYear() + 1, 0, 4), ct = x(O), Wt = x(M);
        return b(ct, m) <= 0 ? b(Wt, m) <= 0 ? m.getFullYear() + 1 : m.getFullYear() : m.getFullYear() - 1;
      }
      var P = {
        "%a": (d) => h[d.tm_wday].substring(0, 3),
        "%A": (d) => h[d.tm_wday],
        "%b": (d) => p[d.tm_mon].substring(0, 3),
        "%B": (d) => p[d.tm_mon],
        "%C": (d) => {
          var m = d.tm_year + 1900;
          return v(m / 100 | 0, 2);
        },
        "%d": (d) => v(d.tm_mday, 2),
        "%e": (d) => w(d.tm_mday, 2, " "),
        "%g": (d) => k(d).toString().substring(2),
        "%G": k,
        "%H": (d) => v(d.tm_hour, 2),
        "%I": (d) => {
          var m = d.tm_hour;
          return m == 0 ? m = 12 : m > 12 && (m -= 12), v(m, 2);
        },
        "%j": (d) => v(d.tm_mday + fa(It(d.tm_year + 1900) ? Be : Ue, d.tm_mon - 1), 3),
        "%m": (d) => v(d.tm_mon + 1, 2),
        "%M": (d) => v(d.tm_min, 2),
        "%n": () => `
`,
        "%p": (d) => d.tm_hour >= 0 && d.tm_hour < 12 ? "AM" : "PM",
        "%S": (d) => v(d.tm_sec, 2),
        "%t": () => "	",
        "%u": (d) => d.tm_wday || 7,
        "%U": (d) => {
          var m = d.tm_yday + 7 - d.tm_wday;
          return v(Math.floor(m / 7), 2);
        },
        "%V": (d) => {
          var m = Math.floor((d.tm_yday + 7 - (d.tm_wday + 6) % 7) / 7);
          if ((d.tm_wday + 371 - d.tm_yday - 2) % 7 <= 2 && m++, m) {
            if (m == 53) {
              var O = (d.tm_wday + 371 - d.tm_yday) % 7;
              O != 4 && (O != 3 || !It(d.tm_year)) && (m = 1);
            }
          } else {
            m = 52;
            var M = (d.tm_wday + 7 - d.tm_yday - 1) % 7;
            (M == 4 || M == 5 && It(d.tm_year % 400 - 1)) && m++;
          }
          return v(m, 2);
        },
        "%w": (d) => d.tm_wday,
        "%W": (d) => {
          var m = d.tm_yday + 7 - (d.tm_wday + 6) % 7;
          return v(Math.floor(m / 7), 2);
        },
        "%y": (d) => (d.tm_year + 1900).toString().substring(2),
        "%Y": (d) => d.tm_year + 1900,
        "%z": (d) => {
          var m = d.tm_gmtoff, O = m >= 0;
          return m = Math.abs(m) / 60, m = m / 60 * 100 + m % 60, (O ? "+" : "-") + ("0000" + m).slice(-4);
        },
        "%Z": (d) => d.tm_zone,
        "%%": () => "%"
      };
      s = s.replace(/%%/g, "\0\0");
      for (var l in P)
        s.includes(l) && (s = s.replace(new RegExp(l, "g"), P[l](o)));
      s = s.replace(/\0\0/g, "%");
      var j = ma(s);
      return j.length > t ? 0 : (ya(j, e2), j.length - 1);
    }, ga = (e2, t, r2, n, a) => va(e2, t, r2, n);
    be = c.InternalError = class extends Error {
      constructor(e2) {
        super(e2), this.name = "InternalError";
      }
    }, Hr(), ut = c.BindingError = class extends Error {
      constructor(e2) {
        super(e2), this.name = "BindingError";
      }
    }, Zr(), Gr(), on(), xe = c.UnboundTypeError = ln(Error, "UnboundTypeError"), yn();
    var wa = {
      s: Fr,
      u: Dr,
      b: Or,
      g: Mr,
      q: Sr,
      K: jr,
      f: Ir,
      Y: Rr,
      e: xr,
      ha: Wr,
      U: kr,
      ba: Ur,
      fa: dn,
      ea: fn,
      w: pn,
      aa: Se,
      x: wn,
      h: $n,
      O: Cn,
      P: _n,
      t: Pn,
      o: En,
      ga: An,
      N: Dn,
      C: Rn,
      A: Wn,
      ia: kn,
      ca: Hn,
      E: Bn,
      ka: ee,
      la: Vn,
      M: Xn,
      Q: qn,
      R: Qn,
      da: Zn,
      B: Jn,
      $: Kn,
      Z: ra,
      W: oa,
      X: ia,
      _: sa,
      T: ua,
      L: da,
      F: Ia,
      D: Ta,
      G: ja,
      m: Ra,
      a: $a,
      d: Ea,
      p: _a,
      k: Sa,
      I: Oa,
      v: Da,
      H: Ma,
      z: ka,
      S: Ba,
      l: Aa,
      j: Pa,
      c: Ca,
      n: ba,
      J: xa,
      r: Wa,
      i: Fa,
      y: Ha,
      ja: ha,
      V: ga
    }, A = Ar(), J = c._free = (e2) => (J = c._free = A.oa)(e2), se = c._malloc = (e2) => (se = c._malloc = A.pa)(e2), Le = (e2) => (Le = A.ra)(e2), T = (e2, t) => (T = A.sa)(e2, t), Ct = (e2) => (Ct = A.ta)(e2), F = () => (F = A.ua)(), D = (e2) => (D = A.va)(e2), Ve = (e2) => (Ve = A.wa)(e2), Ye = (e2) => (Ye = A.xa)(e2), ze = (e2, t, r2) => (ze = A.ya)(e2, t, r2), Ne = (e2) => (Ne = A.za)(e2);
    c.dynCall_viijii = (e2, t, r2, n, a, o, s) => (c.dynCall_viijii = A.Aa)(e2, t, r2, n, a, o, s), c.dynCall_jiji = (e2, t, r2, n, a) => (c.dynCall_jiji = A.Ba)(e2, t, r2, n, a);
    var Ge = c.dynCall_jiiii = (e2, t, r2, n, a) => (Ge = c.dynCall_jiiii = A.Ca)(e2, t, r2, n, a);
    c.dynCall_iiiiij = (e2, t, r2, n, a, o, s) => (c.dynCall_iiiiij = A.Da)(e2, t, r2, n, a, o, s), c.dynCall_iiiiijj = (e2, t, r2, n, a, o, s, u, l) => (c.dynCall_iiiiijj = A.Ea)(e2, t, r2, n, a, o, s, u, l), c.dynCall_iiiiiijj = (e2, t, r2, n, a, o, s, u, l, h) => (c.dynCall_iiiiiijj = A.Fa)(e2, t, r2, n, a, o, s, u, l, h);
    function $a(e2, t) {
      var r2 = F();
      try {
        return E(e2)(t);
      } catch (n) {
        if (D(r2), n !== n + 0)
          throw n;
        T(1, 0);
      }
    }
    function ba(e2, t, r2, n) {
      var a = F();
      try {
        E(e2)(t, r2, n);
      } catch (o) {
        if (D(a), o !== o + 0)
          throw o;
        T(1, 0);
      }
    }
    function Ca(e2, t, r2) {
      var n = F();
      try {
        E(e2)(t, r2);
      } catch (a) {
        if (D(n), a !== a + 0)
          throw a;
        T(1, 0);
      }
    }
    function _a(e2, t, r2, n) {
      var a = F();
      try {
        return E(e2)(t, r2, n);
      } catch (o) {
        if (D(a), o !== o + 0)
          throw o;
        T(1, 0);
      }
    }
    function Ta(e2, t, r2, n, a) {
      var o = F();
      try {
        return E(e2)(t, r2, n, a);
      } catch (s) {
        if (D(o), s !== s + 0)
          throw s;
        T(1, 0);
      }
    }
    function Pa(e2, t) {
      var r2 = F();
      try {
        E(e2)(t);
      } catch (n) {
        if (D(r2), n !== n + 0)
          throw n;
        T(1, 0);
      }
    }
    function Ea(e2, t, r2) {
      var n = F();
      try {
        return E(e2)(t, r2);
      } catch (a) {
        if (D(n), a !== a + 0)
          throw a;
        T(1, 0);
      }
    }
    function Aa(e2) {
      var t = F();
      try {
        E(e2)();
      } catch (r2) {
        if (D(t), r2 !== r2 + 0)
          throw r2;
        T(1, 0);
      }
    }
    function Fa(e2, t, r2, n, a, o, s, u, l, h, p) {
      var w = F();
      try {
        E(e2)(t, r2, n, a, o, s, u, l, h, p);
      } catch (v) {
        if (D(w), v !== v + 0)
          throw v;
        T(1, 0);
      }
    }
    function Da(e2, t, r2, n, a, o, s) {
      var u = F();
      try {
        return E(e2)(t, r2, n, a, o, s);
      } catch (l) {
        if (D(u), l !== l + 0)
          throw l;
        T(1, 0);
      }
    }
    function xa(e2, t, r2, n, a) {
      var o = F();
      try {
        E(e2)(t, r2, n, a);
      } catch (s) {
        if (D(o), s !== s + 0)
          throw s;
        T(1, 0);
      }
    }
    function Oa(e2, t, r2, n, a, o) {
      var s = F();
      try {
        return E(e2)(t, r2, n, a, o);
      } catch (u) {
        if (D(s), u !== u + 0)
          throw u;
        T(1, 0);
      }
    }
    function Ma(e2, t, r2, n, a, o, s, u) {
      var l = F();
      try {
        return E(e2)(t, r2, n, a, o, s, u);
      } catch (h) {
        if (D(l), h !== h + 0)
          throw h;
        T(1, 0);
      }
    }
    function Sa(e2, t, r2, n, a) {
      var o = F();
      try {
        return E(e2)(t, r2, n, a);
      } catch (s) {
        if (D(o), s !== s + 0)
          throw s;
        T(1, 0);
      }
    }
    function ja(e2, t, r2, n) {
      var a = F();
      try {
        return E(e2)(t, r2, n);
      } catch (o) {
        if (D(a), o !== o + 0)
          throw o;
        T(1, 0);
      }
    }
    function Ia(e2, t, r2, n) {
      var a = F();
      try {
        return E(e2)(t, r2, n);
      } catch (o) {
        if (D(a), o !== o + 0)
          throw o;
        T(1, 0);
      }
    }
    function Ra(e2) {
      var t = F();
      try {
        return E(e2)();
      } catch (r2) {
        if (D(t), r2 !== r2 + 0)
          throw r2;
        T(1, 0);
      }
    }
    function Wa(e2, t, r2, n, a, o, s, u) {
      var l = F();
      try {
        E(e2)(t, r2, n, a, o, s, u);
      } catch (h) {
        if (D(l), h !== h + 0)
          throw h;
        T(1, 0);
      }
    }
    function ka(e2, t, r2, n, a, o, s, u, l, h, p, w) {
      var v = F();
      try {
        return E(e2)(t, r2, n, a, o, s, u, l, h, p, w);
      } catch (b) {
        if (D(v), b !== b + 0)
          throw b;
        T(1, 0);
      }
    }
    function Ha(e2, t, r2, n, a, o, s, u, l, h, p, w, v, b, x, k) {
      var P = F();
      try {
        E(e2)(t, r2, n, a, o, s, u, l, h, p, w, v, b, x, k);
      } catch (j) {
        if (D(P), j !== j + 0)
          throw j;
        T(1, 0);
      }
    }
    function Ba(e2, t, r2, n, a) {
      var o = F();
      try {
        return Ge(e2, t, r2, n, a);
      } catch (s) {
        if (D(o), s !== s + 0)
          throw s;
        T(1, 0);
      }
    }
    var Rt;
    pt = function e2() {
      Rt || Xe(), Rt || (pt = e2);
    };
    function Xe() {
      if (et > 0 || (yr(), et > 0))
        return;
      function e2() {
        Rt || (Rt = true, c.calledRun = true, !de && (vr(), g(c), c.onRuntimeInitialized && c.onRuntimeInitialized(), gr()));
      }
      c.setStatus ? (c.setStatus("Running..."), setTimeout(function() {
        setTimeout(function() {
          c.setStatus("");
        }, 1), e2();
      }, 1)) : e2();
    }
    if (c.preInit)
      for (typeof c.preInit == "function" && (c.preInit = [c.preInit]); c.preInit.length > 0; )
        c.preInit.pop()();
    return Xe(), f.ready;
  };
})();
function Ka(i) {
  return le(
    Ut,
    i
  );
}
async function to(i, f) {
  return Za(
    Ut,
    i,
    f
  );
}
async function eo(i, f) {
  return Ja(
    Ut,
    i,
    f
  );
}
const ir = [
  ["aztec", "Aztec"],
  ["code_128", "Code128"],
  ["code_39", "Code39"],
  ["code_93", "Code93"],
  ["codabar", "Codabar"],
  ["databar", "DataBar"],
  ["databar_expanded", "DataBarExpanded"],
  ["data_matrix", "DataMatrix"],
  ["dx_film_edge", "DXFilmEdge"],
  ["ean_13", "EAN-13"],
  ["ean_8", "EAN-8"],
  ["itf", "ITF"],
  ["maxi_code", "MaxiCode"],
  ["micro_qr_code", "MicroQRCode"],
  ["pdf417", "PDF417"],
  ["qr_code", "QRCode"],
  ["rm_qr_code", "rMQRCode"],
  ["upc_a", "UPC-A"],
  ["upc_e", "UPC-E"],
  ["linear_codes", "Linear-Codes"],
  ["matrix_codes", "Matrix-Codes"]
], ro = [...ir, ["unknown"]].map((i) => i[0]), Bt = new Map(
  ir
);
function no(i) {
  for (const [f, y] of Bt)
    if (i === y)
      return f;
  return "unknown";
}
function ao(i) {
  if (sr(i))
    return {
      width: i.naturalWidth,
      height: i.naturalHeight
    };
  if (ur(i))
    return {
      width: i.width.baseVal.value,
      height: i.height.baseVal.value
    };
  if (cr(i))
    return {
      width: i.videoWidth,
      height: i.videoHeight
    };
  if (dr(i))
    return {
      width: i.width,
      height: i.height
    };
  if (fr(i))
    return {
      width: i.displayWidth,
      height: i.displayHeight
    };
  if (lr(i))
    return {
      width: i.width,
      height: i.height
    };
  if (hr(i))
    return {
      width: i.width,
      height: i.height
    };
  throw new TypeError(
    "The provided value is not of type '(Blob or HTMLCanvasElement or HTMLImageElement or HTMLVideoElement or ImageBitmap or ImageData or OffscreenCanvas or SVGImageElement or VideoFrame)'."
  );
}
function sr(i) {
  try {
    return i instanceof HTMLImageElement;
  } catch {
    return false;
  }
}
function ur(i) {
  try {
    return i instanceof SVGImageElement;
  } catch {
    return false;
  }
}
function cr(i) {
  try {
    return i instanceof HTMLVideoElement;
  } catch {
    return false;
  }
}
function lr(i) {
  try {
    return i instanceof HTMLCanvasElement;
  } catch {
    return false;
  }
}
function dr(i) {
  try {
    return i instanceof ImageBitmap;
  } catch {
    return false;
  }
}
function hr(i) {
  try {
    return i instanceof OffscreenCanvas;
  } catch {
    return false;
  }
}
function fr(i) {
  try {
    return i instanceof VideoFrame;
  } catch {
    return false;
  }
}
function pr(i) {
  try {
    return i instanceof Blob;
  } catch {
    return false;
  }
}
function oo(i) {
  try {
    return i instanceof ImageData;
  } catch {
    return false;
  }
}
function io(i, f) {
  try {
    const y = new OffscreenCanvas(i, f);
    if (y.getContext("2d") instanceof OffscreenCanvasRenderingContext2D)
      return y;
    throw void 0;
  } catch {
    const y = document.createElement("canvas");
    return y.width = i, y.height = f, y;
  }
}
async function mr(i) {
  if (sr(i) && !await lo(i))
    throw new DOMException(
      "Failed to load or decode HTMLImageElement.",
      "InvalidStateError"
    );
  if (ur(i) && !await ho(i))
    throw new DOMException(
      "Failed to load or decode SVGImageElement.",
      "InvalidStateError"
    );
  if (fr(i) && fo(i))
    throw new DOMException("VideoFrame is closed.", "InvalidStateError");
  if (cr(i) && (i.readyState === 0 || i.readyState === 1))
    throw new DOMException("Invalid element or state.", "InvalidStateError");
  if (dr(i) && mo(i))
    throw new DOMException(
      "The image source is detached.",
      "InvalidStateError"
    );
  const { width: f, height: y } = ao(i);
  if (f === 0 || y === 0)
    return null;
  const g = io(f, y).getContext("2d");
  g.drawImage(i, 0, 0);
  try {
    return g.getImageData(0, 0, f, y);
  } catch {
    throw new DOMException("Source would taint origin.", "SecurityError");
  }
}
async function so(i) {
  let f;
  try {
    if (globalThis.createImageBitmap)
      f = await createImageBitmap(i);
    else if (globalThis.Image) {
      f = new Image();
      let c = "";
      try {
        c = URL.createObjectURL(i), f.src = c, await f.decode();
      } finally {
        URL.revokeObjectURL(c);
      }
    } else
      return i;
  } catch {
    throw new DOMException(
      "Failed to load or decode Blob.",
      "InvalidStateError"
    );
  }
  return await mr(f);
}
function uo(i) {
  const { width: f, height: y } = i;
  if (f === 0 || y === 0)
    return null;
  const c = i.getContext("2d");
  try {
    return c.getImageData(0, 0, f, y);
  } catch {
    throw new DOMException("Source would taint origin.", "SecurityError");
  }
}
async function co(i) {
  if (pr(i))
    return await so(i);
  if (oo(i)) {
    if (po(i))
      throw new DOMException(
        "The image data has been detached.",
        "InvalidStateError"
      );
    return i;
  }
  return lr(i) || hr(i) ? uo(i) : await mr(i);
}
async function lo(i) {
  try {
    return await i.decode(), true;
  } catch {
    return false;
  }
}
async function ho(i) {
  var f;
  try {
    return await ((f = i.decode) == null ? void 0 : f.call(i)), true;
  } catch {
    return false;
  }
}
function fo(i) {
  return i.format === null;
}
function po(i) {
  return i.data.buffer.byteLength === 0;
}
function mo(i) {
  return i.width === 0 && i.height === 0;
}
function nr(i, f) {
  return i instanceof DOMException ? new DOMException(`${f}: ${i.message}`, i.name) : i instanceof Error ? new i.constructor(`${f}: ${i.message}`) : new Error(`${f}: ${i}`);
}
var lt;
class go extends EventTarget {
  constructor(y = {}) {
    var c;
    super();
    Ke(this, lt, void 0);
    try {
      const g = (c = y == null ? void 0 : y.formats) == null ? void 0 : c.filter(
        ($) => $ !== "unknown"
      );
      if ((g == null ? void 0 : g.length) === 0)
        throw new TypeError("Hint option provided, but is empty.");
      for (const $ of g != null ? g : [])
        if (!Bt.has($))
          throw new TypeError(
            `Failed to read the 'formats' property from 'BarcodeDetectorOptions': The provided value '${$}' is not a valid enum value of type BarcodeFormat.`
          );
      tr(this, lt, g != null ? g : []), Ka().then(($) => {
        this.dispatchEvent(
          new CustomEvent("load", {
            detail: $
          })
        );
      }).catch(($) => {
        this.dispatchEvent(new CustomEvent("error", { detail: $ }));
      });
    } catch (g) {
      throw nr(
        g,
        "Failed to construct 'BarcodeDetector'"
      );
    }
  }
  static async getSupportedFormats() {
    return ro.filter((y) => y !== "unknown");
  }
  async detect(y) {
    try {
      const c = await co(y);
      if (c === null)
        return [];
      let g;
      try {
        pr(c) ? g = await to(c, {
          tryHarder: true,
          formats: ue(this, lt).map(($) => Bt.get($))
        }) : g = await eo(c, {
          tryHarder: true,
          formats: ue(this, lt).map(($) => Bt.get($))
        });
      } catch ($) {
        throw console.error($), new DOMException(
          "Barcode detection service unavailable.",
          "NotSupportedError"
        );
      }
      return g.map(($) => {
        const {
          topLeft: { x: H, y: U },
          topRight: { x: V, y: B },
          bottomLeft: { x: L, y: Y },
          bottomRight: { x: S, y: ht }
        } = $.position, at = Math.min(H, V, L, S), _t = Math.min(U, B, Y, ht), K = Math.max(H, V, L, S), tt = Math.max(U, B, Y, ht);
        return {
          boundingBox: new DOMRectReadOnly(
            at,
            _t,
            K - at,
            tt - _t
          ),
          rawValue: $.text,
          format: no($.format),
          cornerPoints: [
            {
              x: H,
              y: U
            },
            {
              x: V,
              y: B
            },
            {
              x: S,
              y: ht
            },
            {
              x: L,
              y: Y
            }
          ]
        };
      });
    } catch (c) {
      throw nr(
        c,
        "Failed to execute 'detect' on 'BarcodeDetector'"
      );
    }
  }
}
lt = /* @__PURE__ */ new WeakMap();
const _sfc_main$1 = {
  beforeMount() {
    if (!("BarcodeDetector" in window)) {
      window.BarcodeDetector = go;
    }
  },
  methods: {
    async onDetect(resultPromise) {
      this.$emit("detect", resultPromise);
      try {
        const { content } = await resultPromise;
        if (content !== null) {
          this.$emit("decode", content);
        }
      } catch (error) {
      }
    }
  }
};
const CommonAPI = _sfc_main$1;
const _sfc_main = defineComponent({
  name: "QrcodeStream",
  mixins: [CommonAPI],
  props: {
    camera: {
      type: String,
      default: "rear",
      validator(camera) {
        return ["auto", "rear", "front", "off"].includes(camera);
      }
    },
    torch: { type: Boolean, default: false },
    track: { type: Function }
  },
  data() {
    return {
      cameraInstance: null,
      initializedOnce: false,
      destroyed: false
    };
  },
  computed: {
    shouldStream() {
      return this.destroyed === false && this.camera !== "off";
    },
    shouldScan() {
      return this.shouldStream === true && this.cameraInstance !== null && this.initializedOnce;
    },
    /**
     * Minimum delay in milliseconds between frames to be scanned. Don't scan
     * so often when visual tracking is disabled to improve performance.
     */
    scanInterval() {
      if (this.track === void 0) {
        return 500;
      } else {
        return 40;
      }
    }
  },
  watch: {
    shouldStream(shouldStream) {
    },
    shouldScan(shouldScan) {
      if (shouldScan) {
        this.clearCanvas(this.$refs.trackingLayer);
        this.startScanning();
      }
    },
    torch() {
      this.init();
    },
    camera() {
      this.init();
    }
  },
  mounted() {
    this.init();
  },
  beforeUnmount() {
    this.beforeResetCamera();
    this.destroyed = true;
  },
  methods: {
    init() {
      const promise = (async () => {
        const $q = useQuasar();
        this.beforeResetCamera();
        if (this.camera === "off") {
          this.cameraInstance = null;
          return {
            capabilities: {}
          };
        } else {
          this.cameraInstance = await Camera$1(this.$refs.video, {
            camera: this.camera,
            torch: this.torch
          });
          const capabilities = this.cameraInstance.getCapabilities();
          if (this.destroyed) {
            this.cameraInstance.stop();
          }
          if ($q.platform.is.ios) {
            this.initializedOnce = true;
          } else {
            this.initializedOnce = true;
          }
          return {
            capabilities
          };
        }
      })();
      this.$emit("init", promise);
    },
    startScanning() {
      const detectHandler = (result) => {
        this.onDetect(Promise.resolve(result));
      };
      keepScanning(this.$refs.video, {
        detectHandler,
        locateHandler: this.onLocate,
        minDelay: this.scanInterval
      });
    },
    beforeResetCamera() {
      if (this.cameraInstance !== null) {
        this.cameraInstance.stop();
        this.cameraInstance = null;
      }
    },
    onLocate(location) {
      if (this.trackRepaintFunction === void 0 || location === null) {
        this.clearCanvas(this.$refs.trackingLayer);
      } else {
        const video = this.$refs.video;
        const canvas = this.$refs.trackingLayer;
        if (video !== void 0 && canvas !== void 0) {
          this.repaintTrackingLayer(video, canvas, location);
        }
      }
    },
    onLocate(detectedCodes) {
      const canvas = this.$refs.trackingLayer;
      const video = this.$refs.video;
      if (canvas !== void 0) {
        if (detectedCodes.length > 0 && this.track !== void 0 && video !== void 0) {
          const displayWidth2 = video.offsetWidth;
          const displayHeight2 = video.offsetHeight;
          const resolutionWidth = video.videoWidth;
          const resolutionHeight = video.videoHeight;
          const largerRatio = Math.max(
            displayWidth2 / resolutionWidth,
            displayHeight2 / resolutionHeight
          );
          const uncutWidth = resolutionWidth * largerRatio;
          const uncutHeight = resolutionHeight * largerRatio;
          const xScalar = uncutWidth / resolutionWidth;
          const yScalar = uncutHeight / resolutionHeight;
          const xOffset = (displayWidth2 - uncutWidth) / 2;
          const yOffset = (displayHeight2 - uncutHeight) / 2;
          const scale = ({ x, y }) => {
            return {
              x: Math.floor(x * xScalar),
              y: Math.floor(y * yScalar)
            };
          };
          const translate = ({ x, y }) => {
            return {
              x: Math.floor(x + xOffset),
              y: Math.floor(y + yOffset)
            };
          };
          const adjustedCodes = detectedCodes.map((detectedCode) => {
            const { boundingBox, cornerPoints } = detectedCode;
            const { x, y } = translate(scale({
              x: boundingBox.x,
              y: boundingBox.y
            }));
            const { x: width, y: height } = scale({
              x: boundingBox.width,
              y: boundingBox.height
            });
            return {
              ...detectedCode,
              cornerPoints: cornerPoints.map((point) => translate(scale(point))),
              boundingBox: DOMRectReadOnly.fromRect({ x, y, width, height })
            };
          });
          canvas.width = video.offsetWidth;
          canvas.height = video.offsetHeight;
          const ctx = canvas.getContext("2d");
          this.track(adjustedCodes, ctx);
        } else {
          this.clearCanvas(canvas);
        }
      }
    },
    repaintTrackingLayer(video, canvas, location) {
      const ctx = canvas.getContext("2d");
      window.requestAnimationFrame(() => {
        canvas.width = displayWidth;
        canvas.height = displayHeight;
        this.trackRepaintFunction(coordinatesAdjusted, ctx);
      });
    },
    clearCanvas(canvas) {
      if (!canvas) return;
      const ctx = canvas.getContext("2d");
      ctx.clearRect(0, 0, canvas.width, canvas.height);
    }
  }
});
const _hoisted_1 = { class: "qrcode-stream-wrapper" };
const _hoisted_2 = {
  ref: "video",
  class: "qrcode-stream-camera",
  autoplay: "",
  muted: "",
  playsinline: ""
};
const _hoisted_3 = {
  ref: "trackingLayer",
  id: "trackingLayer",
  class: "qrcode-stream-overlay"
};
const _hoisted_4 = { class: "qrcode-stream-overlay" };
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return openBlock(), createElementBlock("div", _hoisted_1, [
    createBaseVNode("video", _hoisted_2, null, 512),
    createBaseVNode("canvas", _hoisted_3, null, 512),
    createBaseVNode("div", _hoisted_4, [
      renderSlot(_ctx.$slots, "default", {}, void 0, true)
    ])
  ]);
}
const QrcodeStream = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-d2b146a0"]]);
export {
  CommonAPI as C,
  QrcodeStream as Q
};
