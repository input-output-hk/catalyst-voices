const __vite__mapDeps=(i,m=__vite__mapDeps,d=(m.f||(m.f=["ui/clipboard2.js","ui/index2.js","ui/index.js","ui/NetworkId.js","assets/index.css"])))=>i.map(i=>d[i]);
import { a0 as isMobileApp, eC as __vitePreload, j0 as Notify_default } from "./index.js";
const copyToClipboard = async (textToCopy, message, showCopiedContent = true) => {
  try {
    let func = null;
    if (isMobileApp()) {
      const { _copyToClipboard } = await __vitePreload(async () => {
        const { _copyToClipboard: _copyToClipboard2 } = await import("./clipboard2.js");
        return { _copyToClipboard: _copyToClipboard2 };
      }, true ? __vite__mapDeps([0,1,2,3,4]) : void 0);
      func = _copyToClipboard;
    } else {
      const { _copyToClipboard } = await __vitePreload(async () => {
        const { _copyToClipboard: _copyToClipboard2 } = await import("./clipboard3.js");
        return { _copyToClipboard: _copyToClipboard2 };
      }, true ? [] : void 0);
      func = _copyToClipboard;
    }
    await func(textToCopy);
    notifyCopyToClipboard(textToCopy, message, showCopiedContent);
  } catch (e) {
    console.error(e);
    Notify_default.create({
      type: "negative",
      message: "Could not copy content to clipboard, please try again.",
      position: "top-left",
      timeout: 2e3
    });
    throw e;
  }
};
const notifyCopyToClipboard = (textToCopy, message, showCopiedContent) => {
  const msg = {
    message,
    html: false,
    caption: void 0,
    timeout: 2e3
  };
  if (showCopiedContent) {
    msg.html = true;
    msg.caption = '<span class="break-all">' + textToCopy + "</span>";
  }
  Notify_default.create(msg);
};
export {
  copyToClipboard as c
};
