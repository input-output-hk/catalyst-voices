import { eO as RefDB, j$ as getPoolInfo, bT as json } from "./index.js";
const getRewardInfoRefId = async (rewardInfo) => {
  return await RefDB.getRefListByRefs(rewardInfo.networkId, rewardInfo.id, [rewardInfo.cred], 1);
};
const updatePoolInRewardInfo = async (rewardInfo) => {
  const uniquePoolIds = /* @__PURE__ */ new Set();
  for (const pool of rewardInfo.currentEpochDelegation) {
    uniquePoolIds.add(typeof pool === "string" ? pool : pool.pb);
  }
  for (const pool of rewardInfo.nextDelegation) {
    uniquePoolIds.add(typeof pool === "string" ? pool : pool.pb);
  }
  for (const pool of rewardInfo.afterNextDelegations) {
    uniquePoolIds.add(typeof pool === "string" ? pool : pool.pb);
  }
  const poolList = [];
  for (const poolId of uniquePoolIds) {
    const poolItem = getPoolInfo(poolId);
    if (poolItem) {
      poolList.push(json(poolItem));
    }
  }
  const _rewardInfo = json(rewardInfo);
  _rewardInfo.currentEpochDelegation.splice(0);
  _rewardInfo.nextDelegation.splice(0);
  _rewardInfo.afterNextDelegations.splice(0);
  for (const pool of rewardInfo.currentEpochDelegation) {
    const poolId = typeof pool === "object" ? pool.pb : pool;
    const poolItem = poolList.find((p) => p.pb === poolId);
    if (poolItem) {
      _rewardInfo.currentEpochDelegation.push(poolItem);
    } else {
      _rewardInfo.currentEpochDelegation.push(pool);
    }
  }
  for (const pool of rewardInfo.nextDelegation) {
    const poolId = typeof pool === "object" ? pool.pb : pool;
    const poolItem = poolList.find((p) => p.pb === poolId);
    if (poolItem) {
      _rewardInfo.nextDelegation.push(poolItem);
    } else {
      _rewardInfo.nextDelegation.push(pool);
    }
  }
  for (const pool of rewardInfo.afterNextDelegations) {
    const poolId = typeof pool === "object" ? pool.pb : pool;
    const poolItem = poolList.find((p) => p.pb === poolId);
    if (poolItem) {
      _rewardInfo.afterNextDelegations.push(poolItem);
    } else {
      _rewardInfo.afterNextDelegations.push(pool);
    }
  }
  return _rewardInfo;
};
const updatePoolInEpochDatumList = (epochDatumList) => {
  var _a;
  const uniquePoolIds = /* @__PURE__ */ new Set();
  const epochPoolIds = new Array(epochDatumList.length);
  for (let i = 0; i < epochDatumList.length; i++) {
    const uniqueEpochPoolIds = /* @__PURE__ */ new Set();
    if (epochDatumList[i].poolItem.length === 0) {
      if ((_a = epochDatumList[i].rewards) == null ? void 0 : _a.poolHash) {
        const bech32 = epochDatumList[i].rewards.poolHash.bech32;
        uniquePoolIds.add(bech32);
        uniqueEpochPoolIds.add(bech32);
      }
    } else {
      for (const pool of epochDatumList[i].poolItem) {
        uniquePoolIds.add(pool.pb);
        uniqueEpochPoolIds.add(pool.pb);
      }
    }
    epochPoolIds[i] = Array.from(uniqueEpochPoolIds);
  }
  const poolList = [];
  for (const poolId of uniquePoolIds) {
    const poolItem = getPoolInfo(poolId);
    if (poolItem) {
      poolList.push(json(poolItem));
    }
  }
  for (let i = 0; i < epochDatumList.length; i++) {
    epochDatumList[i].poolItem = poolList.filter((p) => epochPoolIds[i].includes(p.pb));
  }
};
export {
  updatePoolInEpochDatumList as a,
  getRewardInfoRefId as g,
  updatePoolInRewardInfo as u
};
