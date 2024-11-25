import { cJ as abs, cG as subtract, cP as ITxBalanceType, c_ as add, cI as divide, bh as getTimestampFromSlot, B as useFormatter } from "./index.js";
var ICSVExportTargetId = /* @__PURE__ */ ((ICSVExportTargetId2) => {
  ICSVExportTargetId2["universal"] = "universal";
  ICSVExportTargetId2["universaldot"] = "universaldot";
  ICSVExportTargetId2["koinlysimple"] = "koinlysimple";
  ICSVExportTargetId2["koinlysimpledot"] = "koinlysimpledot";
  return ICSVExportTargetId2;
})(ICSVExportTargetId || {});
var ITxCertificateKind = /* @__PURE__ */ ((ITxCertificateKind2) => {
  ITxCertificateKind2[ITxCertificateKind2["StakeRegistration"] = 0] = "StakeRegistration";
  ITxCertificateKind2[ITxCertificateKind2["StakeDeregistration"] = 1] = "StakeDeregistration";
  ITxCertificateKind2[ITxCertificateKind2["StakeDelegation"] = 2] = "StakeDelegation";
  ITxCertificateKind2[ITxCertificateKind2["PoolRegistration"] = 3] = "PoolRegistration";
  ITxCertificateKind2[ITxCertificateKind2["PoolRetirement"] = 4] = "PoolRetirement";
  return ITxCertificateKind2;
})(ITxCertificateKind || {});
const {
  formatTxType,
  formatDatetime
} = useFormatter();
const csvExportTargetMap = {
  //universal:    { id: 'universal',    label: 'Universal CSV',       separator: ',', fields: 'Date,Sent Amount,Sent Currency,Received Amount,Received Currency,Fee Amount,Fee Currency,Net Worth Amount,Net Worth Currency,Label,Description,TxHash,TxType'.split(',') },
  universal: { id: ICSVExportTargetId.universal, label: "Universal CSV (Decimal: , )", adaSeparator: ",", fields: "Date,Sent Amount,Sent Currency,Received Amount,Received Currency,Fee Amount,Fee Currency,Label,Description,TxHash,TxType".split(",") },
  universaldot: { id: ICSVExportTargetId.universaldot, label: "Universal CSV (Decimal: . )", adaSeparator: ".", fields: "Date,Sent Amount,Sent Currency,Received Amount,Received Currency,Fee Amount,Fee Currency,Label,Description,TxHash,TxType".split(",") },
  koinlysimple: { id: ICSVExportTargetId.koinlysimple, label: "Koinly CSV - simple (Decimal: , )", adaSeparator: ",", fields: "Koinly Date,Amount,Currency,Fee Amount,Fee Currency,TxHash".split(",") },
  koinlysimpledot: { id: ICSVExportTargetId.koinlysimpledot, label: "Koinly CSV - simple (Decimal: . )", adaSeparator: ".", fields: "Koinly Date,Amount,Currency,Fee Amount,Fee Currency,TxHash".split(",") }
};
const csvExportTargetList = [
  csvExportTargetMap.universal,
  csvExportTargetMap.universaldot,
  csvExportTargetMap.koinlysimple,
  csvExportTargetMap.koinlysimpledot
];
const getCSVTargetMap = () => csvExportTargetMap;
const getCSVTargetList = () => csvExportTargetList;
const getCSVTarget = (id) => csvExportTargetMap[id];
const createCSVFile = (networkId, txList, rewardList, target, t, useLocalTimezone = false, includeTxNotes = false) => {
  var _a, _b, _c, _d, _e;
  const fields = target.fields.concat();
  if (includeTxNotes) {
    fields.push("Note");
  }
  const {
    formatDatetime: formatDatetime2
  } = useFormatter();
  const n = "\n";
  const sep = ",";
  const numFields = fields.length;
  const adaSeparator = target.adaSeparator;
  let csv = fields.join(sep) + n;
  const localTxList = [...txList];
  localTxList.sort((a, b) => a.block > b.block ? 1 : -1);
  for (const tx of localTxList) {
    if (!tx.coin) throw new Error("Transaction malformed.");
    const txType = tx.t;
    let total = abs(subtract(tx.coin ?? "0", tx.ow ?? "0"));
    let didSent = false;
    let didReceive = false;
    let fee = "0";
    if ((txType & ITxBalanceType.sentAda) === ITxBalanceType.sentAda) {
      fee = tx.f ?? "0";
      total = subtract(total, fee);
      didSent = true;
    }
    if ((txType & ITxBalanceType.receivedAda) === ITxBalanceType.receivedAda) {
      didReceive = true;
    }
    let isDeposit = false;
    let isReg = false;
    if (tx.cert) {
      for (const certKind of tx.cert) {
        switch (certKind) {
          case ITxCertificateKind.StakeRegistration:
            isDeposit = true;
            isReg = true;
            break;
          case ITxCertificateKind.StakeDeregistration:
            isDeposit = true;
            break;
        }
      }
    }
    if (isDeposit) {
      if (isReg) {
        didSent = true;
      } else {
        fee = tx.f ?? "0";
        total = add(total, fee);
        didReceive = true;
      }
    }
    const total2 = '"' + (didSent ? "-" : "") + divide(total, 1e6, 6).split(".").join(adaSeparator) + '"';
    total = '"' + divide(total, 1e6, 6).split(".").join(adaSeparator) + '"';
    fee = '"' + divide(fee, 1e6, 6).split(".").join(adaSeparator) + '"';
    for (let i = 0; i < numFields; i++) {
      const field = fields[i];
      switch (field) {
        case "Date":
        case "Koinly Date":
          const slotTime = new Date(getTimestampFromSlot(networkId, tx.slot));
          if (!useLocalTimezone) {
            csv += '"' + formatDatetime2(slotTime, true, true, true) + '"';
          } else {
            const time = new Date(slotTime.getTime() - (/* @__PURE__ */ new Date()).getTimezoneOffset() * 6e4);
            csv += '"' + formatDatetime2(time, true, true, true) + '"';
          }
          break;
        case "Sent Amount":
          if (didSent) csv += total;
          break;
        case "Received Amount":
          if (didReceive) csv += total;
          break;
        case "Amount":
          csv += total2;
          break;
        case "Fee Amount":
          csv += fee;
          break;
        case "Net Worth Amount":
          break;
        case "Sent Currency":
        case "Received Currency":
        case "Currency":
        case "Fee Currency":
        case "Net Worth Currency":
          csv += '"ADA"';
          break;
        case "Label":
          break;
        case "Description":
          if (tx.msg && tx.msg.length > 0) {
            csv += '"' + tx.msg.join(" - ") + '"';
          }
          break;
        case "TxHash":
          csv += '"' + tx.hash + '"';
          break;
        case "TxType":
          csv += '"' + formatTxType(tx.t ?? null, t).name.split(", ").join(" - ") + '"';
          break;
        case "Note":
          if (tx.note) {
            csv += '"' + tx.note.note.replace(/\n/g, " ") + '"';
          }
          break;
      }
      if (i <= numFields - 2) {
        csv += sep;
      }
    }
    csv += n;
  }
  for (const reward of rewardList) {
    let total = ((_a = reward.rewards) == null ? void 0 : _a.amount) ?? 0;
    total = '"' + divide(total, 1e6, 6).split(".").join(adaSeparator) + '"';
    for (let i = 0; i < numFields; i++) {
      const field = fields[i];
      switch (field) {
        case "Date":
        case "Koinly Date":
          const time = new Date(reward.tsSpendable);
          if (!useLocalTimezone) {
            csv += '"' + formatDatetime2(time, true, true, true) + '"';
          } else {
            const time2 = new Date(reward.tsSpendable - (/* @__PURE__ */ new Date()).getTimezoneOffset() * 6e4);
            csv += '"' + formatDatetime2(time2, true, true, true) + '"';
          }
          break;
        case "Sent Amount":
          break;
        case "Received Amount":
          csv += total;
          break;
        case "Amount":
          csv += total;
          break;
        case "Fee Amount":
          csv += '"0"';
          break;
        case "Net Worth Amount":
          break;
        case "Sent Currency":
        case "Received Currency":
        case "Currency":
        case "Fee Currency":
        case "Net Worth Currency":
          csv += '"ADA"';
          break;
        case "Label":
          csv += '"reward"';
          break;
        case "Description":
          if (((_b = reward.rewards) == null ? void 0 : _b.type) === "member") {
            csv += '"reward - epoch: earned: ' + ((_c = reward.rewards) == null ? void 0 : _c.epochEarned) + " - spendable: " + ((_d = reward.rewards) == null ? void 0 : _d.epochSpendable) + '"';
          } else {
            csv += '"reward - treasury: spendable: ' + ((_e = reward.rewards) == null ? void 0 : _e.epochSpendable) + '"';
          }
          break;
      }
      if (i <= numFields - 2) {
        csv += sep;
      }
    }
    csv += n;
  }
  return csv;
};
function useCSVExport() {
  return {
    getCSVTargetMap,
    getCSVTargetList,
    getCSVTarget,
    createCSVFile
  };
}
export {
  ICSVExportTargetId as I,
  useCSVExport as u
};
