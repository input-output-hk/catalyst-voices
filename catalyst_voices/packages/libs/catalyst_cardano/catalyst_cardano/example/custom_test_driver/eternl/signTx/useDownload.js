const __vite__mapDeps=(i,m=__vite__mapDeps,d=(m.f||(m.f=["signTx/web.js","signTx/index.js","signTx/signTx.js","assets/signTx.css","signTx/web2.js"])))=>i.map(i=>d[i]);
import { _ as __vitePreload } from "./signTx.js";
import { r as registerPlugin } from "./index.js";
var Directory;
(function(Directory2) {
  Directory2["Documents"] = "DOCUMENTS";
  Directory2["Data"] = "DATA";
  Directory2["Library"] = "LIBRARY";
  Directory2["Cache"] = "CACHE";
  Directory2["External"] = "EXTERNAL";
  Directory2["ExternalStorage"] = "EXTERNAL_STORAGE";
})(Directory || (Directory = {}));
var Encoding;
(function(Encoding2) {
  Encoding2["UTF8"] = "utf8";
  Encoding2["ASCII"] = "ascii";
  Encoding2["UTF16"] = "utf16";
})(Encoding || (Encoding = {}));
const Filesystem = registerPlugin("Filesystem", {
  web: () => __vitePreload(() => import("./web.js"), true ? __vite__mapDeps([0,1,2,3]) : void 0).then((m) => new m.FilesystemWeb())
});
const Share = registerPlugin("Share", {
  web: () => __vitePreload(() => import("./web2.js"), true ? __vite__mapDeps([4,1,2,3]) : void 0).then((m) => new m.ShareWeb())
});
const _downloadWallet = async (walletData) => {
  if (!walletData) {
    return false;
  }
  const fileName = "eternl-" + walletData.settings.name.toLowerCase().replace(/\s/g, "-") + "-" + walletData.wallet.id.toLowerCase().replace(/\s/g, "-") + ".json";
  const result = await Filesystem.writeFile({
    path: fileName,
    data: JSON.stringify(walletData),
    directory: Directory.Cache,
    encoding: Encoding.UTF8
  });
  await Share.share({
    dialogTitle: "Download wallet backup",
    title: fileName,
    url: result.uri
  });
  return true;
};
const _downloadText = async (text, fileName) => {
  if (!text) {
    return false;
  }
  const result = await Filesystem.writeFile({
    path: fileName,
    data: text,
    directory: Directory.Cache,
    encoding: Encoding.UTF8
  });
  await Share.share({
    dialogTitle: "Store text file",
    title: fileName,
    url: result.uri
  });
  return true;
};
const useDownload = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  _downloadText,
  _downloadWallet
}, Symbol.toStringTag, { value: "Module" }));
export {
  Encoding as E,
  useDownload as u
};
