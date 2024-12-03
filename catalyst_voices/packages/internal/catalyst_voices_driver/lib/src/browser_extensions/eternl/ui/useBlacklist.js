import { z as ref, K as networkId, a2 as now, fs as callAPI } from "./index.js";
const _entryList = ref([]);
let _lastUpdate = -1;
let _timeoutId = -1;
const resetList = () => {
  _entryList.value.splice(0);
};
const loadList = async () => {
  clearTimeout(_timeoutId);
  if (!networkId.value) {
    resetList();
  } else if (_lastUpdate + 5 * 60 * 1e3 < now()) {
    callAPI("/v1/misc/blacklist", networkId.value, onLoadList, onErrorList);
  }
  _timeoutId = setTimeout(() => {
    loadList();
  }, 15 * 60 * 1e3);
};
const onLoadList = (data) => {
  var _a, _b;
  if (((_a = data == null ? void 0 : data.data) == null ? void 0 : _a.list) && ((_b = data == null ? void 0 : data.data) == null ? void 0 : _b.list.length) > 0) {
    resetList();
    _entryList.value.push(...data.data.list);
    _lastUpdate = now();
  } else {
    onErrorList();
  }
};
const onErrorList = async () => {
  if (networkId.value) {
    resetList();
  }
};
function useBlacklist() {
  return {
    loadBlacklist: loadList,
    scammerList: _entryList
  };
}
export {
  useBlacklist as u
};
