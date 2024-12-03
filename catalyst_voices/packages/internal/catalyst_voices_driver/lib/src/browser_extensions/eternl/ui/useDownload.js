const __vite__mapDeps=(i,m=__vite__mapDeps,d=(m.f||(m.f=["ui/useDownload2.js","ui/index.js","ui/NetworkId.js","assets/index.css","ui/index2.js"])))=>i.map(i=>d[i]);
import { a0 as isMobileApp, eC as __vitePreload } from "./index.js";
const downloadWallet = async (walletData) => {
  if (!walletData) {
    return false;
  }
  let downloadFunc = null;
  if (isMobileApp()) {
    const { _downloadWallet } = await __vitePreload(async () => {
      const { _downloadWallet: _downloadWallet2 } = await import("./useDownload2.js").then((n) => n.u);
      return { _downloadWallet: _downloadWallet2 };
    }, true ? __vite__mapDeps([0,1,2,3,4]) : void 0);
    downloadFunc = _downloadWallet;
  } else {
    const { _downloadWallet } = await __vitePreload(async () => {
      const { _downloadWallet: _downloadWallet2 } = await import("./useDownload3.js");
      return { _downloadWallet: _downloadWallet2 };
    }, true ? [] : void 0);
    downloadFunc = _downloadWallet;
  }
  return downloadFunc(walletData);
};
const downloadText = async (text, fileName) => {
  if (!text) {
    return false;
  }
  let downloadFunc = null;
  if (isMobileApp()) {
    const { _downloadText } = await __vitePreload(async () => {
      const { _downloadText: _downloadText2 } = await import("./useDownload2.js").then((n) => n.u);
      return { _downloadText: _downloadText2 };
    }, true ? __vite__mapDeps([0,1,2,3,4]) : void 0);
    downloadFunc = _downloadText;
  } else {
    const { _downloadText } = await __vitePreload(async () => {
      const { _downloadText: _downloadText2 } = await import("./useDownload3.js");
      return { _downloadText: _downloadText2 };
    }, true ? [] : void 0);
    downloadFunc = _downloadText;
  }
  return downloadFunc(text, fileName);
};
const useDownload = () => {
  return {
    downloadWallet,
    downloadText
  };
};
export {
  useDownload as u
};
