import { n as networkIdList } from "../ui/NetworkId.js";
const peerConnectionMapKey = "peerConnectMap_";
const activeTabsKey = "activeTabMap_";
const log = (...entries) => {
};
const tabEventMap = /* @__PURE__ */ new Map();
self.addEventListener("install", (event) => {
  self.skipWaiting();
});
self.addEventListener("activate", (event) => {
  event.waitUntil(
    self.clients.claim().then(() => {
      return new Promise(async (resolve) => {
        await recreateAllOwnerMaps();
        resolve();
      });
    })
  );
});
const recreateAllOwnerMaps = async () => {
  for (const n of networkIdList) {
    await createOwnerMap(n);
  }
};
const createTabEventMap = (networkId) => {
  if (!tabEventMap.get(networkId)) {
    tabEventMap.set(networkId, /* @__PURE__ */ new Map());
  }
};
const addToTabEventMap = (networkId, tabUuid, event) => {
  createTabEventMap(networkId);
  const networkEventMap = tabEventMap.get(networkId);
  if (!networkEventMap.get(tabUuid)) {
    networkEventMap.set(tabUuid, event);
  }
};
const deleteFromTabEventMap = (networkId, tabUuid) => {
  const networkEventMap = tabEventMap.get(networkId);
  if (networkEventMap && networkEventMap.get(tabUuid)) {
    networkEventMap.delete(tabUuid);
  }
};
function isOfRequestType(type, obj) {
  return obj.data.type === type;
}
const getOwnershipMap = async (networkId) => {
  const key = peerConnectionMapKey + networkId;
  const ownerMap = await self.caches.match(key);
  if (!ownerMap) {
    return void 0;
  }
  const text = await ownerMap.text();
  return deserializeMap(text);
};
const createOwnerMap = async (network) => {
  const map = /* @__PURE__ */ new Map();
  await saveOwnerMap(network, map);
  return map;
};
const setOwnerForDapp = async (network, uuid, dappId) => {
  let map = await getOwnershipMap(network);
  if (!map) {
    map = await createOwnerMap(network);
  }
  map.set(dappId, uuid);
  await saveOwnerMap(network, map);
};
const saveOwnerMap = async (networkId, map) => {
  const key = peerConnectionMapKey + networkId;
  await self.caches.open(key);
  serializeMap(map);
};
const createTabList = async (network) => {
  const list = [];
  await saveTabList(network, list);
  return list;
};
const saveTabList = async (networkId, map) => {
  const key = activeTabsKey + networkId;
  const cache = await self.caches.open(key);
  await cache.put(key, new Response(JSON.stringify(map)));
};
const getTabList = async (networkId) => {
  const key = activeTabsKey + networkId;
  const tabsList = await self.caches.match(key);
  if (!tabsList) {
    return createTabList(networkId);
  }
  const text = await tabsList.text();
  return JSON.parse(text);
};
const handleOwnerCheckMessageRequest = async (data, event) => {
  const dappId = data.targetId;
  const from = data.fromUuid;
  const ownerMap = await getOwnershipMap(data.networkId);
  if (!ownerMap) {
    sendResponse(
      event,
      createResponse(
        "OWNER_CHECK",
        {
          networkId: data.networkId,
          toUuid: from,
          targetId: dappId,
          workerUUID: null
        }
      )
    );
    await createOwnerMap(data.networkId);
  } else {
    if (ownerMap.size === 0) {
      sendResponse(
        event,
        createResponse("OWNER_CHECK", {
          networkId: data.networkId,
          toUuid: from,
          targetId: dappId,
          workerUUID: null
        })
      );
    } else {
      const owner = ownerMap.get(dappId);
      if (!owner) {
        sendResponse(
          event,
          createResponse("OWNER_CHECK", {
            networkId: data.networkId,
            toUuid: from,
            targetId: dappId,
            workerUUID: null
          })
        );
      } else {
        sendResponse(
          event,
          createResponse("OWNER_CHECK", {
            networkId: data.networkId,
            toUuid: from,
            targetId: dappId,
            workerUUID: owner
          })
        );
      }
    }
  }
};
const handleClaimOwnerMessageRequest = async (data, event) => {
  let ownerMap = await getOwnershipMap(data.networkId);
  if (!ownerMap) {
    await createOwnerMap(data.networkId);
    ownerMap = await getOwnershipMap(data.networkId);
  }
  const currentOwner = ownerMap == null ? void 0 : ownerMap.get(data.targetId);
  if (currentOwner && currentOwner !== data.fromUuid) {
    sendResponse(
      event,
      createResponse(
        "CLAIM_OWNER",
        {
          networkId: data.networkId,
          toUuid: data.fromUuid,
          targetId: data.targetId,
          success: false,
          owner: currentOwner
        }
      )
    );
    return;
  }
  await setOwnerForDapp(data.networkId, data.fromUuid, data.targetId);
  sendResponse(
    event,
    createResponse("CLAIM_OWNER", {
      networkId: data.networkId,
      toUuid: data.fromUuid,
      targetId: data.targetId,
      success: true,
      owner: data.fromUuid
    })
  );
};
const handleRegisterTabMessageRequest = async (data, event) => {
  try {
    let uuid = data.fromUuid;
    await addToTabEventMap(data.networkId, uuid, event);
    const list = await getTabList(data.networkId);
    if (!list.includes(uuid)) {
      list.push(uuid);
      await saveTabList(data.networkId, list);
    }
    sendResponse(
      event,
      createResponse("REGISTER_TAB", {
        networkId: data.networkId,
        toUuid: data.fromUuid,
        targetId: data.fromUuid,
        success: true
      })
    );
  } catch (error) {
    sendResponse(
      event,
      createResponse("REGISTER_TAB", {
        networkId: data.networkId,
        toUuid: data.fromUuid,
        targetId: data.fromUuid,
        success: false
      })
    );
  }
};
const handleReleaseOwnerMessageRequest = async (data, event) => {
  let ownerMap = await getOwnershipMap(data.networkId);
  if (!ownerMap) {
    sendResponse(
      event,
      createResponse("RELEASE_OWNER", {
        networkId: data.networkId,
        toUuid: data.fromUuid,
        targetId: data.targetId,
        success: false,
        error: "No owner map was found."
      })
    );
    return;
  }
  const releasingTab = data.targetId;
  let released = false;
  const releasedDapps = [];
  for (let dappId of ownerMap.keys()) {
    if (ownerMap.get(dappId) === releasingTab) {
      ownerMap.delete(dappId);
      released = true;
      releasedDapps.push(dappId);
    }
  }
  if (released) {
    await saveOwnerMap(data.networkId, ownerMap);
    sendResponse(
      event,
      createResponse("RELEASE_OWNER", {
        networkId: data.networkId,
        toUuid: data.fromUuid,
        targetId: data.targetId,
        success: true
      })
    );
  } else {
    sendResponse(
      event,
      createResponse("RELEASE_OWNER", {
        networkId: data.networkId,
        toUuid: data.fromUuid,
        targetId: data.targetId,
        success: false,
        error: "No owned dapp found."
      })
    );
  }
  const tabList = await getTabList(data.networkId);
  if (tabList) {
    const index = tabList.indexOf(data.fromUuid);
    tabList.splice(index, 1);
    await saveTabList(data.networkId, tabList);
  }
  deleteFromTabEventMap(data.networkId, data.fromUuid);
  const otherTabs = tabEventMap.get(data.networkId);
  if (otherTabs) {
    releasedDapps.forEach((dappId) => {
      otherTabs.forEach((event2, uuid) => {
        if (uuid === data.fromUuid) return;
        log("sending to callback", data.networkId, data.fromUuid, dappId);
        sendResponse(
          event2,
          createResponse("REGISTER_TAB", {
            networkId: data.networkId,
            toUuid: uuid,
            targetId: uuid,
            dappId,
            success: true
          })
        );
      });
    });
  }
};
const serializeMap = (map) => {
  const keyValueArray = Array.from(map.entries());
  return JSON.stringify(keyValueArray);
};
const deserializeMap = (json) => {
  const keyValueArray = JSON.parse(json);
  if (Array.isArray(keyValueArray)) {
    return new Map(keyValueArray);
  } else {
    return /* @__PURE__ */ new Map();
  }
};
const createResponse = (type, data) => {
  return {
    type,
    value: data
  };
};
const sendResponse = (event, response) => {
  var _a;
  (_a = event.source) == null ? void 0 : _a.postMessage(response);
};
try {
  self.addEventListener("message", async (event) => {
    const obj = event;
    log("got message", event.data);
    if (isOfRequestType("OWNER_CHECK", obj)) {
      await handleOwnerCheckMessageRequest(obj.data.value, event);
    } else if (isOfRequestType("CLAIM_OWNER", obj)) {
      await handleClaimOwnerMessageRequest(obj.data.value, event);
    } else if (isOfRequestType("RELEASE_OWNER", obj)) {
      await handleReleaseOwnerMessageRequest(obj.data.value, event);
    } else if (isOfRequestType("REGISTER_TAB", obj)) {
      await handleRegisterTabMessageRequest(obj.data.value, event);
    }
  });
  log("added message event listener");
} catch (error) {
}
