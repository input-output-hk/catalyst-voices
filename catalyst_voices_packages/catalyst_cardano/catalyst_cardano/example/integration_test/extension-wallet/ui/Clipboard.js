const __vite__fileDeps=["ui/clipboard2.js","ui/index2.js","ui/index.js","ui/NetworkId.js","assets/index.css"],__vite__mapDeps=i=>i.map(i=>__vite__fileDeps[i]);
import { a2 as isMobileApp, eJ as __vitePreload, i_ as Notify_default } from "./index.js";
const copyToClipboard = async (textToCopy, message, showCopiedContent = true) => {
  try {
    let func = null;
    if (isMobileApp()) {
      const { _copyToClipboard } = await __vitePreload(() => import("./clipboard2.js"), true ? __vite__mapDeps([0,1,2,3,4]) : void 0);
      func = _copyToClipboard;
    } else {
      const { _copyToClipboard } = await __vitePreload(() => import("./clipboard3.js"), true ? [] : void 0);
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
