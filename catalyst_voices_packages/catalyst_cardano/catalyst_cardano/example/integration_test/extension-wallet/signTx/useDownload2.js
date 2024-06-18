const _downloadWallet = async (walletData) => {
  if (!walletData) {
    return false;
  }
  const fileName = "eternl-" + walletData.settings.name.toLowerCase().replace(/\s/g, "-") + "-" + walletData.wallet.id.toLowerCase().replace(/\s/g, "-") + ".json";
  const blob = new Blob([JSON.stringify(walletData)], { type: "text/json" });
  const link = document.createElement("a");
  link.download = fileName;
  link.href = window.URL.createObjectURL(blob);
  link.target = "_system";
  link.dataset.downloadurl = ["text/json", link.download, link.href].join(":");
  const evt = new MouseEvent("click", {
    view: window,
    bubbles: true,
    cancelable: true
  });
  link.dispatchEvent(evt);
  link.remove();
  return true;
};
const _downloadText = async (text, fileName) => {
  if (!text) {
    return false;
  }
  const blob = new Blob([text], { type: "plain/text" });
  const link = document.createElement("a");
  link.download = fileName;
  link.href = window.URL.createObjectURL(blob);
  link.target = "_system";
  link.dataset.downloadurl = ["plain/text", link.download, link.href].join(":");
  const evt = new MouseEvent("click", {
    view: window,
    bubbles: true,
    cancelable: true
  });
  link.dispatchEvent(evt);
  link.remove();
  return true;
};
export {
  _downloadText,
  _downloadWallet
};
