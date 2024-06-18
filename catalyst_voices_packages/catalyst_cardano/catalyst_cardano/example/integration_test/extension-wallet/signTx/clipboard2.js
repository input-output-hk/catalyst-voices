const _copyToClipboard = async (textToCopy) => {
  try {
    await navigator.clipboard.writeText(textToCopy);
    return true;
  } catch (e) {
    console.error(e);
    throw e;
  }
};
export {
  _copyToClipboard
};
