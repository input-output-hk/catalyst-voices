// Compiles a dart2wasm-generated main module from `source` which can then
// instantiatable via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm modules from `bytes` which is then
// instantiatable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export async function instantiate(modulePromise, importObjectPromise) {
  var moduleOrCompiledApp = await modulePromise;
  if (!(moduleOrCompiledApp instanceof CompiledApp)) {
    moduleOrCompiledApp = new CompiledApp(moduleOrCompiledApp);
  }
  const instantiatedApp = await moduleOrCompiledApp.instantiate(await importObjectPromise);
  return instantiatedApp.instantiatedModule;
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export const invoke = (moduleInstance, ...args) => {
  moduleInstance.exports.$invokeMain(args);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredWasm` is a JS function that takes a module name matching a
  //   wasm file produced by the dart2wasm compiler and returns the bytes to
  //   load the module. These bytes can be in either a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  // `loadDynamicModule` is a JS function that takes two string names matching,
  //   in order, a wasm file produced by the dart2wasm compiler during dynamic
  //   module compilation and a corresponding js file produced by the same
  //   compilation. It should return a JS Array containing 2 elements. The first
  //   should be the bytes for the wasm module in a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`. The second
  //   should be the result of using the JS 'import' API on the js file path.
  async instantiate(additionalImports, {loadDeferredWasm, loadDynamicModule} = {}) {
    let dartInstance;

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + value;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
      wrapped.dartFunction = dartFunction;
      wrapped[jsWrappedDartFunctionSymbol] = true;
      return wrapped;
    }

    // Imports
    const dart2wasm = {
            _3: (o, t) => typeof o === t,
      _4: (o, c) => o instanceof c,
      _6: (o,s,v) => o[s] = v,
      _7: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._7(f,arguments.length,x0) }),
      _8: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._8(f,arguments.length,x0,x1) }),
      _9: (o, a) => o + a,
      _19: (o, a) => o == a,
      _36: () => new Array(),
      _37: x0 => new Array(x0),
      _39: x0 => x0.length,
      _41: (x0,x1) => x0[x1],
      _42: (x0,x1,x2) => { x0[x1] = x2 },
      _43: x0 => new Promise(x0),
      _45: (x0,x1,x2) => new DataView(x0,x1,x2),
      _47: x0 => new Int8Array(x0),
      _48: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      _49: x0 => new Uint8Array(x0),
      _51: x0 => new Uint8ClampedArray(x0),
      _53: x0 => new Int16Array(x0),
      _55: x0 => new Uint16Array(x0),
      _57: x0 => new Int32Array(x0),
      _59: x0 => new Uint32Array(x0),
      _61: x0 => new Float32Array(x0),
      _63: x0 => new Float64Array(x0),
      _65: (x0,x1,x2) => x0.call(x1,x2),
      _66: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._66(f,arguments.length,x0,x1) }),
      _67: (x0,x1) => x0.call(x1),
      _69: () => Symbol("jsBoxedDartObjectProperty"),
      _70: (decoder, codeUnits) => decoder.decode(codeUnits),
      _71: () => new TextDecoder("utf-8", {fatal: true}),
      _72: () => new TextDecoder("utf-8", {fatal: false}),
      _73: (s) => +s,
      _74: x0 => new Uint8Array(x0),
      _75: (x0,x1,x2) => x0.set(x1,x2),
      _76: (x0,x1) => x0.transferFromImageBitmap(x1),
      _77: x0 => x0.arrayBuffer(),
      _78: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._78(f,arguments.length,x0) }),
      _79: x0 => new window.FinalizationRegistry(x0),
      _80: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      _81: (x0,x1) => x0.unregister(x1),
      _82: (x0,x1,x2) => x0.slice(x1,x2),
      _83: (x0,x1) => x0.decode(x1),
      _84: (x0,x1) => x0.segment(x1),
      _85: () => new TextDecoder(),
      _87: x0 => x0.click(),
      _88: x0 => x0.buffer,
      _89: x0 => x0.wasmMemory,
      _90: () => globalThis.window._flutter_skwasmInstance,
      _91: x0 => x0.rasterStartMilliseconds,
      _92: x0 => x0.rasterEndMilliseconds,
      _93: x0 => x0.imageBitmaps,
      _120: x0 => x0.remove(),
      _121: (x0,x1) => x0.append(x1),
      _122: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _123: (x0,x1) => x0.querySelector(x1),
      _125: (x0,x1) => x0.removeChild(x1),
      _203: x0 => x0.stopPropagation(),
      _204: x0 => x0.preventDefault(),
      _206: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _251: x0 => x0.unlock(),
      _252: x0 => x0.getReader(),
      _253: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _254: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      _255: (x0,x1) => x0.item(x1),
      _256: x0 => x0.next(),
      _257: x0 => x0.now(),
      _258: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._258(f,arguments.length,x0) }),
      _259: (x0,x1) => x0.addListener(x1),
      _260: (x0,x1) => x0.removeListener(x1),
      _261: (x0,x1) => x0.matchMedia(x1),
      _262: (x0,x1) => x0.revokeObjectURL(x1),
      _263: x0 => x0.close(),
      _264: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      _265: x0 => new window.ImageDecoder(x0),
      _266: x0 => ({frameIndex: x0}),
      _267: (x0,x1) => x0.decode(x1),
      _268: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._268(f,arguments.length,x0) }),
      _269: (x0,x1) => x0.getModifierState(x1),
      _270: (x0,x1) => x0.removeProperty(x1),
      _271: (x0,x1) => x0.prepend(x1),
      _272: x0 => x0.disconnect(),
      _273: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._273(f,arguments.length,x0) }),
      _274: (x0,x1) => x0.getAttribute(x1),
      _275: (x0,x1) => x0.contains(x1),
      _276: x0 => x0.blur(),
      _277: x0 => x0.hasFocus(),
      _278: (x0,x1) => x0.hasAttribute(x1),
      _279: (x0,x1) => x0.getModifierState(x1),
      _280: (x0,x1) => x0.appendChild(x1),
      _281: (x0,x1) => x0.createTextNode(x1),
      _282: (x0,x1) => x0.removeAttribute(x1),
      _283: x0 => x0.getBoundingClientRect(),
      _284: (x0,x1) => x0.observe(x1),
      _285: x0 => x0.disconnect(),
      _286: (x0,x1) => x0.closest(x1),
      _696: () => globalThis.window.flutterConfiguration,
      _697: x0 => x0.assetBase,
      _703: x0 => x0.debugShowSemanticsNodes,
      _704: x0 => x0.hostElement,
      _705: x0 => x0.multiViewEnabled,
      _706: x0 => x0.nonce,
      _708: x0 => x0.fontFallbackBaseUrl,
      _712: x0 => x0.console,
      _713: x0 => x0.devicePixelRatio,
      _714: x0 => x0.document,
      _715: x0 => x0.history,
      _716: x0 => x0.innerHeight,
      _717: x0 => x0.innerWidth,
      _718: x0 => x0.location,
      _719: x0 => x0.navigator,
      _720: x0 => x0.visualViewport,
      _721: x0 => x0.performance,
      _723: x0 => x0.URL,
      _725: (x0,x1) => x0.getComputedStyle(x1),
      _726: x0 => x0.screen,
      _727: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._727(f,arguments.length,x0) }),
      _728: (x0,x1) => x0.requestAnimationFrame(x1),
      _733: (x0,x1) => x0.warn(x1),
      _735: (x0,x1) => x0.debug(x1),
      _736: x0 => globalThis.parseFloat(x0),
      _737: () => globalThis.window,
      _738: () => globalThis.Intl,
      _739: () => globalThis.Symbol,
      _740: (x0,x1,x2,x3,x4) => globalThis.createImageBitmap(x0,x1,x2,x3,x4),
      _742: x0 => x0.clipboard,
      _743: x0 => x0.maxTouchPoints,
      _744: x0 => x0.vendor,
      _745: x0 => x0.language,
      _746: x0 => x0.platform,
      _747: x0 => x0.userAgent,
      _748: (x0,x1) => x0.vibrate(x1),
      _749: x0 => x0.languages,
      _750: x0 => x0.documentElement,
      _751: (x0,x1) => x0.querySelector(x1),
      _754: (x0,x1) => x0.createElement(x1),
      _757: (x0,x1) => x0.createEvent(x1),
      _758: x0 => x0.activeElement,
      _761: x0 => x0.head,
      _762: x0 => x0.body,
      _764: (x0,x1) => { x0.title = x1 },
      _767: x0 => x0.visibilityState,
      _768: () => globalThis.document,
      _769: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._769(f,arguments.length,x0) }),
      _770: (x0,x1) => x0.dispatchEvent(x1),
      _778: x0 => x0.target,
      _780: x0 => x0.timeStamp,
      _781: x0 => x0.type,
      _783: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      _789: x0 => x0.baseURI,
      _790: x0 => x0.firstChild,
      _794: x0 => x0.parentElement,
      _796: (x0,x1) => { x0.textContent = x1 },
      _797: x0 => x0.parentNode,
      _799: x0 => x0.isConnected,
      _803: x0 => x0.firstElementChild,
      _805: x0 => x0.nextElementSibling,
      _806: x0 => x0.clientHeight,
      _807: x0 => x0.clientWidth,
      _808: x0 => x0.offsetHeight,
      _809: x0 => x0.offsetWidth,
      _810: x0 => x0.id,
      _811: (x0,x1) => { x0.id = x1 },
      _814: (x0,x1) => { x0.spellcheck = x1 },
      _815: x0 => x0.tagName,
      _816: x0 => x0.style,
      _818: (x0,x1) => x0.querySelectorAll(x1),
      _819: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _820: x0 => x0.tabIndex,
      _821: (x0,x1) => { x0.tabIndex = x1 },
      _822: (x0,x1) => x0.focus(x1),
      _823: x0 => x0.scrollTop,
      _824: (x0,x1) => { x0.scrollTop = x1 },
      _825: x0 => x0.scrollLeft,
      _826: (x0,x1) => { x0.scrollLeft = x1 },
      _827: x0 => x0.classList,
      _829: (x0,x1) => { x0.className = x1 },
      _831: (x0,x1) => x0.getElementsByClassName(x1),
      _832: (x0,x1) => x0.attachShadow(x1),
      _835: x0 => x0.computedStyleMap(),
      _836: (x0,x1) => x0.get(x1),
      _842: (x0,x1) => x0.getPropertyValue(x1),
      _843: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      _844: x0 => x0.offsetLeft,
      _845: x0 => x0.offsetTop,
      _846: x0 => x0.offsetParent,
      _848: (x0,x1) => { x0.name = x1 },
      _849: x0 => x0.content,
      _850: (x0,x1) => { x0.content = x1 },
      _854: (x0,x1) => { x0.src = x1 },
      _855: x0 => x0.naturalWidth,
      _856: x0 => x0.naturalHeight,
      _860: (x0,x1) => { x0.crossOrigin = x1 },
      _862: (x0,x1) => { x0.decoding = x1 },
      _863: x0 => x0.decode(),
      _868: (x0,x1) => { x0.nonce = x1 },
      _873: (x0,x1) => { x0.width = x1 },
      _875: (x0,x1) => { x0.height = x1 },
      _878: (x0,x1) => x0.getContext(x1),
      _937: x0 => x0.width,
      _938: x0 => x0.height,
      _940: (x0,x1) => x0.fetch(x1),
      _941: x0 => x0.status,
      _943: x0 => x0.body,
      _944: x0 => x0.arrayBuffer(),
      _947: x0 => x0.read(),
      _948: x0 => x0.value,
      _949: x0 => x0.done,
      _951: x0 => x0.name,
      _952: x0 => x0.x,
      _953: x0 => x0.y,
      _956: x0 => x0.top,
      _957: x0 => x0.right,
      _958: x0 => x0.bottom,
      _959: x0 => x0.left,
      _971: x0 => x0.height,
      _972: x0 => x0.width,
      _973: x0 => x0.scale,
      _974: (x0,x1) => { x0.value = x1 },
      _977: (x0,x1) => { x0.placeholder = x1 },
      _979: (x0,x1) => { x0.name = x1 },
      _980: x0 => x0.selectionDirection,
      _981: x0 => x0.selectionStart,
      _982: x0 => x0.selectionEnd,
      _985: x0 => x0.value,
      _987: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _988: x0 => x0.readText(),
      _989: (x0,x1) => x0.writeText(x1),
      _991: x0 => x0.altKey,
      _992: x0 => x0.code,
      _993: x0 => x0.ctrlKey,
      _994: x0 => x0.key,
      _995: x0 => x0.keyCode,
      _996: x0 => x0.location,
      _997: x0 => x0.metaKey,
      _998: x0 => x0.repeat,
      _999: x0 => x0.shiftKey,
      _1000: x0 => x0.isComposing,
      _1002: x0 => x0.state,
      _1003: (x0,x1) => x0.go(x1),
      _1005: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      _1006: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      _1007: x0 => x0.pathname,
      _1008: x0 => x0.search,
      _1009: x0 => x0.hash,
      _1013: x0 => x0.state,
      _1016: (x0,x1) => x0.createObjectURL(x1),
      _1018: x0 => new Blob(x0),
      _1020: x0 => new MutationObserver(x0),
      _1021: (x0,x1,x2) => x0.observe(x1,x2),
      _1022: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1022(f,arguments.length,x0,x1) }),
      _1025: x0 => x0.attributeName,
      _1026: x0 => x0.type,
      _1027: x0 => x0.matches,
      _1028: x0 => x0.matches,
      _1032: x0 => x0.relatedTarget,
      _1034: x0 => x0.clientX,
      _1035: x0 => x0.clientY,
      _1036: x0 => x0.offsetX,
      _1037: x0 => x0.offsetY,
      _1040: x0 => x0.button,
      _1041: x0 => x0.buttons,
      _1042: x0 => x0.ctrlKey,
      _1046: x0 => x0.pointerId,
      _1047: x0 => x0.pointerType,
      _1048: x0 => x0.pressure,
      _1049: x0 => x0.tiltX,
      _1050: x0 => x0.tiltY,
      _1051: x0 => x0.getCoalescedEvents(),
      _1054: x0 => x0.deltaX,
      _1055: x0 => x0.deltaY,
      _1056: x0 => x0.wheelDeltaX,
      _1057: x0 => x0.wheelDeltaY,
      _1058: x0 => x0.deltaMode,
      _1065: x0 => x0.changedTouches,
      _1068: x0 => x0.clientX,
      _1069: x0 => x0.clientY,
      _1072: x0 => x0.data,
      _1075: (x0,x1) => { x0.disabled = x1 },
      _1077: (x0,x1) => { x0.type = x1 },
      _1078: (x0,x1) => { x0.max = x1 },
      _1079: (x0,x1) => { x0.min = x1 },
      _1080: x0 => x0.value,
      _1081: (x0,x1) => { x0.value = x1 },
      _1082: x0 => x0.disabled,
      _1083: (x0,x1) => { x0.disabled = x1 },
      _1085: (x0,x1) => { x0.placeholder = x1 },
      _1087: (x0,x1) => { x0.name = x1 },
      _1089: (x0,x1) => { x0.autocomplete = x1 },
      _1090: x0 => x0.selectionDirection,
      _1092: x0 => x0.selectionStart,
      _1093: x0 => x0.selectionEnd,
      _1096: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _1097: (x0,x1) => x0.add(x1),
      _1100: (x0,x1) => { x0.noValidate = x1 },
      _1101: (x0,x1) => { x0.method = x1 },
      _1102: (x0,x1) => { x0.action = x1 },
      _1103: (x0,x1) => new OffscreenCanvas(x0,x1),
      _1109: (x0,x1) => x0.getContext(x1),
      _1111: x0 => x0.convertToBlob(),
      _1128: x0 => x0.orientation,
      _1129: x0 => x0.width,
      _1130: x0 => x0.height,
      _1131: (x0,x1) => x0.lock(x1),
      _1150: x0 => new ResizeObserver(x0),
      _1153: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1153(f,arguments.length,x0,x1) }),
      _1161: x0 => x0.length,
      _1162: x0 => x0.iterator,
      _1163: x0 => x0.Segmenter,
      _1164: x0 => x0.v8BreakIterator,
      _1165: (x0,x1) => new Intl.Segmenter(x0,x1),
      _1166: x0 => x0.done,
      _1167: x0 => x0.value,
      _1168: x0 => x0.index,
      _1172: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      _1173: (x0,x1) => x0.adoptText(x1),
      _1174: x0 => x0.first(),
      _1175: x0 => x0.next(),
      _1176: x0 => x0.current(),
      _1182: x0 => x0.hostElement,
      _1183: x0 => x0.viewConstraints,
      _1186: x0 => x0.maxHeight,
      _1187: x0 => x0.maxWidth,
      _1188: x0 => x0.minHeight,
      _1189: x0 => x0.minWidth,
      _1190: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1190(f,arguments.length,x0) }),
      _1191: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1191(f,arguments.length,x0) }),
      _1192: (x0,x1) => ({addView: x0,removeView: x1}),
      _1193: x0 => x0.loader,
      _1194: () => globalThis._flutter,
      _1195: (x0,x1) => x0.didCreateEngineInitializer(x1),
      _1196: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1196(f,arguments.length,x0) }),
      _1197: f => finalizeWrapper(f, function() { return dartInstance.exports._1197(f,arguments.length) }),
      _1198: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      _1199: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1199(f,arguments.length,x0) }),
      _1200: x0 => ({runApp: x0}),
      _1201: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1201(f,arguments.length,x0,x1) }),
      _1202: x0 => x0.length,
      _1203: () => globalThis.window.ImageDecoder,
      _1204: x0 => x0.tracks,
      _1206: x0 => x0.completed,
      _1208: x0 => x0.image,
      _1214: x0 => x0.displayWidth,
      _1215: x0 => x0.displayHeight,
      _1216: x0 => x0.duration,
      _1219: x0 => x0.ready,
      _1220: x0 => x0.selectedTrack,
      _1221: x0 => x0.repetitionCount,
      _1222: x0 => x0.frameCount,
      _1265: x0 => x0.createRange(),
      _1266: (x0,x1) => x0.selectNode(x1),
      _1267: x0 => x0.getSelection(),
      _1268: x0 => x0.removeAllRanges(),
      _1269: (x0,x1) => x0.addRange(x1),
      _1270: (x0,x1) => x0.createElement(x1),
      _1271: (x0,x1) => x0.append(x1),
      _1272: (x0,x1,x2) => x0.insertRule(x1,x2),
      _1273: (x0,x1) => x0.add(x1),
      _1274: x0 => x0.preventDefault(),
      _1275: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1275(f,arguments.length,x0) }),
      _1276: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _1277: x0 => x0.remove(),
      _1278: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1278(f,arguments.length,x0) }),
      _1279: x0 => ({createScriptURL: x0}),
      _1280: (x0,x1,x2) => x0.createPolicy(x1,x2),
      _1281: (x0,x1,x2) => x0.createScriptURL(x1,x2),
      _1282: x0 => x0.hasChildNodes(),
      _1283: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _1284: (x0,x1) => x0.append(x1),
      _1285: (x0,x1) => x0.querySelectorAll(x1),
      _1286: (x0,x1) => x0.item(x1),
      _1287: () => globalThis.window.navigator.userAgent,
      _1288: f => finalizeWrapper(f, function(x0,x1,x2) { return dartInstance.exports._1288(f,arguments.length,x0,x1,x2) }),
      _1290: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _1291: (x0,x1) => x0.removeAttribute(x1),
      _1293: (x0,x1) => x0.getResponseHeader(x1),
      _1316: (x0,x1) => x0.item(x1),
      _1319: (x0,x1) => { x0.csp = x1 },
      _1320: x0 => x0.csp,
      _1321: (x0,x1) => x0.getCookieExpirationDate(x1),
      _1322: x0 => globalThis.Sentry.init(x0),
      _1323: () => new Sentry.getClient(),
      _1324: x0 => x0.getOptions(),
      _1325: () => new Sentry.getIsolationScope(),
      _1326: x0 => x0.getSession(),
      _1327: (x0,x1) => x0.setSession(x1),
      _1328: () => globalThis.Sentry.globalHandlersIntegration(),
      _1329: () => globalThis.Sentry.dedupeIntegration(),
      _1330: () => globalThis.Sentry.close(),
      _1331: (x0,x1) => x0.sendEnvelope(x1),
      _1332: x0 => globalThis.Sentry.startSession(x0),
      _1333: () => globalThis.Sentry.captureSession(),
      _1334: () => globalThis.globalThis,
      _1335: x0 => globalThis.URL.revokeObjectURL(x0),
      _1337: x0 => globalThis.URL.createObjectURL(x0),
      _1343: (x0,x1) => x0.querySelector(x1),
      _1344: (x0,x1) => x0.createElement(x1),
      _1346: x0 => x0.click(),
      _1347: x0 => x0.load(),
      _1348: x0 => x0.play(),
      _1349: x0 => x0.pause(),
      _1350: x0 => x0.preventDefault(),
      _1352: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _1353: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      _1354: (x0,x1) => x0.start(x1),
      _1355: (x0,x1) => x0.end(x1),
      _1356: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _1357: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
      _1358: (x0,x1) => x0.getAttribute(x1),
      _1359: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1359(f,arguments.length,x0) }),
      _1360: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1360(f,arguments.length,x0) }),
      _1361: (x0,x1) => x0.closest(x1),
      _1362: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      _1364: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1364(f,arguments.length,x0) }),
      _1365: f => finalizeWrapper(f, function() { return dartInstance.exports._1365(f,arguments.length) }),
      _1366: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1366(f,arguments.length,x0) }),
      _1367: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1367(f,arguments.length,x0) }),
      _1368: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1368(f,arguments.length,x0,x1) }),
      _1369: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1369(f,arguments.length,x0,x1) }),
      _1370: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1370(f,arguments.length,x0,x1) }),
      _1371: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1371(f,arguments.length,x0,x1) }),
      _1372: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1372(f,arguments.length,x0,x1) }),
      _1373: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1373(f,arguments.length,x0,x1) }),
      _1374: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1374(f,arguments.length,x0,x1) }),
      _1375: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1375(f,arguments.length,x0) }),
      _1376: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11) => globalThis.flutter_dropzone_web.create(x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11),
      _1377: (x0,x1) => globalThis.flutter_dropzone_web.setMIME(x0,x1),
      _1378: (x0,x1) => globalThis.flutter_dropzone_web.setOperation(x0,x1),
      _1379: (x0,x1) => globalThis.flutter_dropzone_web.setCursor(x0,x1),
      _1380: (x0,x1) => x0.item(x1),
      _1383: x0 => x0.arrayBuffer(),
      _1385: x0 => x0.decode(),
      _1386: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      _1387: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      _1388: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1388(f,arguments.length,x0) }),
      _1389: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1389(f,arguments.length,x0) }),
      _1390: x0 => x0.send(),
      _1391: () => new XMLHttpRequest(),
      _1392: (x0,x1) => x0.getItem(x1),
      _1393: (x0,x1) => x0.removeItem(x1),
      _1394: (x0,x1,x2) => x0.setItem(x1,x2),
      _1409: x0 => ({type: x0}),
      _1410: (x0,x1) => new Blob(x0,x1),
      _1411: () => new FileReader(),
      _1413: (x0,x1) => x0.readAsArrayBuffer(x1),
      _1414: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1414(f,arguments.length,x0) }),
      _1415: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1415(f,arguments.length,x0) }),
      _1416: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1416(f,arguments.length,x0) }),
      _1417: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1417(f,arguments.length,x0) }),
      _1418: (x0,x1) => x0.removeChild(x1),
      _1419: x0 => new Blob(x0),
      _1421: x0 => x0.read(),
      _1422: (x0,x1) => x0.getType(x1),
      _1423: x0 => x0.text(),
      _1426: (x0,x1) => x0.key(x1),
      _1427: (x0,x1,x2,x3,x4,x5,x6,x7) => x0.unwrapKey(x1,x2,x3,x4,x5,x6,x7),
      _1428: (x0,x1,x2,x3,x4,x5) => x0.importKey(x1,x2,x3,x4,x5),
      _1429: (x0,x1,x2,x3) => x0.generateKey(x1,x2,x3),
      _1430: (x0,x1,x2,x3,x4) => x0.wrapKey(x1,x2,x3,x4),
      _1431: (x0,x1,x2) => x0.exportKey(x1,x2),
      _1432: (x0,x1) => x0.getRandomValues(x1),
      _1433: (x0,x1,x2,x3) => x0.encrypt(x1,x2,x3),
      _1434: (x0,x1,x2,x3) => x0.decrypt(x1,x2,x3),
      _1435: () => globalThis.removeSplashFromWeb(),
      _1436: () => globalThis.catalyst_cardano.getWallets(),
      _1437: Date.now,
      _1438: secondsSinceEpoch => {
        const date = new Date(secondsSinceEpoch * 1000);
        const match = /\((.*)\)/.exec(date.toString());
        if (match == null) {
            // This should never happen on any recent browser.
            return '';
        }
        return match[1];
      },
      _1439: s => new Date(s * 1000).getTimezoneOffset() * 60,
      _1440: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      _1441: () => {
        let stackString = new Error().stack.toString();
        let frames = stackString.split('\n');
        let drop = 2;
        if (frames[0] === 'Error') {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      _1442: () => typeof dartUseDateNowForTicks !== "undefined",
      _1443: () => 1000 * performance.now(),
      _1444: () => Date.now(),
      _1445: () => {
        // On browsers return `globalThis.location.href`
        if (globalThis.location != null) {
          return globalThis.location.href;
        }
        return null;
      },
      _1446: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
      _1447: () => new WeakMap(),
      _1448: (map, o) => map.get(o),
      _1449: (map, o, v) => map.set(o, v),
      _1450: x0 => new WeakRef(x0),
      _1451: x0 => x0.deref(),
      _1452: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1452(f,arguments.length,x0) }),
      _1453: x0 => new FinalizationRegistry(x0),
      _1454: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      _1456: (x0,x1) => x0.unregister(x1),
      _1458: () => globalThis.WeakRef,
      _1459: () => globalThis.FinalizationRegistry,
      _1461: x0 => x0.call(),
      _1462: s => JSON.stringify(s),
      _1463: s => printToConsole(s),
      _1464: (o, p, r) => o.replaceAll(p, () => r),
      _1465: (o, p, r) => o.replace(p, () => r),
      _1466: Function.prototype.call.bind(String.prototype.toLowerCase),
      _1467: s => s.toUpperCase(),
      _1468: s => s.trim(),
      _1469: s => s.trimLeft(),
      _1470: s => s.trimRight(),
      _1471: (string, times) => string.repeat(times),
      _1472: Function.prototype.call.bind(String.prototype.indexOf),
      _1473: (s, p, i) => s.lastIndexOf(p, i),
      _1474: (string, token) => string.split(token),
      _1475: Object.is,
      _1476: o => o instanceof Array,
      _1477: (a, i) => a.push(i),
      _1478: (a, i) => a.splice(i, 1)[0],
      _1480: (a, l) => a.length = l,
      _1481: a => a.pop(),
      _1482: (a, i) => a.splice(i, 1),
      _1483: (a, s) => a.join(s),
      _1484: (a, s, e) => a.slice(s, e),
      _1485: (a, s, e) => a.splice(s, e),
      _1486: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
      _1487: a => a.length,
      _1488: (a, l) => a.length = l,
      _1489: (a, i) => a[i],
      _1490: (a, i, v) => a[i] = v,
      _1492: o => {
        if (o instanceof ArrayBuffer) return 0;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 1;
        }
        return 2;
      },
      _1493: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      _1494: o => o instanceof DataView,
      _1495: o => o instanceof Uint8Array,
      _1496: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      _1497: o => o instanceof Int8Array,
      _1498: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      _1499: o => o instanceof Uint8ClampedArray,
      _1500: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      _1501: o => o instanceof Uint16Array,
      _1502: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      _1503: o => o instanceof Int16Array,
      _1504: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      _1505: o => o instanceof Uint32Array,
      _1506: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      _1507: o => o instanceof Int32Array,
      _1508: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      _1510: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      _1511: o => o instanceof Float32Array,
      _1512: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      _1513: o => o instanceof Float64Array,
      _1514: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      _1515: (t, s) => t.set(s),
      _1516: l => new DataView(new ArrayBuffer(l)),
      _1517: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      _1518: o => o.byteLength,
      _1519: o => o.buffer,
      _1520: o => o.byteOffset,
      _1521: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      _1522: (b, o) => new DataView(b, o),
      _1523: (b, o, l) => new DataView(b, o, l),
      _1524: Function.prototype.call.bind(DataView.prototype.getUint8),
      _1525: Function.prototype.call.bind(DataView.prototype.setUint8),
      _1526: Function.prototype.call.bind(DataView.prototype.getInt8),
      _1527: Function.prototype.call.bind(DataView.prototype.setInt8),
      _1528: Function.prototype.call.bind(DataView.prototype.getUint16),
      _1529: Function.prototype.call.bind(DataView.prototype.setUint16),
      _1530: Function.prototype.call.bind(DataView.prototype.getInt16),
      _1531: Function.prototype.call.bind(DataView.prototype.setInt16),
      _1532: Function.prototype.call.bind(DataView.prototype.getUint32),
      _1533: Function.prototype.call.bind(DataView.prototype.setUint32),
      _1534: Function.prototype.call.bind(DataView.prototype.getInt32),
      _1535: Function.prototype.call.bind(DataView.prototype.setInt32),
      _1538: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      _1539: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      _1540: Function.prototype.call.bind(DataView.prototype.getFloat32),
      _1541: Function.prototype.call.bind(DataView.prototype.setFloat32),
      _1542: Function.prototype.call.bind(DataView.prototype.getFloat64),
      _1543: Function.prototype.call.bind(DataView.prototype.setFloat64),
      _1545: () => globalThis.performance,
      _1546: () => globalThis.JSON,
      _1547: x0 => x0.measure,
      _1548: x0 => x0.mark,
      _1549: x0 => x0.clearMeasures,
      _1550: x0 => x0.clearMarks,
      _1551: (x0,x1,x2,x3) => x0.measure(x1,x2,x3),
      _1552: (x0,x1,x2) => x0.mark(x1,x2),
      _1553: x0 => x0.clearMeasures(),
      _1554: x0 => x0.clearMarks(),
      _1555: (x0,x1) => x0.parse(x1),
      _1556: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      _1557: (handle) => clearTimeout(handle),
      _1558: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      _1559: (handle) => clearInterval(handle),
      _1560: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      _1561: () => Date.now(),
      _1566: o => Object.keys(o),
      _1567: (x0,x1) => x0.postMessage(x1),
      _1569: x0 => new Worker(x0),
      _1571: x0 => x0.getDirectory(),
      _1572: x0 => ({create: x0}),
      _1573: (x0,x1,x2) => x0.getFileHandle(x1,x2),
      _1574: x0 => x0.createSyncAccessHandle(),
      _1575: x0 => x0.close(),
      _1578: x0 => x0.close(),
      _1581: (x0,x1,x2) => x0.open(x1,x2),
      _1587: x0 => x0.start(),
      _1588: x0 => x0.close(),
      _1589: x0 => x0.terminate(),
      _1590: (x0,x1) => new SharedWorker(x0,x1),
      _1591: (x0,x1,x2) => x0.postMessage(x1,x2),
      _1592: (x0,x1,x2) => x0.postMessage(x1,x2),
      _1593: () => new MessageChannel(),
      _1598: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1598(f,arguments.length,x0) }),
      _1599: x0 => x0.continue(),
      _1600: () => globalThis.indexedDB,
      _1602: x0 => x0.sqlite3_initialize,
      _1604: (x0,x1,x2,x3,x4) => x0.sqlite3_open_v2(x1,x2,x3,x4),
      _1605: (x0,x1) => x0.sqlite3_close_v2(x1),
      _1606: (x0,x1,x2) => x0.sqlite3_extended_result_codes(x1,x2),
      _1607: (x0,x1) => x0.sqlite3_extended_errcode(x1),
      _1608: (x0,x1) => x0.sqlite3_errmsg(x1),
      _1609: (x0,x1) => x0.sqlite3_errstr(x1),
      _1610: x0 => x0.sqlite3_error_offset,
      _1614: (x0,x1) => x0.sqlite3_last_insert_rowid(x1),
      _1615: (x0,x1) => x0.sqlite3_changes(x1),
      _1616: (x0,x1,x2,x3,x4,x5) => x0.sqlite3_exec(x1,x2,x3,x4,x5),
      _1619: (x0,x1,x2,x3,x4,x5,x6) => x0.sqlite3_prepare_v3(x1,x2,x3,x4,x5,x6),
      _1620: (x0,x1) => x0.sqlite3_finalize(x1),
      _1621: (x0,x1) => x0.sqlite3_step(x1),
      _1622: (x0,x1) => x0.sqlite3_reset(x1),
      _1623: (x0,x1) => x0.sqlite3_stmt_isexplain(x1),
      _1625: (x0,x1) => x0.sqlite3_column_count(x1),
      _1626: (x0,x1) => x0.sqlite3_bind_parameter_count(x1),
      _1628: (x0,x1,x2) => x0.sqlite3_column_name(x1,x2),
      _1629: (x0,x1,x2,x3,x4,x5) => x0.sqlite3_bind_blob64(x1,x2,x3,x4,x5),
      _1630: (x0,x1,x2,x3) => x0.sqlite3_bind_double(x1,x2,x3),
      _1631: (x0,x1,x2,x3) => x0.sqlite3_bind_int64(x1,x2,x3),
      _1632: (x0,x1,x2) => x0.sqlite3_bind_null(x1,x2),
      _1633: (x0,x1,x2,x3,x4,x5) => x0.sqlite3_bind_text(x1,x2,x3,x4,x5),
      _1634: (x0,x1,x2) => x0.sqlite3_column_blob(x1,x2),
      _1635: (x0,x1,x2) => x0.sqlite3_column_double(x1,x2),
      _1636: (x0,x1,x2) => x0.sqlite3_column_int64(x1,x2),
      _1637: (x0,x1,x2) => x0.sqlite3_column_text(x1,x2),
      _1638: (x0,x1,x2) => x0.sqlite3_column_bytes(x1,x2),
      _1639: (x0,x1,x2) => x0.sqlite3_column_type(x1,x2),
      _1640: (x0,x1) => x0.sqlite3_value_blob(x1),
      _1641: (x0,x1) => x0.sqlite3_value_double(x1),
      _1642: (x0,x1) => x0.sqlite3_value_type(x1),
      _1643: (x0,x1) => x0.sqlite3_value_int64(x1),
      _1644: (x0,x1) => x0.sqlite3_value_text(x1),
      _1645: (x0,x1) => x0.sqlite3_value_bytes(x1),
      _1648: (x0,x1) => x0.sqlite3_user_data(x1),
      _1649: (x0,x1,x2,x3,x4) => x0.sqlite3_result_blob64(x1,x2,x3,x4),
      _1650: (x0,x1,x2) => x0.sqlite3_result_double(x1,x2),
      _1651: (x0,x1,x2,x3) => x0.sqlite3_result_error(x1,x2,x3),
      _1652: (x0,x1,x2) => x0.sqlite3_result_int64(x1,x2),
      _1653: (x0,x1) => x0.sqlite3_result_null(x1),
      _1654: (x0,x1,x2,x3,x4) => x0.sqlite3_result_text(x1,x2,x3,x4),
      _1655: x0 => x0.sqlite3_result_subtype,
      _1674: (x0,x1) => x0.dart_sqlite3_malloc(x1),
      _1675: (x0,x1) => x0.dart_sqlite3_free(x1),
      _1676: (x0,x1,x2,x3) => x0.dart_sqlite3_register_vfs(x1,x2,x3),
      _1677: (x0,x1,x2,x3,x4,x5) => x0.dart_sqlite3_create_scalar_function(x1,x2,x3,x4,x5),
      _1680: x0 => x0.dart_sqlite3_updates,
      _1681: x0 => x0.dart_sqlite3_commits,
      _1682: x0 => x0.dart_sqlite3_rollbacks,
      _1686: x0 => ({initial: x0}),
      _1687: x0 => new WebAssembly.Memory(x0),
      _1688: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1688(f,arguments.length,x0) }),
      _1689: f => finalizeWrapper(f, function(x0,x1,x2,x3,x4) { return dartInstance.exports._1689(f,arguments.length,x0,x1,x2,x3,x4) }),
      _1690: f => finalizeWrapper(f, function(x0,x1,x2) { return dartInstance.exports._1690(f,arguments.length,x0,x1,x2) }),
      _1691: f => finalizeWrapper(f, function(x0,x1,x2,x3) { return dartInstance.exports._1691(f,arguments.length,x0,x1,x2,x3) }),
      _1692: f => finalizeWrapper(f, function(x0,x1,x2,x3) { return dartInstance.exports._1692(f,arguments.length,x0,x1,x2,x3) }),
      _1693: f => finalizeWrapper(f, function(x0,x1,x2) { return dartInstance.exports._1693(f,arguments.length,x0,x1,x2) }),
      _1694: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1694(f,arguments.length,x0,x1) }),
      _1695: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1695(f,arguments.length,x0,x1) }),
      _1696: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1696(f,arguments.length,x0) }),
      _1697: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1697(f,arguments.length,x0) }),
      _1698: f => finalizeWrapper(f, function(x0,x1,x2,x3) { return dartInstance.exports._1698(f,arguments.length,x0,x1,x2,x3) }),
      _1699: f => finalizeWrapper(f, function(x0,x1,x2,x3) { return dartInstance.exports._1699(f,arguments.length,x0,x1,x2,x3) }),
      _1700: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1700(f,arguments.length,x0,x1) }),
      _1701: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1701(f,arguments.length,x0,x1) }),
      _1702: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1702(f,arguments.length,x0,x1) }),
      _1703: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1703(f,arguments.length,x0,x1) }),
      _1704: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1704(f,arguments.length,x0,x1) }),
      _1705: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1705(f,arguments.length,x0,x1) }),
      _1706: f => finalizeWrapper(f, function(x0,x1,x2) { return dartInstance.exports._1706(f,arguments.length,x0,x1,x2) }),
      _1707: f => finalizeWrapper(f, function(x0,x1,x2) { return dartInstance.exports._1707(f,arguments.length,x0,x1,x2) }),
      _1708: f => finalizeWrapper(f, function(x0,x1,x2) { return dartInstance.exports._1708(f,arguments.length,x0,x1,x2) }),
      _1709: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1709(f,arguments.length,x0) }),
      _1710: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1710(f,arguments.length,x0) }),
      _1711: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1711(f,arguments.length,x0) }),
      _1712: f => finalizeWrapper(f, function(x0,x1,x2,x3,x4) { return dartInstance.exports._1712(f,arguments.length,x0,x1,x2,x3,x4) }),
      _1713: f => finalizeWrapper(f, function(x0,x1,x2,x3,x4) { return dartInstance.exports._1713(f,arguments.length,x0,x1,x2,x3,x4) }),
      _1714: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1714(f,arguments.length,x0) }),
      _1715: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1715(f,arguments.length,x0) }),
      _1716: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1716(f,arguments.length,x0,x1) }),
      _1717: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1717(f,arguments.length,x0,x1) }),
      _1718: f => finalizeWrapper(f, function(x0,x1,x2) { return dartInstance.exports._1718(f,arguments.length,x0,x1,x2) }),
      _1720: (x0,x1,x2,x3) => x0.call(x1,x2,x3),
      _1725: x0 => new URL(x0),
      _1726: (x0,x1) => new URL(x0,x1),
      _1727: (x0,x1) => globalThis.fetch(x0,x1),
      _1729: (x0,x1) => ({i: x0,p: x1}),
      _1730: (x0,x1) => ({c: x0,r: x1}),
      _1731: x0 => x0.i,
      _1732: x0 => x0.p,
      _1733: x0 => x0.c,
      _1734: x0 => x0.r,
      _1735: x0 => new SharedArrayBuffer(x0),
      _1736: x0 => ({at: x0}),
      _1737: x0 => x0.getSize(),
      _1738: (x0,x1) => x0.truncate(x1),
      _1739: x0 => x0.flush(),
      _1742: x0 => x0.synchronizationBuffer,
      _1743: x0 => x0.communicationBuffer,
      _1744: (x0,x1,x2,x3) => ({clientVersion: x0,root: x1,synchronizationBuffer: x2,communicationBuffer: x3}),
      _1745: (x0,x1) => globalThis.IDBKeyRange.bound(x0,x1),
      _1746: x0 => ({autoIncrement: x0}),
      _1747: (x0,x1,x2) => x0.createObjectStore(x1,x2),
      _1748: x0 => ({unique: x0}),
      _1749: (x0,x1,x2,x3) => x0.createIndex(x1,x2,x3),
      _1750: (x0,x1) => x0.createObjectStore(x1),
      _1751: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1751(f,arguments.length,x0) }),
      _1752: (x0,x1,x2) => x0.transaction(x1,x2),
      _1753: (x0,x1) => x0.objectStore(x1),
      _1755: (x0,x1) => x0.index(x1),
      _1756: x0 => x0.openKeyCursor(),
      _1757: (x0,x1) => x0.getKey(x1),
      _1758: (x0,x1) => ({name: x0,length: x1}),
      _1759: (x0,x1) => x0.put(x1),
      _1760: (x0,x1) => x0.get(x1),
      _1761: (x0,x1) => x0.openCursor(x1),
      _1762: x0 => globalThis.IDBKeyRange.only(x0),
      _1763: (x0,x1,x2) => x0.put(x1,x2),
      _1764: (x0,x1) => x0.update(x1),
      _1765: (x0,x1) => x0.delete(x1),
      _1766: x0 => x0.name,
      _1767: x0 => x0.length,
      _1770: x0 => globalThis.BigInt(x0),
      _1771: x0 => globalThis.Number(x0),
      _1778: () => globalThis.navigator,
      _1779: (x0,x1) => x0.read(x1),
      _1780: (x0,x1,x2) => x0.read(x1,x2),
      _1781: (x0,x1) => x0.write(x1),
      _1782: (x0,x1,x2) => x0.write(x1,x2),
      _1783: x0 => ({create: x0}),
      _1784: (x0,x1,x2) => x0.getDirectoryHandle(x1,x2),
      _1785: x0 => new BroadcastChannel(x0),
      _1786: x0 => globalThis.Array.isArray(x0),
      _1787: (x0,x1) => x0.postMessage(x1),
      _1788: x0 => x0.close(),
      _1789: (x0,x1) => ({kind: x0,table: x1}),
      _1790: x0 => x0.kind,
      _1791: x0 => x0.table,
      _1793: x0 => x0.getBalance(),
      _1794: x0 => x0.getChangeAddress(),
      _1796: x0 => x0.getNetworkId(),
      _1797: x0 => x0.getRewardAddresses(),
      _1801: x0 => x0.getUtxos(),
      _1805: (x0,x1,x2) => x0.signTx(x1,x2),
      _1806: (x0,x1) => x0.submitTx(x1),
      _1811: (x0,x1) => x0.enable(x1),
      _1814: x0 => x0.icon,
      _1815: x0 => x0.name,
      _1828: (x0,x1,x2,x3,x4,x5) => x0.frb_pde_ffi_dispatcher_primary(x1,x2,x3,x4,x5),
      _1829: (x0,x1,x2,x3,x4) => x0.frb_pde_ffi_dispatcher_sync(x1,x2,x3,x4),
      _1831: x0 => x0.frb_get_rust_content_hash(),
      _1835: (x0,x1) => x0.rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519Signature(x1),
      _1836: (x0,x1) => x0.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519Signature(x1),
      _1837: (x0,x1) => x0.rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519XPrivateKey(x1),
      _1838: (x0,x1) => x0.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519XPrivateKey(x1),
      _1839: (x0,x1) => x0.rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519XPublicKey(x1),
      _1840: (x0,x1) => x0.rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBip32Ed25519XPublicKey(x1),
      _1841: () => globalThis.key_derivation_wasm_bindgen,
      _1842: x0 => x0.deviceMemory,
      _1844: (x0,x1,x2,x3) => ({name: x0,iv: x1,additionalData: x2,tagLength: x3}),
      _1861: (x0,x1) => x0.call(x1),
      _1862: (x0,x1) => x0.warn(x1),
      _1863: () => new AbortController(),
      _1864: x0 => x0.abort(),
      _1865: (x0,x1,x2,x3,x4,x5) => ({method: x0,headers: x1,body: x2,credentials: x3,redirect: x4,signal: x5}),
      _1866: (x0,x1) => globalThis.fetch(x0,x1),
      _1867: (x0,x1) => x0.get(x1),
      _1868: f => finalizeWrapper(f, function(x0,x1,x2) { return dartInstance.exports._1868(f,arguments.length,x0,x1,x2) }),
      _1869: (x0,x1) => x0.forEach(x1),
      _1870: x0 => x0.getReader(),
      _1871: x0 => x0.read(),
      _1872: x0 => x0.cancel(),
      _1873: () => new XMLHttpRequest(),
      _1874: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      _1875: x0 => x0.send(),
      _1879: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      _1880: (x0,x1) => x0.send(x1),
      _1882: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1882(f,arguments.length,x0) }),
      _1883: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1883(f,arguments.length,x0) }),
      _1888: x0 => x0.exports,
      _1889: (x0,x1) => globalThis.WebAssembly.instantiateStreaming(x0,x1),
      _1890: x0 => x0.instance,
      _1892: x0 => x0.buffer,
      _1895: (x0,x1) => x0.matchMedia(x1),
      _1897: () => globalThis.crypto.subtle,
      _1898: (x0,x1,x2) => globalThis.crypto.subtle.decrypt(x0,x1,x2),
      _1902: (x0,x1,x2) => globalThis.crypto.subtle.encrypt(x0,x1,x2),
      _1905: (x0,x1,x2,x3,x4) => globalThis.crypto.subtle.importKey(x0,x1,x2,x3,x4),
      _1943: () => globalThis.window.flutter_inappwebview,
      _1947: (x0,x1) => { x0.nativeCommunication = x1 },
      _1957: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      _1958: (x0,x1) => x0.exec(x1),
      _1959: (x0,x1) => x0.test(x1),
      _1960: x0 => x0.pop(),
      _1962: o => o === undefined,
      _1964: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      _1966: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      _1967: o => o instanceof RegExp,
      _1968: (l, r) => l === r,
      _1969: o => o,
      _1970: o => o,
      _1971: o => o,
      _1972: b => !!b,
      _1973: o => o.length,
      _1975: (o, i) => o[i],
      _1976: f => f.dartFunction,
      _1977: () => ({}),
      _1978: () => [],
      _1980: () => globalThis,
      _1981: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      _1982: (o, p) => p in o,
      _1983: (o, p) => o[p],
      _1984: (o, p, v) => o[p] = v,
      _1985: (o, m, a) => o[m].apply(o, a),
      _1987: o => String(o),
      _1988: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      _1989: o => {
        if (o === undefined) return 1;
        var type = typeof o;
        if (type === 'boolean') return 2;
        if (type === 'number') return 3;
        if (type === 'string') return 4;
        if (o instanceof Array) return 5;
        if (ArrayBuffer.isView(o)) {
          if (o instanceof Int8Array) return 6;
          if (o instanceof Uint8Array) return 7;
          if (o instanceof Uint8ClampedArray) return 8;
          if (o instanceof Int16Array) return 9;
          if (o instanceof Uint16Array) return 10;
          if (o instanceof Int32Array) return 11;
          if (o instanceof Uint32Array) return 12;
          if (o instanceof Float32Array) return 13;
          if (o instanceof Float64Array) return 14;
          if (o instanceof DataView) return 15;
        }
        if (o instanceof ArrayBuffer) return 16;
        // Feature check for `SharedArrayBuffer` before doing a type-check.
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
            return 17;
        }
        return 18;
      },
      _1990: o => [o],
      _1991: (o0, o1) => [o0, o1],
      _1992: (o0, o1, o2) => [o0, o1, o2],
      _1993: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      _1994: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _1995: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _1996: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI16ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _1997: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI16ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _1998: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _1999: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2000: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2001: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2002: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2003: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2004: x0 => new ArrayBuffer(x0),
      _2005: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      _2006: x0 => x0.input,
      _2007: x0 => x0.index,
      _2008: x0 => x0.groups,
      _2009: x0 => x0.flags,
      _2010: x0 => x0.multiline,
      _2011: x0 => x0.ignoreCase,
      _2012: x0 => x0.unicode,
      _2013: x0 => x0.dotAll,
      _2014: (x0,x1) => { x0.lastIndex = x1 },
      _2015: (o, p) => p in o,
      _2016: (o, p) => o[p],
      _2017: (o, p, v) => o[p] = v,
      _2019: (x0,x1,x2) => globalThis.Atomics.wait(x0,x1,x2),
      _2021: (x0,x1,x2) => globalThis.Atomics.notify(x0,x1,x2),
      _2022: (x0,x1,x2) => globalThis.Atomics.store(x0,x1,x2),
      _2023: (x0,x1) => globalThis.Atomics.load(x0,x1),
      _2024: () => globalThis.Int32Array,
      _2026: () => globalThis.Uint8Array,
      _2028: () => globalThis.DataView,
      _2030: x0 => x0.byteLength,
      _2031: x0 => x0.random(),
      _2032: (x0,x1) => x0.getRandomValues(x1),
      _2033: () => globalThis.crypto,
      _2034: () => globalThis.Math,
      _2035: Function.prototype.call.bind(Number.prototype.toString),
      _2036: Function.prototype.call.bind(BigInt.prototype.toString),
      _2037: Function.prototype.call.bind(Number.prototype.toString),
      _2038: (d, digits) => d.toFixed(digits),
      _2042: x0 => new Function(x0),
      _2043: x0 => x0.call(),
      _2044: () => globalThis.crossOriginIsolated,
      _2046: () => globalThis.document,
      _2047: () => globalThis.window,
      _2052: (x0,x1) => { x0.height = x1 },
      _2054: (x0,x1) => { x0.width = x1 },
      _2057: x0 => x0.head,
      _2058: x0 => x0.classList,
      _2062: (x0,x1) => { x0.innerText = x1 },
      _2063: x0 => x0.style,
      _2065: x0 => x0.sheet,
      _2066: x0 => x0.src,
      _2067: (x0,x1) => { x0.src = x1 },
      _2068: x0 => x0.naturalWidth,
      _2069: x0 => x0.naturalHeight,
      _2076: x0 => x0.offsetX,
      _2077: x0 => x0.offsetY,
      _2078: x0 => x0.button,
      _2085: x0 => x0.status,
      _2086: (x0,x1) => { x0.responseType = x1 },
      _2088: x0 => x0.response,
      _2133: x0 => x0.status,
      _2136: (x0,x1) => { x0.responseType = x1 },
      _2137: x0 => x0.response,
      _2138: x0 => x0.responseText,
      _2197: (x0,x1) => { x0.draggable = x1 },
      _2203: (x0,x1) => { x0.innerText = x1 },
      _2213: x0 => x0.style,
      _2570: (x0,x1) => { x0.target = x1 },
      _2572: (x0,x1) => { x0.download = x1 },
      _2597: (x0,x1) => { x0.href = x1 },
      _2689: x0 => x0.src,
      _2690: (x0,x1) => { x0.src = x1 },
      _2693: x0 => x0.name,
      _2694: (x0,x1) => { x0.name = x1 },
      _2695: x0 => x0.sandbox,
      _2696: x0 => x0.allow,
      _2697: (x0,x1) => { x0.allow = x1 },
      _2698: x0 => x0.allowFullscreen,
      _2699: (x0,x1) => { x0.allowFullscreen = x1 },
      _2704: x0 => x0.referrerPolicy,
      _2705: (x0,x1) => { x0.referrerPolicy = x1 },
      _2785: x0 => x0.videoWidth,
      _2786: x0 => x0.videoHeight,
      _2790: (x0,x1) => { x0.playsInline = x1 },
      _2816: x0 => x0.error,
      _2818: (x0,x1) => { x0.src = x1 },
      _2827: x0 => x0.buffered,
      _2830: x0 => x0.currentTime,
      _2831: (x0,x1) => { x0.currentTime = x1 },
      _2832: x0 => x0.duration,
      _2837: (x0,x1) => { x0.playbackRate = x1 },
      _2844: (x0,x1) => { x0.autoplay = x1 },
      _2846: (x0,x1) => { x0.loop = x1 },
      _2848: (x0,x1) => { x0.controls = x1 },
      _2850: (x0,x1) => { x0.volume = x1 },
      _2852: (x0,x1) => { x0.muted = x1 },
      _2867: x0 => x0.code,
      _2868: x0 => x0.message,
      _2941: x0 => x0.length,
      _3137: (x0,x1) => { x0.accept = x1 },
      _3151: x0 => x0.files,
      _3177: (x0,x1) => { x0.multiple = x1 },
      _3195: (x0,x1) => { x0.type = x1 },
      _3445: (x0,x1) => { x0.src = x1 },
      _3447: (x0,x1) => { x0.type = x1 },
      _3453: (x0,x1) => { x0.defer = x1 },
      _3455: (x0,x1) => { x0.crossOrigin = x1 },
      _3459: (x0,x1) => { x0.integrity = x1 },
      _3913: () => globalThis.window,
      _3952: x0 => x0.document,
      _3955: x0 => x0.location,
      _3974: x0 => x0.navigator,
      _3978: x0 => x0.screen,
      _3990: x0 => x0.devicePixelRatio,
      _4229: x0 => x0.isSecureContext,
      _4232: x0 => x0.crypto,
      _4236: x0 => x0.trustedTypes,
      _4237: x0 => x0.sessionStorage,
      _4238: x0 => x0.localStorage,
      _4248: x0 => x0.origin,
      _4257: x0 => x0.pathname,
      _4342: x0 => x0.clipboard,
      _4344: x0 => x0.geolocation,
      _4347: x0 => x0.mediaDevices,
      _4349: x0 => x0.permissions,
      _4350: x0 => x0.maxTouchPoints,
      _4360: x0 => x0.platform,
      _4363: x0 => x0.userAgent,
      _4364: x0 => x0.vendor,
      _4369: x0 => x0.onLine,
      _4376: x0 => x0.storage,
      _4414: x0 => x0.data,
      _4444: x0 => x0.port1,
      _4445: x0 => x0.port2,
      _4447: (x0,x1) => { x0.onmessage = x1 },
      _4525: x0 => x0.port,
      _4560: x0 => x0.length,
      _6464: x0 => x0.type,
      _6465: x0 => x0.target,
      _6505: x0 => x0.signal,
      _6514: x0 => x0.length,
      _6557: x0 => x0.baseURI,
      _6563: x0 => x0.firstChild,
      _6574: () => globalThis.document,
      _6655: x0 => x0.body,
      _6657: x0 => x0.head,
      _6984: x0 => x0.tagName,
      _6985: x0 => x0.id,
      _6986: (x0,x1) => { x0.id = x1 },
      _7013: x0 => x0.children,
      _7216: x0 => x0.length,
      _7420: x0 => x0.ctrlKey,
      _7421: x0 => x0.shiftKey,
      _7422: x0 => x0.altKey,
      _7423: x0 => x0.metaKey,
      _8331: x0 => x0.value,
      _8333: x0 => x0.done,
      _8495: x0 => x0.size,
      _8496: x0 => x0.type,
      _8503: x0 => x0.name,
      _8509: x0 => x0.length,
      _8514: x0 => x0.result,
      _9010: x0 => x0.url,
      _9012: x0 => x0.status,
      _9014: x0 => x0.statusText,
      _9015: x0 => x0.headers,
      _9016: x0 => x0.body,
      _9091: x0 => x0.types,
      _9281: x0 => x0.type,
      _9296: x0 => x0.matches,
      _9307: x0 => x0.availWidth,
      _9308: x0 => x0.availHeight,
      _9309: x0 => x0.width,
      _9310: x0 => x0.height,
      _9313: x0 => x0.orientation,
      _10465: x0 => x0.result,
      _10466: x0 => x0.error,
      _10477: (x0,x1) => { x0.onupgradeneeded = x1 },
      _10479: x0 => x0.oldVersion,
      _10558: x0 => x0.key,
      _10559: x0 => x0.primaryKey,
      _10561: x0 => x0.value,
      _11021: (x0,x1) => { x0.alignSelf = x1 },
      _11039: (x0,x1) => { x0.animationDuration = x1 },
      _11045: (x0,x1) => { x0.animationName = x1 },
      _11121: (x0,x1) => { x0.border = x1 },
      _11389: (x0,x1) => { x0.cursor = x1 },
      _11399: (x0,x1) => { x0.display = x1 },
      _11563: (x0,x1) => { x0.height = x1 },
      _11649: (x0,x1) => { x0.margin = x1 },
      _11775: (x0,x1) => { x0.opacity = x1 },
      _11887: (x0,x1) => { x0.pointerEvents = x1 },
      _12253: (x0,x1) => { x0.width = x1 },
      _12621: x0 => x0.name,
      _12622: x0 => x0.message,
      _12625: x0 => x0.subtle,
      _13328: () => globalThis.console,
      _13354: () => globalThis.window.flutterCanvasKit,
      _13355: () => globalThis.window._flutter_skwasmInstance,

    };

    const baseImports = {
      dart2wasm: dart2wasm,
      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
      S: new Proxy({}, { get(_, prop) { return prop; } }),

    };

    const jsStringPolyfill = {
      "charCodeAt": (s, i) => s.charCodeAt(i),
      "compare": (s1, s2) => {
        if (s1 < s2) return -1;
        if (s1 > s2) return 1;
        return 0;
      },
      "concat": (s1, s2) => s1 + s2,
      "equals": (s1, s2) => s1 === s2,
      "fromCharCode": (i) => String.fromCharCode(i),
      "length": (s) => s.length,
      "substring": (s, a, b) => s.substring(a, b),
      "fromCharCodeArray": (a, start, end) => {
        if (end <= start) return '';

        const read = dartInstance.exports.$wasmI16ArrayGet;
        let result = '';
        let index = start;
        const chunkLength = Math.min(end - index, 500);
        let array = new Array(chunkLength);
        while (index < end) {
          const newChunkLength = Math.min(end - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(a, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
      "intoCharCodeArray": (s, a, start) => {
        if (s === '') return 0;

        const write = dartInstance.exports.$wasmI16ArraySet;
        for (var i = 0; i < s.length; ++i) {
          write(a, start++, s.charCodeAt(i));
        }
        return s.length;
      },
      "test": (s) => typeof s == "string",
    };


    

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      
      "wasm:js-string": jsStringPolyfill,
    });

    return new InstantiatedApp(this, dartInstance);
  }
}

class InstantiatedApp {
  constructor(compiledApp, instantiatedModule) {
    this.compiledApp = compiledApp;
    this.instantiatedModule = instantiatedModule;
  }

  // Call the main function with the given arguments.
  invokeMain(...args) {
    this.instantiatedModule.exports.$invokeMain(args);
  }
}
