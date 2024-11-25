import { ds as getDefaultExportFromCjs, dv as process$1, dr as global, d as defineComponent, a7 as useQuasar, o as openBlock, c as createElementBlock, e as createBaseVNode, aA as renderSlot } from "./index.js";
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
          e2.stream.addEventListener("addtrack", (te2) => {
            let receiver;
            if (window2.RTCPeerConnection.prototype.getReceivers) {
              receiver = this.getReceivers().find((r2) => r2.track && r2.track.id === te2.track.id);
            } else {
              receiver = { track: te2.track };
            }
            const event = new Event("track");
            event.track = te2.track;
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
var Zr = (o) => {
  throw TypeError(o);
};
var Jr = (o, d, p) => d.has(o) || Zr("Cannot " + p);
var Kr = (o, d, p) => (Jr(o, d, "read from private field"), p ? p.call(o) : d.get(o)), te = (o, d, p) => d.has(o) ? Zr("Cannot add the same private member more than once") : d instanceof WeakSet ? d.add(o) : d.set(o, p), re = (o, d, p, y) => (Jr(o, d, "write to private field"), d.set(o, p), p);
const ee = [
  "Aztec",
  "Codabar",
  "Code128",
  "Code39",
  "Code93",
  "DataBar",
  "DataBarExpanded",
  "DataBarLimited",
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
function ro(o) {
  return o.join("|");
}
function eo(o) {
  const d = ne(o);
  let p = 0, y = ee.length - 1;
  for (; p <= y; ) {
    const c = Math.floor((p + y) / 2), P = ee[c], D = ne(P);
    if (D === d)
      return P;
    D < d ? p = c + 1 : y = c - 1;
  }
  return "None";
}
function ne(o) {
  return o.toLowerCase().replace(/_-\[\]/g, "");
}
function no(o, d) {
  return o.Binarizer[d];
}
function ao(o, d) {
  return o.CharacterSet[d];
}
const oo = [
  "Text",
  "Binary",
  "Mixed",
  "GS1",
  "ISO15434",
  "UnknownECI"
];
function io(o) {
  return oo[o.value];
}
function so(o, d) {
  return o.EanAddOnSymbol[d];
}
function uo(o, d) {
  return o.TextMode[d];
}
const st = {
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
function oe(o, d) {
  return {
    ...d,
    formats: ro(d.formats),
    binarizer: no(o, d.binarizer),
    eanAddOnSymbol: so(
      o,
      d.eanAddOnSymbol
    ),
    textMode: uo(o, d.textMode),
    characterSet: ao(
      o,
      d.characterSet
    )
  };
}
function ie(o) {
  return {
    ...o,
    format: eo(o.format),
    eccLevel: o.eccLevel,
    contentType: io(o.contentType)
  };
}
const co = {
  locateFile: (o, d) => {
    const p = o.match(/_(.+?)\.wasm$/);
    return p ? `https://fastly.jsdelivr.net/npm/zxing-wasm@1.3.4/dist/${p[1]}/${o}` : d + o;
  }
};
let ar = /* @__PURE__ */ new WeakMap();
function ir(o, d) {
  var p;
  const y = ar.get(o);
  if (y != null && y.modulePromise && d === void 0)
    return y.modulePromise;
  const c = (p = y == null ? void 0 : y.moduleOverrides) != null ? p : co, P = o({
    ...c
  });
  return ar.set(o, {
    moduleOverrides: c,
    modulePromise: P
  }), P;
}
async function fo(o, d, p = st) {
  const y = {
    ...st,
    ...p
  }, c = await ir(o), { size: P } = d, D = new Uint8Array(await d.arrayBuffer()), B = c._malloc(P);
  c.HEAPU8.set(D, B);
  const V = c.readBarcodesFromImage(
    B,
    P,
    oe(c, y)
  );
  c._free(B);
  const R = [];
  for (let W = 0; W < V.size(); ++W)
    R.push(
      ie(V.get(W))
    );
  return R;
}
async function ho(o, d, p = st) {
  const y = {
    ...st,
    ...p
  }, c = await ir(o), {
    data: P,
    width: D,
    height: B,
    data: { byteLength: V }
  } = d, R = c._malloc(V);
  c.HEAPU8.set(P, R);
  const W = c.readBarcodesFromPixmap(
    R,
    D,
    B,
    oe(c, y)
  );
  c._free(R);
  const N = [];
  for (let H = 0; H < W.size(); ++H)
    N.push(
      ie(W.get(H))
    );
  return N;
}
({
  ...st,
  formats: [...st.formats]
});
var Bt = (() => {
  var o, d = typeof document < "u" && ((o = document.currentScript) == null ? void 0 : o.tagName.toUpperCase()) === "SCRIPT" ? document.currentScript.src : void 0;
  return function(p = {}) {
    var y, c = p, P, D, B = new Promise((t, r2) => {
      P = t, D = r2;
    }), V = typeof window == "object", R = typeof Bun < "u", W = typeof importScripts == "function";
    typeof process$1 == "object" && typeof process$1.versions == "object" && typeof process$1.versions.node == "string" && process$1.type != "renderer";
    var N = Object.assign({}, c), H = "./this.program", I = "";
    function ut(t) {
      return c.locateFile ? c.locateFile(t, I) : I + t;
    }
    var ct, et;
    if (V || W || R) {
      var lt;
      W ? I = self.location.href : typeof document < "u" && ((lt = document.currentScript) === null || lt === void 0 ? void 0 : lt.tagName.toUpperCase()) === "SCRIPT" && (I = document.currentScript.src), d && (I = d), I.startsWith("blob:") ? I = "" : I = I.substr(0, I.replace(/[?#].*/, "").lastIndexOf("/") + 1), W && (et = (t) => {
        var r2 = new XMLHttpRequest();
        return r2.open("GET", t, false), r2.responseType = "arraybuffer", r2.send(null), new Uint8Array(r2.response);
      }), ct = (t) => fetch(t, {
        credentials: "same-origin"
      }).then((r2) => r2.ok ? r2.arrayBuffer() : Promise.reject(new Error(r2.status + " : " + r2.url)));
    }
    var kt = c.print || console.log.bind(console), nt = c.printErr || console.error.bind(console);
    Object.assign(c, N), N = null, c.arguments && c.arguments, c.thisProgram && (H = c.thisProgram);
    var wt = c.wasmBinary, $t, sr = false, L, F, at, ft, Z, E, ur, cr;
    function lr() {
      var t = $t.buffer;
      c.HEAP8 = L = new Int8Array(t), c.HEAP16 = at = new Int16Array(t), c.HEAPU8 = F = new Uint8Array(t), c.HEAPU16 = ft = new Uint16Array(t), c.HEAP32 = Z = new Int32Array(t), c.HEAPU32 = E = new Uint32Array(t), c.HEAPF32 = ur = new Float32Array(t), c.HEAPF64 = cr = new Float64Array(t);
    }
    var fr = [], dr = [], hr = [];
    function me() {
      var t = c.preRun;
      t && (typeof t == "function" && (t = [t]), t.forEach($e)), Vt(fr);
    }
    function ge() {
      Vt(dr);
    }
    function we() {
      var t = c.postRun;
      t && (typeof t == "function" && (t = [t]), t.forEach(Ce)), Vt(hr);
    }
    function $e(t) {
      fr.unshift(t);
    }
    function be(t) {
      dr.unshift(t);
    }
    function Ce(t) {
      hr.unshift(t);
    }
    var J = 0, dt = null;
    function Te(t) {
      var r2;
      J++, (r2 = c.monitorRunDependencies) === null || r2 === void 0 || r2.call(c, J);
    }
    function Pe(t) {
      var r2;
      if (J--, (r2 = c.monitorRunDependencies) === null || r2 === void 0 || r2.call(c, J), J == 0 && dt) {
        var e2 = dt;
        dt = null, e2();
      }
    }
    function Ut(t) {
      var r2;
      (r2 = c.onAbort) === null || r2 === void 0 || r2.call(c, t), t = "Aborted(" + t + ")", nt(t), sr = true, t += ". Build with -sASSERTIONS for more info.";
      var e2 = new WebAssembly.RuntimeError(t);
      throw D(e2), e2;
    }
    var Ee = "data:application/octet-stream;base64,", pr = (t) => t.startsWith(Ee);
    function _e() {
      var t = "zxing_reader.wasm";
      return pr(t) ? t : ut(t);
    }
    var bt;
    function vr(t) {
      if (t == bt && wt)
        return new Uint8Array(wt);
      if (et)
        return et(t);
      throw "both async and sync fetching of the wasm failed";
    }
    function Ae(t) {
      return wt ? Promise.resolve().then(() => vr(t)) : ct(t).then((r2) => new Uint8Array(r2), () => vr(t));
    }
    function yr(t, r2, e2) {
      return Ae(t).then((n) => WebAssembly.instantiate(n, r2)).then(e2, (n) => {
        nt(`failed to asynchronously prepare wasm: ${n}`), Ut(n);
      });
    }
    function Oe(t, r2, e2, n) {
      return !t && typeof WebAssembly.instantiateStreaming == "function" && !pr(r2) && typeof fetch == "function" ? fetch(r2, {
        credentials: "same-origin"
      }).then((a) => {
        var i = WebAssembly.instantiateStreaming(a, e2);
        return i.then(n, function(u) {
          return nt(`wasm streaming compile failed: ${u}`), nt("falling back to ArrayBuffer instantiation"), yr(r2, e2, n);
        });
      }) : yr(r2, e2, n);
    }
    function xe() {
      return {
        a: wa
      };
    }
    function De() {
      var t, r2 = xe();
      function e2(a, i) {
        return A = a.exports, $t = A.za, lr(), _r = A.Da, be(A.Aa), Pe(), A;
      }
      Te();
      function n(a) {
        e2(a.instance);
      }
      if (c.instantiateWasm)
        try {
          return c.instantiateWasm(r2, e2);
        } catch (a) {
          nt(`Module.instantiateWasm callback failed with error: ${a}`), D(a);
        }
      return (t = bt) !== null && t !== void 0 || (bt = _e()), Oe(wt, bt, r2, n).catch(D), {};
    }
    var Vt = (t) => {
      t.forEach((r2) => r2(c));
    };
    c.noExitRuntime;
    var w = (t) => Br(t), $ = () => kr(), Ct = [], Tt = 0, Se = (t) => {
      var r2 = new Ht(t);
      return r2.get_caught() || (r2.set_caught(true), Tt--), r2.set_rethrown(false), Ct.push(r2), Vr(t), Ir(t);
    }, G = 0, je = () => {
      m(0, 0);
      var t = Ct.pop();
      Ur(t.excPtr), G = 0;
    };
    class Ht {
      constructor(r2) {
        this.excPtr = r2, this.ptr = r2 - 24;
      }
      set_type(r2) {
        E[this.ptr + 4 >> 2] = r2;
      }
      get_type() {
        return E[this.ptr + 4 >> 2];
      }
      set_destructor(r2) {
        E[this.ptr + 8 >> 2] = r2;
      }
      get_destructor() {
        return E[this.ptr + 8 >> 2];
      }
      set_caught(r2) {
        r2 = r2 ? 1 : 0, L[this.ptr + 12] = r2;
      }
      get_caught() {
        return L[this.ptr + 12] != 0;
      }
      set_rethrown(r2) {
        r2 = r2 ? 1 : 0, L[this.ptr + 13] = r2;
      }
      get_rethrown() {
        return L[this.ptr + 13] != 0;
      }
      init(r2, e2) {
        this.set_adjusted_ptr(0), this.set_type(r2), this.set_destructor(e2);
      }
      set_adjusted_ptr(r2) {
        E[this.ptr + 16 >> 2] = r2;
      }
      get_adjusted_ptr() {
        return E[this.ptr + 16 >> 2];
      }
    }
    var Fe = (t) => {
      throw G || (G = t), G;
    }, Pt = (t) => Rr(t), Lt = (t) => {
      var r2 = G;
      if (!r2)
        return Pt(0), 0;
      var e2 = new Ht(r2);
      e2.set_adjusted_ptr(r2);
      var n = e2.get_type();
      if (!n)
        return Pt(0), r2;
      for (var a of t) {
        if (a === 0 || a === n)
          break;
        var i = e2.ptr + 16;
        if (Hr(a, n, i))
          return Pt(a), r2;
      }
      return Pt(n), r2;
    }, Me = () => Lt([]), We = (t) => Lt([t]), Ie = (t, r2) => Lt([t, r2]), Re = () => {
      var t = Ct.pop();
      t || Ut("no exception to throw");
      var r2 = t.excPtr;
      throw t.get_rethrown() || (Ct.push(t), t.set_rethrown(true), t.set_caught(false), Tt++), G = r2, G;
    }, Be = (t, r2, e2) => {
      var n = new Ht(t);
      throw n.init(r2, e2), G = t, Tt++, G;
    }, ke = () => Tt, Ue = () => {
      Ut("");
    }, Et = {}, zt = (t) => {
      for (; t.length; ) {
        var r2 = t.pop(), e2 = t.pop();
        e2(r2);
      }
    };
    function ht(t) {
      return this.fromWireType(E[t >> 2]);
    }
    var ot = {}, K = {}, _t = {}, mr, At = (t) => {
      throw new mr(t);
    }, tt = (t, r2, e2) => {
      t.forEach((s) => _t[s] = r2);
      function n(s) {
        var l = e2(s);
        l.length !== t.length && At("Mismatched type converter count");
        for (var f = 0; f < t.length; ++f)
          k(t[f], l[f]);
      }
      var a = new Array(r2.length), i = [], u = 0;
      r2.forEach((s, l) => {
        K.hasOwnProperty(s) ? a[l] = K[s] : (i.push(s), ot.hasOwnProperty(s) || (ot[s] = []), ot[s].push(() => {
          a[l] = K[s], ++u, u === i.length && n(a);
        }));
      }), i.length === 0 && n(a);
    }, Ve = (t) => {
      var r2 = Et[t];
      delete Et[t];
      var e2 = r2.rawConstructor, n = r2.rawDestructor, a = r2.fields, i = a.map((u) => u.getterReturnType).concat(a.map((u) => u.setterArgumentType));
      tt([t], i, (u) => {
        var s = {};
        return a.forEach((l, f) => {
          var h = l.fieldName, v = u[f], g = l.getter, T = l.getterContext, _ = u[f + a.length], S = l.setter, O = l.setterContext;
          s[h] = {
            read: (x) => v.fromWireType(g(T, x)),
            write: (x, rt) => {
              var M = [];
              S(O, x, _.toWireType(M, rt)), zt(M);
            }
          };
        }), [{
          name: r2.name,
          fromWireType: (l) => {
            var f = {};
            for (var h in s)
              f[h] = s[h].read(l);
            return n(l), f;
          },
          toWireType: (l, f) => {
            for (var h in s)
              if (!(h in f))
                throw new TypeError(`Missing field: "${h}"`);
            var v = e2();
            for (h in s)
              s[h].write(v, f[h]);
            return l !== null && l.push(n, v), v;
          },
          argPackAdvance: z,
          readValueFromPointer: ht,
          destructorFunction: n
        }];
      });
    }, He = (t, r2, e2, n, a) => {
    }, Le = () => {
      for (var t = new Array(256), r2 = 0; r2 < 256; ++r2)
        t[r2] = String.fromCharCode(r2);
      gr = t;
    }, gr, j = (t) => {
      for (var r2 = "", e2 = t; F[e2]; )
        r2 += gr[F[e2++]];
      return r2;
    }, it, C = (t) => {
      throw new it(t);
    };
    function ze(t, r2) {
      let e2 = arguments.length > 2 && arguments[2] !== void 0 ? arguments[2] : {};
      var n = r2.name;
      if (t || C(`type "${n}" must have a positive integer typeid pointer`), K.hasOwnProperty(t)) {
        if (e2.ignoreDuplicateRegistrations)
          return;
        C(`Cannot register type '${n}' twice`);
      }
      if (K[t] = r2, delete _t[t], ot.hasOwnProperty(t)) {
        var a = ot[t];
        delete ot[t], a.forEach((i) => i());
      }
    }
    function k(t, r2) {
      let e2 = arguments.length > 2 && arguments[2] !== void 0 ? arguments[2] : {};
      return ze(t, r2, e2);
    }
    var z = 8, Ne = (t, r2, e2, n) => {
      r2 = j(r2), k(t, {
        name: r2,
        fromWireType: function(a) {
          return !!a;
        },
        toWireType: function(a, i) {
          return i ? e2 : n;
        },
        argPackAdvance: z,
        readValueFromPointer: function(a) {
          return this.fromWireType(F[a]);
        },
        destructorFunction: null
      });
    }, Ge = (t) => ({
      count: t.count,
      deleteScheduled: t.deleteScheduled,
      preservePointerOnDelete: t.preservePointerOnDelete,
      ptr: t.ptr,
      ptrType: t.ptrType,
      smartPtr: t.smartPtr,
      smartPtrType: t.smartPtrType
    }), Nt = (t) => {
      function r2(e2) {
        return e2.$$.ptrType.registeredClass.name;
      }
      C(r2(t) + " instance already deleted");
    }, Gt = false, wr = (t) => {
    }, Xe = (t) => {
      t.smartPtr ? t.smartPtrType.rawDestructor(t.smartPtr) : t.ptrType.registeredClass.rawDestructor(t.ptr);
    }, $r = (t) => {
      t.count.value -= 1;
      var r2 = t.count.value === 0;
      r2 && Xe(t);
    }, br = (t, r2, e2) => {
      if (r2 === e2)
        return t;
      if (e2.baseClass === void 0)
        return null;
      var n = br(t, r2, e2.baseClass);
      return n === null ? null : e2.downcast(n);
    }, Cr = {}, Qe = {}, Ye = (t, r2) => {
      for (r2 === void 0 && C("ptr should not be undefined"); t.baseClass; )
        r2 = t.upcast(r2), t = t.baseClass;
      return r2;
    }, qe = (t, r2) => (r2 = Ye(t, r2), Qe[r2]), Ot = (t, r2) => {
      (!r2.ptrType || !r2.ptr) && At("makeClassHandle requires ptr and ptrType");
      var e2 = !!r2.smartPtrType, n = !!r2.smartPtr;
      return e2 !== n && At("Both smartPtrType and smartPtr must be specified"), r2.count = {
        value: 1
      }, pt(Object.create(t, {
        $$: {
          value: r2,
          writable: true
        }
      }));
    };
    function Ze(t) {
      var r2 = this.getPointee(t);
      if (!r2)
        return this.destructor(t), null;
      var e2 = qe(this.registeredClass, r2);
      if (e2 !== void 0) {
        if (e2.$$.count.value === 0)
          return e2.$$.ptr = r2, e2.$$.smartPtr = t, e2.clone();
        var n = e2.clone();
        return this.destructor(t), n;
      }
      function a() {
        return this.isSmartPointer ? Ot(this.registeredClass.instancePrototype, {
          ptrType: this.pointeeType,
          ptr: r2,
          smartPtrType: this,
          smartPtr: t
        }) : Ot(this.registeredClass.instancePrototype, {
          ptrType: this,
          ptr: t
        });
      }
      var i = this.registeredClass.getActualType(r2), u = Cr[i];
      if (!u)
        return a.call(this);
      var s;
      this.isConst ? s = u.constPointerType : s = u.pointerType;
      var l = br(r2, this.registeredClass, s.registeredClass);
      return l === null ? a.call(this) : this.isSmartPointer ? Ot(s.registeredClass.instancePrototype, {
        ptrType: s,
        ptr: l,
        smartPtrType: this,
        smartPtr: t
      }) : Ot(s.registeredClass.instancePrototype, {
        ptrType: s,
        ptr: l
      });
    }
    var pt = (t) => typeof FinalizationRegistry > "u" ? (pt = (r2) => r2, t) : (Gt = new FinalizationRegistry((r2) => {
      $r(r2.$$);
    }), pt = (r2) => {
      var e2 = r2.$$, n = !!e2.smartPtr;
      if (n) {
        var a = {
          $$: e2
        };
        Gt.register(r2, a, r2);
      }
      return r2;
    }, wr = (r2) => Gt.unregister(r2), pt(t)), xt = [], Je = () => {
      for (; xt.length; ) {
        var t = xt.pop();
        t.$$.deleteScheduled = false, t.delete();
      }
    }, Tr, Ke = () => {
      Object.assign(Dt.prototype, {
        isAliasOf(t) {
          if (!(this instanceof Dt) || !(t instanceof Dt))
            return false;
          var r2 = this.$$.ptrType.registeredClass, e2 = this.$$.ptr;
          t.$$ = t.$$;
          for (var n = t.$$.ptrType.registeredClass, a = t.$$.ptr; r2.baseClass; )
            e2 = r2.upcast(e2), r2 = r2.baseClass;
          for (; n.baseClass; )
            a = n.upcast(a), n = n.baseClass;
          return r2 === n && e2 === a;
        },
        clone() {
          if (this.$$.ptr || Nt(this), this.$$.preservePointerOnDelete)
            return this.$$.count.value += 1, this;
          var t = pt(Object.create(Object.getPrototypeOf(this), {
            $$: {
              value: Ge(this.$$)
            }
          }));
          return t.$$.count.value += 1, t.$$.deleteScheduled = false, t;
        },
        delete() {
          this.$$.ptr || Nt(this), this.$$.deleteScheduled && !this.$$.preservePointerOnDelete && C("Object already scheduled for deletion"), wr(this), $r(this.$$), this.$$.preservePointerOnDelete || (this.$$.smartPtr = void 0, this.$$.ptr = void 0);
        },
        isDeleted() {
          return !this.$$.ptr;
        },
        deleteLater() {
          return this.$$.ptr || Nt(this), this.$$.deleteScheduled && !this.$$.preservePointerOnDelete && C("Object already scheduled for deletion"), xt.push(this), xt.length === 1 && Tr && Tr(Je), this.$$.deleteScheduled = true, this;
        }
      });
    };
    function Dt() {
    }
    var vt = (t, r2) => Object.defineProperty(r2, "name", {
      value: t
    }), Pr = (t, r2, e2) => {
      if (t[r2].overloadTable === void 0) {
        var n = t[r2];
        t[r2] = function() {
          for (var a = arguments.length, i = new Array(a), u = 0; u < a; u++)
            i[u] = arguments[u];
          return t[r2].overloadTable.hasOwnProperty(i.length) || C(`Function '${e2}' called with an invalid number of arguments (${i.length}) - expects one of (${t[r2].overloadTable})!`), t[r2].overloadTable[i.length].apply(this, i);
        }, t[r2].overloadTable = [], t[r2].overloadTable[n.argCount] = n;
      }
    }, Xt = (t, r2, e2) => {
      c.hasOwnProperty(t) ? ((e2 === void 0 || c[t].overloadTable !== void 0 && c[t].overloadTable[e2] !== void 0) && C(`Cannot register public name '${t}' twice`), Pr(c, t, t), c.hasOwnProperty(e2) && C(`Cannot register multiple overloads of a function with the same number of arguments (${e2})!`), c[t].overloadTable[e2] = r2) : (c[t] = r2, e2 !== void 0 && (c[t].numArguments = e2));
    }, tn = 48, rn = 57, en = (t) => {
      t = t.replace(/[^a-zA-Z0-9_]/g, "$");
      var r2 = t.charCodeAt(0);
      return r2 >= tn && r2 <= rn ? `_${t}` : t;
    };
    function nn(t, r2, e2, n, a, i, u, s) {
      this.name = t, this.constructor = r2, this.instancePrototype = e2, this.rawDestructor = n, this.baseClass = a, this.getActualType = i, this.upcast = u, this.downcast = s, this.pureVirtualFunctions = [];
    }
    var Qt = (t, r2, e2) => {
      for (; r2 !== e2; )
        r2.upcast || C(`Expected null or instance of ${e2.name}, got an instance of ${r2.name}`), t = r2.upcast(t), r2 = r2.baseClass;
      return t;
    };
    function an(t, r2) {
      if (r2 === null)
        return this.isReference && C(`null is not a valid ${this.name}`), 0;
      r2.$$ || C(`Cannot pass "${tr(r2)}" as a ${this.name}`), r2.$$.ptr || C(`Cannot pass deleted object as a pointer of type ${this.name}`);
      var e2 = r2.$$.ptrType.registeredClass, n = Qt(r2.$$.ptr, e2, this.registeredClass);
      return n;
    }
    function on(t, r2) {
      var e2;
      if (r2 === null)
        return this.isReference && C(`null is not a valid ${this.name}`), this.isSmartPointer ? (e2 = this.rawConstructor(), t !== null && t.push(this.rawDestructor, e2), e2) : 0;
      (!r2 || !r2.$$) && C(`Cannot pass "${tr(r2)}" as a ${this.name}`), r2.$$.ptr || C(`Cannot pass deleted object as a pointer of type ${this.name}`), !this.isConst && r2.$$.ptrType.isConst && C(`Cannot convert argument of type ${r2.$$.smartPtrType ? r2.$$.smartPtrType.name : r2.$$.ptrType.name} to parameter type ${this.name}`);
      var n = r2.$$.ptrType.registeredClass;
      if (e2 = Qt(r2.$$.ptr, n, this.registeredClass), this.isSmartPointer)
        switch (r2.$$.smartPtr === void 0 && C("Passing raw pointer to smart pointer is illegal"), this.sharingPolicy) {
          case 0:
            r2.$$.smartPtrType === this ? e2 = r2.$$.smartPtr : C(`Cannot convert argument of type ${r2.$$.smartPtrType ? r2.$$.smartPtrType.name : r2.$$.ptrType.name} to parameter type ${this.name}`);
            break;
          case 1:
            e2 = r2.$$.smartPtr;
            break;
          case 2:
            if (r2.$$.smartPtrType === this)
              e2 = r2.$$.smartPtr;
            else {
              var a = r2.clone();
              e2 = this.rawShare(e2, Q.toHandle(() => a.delete())), t !== null && t.push(this.rawDestructor, e2);
            }
            break;
          default:
            C("Unsupporting sharing policy");
        }
      return e2;
    }
    function sn(t, r2) {
      if (r2 === null)
        return this.isReference && C(`null is not a valid ${this.name}`), 0;
      r2.$$ || C(`Cannot pass "${tr(r2)}" as a ${this.name}`), r2.$$.ptr || C(`Cannot pass deleted object as a pointer of type ${this.name}`), r2.$$.ptrType.isConst && C(`Cannot convert argument of type ${r2.$$.ptrType.name} to parameter type ${this.name}`);
      var e2 = r2.$$.ptrType.registeredClass, n = Qt(r2.$$.ptr, e2, this.registeredClass);
      return n;
    }
    var un = () => {
      Object.assign(St.prototype, {
        getPointee(t) {
          return this.rawGetPointee && (t = this.rawGetPointee(t)), t;
        },
        destructor(t) {
          var r2;
          (r2 = this.rawDestructor) === null || r2 === void 0 || r2.call(this, t);
        },
        argPackAdvance: z,
        readValueFromPointer: ht,
        fromWireType: Ze
      });
    };
    function St(t, r2, e2, n, a, i, u, s, l, f, h) {
      this.name = t, this.registeredClass = r2, this.isReference = e2, this.isConst = n, this.isSmartPointer = a, this.pointeeType = i, this.sharingPolicy = u, this.rawGetPointee = s, this.rawConstructor = l, this.rawShare = f, this.rawDestructor = h, !a && r2.baseClass === void 0 ? n ? (this.toWireType = an, this.destructorFunction = null) : (this.toWireType = sn, this.destructorFunction = null) : this.toWireType = on;
    }
    var Er = (t, r2, e2) => {
      c.hasOwnProperty(t) || At("Replacing nonexistent public symbol"), c[t].overloadTable !== void 0 && e2 !== void 0 ? c[t].overloadTable[e2] = r2 : (c[t] = r2, c[t].argCount = e2);
    }, cn = (t, r2, e2) => {
      t = t.replace(/p/g, "i");
      var n = c["dynCall_" + t];
      return n(r2, ...e2);
    }, jt = [], _r, b = (t) => {
      var r2 = jt[t];
      return r2 || (t >= jt.length && (jt.length = t + 1), jt[t] = r2 = _r.get(t)), r2;
    }, ln = function(t, r2) {
      let e2 = arguments.length > 2 && arguments[2] !== void 0 ? arguments[2] : [];
      if (t.includes("j"))
        return cn(t, r2, e2);
      var n = b(r2)(...e2);
      return n;
    }, fn = (t, r2) => function() {
      for (var e2 = arguments.length, n = new Array(e2), a = 0; a < e2; a++)
        n[a] = arguments[a];
      return ln(t, r2, n);
    }, U = (t, r2) => {
      t = j(t);
      function e2() {
        return t.includes("j") ? fn(t, r2) : b(r2);
      }
      var n = e2();
      return typeof n != "function" && C(`unknown function pointer with signature ${t}: ${r2}`), n;
    }, dn = (t, r2) => {
      var e2 = vt(r2, function(n) {
        this.name = r2, this.message = n;
        var a = new Error(n).stack;
        a !== void 0 && (this.stack = this.toString() + `
` + a.replace(/^Error(:[^\n]*)?\n/, ""));
      });
      return e2.prototype = Object.create(t.prototype), e2.prototype.constructor = e2, e2.prototype.toString = function() {
        return this.message === void 0 ? this.name : `${this.name}: ${this.message}`;
      }, e2;
    }, Ar, Or = (t) => {
      var r2 = Wr(t), e2 = j(r2);
      return Y(r2), e2;
    }, Ft = (t, r2) => {
      var e2 = [], n = {};
      function a(i) {
        if (!n[i] && !K[i]) {
          if (_t[i]) {
            _t[i].forEach(a);
            return;
          }
          e2.push(i), n[i] = true;
        }
      }
      throw r2.forEach(a), new Ar(`${t}: ` + e2.map(Or).join([", "]));
    }, hn = (t, r2, e2, n, a, i, u, s, l, f, h, v, g) => {
      h = j(h), i = U(a, i), s && (s = U(u, s)), f && (f = U(l, f)), g = U(v, g);
      var T = en(h);
      Xt(T, function() {
        Ft(`Cannot construct ${h} due to unbound types`, [n]);
      }), tt([t, r2, e2], n ? [n] : [], (_) => {
        _ = _[0];
        var S, O;
        n ? (S = _.registeredClass, O = S.instancePrototype) : O = Dt.prototype;
        var x = vt(h, function() {
          if (Object.getPrototypeOf(this) !== rt)
            throw new it("Use 'new' to construct " + h);
          if (M.constructor_body === void 0)
            throw new it(h + " has no accessible constructor");
          for (var Yr = arguments.length, It = new Array(Yr), Rt = 0; Rt < Yr; Rt++)
            It[Rt] = arguments[Rt];
          var qr = M.constructor_body[It.length];
          if (qr === void 0)
            throw new it(`Tried to invoke ctor of ${h} with invalid number of parameters (${It.length}) - expected (${Object.keys(M.constructor_body).toString()}) parameters instead!`);
          return qr.apply(this, It);
        }), rt = Object.create(O, {
          constructor: {
            value: x
          }
        });
        x.prototype = rt;
        var M = new nn(h, x, rt, g, S, i, s, f);
        if (M.baseClass) {
          var q, Wt;
          (Wt = (q = M.baseClass).__derivedClasses) !== null && Wt !== void 0 || (q.__derivedClasses = []), M.baseClass.__derivedClasses.push(M);
        }
        var to = new St(h, M, true, false, false), Xr = new St(h + "*", M, false, false, false), Qr = new St(h + " const*", M, false, true, false);
        return Cr[t] = {
          pointerType: Xr,
          constPointerType: Qr
        }, Er(T, x), [to, Xr, Qr];
      });
    }, Yt = (t, r2) => {
      for (var e2 = [], n = 0; n < t; n++)
        e2.push(E[r2 + n * 4 >> 2]);
      return e2;
    };
    function pn(t) {
      for (var r2 = 1; r2 < t.length; ++r2)
        if (t[r2] !== null && t[r2].destructorFunction === void 0)
          return true;
      return false;
    }
    function qt(t, r2, e2, n, a, i) {
      var u = r2.length;
      u < 2 && C("argTypes array size mismatch! Must at least get return value and 'this' types!");
      var s = r2[1] !== null && e2 !== null, l = pn(r2), f = r2[0].name !== "void", h = u - 2, v = new Array(h), g = [], T = [], _ = function() {
        T.length = 0;
        var S;
        g.length = s ? 2 : 1, g[0] = a, s && (S = r2[1].toWireType(T, this), g[1] = S);
        for (var O = 0; O < h; ++O)
          v[O] = r2[O + 2].toWireType(T, O < 0 || arguments.length <= O ? void 0 : arguments[O]), g.push(v[O]);
        var x = n(...g);
        function rt(M) {
          if (l)
            zt(T);
          else
            for (var q = s ? 1 : 2; q < r2.length; q++) {
              var Wt = q === 1 ? S : v[q - 2];
              r2[q].destructorFunction !== null && r2[q].destructorFunction(Wt);
            }
          if (f)
            return r2[0].fromWireType(M);
        }
        return rt(x);
      };
      return vt(t, _);
    }
    var vn = (t, r2, e2, n, a, i) => {
      var u = Yt(r2, e2);
      a = U(n, a), tt([], [t], (s) => {
        s = s[0];
        var l = `constructor ${s.name}`;
        if (s.registeredClass.constructor_body === void 0 && (s.registeredClass.constructor_body = []), s.registeredClass.constructor_body[r2 - 1] !== void 0)
          throw new it(`Cannot register multiple constructors with identical number of parameters (${r2 - 1}) for class '${s.name}'! Overload resolution is currently only performed using the parameter count, not actual type info!`);
        return s.registeredClass.constructor_body[r2 - 1] = () => {
          Ft(`Cannot construct ${s.name} due to unbound types`, u);
        }, tt([], u, (f) => (f.splice(1, 0, null), s.registeredClass.constructor_body[r2 - 1] = qt(l, f, null, a, i), [])), [];
      });
    }, xr = (t) => {
      t = t.trim();
      const r2 = t.indexOf("(");
      return r2 !== -1 ? t.substr(0, r2) : t;
    }, yn = (t, r2, e2, n, a, i, u, s, l, f) => {
      var h = Yt(e2, n);
      r2 = j(r2), r2 = xr(r2), i = U(a, i), tt([], [t], (v) => {
        v = v[0];
        var g = `${v.name}.${r2}`;
        r2.startsWith("@@") && (r2 = Symbol[r2.substring(2)]), s && v.registeredClass.pureVirtualFunctions.push(r2);
        function T() {
          Ft(`Cannot call ${g} due to unbound types`, h);
        }
        var _ = v.registeredClass.instancePrototype, S = _[r2];
        return S === void 0 || S.overloadTable === void 0 && S.className !== v.name && S.argCount === e2 - 2 ? (T.argCount = e2 - 2, T.className = v.name, _[r2] = T) : (Pr(_, r2, g), _[r2].overloadTable[e2 - 2] = T), tt([], h, (O) => {
          var x = qt(g, O, v, i, u);
          return _[r2].overloadTable === void 0 ? (x.argCount = e2 - 2, _[r2] = x) : _[r2].overloadTable[e2 - 2] = x, [];
        }), [];
      });
    }, Zt = [], X = [], Jt = (t) => {
      t > 9 && --X[t + 1] === 0 && (X[t] = void 0, Zt.push(t));
    }, mn = () => X.length / 2 - 5 - Zt.length, gn = () => {
      X.push(0, 1, void 0, 1, null, 1, true, 1, false, 1), c.count_emval_handles = mn;
    }, Q = {
      toValue: (t) => (t || C("Cannot use deleted val. handle = " + t), X[t]),
      toHandle: (t) => {
        switch (t) {
          case void 0:
            return 2;
          case null:
            return 4;
          case true:
            return 6;
          case false:
            return 8;
          default: {
            const r2 = Zt.pop() || X.length;
            return X[r2] = t, X[r2 + 1] = 1, r2;
          }
        }
      }
    }, Dr = {
      name: "emscripten::val",
      fromWireType: (t) => {
        var r2 = Q.toValue(t);
        return Jt(t), r2;
      },
      toWireType: (t, r2) => Q.toHandle(r2),
      argPackAdvance: z,
      readValueFromPointer: ht,
      destructorFunction: null
    }, wn = (t) => k(t, Dr), $n = (t, r2, e2) => {
      switch (r2) {
        case 1:
          return e2 ? function(n) {
            return this.fromWireType(L[n]);
          } : function(n) {
            return this.fromWireType(F[n]);
          };
        case 2:
          return e2 ? function(n) {
            return this.fromWireType(at[n >> 1]);
          } : function(n) {
            return this.fromWireType(ft[n >> 1]);
          };
        case 4:
          return e2 ? function(n) {
            return this.fromWireType(Z[n >> 2]);
          } : function(n) {
            return this.fromWireType(E[n >> 2]);
          };
        default:
          throw new TypeError(`invalid integer width (${r2}): ${t}`);
      }
    }, bn = (t, r2, e2, n) => {
      r2 = j(r2);
      function a() {
      }
      a.values = {}, k(t, {
        name: r2,
        constructor: a,
        fromWireType: function(i) {
          return this.constructor.values[i];
        },
        toWireType: (i, u) => u.value,
        argPackAdvance: z,
        readValueFromPointer: $n(r2, e2, n),
        destructorFunction: null
      }), Xt(r2, a);
    }, Kt = (t, r2) => {
      var e2 = K[t];
      return e2 === void 0 && C(`${r2} has unknown type ${Or(t)}`), e2;
    }, Cn = (t, r2, e2) => {
      var n = Kt(t, "enum");
      r2 = j(r2);
      var a = n.constructor, i = Object.create(n.constructor.prototype, {
        value: {
          value: e2
        },
        constructor: {
          value: vt(`${n.name}_${r2}`, function() {
          })
        }
      });
      a.values[e2] = i, a[r2] = i;
    }, tr = (t) => {
      if (t === null)
        return "null";
      var r2 = typeof t;
      return r2 === "object" || r2 === "array" || r2 === "function" ? t.toString() : "" + t;
    }, Tn = (t, r2) => {
      switch (r2) {
        case 4:
          return function(e2) {
            return this.fromWireType(ur[e2 >> 2]);
          };
        case 8:
          return function(e2) {
            return this.fromWireType(cr[e2 >> 3]);
          };
        default:
          throw new TypeError(`invalid float width (${r2}): ${t}`);
      }
    }, Pn = (t, r2, e2) => {
      r2 = j(r2), k(t, {
        name: r2,
        fromWireType: (n) => n,
        toWireType: (n, a) => a,
        argPackAdvance: z,
        readValueFromPointer: Tn(r2, e2),
        destructorFunction: null
      });
    }, En = (t, r2, e2, n, a, i, u, s) => {
      var l = Yt(r2, e2);
      t = j(t), t = xr(t), a = U(n, a), Xt(t, function() {
        Ft(`Cannot call ${t} due to unbound types`, l);
      }, r2 - 1), tt([], l, (f) => {
        var h = [f[0], null].concat(f.slice(1));
        return Er(t, qt(t, h, null, a, i), r2 - 1), [];
      });
    }, _n = (t, r2, e2) => {
      switch (r2) {
        case 1:
          return e2 ? (n) => L[n] : (n) => F[n];
        case 2:
          return e2 ? (n) => at[n >> 1] : (n) => ft[n >> 1];
        case 4:
          return e2 ? (n) => Z[n >> 2] : (n) => E[n >> 2];
        default:
          throw new TypeError(`invalid integer width (${r2}): ${t}`);
      }
    }, An = (t, r2, e2, n, a) => {
      r2 = j(r2);
      var i = (h) => h;
      if (n === 0) {
        var u = 32 - 8 * e2;
        i = (h) => h << u >>> u;
      }
      var s = r2.includes("unsigned"), l = (h, v) => {
      }, f;
      s ? f = function(h, v) {
        return l(v, this.name), v >>> 0;
      } : f = function(h, v) {
        return l(v, this.name), v;
      }, k(t, {
        name: r2,
        fromWireType: i,
        toWireType: f,
        argPackAdvance: z,
        readValueFromPointer: _n(r2, e2, n !== 0),
        destructorFunction: null
      });
    }, On = (t, r2, e2) => {
      var n = [Int8Array, Uint8Array, Int16Array, Uint16Array, Int32Array, Uint32Array, Float32Array, Float64Array], a = n[r2];
      function i(u) {
        var s = E[u >> 2], l = E[u + 4 >> 2];
        return new a(L.buffer, l, s);
      }
      e2 = j(e2), k(t, {
        name: e2,
        fromWireType: i,
        argPackAdvance: z,
        readValueFromPointer: i
      }, {
        ignoreDuplicateRegistrations: true
      });
    }, xn = Object.assign({
      optional: true
    }, Dr), Dn = (t, r2) => {
      k(t, xn);
    }, Sn = (t, r2, e2, n) => {
      if (!(n > 0)) return 0;
      for (var a = e2, i = e2 + n - 1, u = 0; u < t.length; ++u) {
        var s = t.charCodeAt(u);
        if (s >= 55296 && s <= 57343) {
          var l = t.charCodeAt(++u);
          s = 65536 + ((s & 1023) << 10) | l & 1023;
        }
        if (s <= 127) {
          if (e2 >= i) break;
          r2[e2++] = s;
        } else if (s <= 2047) {
          if (e2 + 1 >= i) break;
          r2[e2++] = 192 | s >> 6, r2[e2++] = 128 | s & 63;
        } else if (s <= 65535) {
          if (e2 + 2 >= i) break;
          r2[e2++] = 224 | s >> 12, r2[e2++] = 128 | s >> 6 & 63, r2[e2++] = 128 | s & 63;
        } else {
          if (e2 + 3 >= i) break;
          r2[e2++] = 240 | s >> 18, r2[e2++] = 128 | s >> 12 & 63, r2[e2++] = 128 | s >> 6 & 63, r2[e2++] = 128 | s & 63;
        }
      }
      return r2[e2] = 0, e2 - a;
    }, yt = (t, r2, e2) => Sn(t, F, r2, e2), jn = (t) => {
      for (var r2 = 0, e2 = 0; e2 < t.length; ++e2) {
        var n = t.charCodeAt(e2);
        n <= 127 ? r2++ : n <= 2047 ? r2 += 2 : n >= 55296 && n <= 57343 ? (r2 += 4, ++e2) : r2 += 3;
      }
      return r2;
    }, Sr = typeof TextDecoder < "u" ? new TextDecoder() : void 0, jr = function(t) {
      let r2 = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : 0, e2 = arguments.length > 2 && arguments[2] !== void 0 ? arguments[2] : NaN;
      for (var n = r2 + e2, a = r2; t[a] && !(a >= n); ) ++a;
      if (a - r2 > 16 && t.buffer && Sr)
        return Sr.decode(t.subarray(r2, a));
      for (var i = ""; r2 < a; ) {
        var u = t[r2++];
        if (!(u & 128)) {
          i += String.fromCharCode(u);
          continue;
        }
        var s = t[r2++] & 63;
        if ((u & 224) == 192) {
          i += String.fromCharCode((u & 31) << 6 | s);
          continue;
        }
        var l = t[r2++] & 63;
        if ((u & 240) == 224 ? u = (u & 15) << 12 | s << 6 | l : u = (u & 7) << 18 | s << 12 | l << 6 | t[r2++] & 63, u < 65536)
          i += String.fromCharCode(u);
        else {
          var f = u - 65536;
          i += String.fromCharCode(55296 | f >> 10, 56320 | f & 1023);
        }
      }
      return i;
    }, Fn = (t, r2) => t ? jr(F, t, r2) : "", Mn = (t, r2) => {
      r2 = j(r2);
      var e2 = r2 === "std::string";
      k(t, {
        name: r2,
        fromWireType(n) {
          var a = E[n >> 2], i = n + 4, u;
          if (e2)
            for (var s = i, l = 0; l <= a; ++l) {
              var f = i + l;
              if (l == a || F[f] == 0) {
                var h = f - s, v = Fn(s, h);
                u === void 0 ? u = v : (u += "\0", u += v), s = f + 1;
              }
            }
          else {
            for (var g = new Array(a), l = 0; l < a; ++l)
              g[l] = String.fromCharCode(F[i + l]);
            u = g.join("");
          }
          return Y(n), u;
        },
        toWireType(n, a) {
          a instanceof ArrayBuffer && (a = new Uint8Array(a));
          var i, u = typeof a == "string";
          u || a instanceof Uint8Array || a instanceof Uint8ClampedArray || a instanceof Int8Array || C("Cannot pass non-string to std::string"), e2 && u ? i = jn(a) : i = a.length;
          var s = nr(4 + i + 1), l = s + 4;
          if (E[s >> 2] = i, e2 && u)
            yt(a, l, i + 1);
          else if (u)
            for (var f = 0; f < i; ++f) {
              var h = a.charCodeAt(f);
              h > 255 && (Y(l), C("String has UTF-16 code units that do not fit in 8 bits")), F[l + f] = h;
            }
          else
            for (var f = 0; f < i; ++f)
              F[l + f] = a[f];
          return n !== null && n.push(Y, s), s;
        },
        argPackAdvance: z,
        readValueFromPointer: ht,
        destructorFunction(n) {
          Y(n);
        }
      });
    }, Fr = typeof TextDecoder < "u" ? new TextDecoder("utf-16le") : void 0, Wn = (t, r2) => {
      for (var e2 = t, n = e2 >> 1, a = n + r2 / 2; !(n >= a) && ft[n]; ) ++n;
      if (e2 = n << 1, e2 - t > 32 && Fr) return Fr.decode(F.subarray(t, e2));
      for (var i = "", u = 0; !(u >= r2 / 2); ++u) {
        var s = at[t + u * 2 >> 1];
        if (s == 0) break;
        i += String.fromCharCode(s);
      }
      return i;
    }, In = (t, r2, e2) => {
      var n;
      if ((n = e2) !== null && n !== void 0 || (e2 = 2147483647), e2 < 2) return 0;
      e2 -= 2;
      for (var a = r2, i = e2 < t.length * 2 ? e2 / 2 : t.length, u = 0; u < i; ++u) {
        var s = t.charCodeAt(u);
        at[r2 >> 1] = s, r2 += 2;
      }
      return at[r2 >> 1] = 0, r2 - a;
    }, Rn = (t) => t.length * 2, Bn = (t, r2) => {
      for (var e2 = 0, n = ""; !(e2 >= r2 / 4); ) {
        var a = Z[t + e2 * 4 >> 2];
        if (a == 0) break;
        if (++e2, a >= 65536) {
          var i = a - 65536;
          n += String.fromCharCode(55296 | i >> 10, 56320 | i & 1023);
        } else
          n += String.fromCharCode(a);
      }
      return n;
    }, kn = (t, r2, e2) => {
      var n;
      if ((n = e2) !== null && n !== void 0 || (e2 = 2147483647), e2 < 4) return 0;
      for (var a = r2, i = a + e2 - 4, u = 0; u < t.length; ++u) {
        var s = t.charCodeAt(u);
        if (s >= 55296 && s <= 57343) {
          var l = t.charCodeAt(++u);
          s = 65536 + ((s & 1023) << 10) | l & 1023;
        }
        if (Z[r2 >> 2] = s, r2 += 4, r2 + 4 > i) break;
      }
      return Z[r2 >> 2] = 0, r2 - a;
    }, Un = (t) => {
      for (var r2 = 0, e2 = 0; e2 < t.length; ++e2) {
        var n = t.charCodeAt(e2);
        n >= 55296 && n <= 57343 && ++e2, r2 += 4;
      }
      return r2;
    }, Vn = (t, r2, e2) => {
      e2 = j(e2);
      var n, a, i, u;
      r2 === 2 ? (n = Wn, a = In, u = Rn, i = (s) => ft[s >> 1]) : r2 === 4 && (n = Bn, a = kn, u = Un, i = (s) => E[s >> 2]), k(t, {
        name: e2,
        fromWireType: (s) => {
          for (var l = E[s >> 2], f, h = s + 4, v = 0; v <= l; ++v) {
            var g = s + 4 + v * r2;
            if (v == l || i(g) == 0) {
              var T = g - h, _ = n(h, T);
              f === void 0 ? f = _ : (f += "\0", f += _), h = g + r2;
            }
          }
          return Y(s), f;
        },
        toWireType: (s, l) => {
          typeof l != "string" && C(`Cannot pass non-string to C++ string type ${e2}`);
          var f = u(l), h = nr(4 + f + r2);
          return E[h >> 2] = f / r2, a(l, h + 4, f + r2), s !== null && s.push(Y, h), h;
        },
        argPackAdvance: z,
        readValueFromPointer: ht,
        destructorFunction(s) {
          Y(s);
        }
      });
    }, Hn = (t, r2, e2, n, a, i) => {
      Et[t] = {
        name: j(r2),
        rawConstructor: U(e2, n),
        rawDestructor: U(a, i),
        fields: []
      };
    }, Ln = (t, r2, e2, n, a, i, u, s, l, f) => {
      Et[t].fields.push({
        fieldName: j(r2),
        getterReturnType: e2,
        getter: U(n, a),
        getterContext: i,
        setterArgumentType: u,
        setter: U(s, l),
        setterContext: f
      });
    }, zn = (t, r2) => {
      r2 = j(r2), k(t, {
        isVoid: true,
        name: r2,
        argPackAdvance: 0,
        fromWireType: () => {
        },
        toWireType: (e2, n) => {
        }
      });
    }, Nn = (t, r2, e2) => F.copyWithin(t, r2, r2 + e2), rr = [], Gn = (t, r2, e2, n) => (t = rr[t], r2 = Q.toValue(r2), t(null, r2, e2, n)), Xn = {}, Qn = (t) => {
      var r2 = Xn[t];
      return r2 === void 0 ? j(t) : r2;
    }, Mr = () => {
      if (typeof globalThis == "object")
        return globalThis;
      function t(r2) {
        r2.$$$embind_global$$$ = r2;
        var e2 = typeof $$$embind_global$$$ == "object" && r2.$$$embind_global$$$ == r2;
        return e2 || delete r2.$$$embind_global$$$, e2;
      }
      if (typeof $$$embind_global$$$ == "object" || (typeof global == "object" && t(global) ? $$$embind_global$$$ = global : typeof self == "object" && t(self) && ($$$embind_global$$$ = self), typeof $$$embind_global$$$ == "object"))
        return $$$embind_global$$$;
      throw Error("unable to get global object.");
    }, Yn = (t) => t === 0 ? Q.toHandle(Mr()) : (t = Qn(t), Q.toHandle(Mr()[t])), qn = (t) => {
      var r2 = rr.length;
      return rr.push(t), r2;
    }, Zn = (t, r2) => {
      for (var e2 = new Array(t), n = 0; n < t; ++n)
        e2[n] = Kt(E[r2 + n * 4 >> 2], "parameter " + n);
      return e2;
    }, Jn = Reflect.construct, Kn = (t, r2, e2) => {
      var n = [], a = t.toWireType(n, e2);
      return n.length && (E[r2 >> 2] = Q.toHandle(n)), a;
    }, ta = (t, r2, e2) => {
      var n = Zn(t, r2), a = n.shift();
      t--;
      var i = new Array(t), u = (l, f, h, v) => {
        for (var g = 0, T = 0; T < t; ++T)
          i[T] = n[T].readValueFromPointer(v + g), g += n[T].argPackAdvance;
        var _ = e2 === 1 ? Jn(f, i) : f.apply(l, i);
        return Kn(a, h, _);
      }, s = `methodCaller<(${n.map((l) => l.name).join(", ")}) => ${a.name}>`;
      return qn(vt(s, u));
    }, ra = (t) => {
      t > 9 && (X[t + 1] += 1);
    }, ea = (t) => {
      var r2 = Q.toValue(t);
      zt(r2), Jt(t);
    }, na = (t, r2) => {
      t = Kt(t, "_emval_take_value");
      var e2 = t.readValueFromPointer(r2);
      return Q.toHandle(e2);
    }, aa = (t, r2, e2, n) => {
      var a = (/* @__PURE__ */ new Date()).getFullYear(), i = new Date(a, 0, 1), u = new Date(a, 6, 1), s = i.getTimezoneOffset(), l = u.getTimezoneOffset(), f = Math.max(s, l);
      E[t >> 2] = f * 60, Z[r2 >> 2] = +(s != l);
      var h = (T) => {
        var _ = T >= 0 ? "-" : "+", S = Math.abs(T), O = String(Math.floor(S / 60)).padStart(2, "0"), x = String(S % 60).padStart(2, "0");
        return `UTC${_}${O}${x}`;
      }, v = h(s), g = h(l);
      l < s ? (yt(v, e2, 17), yt(g, n, 17)) : (yt(v, n, 17), yt(g, e2, 17));
    }, oa = () => 2147483648, ia = (t, r2) => Math.ceil(t / r2) * r2, sa = (t) => {
      var r2 = $t.buffer, e2 = (t - r2.byteLength + 65535) / 65536 | 0;
      try {
        return $t.grow(e2), lr(), 1;
      } catch {
      }
    }, ua = (t) => {
      var r2 = F.length;
      t >>>= 0;
      var e2 = oa();
      if (t > e2)
        return false;
      for (var n = 1; n <= 4; n *= 2) {
        var a = r2 * (1 + 0.2 / n);
        a = Math.min(a, t + 100663296);
        var i = Math.min(e2, ia(Math.max(t, a), 65536)), u = sa(i);
        if (u)
          return true;
      }
      return false;
    }, er = {}, ca = () => H || "./this.program", mt = () => {
      if (!mt.strings) {
        var t = (typeof navigator == "object" && navigator.languages && navigator.languages[0] || "C").replace("-", "_") + ".UTF-8", r2 = {
          USER: "web_user",
          LOGNAME: "web_user",
          PATH: "/",
          PWD: "/",
          HOME: "/home/web_user",
          LANG: t,
          _: ca()
        };
        for (var e2 in er)
          er[e2] === void 0 ? delete r2[e2] : r2[e2] = er[e2];
        var n = [];
        for (var e2 in r2)
          n.push(`${e2}=${r2[e2]}`);
        mt.strings = n;
      }
      return mt.strings;
    }, la = (t, r2) => {
      for (var e2 = 0; e2 < t.length; ++e2)
        L[r2++] = t.charCodeAt(e2);
      L[r2] = 0;
    }, fa = (t, r2) => {
      var e2 = 0;
      return mt().forEach((n, a) => {
        var i = r2 + e2;
        E[t + a * 4 >> 2] = i, la(n, i), e2 += n.length + 1;
      }), 0;
    }, da = (t, r2) => {
      var e2 = mt();
      E[t >> 2] = e2.length;
      var n = 0;
      return e2.forEach((a) => n += a.length + 1), E[r2 >> 2] = n, 0;
    }, ha = (t) => 52;
    function pa(t, r2, e2, n, a) {
      return 70;
    }
    var va = [null, [], []], ya = (t, r2) => {
      var e2 = va[t];
      r2 === 0 || r2 === 10 ? ((t === 1 ? kt : nt)(jr(e2)), e2.length = 0) : e2.push(r2);
    }, ma = (t, r2, e2, n) => {
      for (var a = 0, i = 0; i < e2; i++) {
        var u = E[r2 >> 2], s = E[r2 + 4 >> 2];
        r2 += 8;
        for (var l = 0; l < s; l++)
          ya(t, F[u + l]);
        a += s;
      }
      return E[n >> 2] = a, 0;
    }, ga = (t) => t;
    mr = c.InternalError = class extends Error {
      constructor(t) {
        super(t), this.name = "InternalError";
      }
    }, Le(), it = c.BindingError = class extends Error {
      constructor(t) {
        super(t), this.name = "BindingError";
      }
    }, Ke(), un(), Ar = c.UnboundTypeError = dn(Error, "UnboundTypeError"), gn();
    var wa = {
      t: Se,
      x: je,
      a: Me,
      j: We,
      k: Ie,
      O: Re,
      q: Be,
      ga: ke,
      d: Fe,
      ca: Ue,
      va: Ve,
      ba: He,
      pa: Ne,
      ta: hn,
      sa: vn,
      E: yn,
      oa: wn,
      F: bn,
      n: Cn,
      W: Pn,
      X: En,
      y: An,
      u: On,
      ua: Dn,
      V: Mn,
      P: Vn,
      L: Hn,
      wa: Ln,
      qa: zn,
      ja: Nn,
      T: Gn,
      xa: Jt,
      ya: Yn,
      U: ta,
      Y: ra,
      Z: ea,
      ra: na,
      da: aa,
      ha: ua,
      ea: fa,
      fa: da,
      ia: ha,
      $: pa,
      S: ma,
      J: Ua,
      C: Ha,
      Q: Pa,
      R: Ya,
      r: Ia,
      b: $a,
      D: ka,
      la: za,
      c: _a,
      ka: Na,
      h: Ta,
      i: Da,
      s: Sa,
      N: Ba,
      w: Fa,
      I: Xa,
      K: Ra,
      z: La,
      H: qa,
      aa: Ja,
      _: Ka,
      l: Aa,
      f: Ea,
      e: Ca,
      g: ba,
      M: Qa,
      m: xa,
      ma: Va,
      p: ja,
      v: Ma,
      na: Wa,
      B: Ga,
      o: Oa,
      G: Za,
      A: ga
    }, A = De(), Wr = (t) => (Wr = A.Ba)(t), Y = c._free = (t) => (Y = c._free = A.Ca)(t), nr = c._malloc = (t) => (nr = c._malloc = A.Ea)(t), Ir = (t) => (Ir = A.Fa)(t), m = (t, r2) => (m = A.Ga)(t, r2), Rr = (t) => (Rr = A.Ha)(t), Br = (t) => (Br = A.Ia)(t), kr = () => (kr = A.Ja)(), Ur = (t) => (Ur = A.Ka)(t), Vr = (t) => (Vr = A.La)(t), Hr = (t, r2, e2) => (Hr = A.Ma)(t, r2, e2);
    c.dynCall_viijii = (t, r2, e2, n, a, i, u) => (c.dynCall_viijii = A.Na)(t, r2, e2, n, a, i, u);
    var Lr = c.dynCall_jiii = (t, r2, e2, n) => (Lr = c.dynCall_jiii = A.Oa)(t, r2, e2, n);
    c.dynCall_jiji = (t, r2, e2, n, a) => (c.dynCall_jiji = A.Pa)(t, r2, e2, n, a);
    var zr = c.dynCall_jiiii = (t, r2, e2, n, a) => (zr = c.dynCall_jiiii = A.Qa)(t, r2, e2, n, a);
    c.dynCall_iiiiij = (t, r2, e2, n, a, i, u) => (c.dynCall_iiiiij = A.Ra)(t, r2, e2, n, a, i, u), c.dynCall_iiiiijj = (t, r2, e2, n, a, i, u, s, l) => (c.dynCall_iiiiijj = A.Sa)(t, r2, e2, n, a, i, u, s, l), c.dynCall_iiiiiijj = (t, r2, e2, n, a, i, u, s, l, f) => (c.dynCall_iiiiiijj = A.Ta)(t, r2, e2, n, a, i, u, s, l, f);
    function $a(t, r2) {
      var e2 = $();
      try {
        return b(t)(r2);
      } catch (n) {
        if (w(e2), n !== n + 0) throw n;
        m(1, 0);
      }
    }
    function ba(t, r2, e2, n) {
      var a = $();
      try {
        b(t)(r2, e2, n);
      } catch (i) {
        if (w(a), i !== i + 0) throw i;
        m(1, 0);
      }
    }
    function Ca(t, r2, e2) {
      var n = $();
      try {
        b(t)(r2, e2);
      } catch (a) {
        if (w(n), a !== a + 0) throw a;
        m(1, 0);
      }
    }
    function Ta(t, r2, e2, n) {
      var a = $();
      try {
        return b(t)(r2, e2, n);
      } catch (i) {
        if (w(a), i !== i + 0) throw i;
        m(1, 0);
      }
    }
    function Pa(t, r2, e2, n, a) {
      var i = $();
      try {
        return b(t)(r2, e2, n, a);
      } catch (u) {
        if (w(i), u !== u + 0) throw u;
        m(1, 0);
      }
    }
    function Ea(t, r2) {
      var e2 = $();
      try {
        b(t)(r2);
      } catch (n) {
        if (w(e2), n !== n + 0) throw n;
        m(1, 0);
      }
    }
    function _a(t, r2, e2) {
      var n = $();
      try {
        return b(t)(r2, e2);
      } catch (a) {
        if (w(n), a !== a + 0) throw a;
        m(1, 0);
      }
    }
    function Aa(t) {
      var r2 = $();
      try {
        b(t)();
      } catch (e2) {
        if (w(r2), e2 !== e2 + 0) throw e2;
        m(1, 0);
      }
    }
    function Oa(t, r2, e2, n, a, i, u, s, l, f, h) {
      var v = $();
      try {
        b(t)(r2, e2, n, a, i, u, s, l, f, h);
      } catch (g) {
        if (w(v), g !== g + 0) throw g;
        m(1, 0);
      }
    }
    function xa(t, r2, e2, n, a) {
      var i = $();
      try {
        b(t)(r2, e2, n, a);
      } catch (u) {
        if (w(i), u !== u + 0) throw u;
        m(1, 0);
      }
    }
    function Da(t, r2, e2, n, a) {
      var i = $();
      try {
        return b(t)(r2, e2, n, a);
      } catch (u) {
        if (w(i), u !== u + 0) throw u;
        m(1, 0);
      }
    }
    function Sa(t, r2, e2, n, a, i) {
      var u = $();
      try {
        return b(t)(r2, e2, n, a, i);
      } catch (s) {
        if (w(u), s !== s + 0) throw s;
        m(1, 0);
      }
    }
    function ja(t, r2, e2, n, a, i) {
      var u = $();
      try {
        b(t)(r2, e2, n, a, i);
      } catch (s) {
        if (w(u), s !== s + 0) throw s;
        m(1, 0);
      }
    }
    function Fa(t, r2, e2, n, a, i, u) {
      var s = $();
      try {
        return b(t)(r2, e2, n, a, i, u);
      } catch (l) {
        if (w(s), l !== l + 0) throw l;
        m(1, 0);
      }
    }
    function Ma(t, r2, e2, n, a, i, u, s) {
      var l = $();
      try {
        b(t)(r2, e2, n, a, i, u, s);
      } catch (f) {
        if (w(l), f !== f + 0) throw f;
        m(1, 0);
      }
    }
    function Wa(t, r2, e2, n, a, i, u, s, l) {
      var f = $();
      try {
        b(t)(r2, e2, n, a, i, u, s, l);
      } catch (h) {
        if (w(f), h !== h + 0) throw h;
        m(1, 0);
      }
    }
    function Ia(t) {
      var r2 = $();
      try {
        return b(t)();
      } catch (e2) {
        if (w(r2), e2 !== e2 + 0) throw e2;
        m(1, 0);
      }
    }
    function Ra(t, r2, e2, n, a, i, u, s, l) {
      var f = $();
      try {
        return b(t)(r2, e2, n, a, i, u, s, l);
      } catch (h) {
        if (w(f), h !== h + 0) throw h;
        m(1, 0);
      }
    }
    function Ba(t, r2, e2, n, a, i, u) {
      var s = $();
      try {
        return b(t)(r2, e2, n, a, i, u);
      } catch (l) {
        if (w(s), l !== l + 0) throw l;
        m(1, 0);
      }
    }
    function ka(t, r2, e2, n) {
      var a = $();
      try {
        return b(t)(r2, e2, n);
      } catch (i) {
        if (w(a), i !== i + 0) throw i;
        m(1, 0);
      }
    }
    function Ua(t, r2, e2, n) {
      var a = $();
      try {
        return b(t)(r2, e2, n);
      } catch (i) {
        if (w(a), i !== i + 0) throw i;
        m(1, 0);
      }
    }
    function Va(t, r2, e2, n, a, i, u, s) {
      var l = $();
      try {
        b(t)(r2, e2, n, a, i, u, s);
      } catch (f) {
        if (w(l), f !== f + 0) throw f;
        m(1, 0);
      }
    }
    function Ha(t, r2, e2, n, a, i) {
      var u = $();
      try {
        return b(t)(r2, e2, n, a, i);
      } catch (s) {
        if (w(u), s !== s + 0) throw s;
        m(1, 0);
      }
    }
    function La(t, r2, e2, n, a, i, u, s, l, f) {
      var h = $();
      try {
        return b(t)(r2, e2, n, a, i, u, s, l, f);
      } catch (v) {
        if (w(h), v !== v + 0) throw v;
        m(1, 0);
      }
    }
    function za(t, r2, e2) {
      var n = $();
      try {
        return b(t)(r2, e2);
      } catch (a) {
        if (w(n), a !== a + 0) throw a;
        m(1, 0);
      }
    }
    function Na(t, r2, e2, n, a) {
      var i = $();
      try {
        return b(t)(r2, e2, n, a);
      } catch (u) {
        if (w(i), u !== u + 0) throw u;
        m(1, 0);
      }
    }
    function Ga(t, r2, e2, n, a, i, u, s, l, f) {
      var h = $();
      try {
        b(t)(r2, e2, n, a, i, u, s, l, f);
      } catch (v) {
        if (w(h), v !== v + 0) throw v;
        m(1, 0);
      }
    }
    function Xa(t, r2, e2, n, a, i, u, s) {
      var l = $();
      try {
        return b(t)(r2, e2, n, a, i, u, s);
      } catch (f) {
        if (w(l), f !== f + 0) throw f;
        m(1, 0);
      }
    }
    function Qa(t, r2, e2, n, a, i, u) {
      var s = $();
      try {
        b(t)(r2, e2, n, a, i, u);
      } catch (l) {
        if (w(s), l !== l + 0) throw l;
        m(1, 0);
      }
    }
    function Ya(t, r2, e2, n) {
      var a = $();
      try {
        return b(t)(r2, e2, n);
      } catch (i) {
        if (w(a), i !== i + 0) throw i;
        m(1, 0);
      }
    }
    function qa(t, r2, e2, n, a, i, u, s, l, f, h, v) {
      var g = $();
      try {
        return b(t)(r2, e2, n, a, i, u, s, l, f, h, v);
      } catch (T) {
        if (w(g), T !== T + 0) throw T;
        m(1, 0);
      }
    }
    function Za(t, r2, e2, n, a, i, u, s, l, f, h, v, g, T, _, S) {
      var O = $();
      try {
        b(t)(r2, e2, n, a, i, u, s, l, f, h, v, g, T, _, S);
      } catch (x) {
        if (w(O), x !== x + 0) throw x;
        m(1, 0);
      }
    }
    function Ja(t, r2, e2, n) {
      var a = $();
      try {
        return Lr(t, r2, e2, n);
      } catch (i) {
        if (w(a), i !== i + 0) throw i;
        m(1, 0);
      }
    }
    function Ka(t, r2, e2, n, a) {
      var i = $();
      try {
        return zr(t, r2, e2, n, a);
      } catch (u) {
        if (w(i), u !== u + 0) throw u;
        m(1, 0);
      }
    }
    var Mt, Nr;
    dt = function t() {
      Mt || Gr(), Mt || (dt = t);
    };
    function Gr() {
      if (J > 0 || !Nr && (Nr = 1, me(), J > 0))
        return;
      function t() {
        var r2;
        Mt || (Mt = 1, c.calledRun = 1, !sr && (ge(), P(c), (r2 = c.onRuntimeInitialized) === null || r2 === void 0 || r2.call(c), we()));
      }
      c.setStatus ? (c.setStatus("Running..."), setTimeout(() => {
        setTimeout(() => c.setStatus(""), 1), t();
      }, 1)) : t();
    }
    if (c.preInit)
      for (typeof c.preInit == "function" && (c.preInit = [c.preInit]); c.preInit.length > 0; )
        c.preInit.pop()();
    return Gr(), y = B, y;
  };
})();
function po(o) {
  return ir(
    Bt,
    o
  );
}
async function vo(o, d) {
  return fo(
    Bt,
    o,
    d
  );
}
async function yo(o, d) {
  return ho(
    Bt,
    o,
    d
  );
}
const se = [
  ["aztec", "Aztec"],
  ["code_128", "Code128"],
  ["code_39", "Code39"],
  ["code_93", "Code93"],
  ["codabar", "Codabar"],
  ["databar", "DataBar"],
  ["databar_expanded", "DataBarExpanded"],
  ["databar_limited", "DataBarLimited"],
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
], mo = [...se, ["unknown"]].map((o) => o[0]), or = new Map(
  se
);
function go(o) {
  for (const [d, p] of or)
    if (o === p)
      return d;
  return "unknown";
}
function wo(o) {
  if (ue(o))
    return {
      width: o.naturalWidth,
      height: o.naturalHeight
    };
  if (ce(o))
    return {
      width: o.width.baseVal.value,
      height: o.height.baseVal.value
    };
  if (le(o))
    return {
      width: o.videoWidth,
      height: o.videoHeight
    };
  if (de(o))
    return {
      width: o.width,
      height: o.height
    };
  if (pe(o))
    return {
      width: o.displayWidth,
      height: o.displayHeight
    };
  if (fe(o))
    return {
      width: o.width,
      height: o.height
    };
  if (he(o))
    return {
      width: o.width,
      height: o.height
    };
  throw new TypeError(
    "The provided value is not of type '(Blob or HTMLCanvasElement or HTMLImageElement or HTMLVideoElement or ImageBitmap or ImageData or OffscreenCanvas or SVGImageElement or VideoFrame)'."
  );
}
function ue(o) {
  var d, p;
  try {
    return o instanceof ((p = (d = o == null ? void 0 : o.ownerDocument) == null ? void 0 : d.defaultView) == null ? void 0 : p.HTMLImageElement);
  } catch {
    return false;
  }
}
function ce(o) {
  var d, p;
  try {
    return o instanceof ((p = (d = o == null ? void 0 : o.ownerDocument) == null ? void 0 : d.defaultView) == null ? void 0 : p.SVGImageElement);
  } catch {
    return false;
  }
}
function le(o) {
  var d, p;
  try {
    return o instanceof ((p = (d = o == null ? void 0 : o.ownerDocument) == null ? void 0 : d.defaultView) == null ? void 0 : p.HTMLVideoElement);
  } catch {
    return false;
  }
}
function fe(o) {
  var d, p;
  try {
    return o instanceof ((p = (d = o == null ? void 0 : o.ownerDocument) == null ? void 0 : d.defaultView) == null ? void 0 : p.HTMLCanvasElement);
  } catch {
    return false;
  }
}
function de(o) {
  try {
    return o instanceof ImageBitmap || Object.prototype.toString.call(o) === "[object ImageBitmap]";
  } catch {
    return false;
  }
}
function he(o) {
  try {
    return o instanceof OffscreenCanvas || Object.prototype.toString.call(o) === "[object OffscreenCanvas]";
  } catch {
    return false;
  }
}
function pe(o) {
  try {
    return o instanceof VideoFrame || Object.prototype.toString.call(o) === "[object VideoFrame]";
  } catch {
    return false;
  }
}
function ve(o) {
  try {
    return o instanceof Blob || Object.prototype.toString.call(o) === "[object Blob]";
  } catch {
    return false;
  }
}
function $o(o) {
  try {
    return o instanceof ImageData || Object.prototype.toString.call(o) === "[object ImageData]";
  } catch {
    return false;
  }
}
function bo(o, d) {
  try {
    const p = new OffscreenCanvas(o, d);
    if (p.getContext("2d") instanceof OffscreenCanvasRenderingContext2D)
      return p;
    throw void 0;
  } catch {
    const p = document.createElement("canvas");
    return p.width = o, p.height = d, p;
  }
}
async function ye(o) {
  if (ue(o) && !await Eo(o))
    throw new DOMException(
      "Failed to load or decode HTMLImageElement.",
      "InvalidStateError"
    );
  if (ce(o) && !await _o(o))
    throw new DOMException(
      "Failed to load or decode SVGImageElement.",
      "InvalidStateError"
    );
  if (pe(o) && Ao(o))
    throw new DOMException("VideoFrame is closed.", "InvalidStateError");
  if (le(o) && (o.readyState === 0 || o.readyState === 1))
    throw new DOMException("Invalid element or state.", "InvalidStateError");
  if (de(o) && xo(o))
    throw new DOMException(
      "The image source is detached.",
      "InvalidStateError"
    );
  const { width: d, height: p } = wo(o);
  if (d === 0 || p === 0)
    return null;
  const c = bo(d, p).getContext("2d");
  c.drawImage(o, 0, 0);
  try {
    return c.getImageData(0, 0, d, p);
  } catch {
    throw new DOMException("Source would taint origin.", "SecurityError");
  }
}
async function Co(o) {
  let d;
  try {
    if (globalThis.createImageBitmap)
      d = await createImageBitmap(o);
    else if (globalThis.Image) {
      d = new Image();
      let y = "";
      try {
        y = URL.createObjectURL(o), d.src = y, await d.decode();
      } finally {
        URL.revokeObjectURL(y);
      }
    } else
      return o;
  } catch {
    throw new DOMException(
      "Failed to load or decode Blob.",
      "InvalidStateError"
    );
  }
  return await ye(d);
}
function To(o) {
  const { width: d, height: p } = o;
  if (d === 0 || p === 0)
    return null;
  const y = o.getContext("2d");
  try {
    return y.getImageData(0, 0, d, p);
  } catch {
    throw new DOMException("Source would taint origin.", "SecurityError");
  }
}
async function Po(o) {
  if (ve(o))
    return await Co(o);
  if ($o(o)) {
    if (Oo(o))
      throw new DOMException(
        "The image data has been detached.",
        "InvalidStateError"
      );
    return o;
  }
  return fe(o) || he(o) ? To(o) : await ye(o);
}
async function Eo(o) {
  try {
    return await o.decode(), true;
  } catch {
    return false;
  }
}
async function _o(o) {
  var d;
  try {
    return await ((d = o.decode) == null ? void 0 : d.call(o)), true;
  } catch {
    return false;
  }
}
function Ao(o) {
  return o.format === null;
}
function Oo(o) {
  return o.data.buffer.byteLength === 0;
}
function xo(o) {
  return o.width === 0 && o.height === 0;
}
function ae(o, d) {
  return Do(o) ? new DOMException(`${d}: ${o.message}`, o.name) : So(o) ? new o.constructor(`${d}: ${o.message}`) : new Error(`${d}: ${o}`);
}
function Do(o) {
  return o instanceof DOMException || Object.prototype.toString.call(o) === "[object DOMException]";
}
function So(o) {
  return o instanceof Error || Object.prototype.toString.call(o) === "[object Error]";
}
var gt;
class Mo extends EventTarget {
  constructor(p = {}) {
    var y;
    super();
    te(this, gt);
    try {
      const c = (y = p == null ? void 0 : p.formats) == null ? void 0 : y.filter(
        (P) => P !== "unknown"
      );
      if ((c == null ? void 0 : c.length) === 0)
        throw new TypeError("Hint option provided, but is empty.");
      for (const P of c != null ? c : [])
        if (!or.has(P))
          throw new TypeError(
            `Failed to read the 'formats' property from 'BarcodeDetectorOptions': The provided value '${P}' is not a valid enum value of type BarcodeFormat.`
          );
      re(this, gt, c != null ? c : []), po().then((P) => {
        this.dispatchEvent(
          new CustomEvent("load", {
            detail: P
          })
        );
      }).catch((P) => {
        this.dispatchEvent(new CustomEvent("error", { detail: P }));
      });
    } catch (c) {
      throw ae(
        c,
        "Failed to construct 'BarcodeDetector'"
      );
    }
  }
  static async getSupportedFormats() {
    return mo.filter((p) => p !== "unknown");
  }
  async detect(p) {
    try {
      const y = await Po(p);
      if (y === null)
        return [];
      let c;
      const P = {
        tryHarder: true,
        // https://github.com/Sec-ant/barcode-detector/issues/91
        returnCodabarStartEnd: true,
        formats: Kr(this, gt).map((D) => or.get(D))
      };
      try {
        ve(y) ? c = await vo(
          y,
          P
        ) : c = await yo(
          y,
          P
        );
      } catch (D) {
        throw console.error(D), new DOMException(
          "Barcode detection service unavailable.",
          "NotSupportedError"
        );
      }
      return c.map((D) => {
        const {
          topLeft: { x: B, y: V },
          topRight: { x: R, y: W },
          bottomLeft: { x: N, y: H },
          bottomRight: { x: I, y: ut }
        } = D.position, ct = Math.min(B, R, N, I), et = Math.min(V, W, H, ut), lt = Math.max(B, R, N, I), kt = Math.max(V, W, H, ut);
        return {
          boundingBox: new DOMRectReadOnly(
            ct,
            et,
            lt - ct,
            kt - et
          ),
          rawValue: D.text,
          format: go(D.format),
          cornerPoints: [
            {
              x: B,
              y: V
            },
            {
              x: R,
              y: W
            },
            {
              x: I,
              y: ut
            },
            {
              x: N,
              y: H
            }
          ]
        };
      });
    } catch (y) {
      throw ae(
        y,
        "Failed to execute 'detect' on 'BarcodeDetector'"
      );
    }
  }
}
gt = /* @__PURE__ */ new WeakMap();
const _sfc_main$1 = {
  beforeMount() {
    if (!("BarcodeDetector" in window)) {
      window.BarcodeDetector = Mo;
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
const _sfc_main = defineComponent({
  name: "QrcodeStream",
  mixins: [_sfc_main$1],
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
  QrcodeStream as Q,
  _sfc_main$1 as _
};
