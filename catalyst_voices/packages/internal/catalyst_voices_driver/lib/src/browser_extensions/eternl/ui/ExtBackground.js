import { $ as isBexApp, jV as fetchAssetMetadata, jW as get721MetadataDetails, jX as get1155Metadata, z as ref, jY as parseMetaSrcFile } from "./index.js";
const layoutContainer = "cc-layout-container";
const layoutIFrameContainer = "cc-background-iframe-container";
const bgIFrameId = "backgroundIFrame";
const opacityContainerIds = ["cc-main-container", "cc-epoch-container", "cc-footer-container"];
const setWalletBackground = async (networkId, bg) => {
  if (bg && bg.policy !== "" && bg.name != "") {
    removeBackground();
    addBackgroundIFrame();
    let backgroundData = await getBackgroundData(networkId, bg);
    if (backgroundData) {
      setBackground(backgroundData);
      setSiteOpacity(bg.opacity ?? 100);
    }
  } else {
    removeBackground();
    setSiteOpacity(100);
  }
};
const setBackground = (data) => {
  if (data.target != null) {
    const iframe = document.getElementById(bgIFrameId);
    if (data.isImage) {
      let image = document.createElement("img");
      image.src = data.target;
      image.setAttribute("style", "display:block; margin: auto; max-width: 100%; max-height: 100%; width: 100%; height: auto; position: absolute; top:0; bottom: 0; left: 0; right: 0; object-fit: contain;");
      let body = document.createElement("body");
      body.classList.add("overflow-hidden");
      body.setAttribute("style", "overflow: hidden; height: 100%;");
      body.appendChild(image);
      if (!iframe.contentDocument) {
        console.log("iframe.contentDocument", iframe.contentDocument);
      }
      iframe.contentDocument.body = body;
    } else if (data.isVideo) {
      let video = document.createElement("video");
      video.setAttribute("style", "display:block; margin: 0 auto; width: 100%");
      video.src = data.target;
      video.autoplay = true;
      video.loop = true;
      video.muted = true;
      let body = document.createElement("body");
      body.classList.add("overflow-hidden");
      body.setAttribute("style", "overflow: hidden; height: 100%");
      body.appendChild(video);
      iframe.contentDocument.body = body;
      video.play();
    } else if (data.isIframe) {
      if (isBexApp()) {
        throw new Error("Not supported in bex mode.");
      }
      iframe.src = data.target;
    }
  }
};
const setSiteOpacity = (opacity) => {
  for (let identifier of opacityContainerIds) {
    const container = document.getElementById(identifier);
    if (container) {
      container.style.opacity = String(opacity / 100);
    }
  }
};
const getBackgroundData = async (networkId, bg) => {
  var _a, _b, _c;
  if (!bg.policy) {
    return null;
  }
  if (bg.name === null) {
    return null;
  }
  const metadata = await fetchAssetMetadata(networkId, bg.policy, bg.name);
  let anymeta = null;
  if (Array.isArray(metadata)) {
    anymeta = get721MetadataDetails(bg.policy, bg.name, metadata);
    if (!anymeta) {
      anymeta = get1155Metadata(metadata);
    }
  } else {
    anymeta = metadata.json;
  }
  if (anymeta) {
    const target = ref("");
    if ((anymeta == null ? void 0 : anymeta.files) || (anymeta == null ? void 0 : anymeta.image) || (anymeta == null ? void 0 : anymeta.asset.ipfs)) {
      let item = null;
      if ((((_a = anymeta == null ? void 0 : anymeta.files) == null ? void 0 : _a.length) ?? 0) > 0) {
        item = anymeta.files[0];
      } else if (anymeta && anymeta.image.length > 0) {
        item = {
          name: anymeta.name ?? "",
          src: Array.isArray(anymeta.image) ? anymeta.image.join("") : anymeta.image,
          mediaType: "image/png"
        };
      } else if (anymeta && (((_b = anymeta.asset.ipfs) == null ? void 0 : _b.length) ?? 0) > 0) {
        item = {
          name: anymeta.asset.artistName ?? "",
          src: anymeta.asset.ipfs,
          mediaType: "image/png"
        };
      } else {
        throw new Error("No files found in metadata.");
      }
      let isIframe = false;
      let isImage = false;
      let isVideo = false;
      let isAudio = false;
      let isPDF = false;
      item.mediaType = item.mediaType ?? null;
      if (item.mediaType === "text/html") {
        if (await parseMetaSrcFile(item, target)) {
          isIframe = true;
        }
      } else if (item.mediaType === "application/pdf") {
        throw new Error("PDF background is not supported.");
      } else if (item.mediaType === "image/png" || item.mediaType === "image/jpg" || item.mediaType === "image/jpeg" || item.mediaType === "image/webp" || item.mediaType === "image/gif") {
        if (await parseMetaSrcFile(item, target)) {
          isImage = true;
        }
      } else if ((_c = item.mediaType) == null ? void 0 : _c.startsWith("video/")) {
        if (await parseMetaSrcFile(item, target)) {
          isVideo = true;
        }
      }
      return {
        isIframe,
        isImage,
        isVideo,
        isAudio,
        isPDF,
        target: target.value
      };
    } else {
      throw new Error("No files found in metadata.");
    }
  }
  return null;
};
const removeBackground = () => {
  const layout = document.getElementById(layoutIFrameContainer);
  if (layout) {
    const bgContainer = document.getElementById(bgIFrameId);
    if (bgContainer) {
      layout.removeChild(bgContainer);
    }
  }
};
const addBackgroundIFrame = () => {
  const iframe = document.getElementById(bgIFrameId);
  if (iframe) {
    return;
  }
  const layout = document.getElementById(layoutContainer);
  if (!layout) {
    return;
  }
  const div = document.getElementById(layoutIFrameContainer);
  if (div) {
    const frame = document.createElement("iframe");
    frame.setAttribute("id", bgIFrameId);
    frame.sandbox.add("allow-forms", "allow-downloads", "allow-scripts", "allow-same-origin");
    frame.classList.add("absolute", "w-full", "h-full", "float-left", "clear-both", "-z-15", "bg-no-repeat");
    frame.setAttribute("style", "overflow:hidden;");
    div.append(frame);
    layout.insertBefore(div, layout.firstChild);
  } else {
    console.log("Error: background iFrame container not found.");
  }
};
export {
  setSiteOpacity as a,
  addBackgroundIFrame as b,
  setBackground as c,
  getBackgroundData as g,
  removeBackground as r,
  setWalletBackground as s
};
