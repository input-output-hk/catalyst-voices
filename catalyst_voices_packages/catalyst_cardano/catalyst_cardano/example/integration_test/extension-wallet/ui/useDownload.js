const __vite__fileDeps=["ui/useDownload2.js","ui/index.js","ui/NetworkId.js","assets/index.css","ui/index2.js"],__vite__mapDeps=i=>i.map(i=>__vite__fileDeps[i]);
import { a2 as isMobileApp, eJ as __vitePreload } from "./index.js";
const downloadWallet = async (walletData) => {
  if (!walletData) {
    return false;
  }
  let downloadFunc = null;
  if (isMobileApp()) {
    const { _downloadWallet } = await __vitePreload(() => import("./useDownload2.js").then((n) => n.u), true ? __vite__mapDeps([0,1,2,3,4]) : void 0);
    downloadFunc = _downloadWallet;
  } else {
    const { _downloadWallet } = await __vitePreload(() => import("./useDownload3.js"), true ? [] : void 0);
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
    const { _downloadText } = await __vitePreload(() => import("./useDownload2.js").then((n) => n.u), true ? __vite__mapDeps([0,1,2,3,4]) : void 0);
    downloadFunc = _downloadText;
  } else {
    const { _downloadText } = await __vitePreload(() => import("./useDownload3.js"), true ? [] : void 0);
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
