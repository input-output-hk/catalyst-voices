(function() {
  "use strict";
  var ApiChannel = /* @__PURE__ */ ((ApiChannel2) => {
    ApiChannel2["domToCS"] = "eternl-dom-to-cs";
    ApiChannel2["csToDom"] = "eternl-cs-to-dom";
    ApiChannel2["csToBg"] = "eternl-cs-to-bg";
    ApiChannel2["bgToCs"] = "eternl-bg-to-cs";
    ApiChannel2["bgToEnable"] = "eternl-bg-to-enable";
    ApiChannel2["enableToBg"] = "eternl-enable-to-bg";
    ApiChannel2["bgToSignTx"] = "eternl-bg-to-sign-tx";
    ApiChannel2["signTxToBg"] = "eternl-sign-tx-to-bg";
    ApiChannel2["bgToSignData"] = "eternl-bg-to-sign-data";
    ApiChannel2["signDataToBg"] = "eternl-sign-data-to-bg";
    ApiChannel2["bgToSync"] = "eternl-bg-to-sync";
    ApiChannel2["syncToBg"] = "eternl-sync-to-bg";
    return ApiChannel2;
  })(ApiChannel || {});
  var define_process_env_default = {};
  let _port = null;
  const handleMessage = (data, port) => {
    if (data.channel === ApiChannel.bgToCs) {
      data.channel = ApiChannel.csToDom;
      window.postMessage(data, "*");
    }
    return true;
  };
  const onDisconnect = () => {
    window.removeEventListener("message", onPostMessage);
    return true;
  };
  const initPort = () => {
    _port == null ? void 0 : _port.onMessage.removeListener(handleMessage);
    _port == null ? void 0 : _port.onDisconnect.removeListener(onDisconnect);
    _port = chrome.runtime.connect({ name: ApiChannel.csToBg });
    _port.onMessage.addListener(handleMessage);
    _port.onDisconnect.addListener(onDisconnect);
  };
  initPort();
  const onPostMessage = (msg) => {
    const data = msg.data;
    if (msg.source != window) {
      return;
    }
    if (((data == null ? void 0 : data.channel) ?? "") !== ApiChannel.domToCS) {
      return;
    }
    if (data.channel === ApiChannel.domToCS && _port) {
      data.channel = ApiChannel.csToBg;
      _port.postMessage(data);
    }
  };
  window.addEventListener("message", onPostMessage);
  function injectDomScript(url) {
    if (!document.getElementById("eternl-dom-script")) {
      const script = document.createElement("script");
      script.id = "eternl-dom-script";
      script.src = url;
      script.onload = function() {
        script.remove();
      };
      (document.head || document.documentElement).appendChild(script);
    }
  }
  if (typeof document !== "undefined" && document instanceof HTMLDocument) {
    injectDomScript(chrome.runtime.getURL(define_process_env_default.DEV ? "app/dom.js" : "app/dom.js"));
  }
})();
