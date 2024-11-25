import { d as defineComponent, a5 as toRefs, f as computed, z as ref, u as unref, o as openBlock, a as createBlock, h as withCtx, e as createBaseVNode, q as createVNode, c as createElementBlock, j as createCommentVNode, a7 as useQuasar, bS as entityGroupList, C as onMounted, n as normalizeClass, b as withModifiers, t as toDisplayString, H as Fragment, I as renderList, aH as QPagination_default, bT as json, bU as deleteReportEntityGroup, bV as addReportEntityGroup, bW as updateReportEntityGroup, bX as updateAllReportEntityGroups, bY as setSelectedEntityGroup, F as withDirectives, J as vShow, bZ as selectedEntityGroup, i as createTextVNode, b_ as reportLabelList, b$ as addReportLabel, c0 as deleteReportLabel, ag as walletGroupNameList, c1 as allEntityGroup, c2 as switchWalletGroupToSelectedEntityGroup, D as watch, c3 as isZero, c4 as isLessThanZero, c5 as getAssetName, B as useFormatter, c6 as getAssetIdBech32, c7 as accAssetInfoMap, c8 as fetchAssetInfo, K as networkId, c9 as updateAccountAssetInfoMap, aI as useGuard, ca as hasLeftOverValue, bh as getTimestampFromSlot, cb as QToggle_default, cc as QBtn_default, cd as QPopupProxy_default, ce as QDate_default, cf as getRandomId, cg as markBalanceRewards, ch as markBalanceAsTaxRelevant, ci as markBalanceAsC, cj as resetBalance, ck as calcFiatValue, cl as markBalanceAsManual, cm as markBalanceAsN, cn as trimAllStrings, co as isTxHash, cp as getMetaData, cq as markBalanceUsingCostBasis, cr as updateBalanceCB, cs as getSlotFromDateId, as as appTimezone, ct as onErrorCaptured, cu as getAllMetaData, cv as isZeroOrGreater, be as useWalletAccount, cw as getRawData, aG as onUnmounted, cx as isAccountLoadingRawReportingData, cy as isLoadingRawReportingData, cz as loadRawData, a6 as useAppWallet, a8 as SyncState, ab as withKeys, ai as walletGroupMap, cA as getIAppWallet, cB as loadRawDataRewards, cC as saveRawData, cD as clearRawData, cE as addRawData, V as nextTick, cF as sortRawBalanceList, cG as subtract, cH as neg, cI as divide, cJ as abs, cK as isGreaterThanZero, cL as getAssetInfoLight, cM as doLoadMissingAssetInfo, cN as saveMetaData, cO as clearMetaData, cP as ITxBalanceType, cQ as getDateIdFromSlot, cR as addPriceOfDay, cS as combineData, cT as setMetaData, cU as getAllReportData, cV as getCSVADAAmount, cW as getCSVAmount, cX as getCSVAmount2, cY as bigToNum, cZ as multiply, c_ as add, c$ as saveReportData, d0 as clearReportData, d1 as createReportData, d2 as getAccountIdListByEntity, d3 as createLedger, d4 as getReports, d5 as doLoadMissingAssetInfoByStringList, d6 as setReportData, x as isSignMode } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$t } from "./Page.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$s } from "./SettingsItem.vue_vue_type_script_setup_true_lang.js";
import { u as useDownload } from "./useDownload.js";
import { I as IconPencil } from "./IconPencil.js";
import { I as IconDelete } from "./IconDelete.js";
import { G as GridSpace } from "./GridSpace.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { _ as _sfc_main$m } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$l } from "./ConfirmationModal.vue_vue_type_script_setup_true_lang.js";
import { G as GridInput } from "./GridInput.js";
import { _ as _sfc_main$k } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$i, a as _sfc_main$j } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { M as Modal } from "./Modal.js";
import { _ as _sfc_main$n } from "./ReportLabelNewModal.vue_vue_type_script_setup_true_lang.js";
import { u as useUiSelectedAccount } from "./uiSelectedAccount.js";
import { _ as _sfc_main$r } from "./GridTxListEntryBalance.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$o } from "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
import { _ as _sfc_main$p } from "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$q } from "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import "./NetworkId.js";
import { I as ICSVExportTargetId, u as useCSVExport } from "./useCSVExport.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./IconError.js";
import "./useBalanceVisible.js";
import "./Clipboard.js";
const _hoisted_1$h = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_2$h = { class: "flex flex-col cc-text-sz" };
const _hoisted_3$g = {
  key: 0,
  class: "grid grid-cols-12 cc-gap p-4 w-full"
};
const _hoisted_4$g = { class: "px-4 pb-4" };
const _hoisted_5$d = { class: "grid grid-cols-12 cc-gap" };
const _sfc_main$h = /* @__PURE__ */ defineComponent({
  __name: "ReportEntityEditModal",
  props: {
    showModal: { type: Object, required: true },
    isEdit: { type: Boolean, required: false, default: false },
    id: { type: String, required: false, default: "notset" },
    value: { type: String, required: false, default: "" }
  },
  emits: ["close", "submit"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const { showModal } = toRefs(props);
    const mode = computed(() => props.id === "new" ? "add" : "edit");
    const input = ref(props.value ?? "");
    const inputError = ref("");
    const idInput = ref(mode.value === "add" ? "" : props.id ?? "");
    const idInputError = ref("");
    const title = ref(`setting.reportEntity.${mode.value}.title`);
    const caption = ref(`setting.reportEntity.${mode.value}.caption`);
    const validateIdInput = () => {
      idInputError.value = idInput.value.length > 0 ? "" : it(`setting.reportEntity.${mode.value}.id.error`);
    };
    const onSubmit = () => {
      const id = props.id === "new" ? idInput.value : props.id;
      emit("submit", id, input.value);
      onClose();
    };
    const onReset = () => {
      input.value = "";
      inputError.value = "";
      idInput.value = "";
      idInputError.value = "";
    };
    const onClose = () => {
      showModal.value.display = false;
      onReset();
      emit("close");
    };
    return (_ctx, _cache) => {
      var _a;
      return ((_a = unref(showModal)) == null ? void 0 : _a.display) ? (openBlock(), createBlock(Modal, {
        key: 0,
        "modal-container": "#eternl-modal",
        narrow: "",
        "full-width-on-mobile": "",
        onClose
      }, {
        header: withCtx(() => [
          createBaseVNode("div", _hoisted_1$h, [
            createBaseVNode("div", _hoisted_2$h, [
              createVNode(_sfc_main$i, {
                label: unref(it)(title.value)
              }, null, 8, ["label"])
            ])
          ])
        ]),
        content: withCtx(() => [
          caption.value ? (openBlock(), createElementBlock("div", _hoisted_3$g, [
            createVNode(_sfc_main$j, {
              text: unref(it)(caption.value)
            }, null, 8, ["text"])
          ])) : createCommentVNode("", true),
          createBaseVNode("div", _hoisted_4$g, [
            __props.id === "new" ? (openBlock(), createBlock(GridInput, {
              key: 0,
              "input-text": idInput.value,
              "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => idInput.value = $event),
              "input-error": idInputError.value,
              "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => idInputError.value = $event),
              class: "col-span-12 lg:col-span-4 pb-2",
              onLostFocus: validateIdInput,
              onEnter: onSubmit,
              onReset,
              label: unref(it)("setting.reportEntity.add.id.label"),
              "input-hint": unref(it)("setting.reportEntity.add.id.hint"),
              autofocus: true,
              alwaysShowInfo: false,
              showReset: true,
              "input-id": "inputName",
              "input-type": "text"
            }, {
              "icon-prepend": withCtx(() => [
                createVNode(IconPencil, { class: "h-5 w-5" })
              ]),
              _: 1
            }, 8, ["input-text", "input-error", "label", "input-hint"])) : createCommentVNode("", true),
            createVNode(GridInput, {
              "input-text": input.value,
              "onUpdate:inputText": _cache[2] || (_cache[2] = ($event) => input.value = $event),
              "input-error": inputError.value,
              "onUpdate:inputError": _cache[3] || (_cache[3] = ($event) => inputError.value = $event),
              class: "col-span-12 lg:col-span-8 pb-2",
              onEnter: onSubmit,
              onReset,
              label: unref(it)("setting.reportEntity.add.comment.label"),
              "input-hint": unref(it)("setting.reportEntity.add.comment.hint"),
              alwaysShowInfo: false,
              showReset: true,
              "input-disabled": false,
              "input-id": "inputComment",
              "input-type": "text"
            }, {
              "icon-prepend": withCtx(() => [
                createVNode(IconPencil, { class: "h-5 w-5" })
              ]),
              _: 1
            }, 8, ["input-text", "input-error", "label", "input-hint"]),
            createBaseVNode("div", _hoisted_5$d, [
              createVNode(GridButtonSecondary, {
                label: unref(it)("setting.reportEntity.button.cancel"),
                link: onClose,
                class: "col-start-0 col-span-6 lg:col-start-7 lg:col-span-3"
              }, null, 8, ["label"]),
              createVNode(_sfc_main$k, {
                label: __props.isEdit ? unref(it)("setting.reportEntity.button.save") : unref(it)("setting.reportEntity.button.add"),
                link: onSubmit,
                disabled: __props.isEdit && input.value === __props.value,
                class: "col-span-6 lg:col-span-3"
              }, null, 8, ["label", "disabled"])
            ])
          ])
        ]),
        _: 1
      })) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$g = { class: "cc-grid" };
const _hoisted_2$g = { class: "cc-area-light flex flex-col flex-nowrap py-2 px-5" };
const _hoisted_3$f = { class: "table-auto divide-y" };
const _hoisted_4$f = { class: "cc-text-bold cc-text-sz capitalize text-middle" };
const _hoisted_5$c = { class: "flex flex-row flex-nowrap justify-start items-center" };
const _hoisted_6$a = { class: "text-left w-full" };
const _hoisted_7$9 = {
  key: 0,
  class: "text-right"
};
const _hoisted_8$7 = { class: "divide-y" };
const _hoisted_9$6 = ["onClick"];
const _hoisted_10$4 = { class: "w-5 h-5 cc-text-highlight mdi mdi-text-box-edit-outline ml-1" };
const _hoisted_11$2 = ["onClick"];
const _hoisted_12$2 = { class: "" };
const _hoisted_13$1 = { key: 0 };
const _hoisted_14$1 = { class: "cc-grid" };
const itemsOnPage$1 = 8;
const _sfc_main$g = /* @__PURE__ */ defineComponent({
  __name: "ReportEntityList",
  props: {
    readonly: { type: Boolean, required: false, default: false },
    fullWidth: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const $q = useQuasar();
    const { it } = useTranslation();
    const { downloadText } = useDownload();
    const inputRef = ref(null);
    const modalEntry = ref(null);
    const showModalAddEntry = ref({ display: false });
    const showModalDeleteEntry = ref({ display: false });
    const isEdit = ref(false);
    const nameSortOrderAsc = ref(true);
    ref([]);
    const list = computed(() => entityGroupList.value ?? []);
    const currentPage = ref(1);
    const showPagination = computed(() => list.value.length > itemsOnPage$1);
    const currentPageStart = computed(() => (currentPage.value - 1) * itemsOnPage$1);
    const maxPages = computed(() => Math.ceil(list.value.length / itemsOnPage$1));
    const filteredList = computed(() => {
      list.value.sort((a, b) => {
        if (nameSortOrderAsc.value) {
          return a.id.localeCompare(b.id, "en-US");
        }
        return b.id.localeCompare(a.id, "en-US");
      });
      return list.value.slice(currentPageStart.value, currentPageStart.value + itemsOnPage$1);
    });
    const onShowModalDelete = (entity) => {
      modalEntry.value = entity;
      showModalDeleteEntry.value.display = true;
    };
    const onClose = () => {
      isEdit.value = false;
      modalEntry.value = null;
      showModalAddEntry.value.display = false;
      showModalDeleteEntry.value.display = false;
    };
    const onNew = () => {
      modalEntry.value = null;
      showModalAddEntry.value.display = true;
    };
    const onSave = () => {
      const save = {
        entities: json(entityGroupList.value)
      };
      downloadText(JSON.stringify(save, null, 2), "reporting.json");
    };
    const onImport = () => {
      if (inputRef.value) inputRef.value.click();
    };
    const onDelete = () => {
      showModalDeleteEntry.value.display = false;
      if (!modalEntry.value) {
        return;
      }
      if (modalEntry.value.id === "all") {
        return;
      }
      deleteReportEntityGroup(modalEntry.value.id);
    };
    const onEdit = (id, comment) => {
      if (!modalEntry.value) {
        addReportEntityGroup(id, comment);
        return;
      }
      if (id === modalEntry.value.id) {
        modalEntry.value.comment = comment;
        updateReportEntityGroup(modalEntry.value);
      }
    };
    const doEdit = (entity) => {
      modalEntry.value = entity;
      isEdit.value = true;
      showModalAddEntry.value.display = true;
    };
    const processFile = async (jsonObj) => {
      if (!jsonObj || !jsonObj.entities || !Array.isArray(jsonObj.entities)) {
        showNotificationError("Invalid file format");
        return;
      }
      await updateAllReportEntityGroups(jsonObj.entities);
      return null;
    };
    const onHandleFileSelect = async (e) => {
      const files = e.target.files;
      const file = files[0];
      if (!file) {
        return;
      }
      if (!file.type.match("application/json")) {
        showNotificationWarning("Unsupported file type: " + file.type);
        return;
      }
      const loadedFile = await loadFile(file);
      await processFile(loadedFile);
    };
    const loadFile = (file) => {
      const reader = new FileReader();
      return new Promise(async (resolve, reject) => {
        reader.onload = async (re) => {
          try {
            const loadedFile = JSON.parse(re.target.result);
            return resolve(loadedFile);
          } catch (err) {
            showNotificationError("Could not parse: " + (file == null ? void 0 : file.name));
            console.error("Could not parse:", file == null ? void 0 : file.name);
          }
          return reject("error 1");
        };
        reader.onerror = () => {
          showNotificationError("Could not load: " + (file == null ? void 0 : file.name));
          return reject("error 2");
        };
        reader.onabort = () => {
          showNotificationError("Could not load: " + (file == null ? void 0 : file.name));
          return reject("error 3");
        };
        reader.readAsText(file);
      });
    };
    onMounted(() => {
      if (inputRef.value) {
        inputRef.value.addEventListener("change", onHandleFileSelect, false);
      }
    });
    const showNotificationError = (msg) => {
      $q.notify({
        message: msg,
        type: "warning",
        position: "top-left",
        timeout: 8e3,
        closeBtn: true,
        progress: true
      });
    };
    const showNotificationWarning = (msg) => {
      $q.notify({
        message: msg,
        type: "warning",
        position: "top-left",
        timeout: 8e3,
        closeBtn: true,
        progress: true
      });
    };
    return (_ctx, _cache) => {
      var _a, _b, _c, _d;
      return openBlock(), createElementBlock("div", _hoisted_1$g, [
        ((_a = showModalAddEntry.value) == null ? void 0 : _a.display) ? (openBlock(), createBlock(_sfc_main$h, {
          key: 0,
          "show-modal": showModalAddEntry.value,
          "is-edit": isEdit.value,
          id: ((_b = modalEntry.value) == null ? void 0 : _b.id) ?? "new",
          value: ((_c = modalEntry.value) == null ? void 0 : _c.comment) ?? "",
          onSubmit: onEdit,
          onClose
        }, null, 8, ["show-modal", "is-edit", "id", "value"])) : createCommentVNode("", true),
        modalEntry.value && ((_d = showModalDeleteEntry.value) == null ? void 0 : _d.display) ? (openBlock(), createBlock(_sfc_main$l, {
          key: 1,
          "show-modal": showModalDeleteEntry.value,
          title: unref(it)("setting.reportEntity.delete.title"),
          caption: unref(it)("setting.reportEntity.delete.caption").replace("###name###", modalEntry.value.id),
          "cancel-label": unref(it)("common.label.no"),
          "confirm-label": unref(it)("common.label.yes"),
          onConfirm: onDelete
        }, null, 8, ["show-modal", "title", "caption", "cancel-label", "confirm-label"])) : createCommentVNode("", true),
        filteredList.value.length > 0 ? (openBlock(), createElementBlock("div", {
          key: 2,
          class: normalizeClass(["col-span-12 item-text", __props.fullWidth ? "" : ""])
        }, [
          createBaseVNode("div", _hoisted_2$g, [
            createBaseVNode("table", _hoisted_3$f, [
              createBaseVNode("thead", null, [
                createBaseVNode("tr", _hoisted_4$f, [
                  createBaseVNode("th", {
                    class: "text-left min-w-24 cursor-pointer pr-1 sm:pr-2",
                    onClick: _cache[0] || (_cache[0] = withModifiers(($event) => nameSortOrderAsc.value = !nameSortOrderAsc.value, ["stop"]))
                  }, [
                    createBaseVNode("div", _hoisted_5$c, [
                      createBaseVNode("span", null, toDisplayString(unref(it)("setting.reportEntity.table.header.name")), 1),
                      createBaseVNode("i", {
                        class: normalizeClass(["cc-text-xl mt-0.5 text-gray-400", nameSortOrderAsc.value ? "mdi mdi-chevron-up" : "mdi mdi-chevron-down"])
                      }, null, 2)
                    ])
                  ]),
                  createBaseVNode("th", _hoisted_6$a, toDisplayString(unref(it)("setting.reportEntity.table.header.comment")), 1),
                  !__props.readonly ? (openBlock(), createElementBlock("th", _hoisted_7$9, toDisplayString(unref(it)("setting.reportEntity.table.header.action")), 1)) : createCommentVNode("", true)
                ])
              ]),
              createBaseVNode("tbody", _hoisted_8$7, [
                (openBlock(true), createElementBlock(Fragment, null, renderList(filteredList.value, (entityGroup, index) => {
                  var _a2;
                  return openBlock(), createElementBlock("tr", {
                    class: "align-middle cc-text-sm cursor-pointer h-12",
                    key: index
                  }, [
                    createBaseVNode("td", {
                      class: normalizeClass(["h-14 pr-2 break-all md:whitespace-nowrap rounded flex flex-row justify-start items-center", (!__props.readonly ? "" : "cursor-pointer ") + (index !== filteredList.value.length - 1 ? "pb-0" : "")]),
                      onClick: withModifiers(($event) => unref(setSelectedEntityGroup)(entityGroup), ["stop"])
                    }, [
                      createBaseVNode("div", null, toDisplayString(entityGroup.id + " (" + entityGroup.walletGroupNameList.length + ")"), 1),
                      withDirectives(createBaseVNode("i", _hoisted_10$4, null, 512), [
                        [vShow, entityGroup.id === ((_a2 = unref(selectedEntityGroup)) == null ? void 0 : _a2.id)]
                      ])
                    ], 10, _hoisted_9$6),
                    createBaseVNode("td", {
                      class: normalizeClass(["h-14 sm:text-sm", (!__props.readonly ? "" : "cursor-pointer ") + (index !== filteredList.value.length - 1 ? "" : "")]),
                      onClick: withModifiers(($event) => unref(setSelectedEntityGroup)(entityGroup), ["stop"])
                    }, toDisplayString(entityGroup.comment), 11, _hoisted_11$2),
                    !__props.readonly ? (openBlock(), createElementBlock("td", {
                      key: 0,
                      class: normalizeClass(["h-14 flex flex-row flex-nowrap justify-end items-center whitespace-nowrap gap-1", index !== filteredList.value.length - 1 ? "" : ""])
                    }, [
                      createBaseVNode("div", _hoisted_12$2, [
                        createVNode(IconPencil, {
                          class: "h-5 flex-none cursor-pointer",
                          onClick: ($event) => doEdit(entityGroup)
                        }, null, 8, ["onClick"]),
                        createVNode(_sfc_main$m, {
                          anchor: "bottom middle",
                          "transition-show": "scale",
                          "transition-hide": "scale"
                        }, {
                          default: withCtx(() => [
                            createTextVNode(toDisplayString(unref(it)("setting.reportEntity.button.edit")), 1)
                          ]),
                          _: 1
                        })
                      ]),
                      entityGroup.id !== "all" ? (openBlock(), createElementBlock("div", _hoisted_13$1, [
                        createVNode(IconDelete, {
                          class: "h-5 flex-none cc-text-color-error cursor-pointer",
                          onClick: ($event) => onShowModalDelete(entityGroup)
                        }, null, 8, ["onClick"]),
                        createVNode(_sfc_main$m, {
                          anchor: "bottom middle",
                          "transition-show": "scale",
                          "transition-hide": "scale"
                        }, {
                          default: withCtx(() => [
                            createTextVNode(toDisplayString(unref(it)("setting.reportEntity.button.delete")), 1)
                          ]),
                          _: 1
                        })
                      ])) : createCommentVNode("", true)
                    ], 2)) : createCommentVNode("", true)
                  ]);
                }), 128))
              ])
            ]),
            showPagination.value ? (openBlock(), createBlock(GridSpace, {
              key: 0,
              class: "mb-2"
            })) : createCommentVNode("", true),
            showPagination.value ? (openBlock(), createBlock(QPagination_default, {
              key: 1,
              modelValue: currentPage.value,
              "onUpdate:modelValue": _cache[1] || (_cache[1] = ($event) => currentPage.value = $event),
              max: maxPages.value,
              "max-pages": 6,
              "boundary-numbers": "",
              flat: "",
              color: "teal-90",
              "text-color": "teal-90",
              "active-color": "teal-90",
              "active-text-color": "teal-90",
              "active-design": "unelevated",
              class: "self-center"
            }, null, 8, ["modelValue", "max"])) : createCommentVNode("", true)
          ])
        ], 2)) : createCommentVNode("", true),
        !__props.readonly ? (openBlock(), createElementBlock("div", {
          key: 3,
          class: normalizeClass(["col-span-12 space-y-2 flex flex-col flex-nowrap", __props.fullWidth ? "" : ""])
        }, [
          createBaseVNode("div", _hoisted_14$1, [
            createVNode(GridButtonSecondary, {
              label: unref(it)("setting.reportEntity.button.newEntity"),
              link: onNew,
              class: "col-span-12 sm:col-span-4 lg:col-span-3"
            }, null, 8, ["label"]),
            createVNode(GridButtonSecondary, {
              label: unref(it)("setting.reportEntity.button.save"),
              link: onSave,
              class: "col-span-6 sm:col-span-4 lg:col-span-3 lg:col-start-7"
            }, null, 8, ["label"]),
            createBaseVNode("input", {
              type: "file",
              id: "files",
              name: "files[]",
              multiple: "",
              ref_key: "inputRef",
              ref: inputRef,
              hidden: ""
            }, null, 512),
            createVNode(GridButtonSecondary, {
              label: unref(it)("setting.reportEntity.button.import"),
              link: onImport,
              class: "col-span-6 sm:col-span-4 lg:col-span-3"
            }, null, 8, ["label"])
          ])
        ], 2)) : createCommentVNode("", true)
      ]);
    };
  }
});
const _hoisted_1$f = { class: "cc-grid" };
const _hoisted_2$f = { class: "cc-area-light flex flex-col flex-nowrap p-2 md:px-3" };
const _hoisted_3$e = { class: "table-auto divide-y" };
const _hoisted_4$e = { class: "cc-text-bold cc-text-sz capitalize text-middle" };
const _hoisted_5$b = { class: "flex flex-row flex-nowrap justify-start items-center" };
const _hoisted_6$9 = { class: "flex flex-row flex-nowrap justify-start items-center" };
const _hoisted_7$8 = { class: "text-left" };
const _hoisted_8$6 = {
  key: 0,
  class: "text-right"
};
const _hoisted_9$5 = { class: "divide-y" };
const _hoisted_10$3 = { class: "cc-grid" };
const itemsOnPage = 8;
const _sfc_main$f = /* @__PURE__ */ defineComponent({
  __name: "ReportLabels",
  props: {
    label: { type: Boolean, required: false, default: false },
    readonly: { type: Boolean, required: false, default: false },
    fullWidth: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    useQuasar();
    const { it } = useTranslation();
    const modalEntry = ref(null);
    const showReportLabelNewModal = ref({ display: false });
    const showReportLabelDeleteModal = ref({ display: false });
    const entitySortOrderAsc = ref(true);
    const nameSortOrderAsc = ref(true);
    ref([]);
    const entryList = computed(() => reportLabelList.value);
    const currentPage = ref(1);
    const showPagination = computed(() => entryList.value.length > itemsOnPage);
    const currentPageStart = computed(() => (currentPage.value - 1) * itemsOnPage);
    const maxPages = computed(() => Math.ceil(entryList.value.length / itemsOnPage));
    const filteredList = computed(() => {
      entryList.value.sort((a, b) => {
        if (entitySortOrderAsc.value) {
          return a.label.localeCompare(b.label, "en-US");
        }
        if (nameSortOrderAsc.value) {
          return a.label.localeCompare(b.label, "en-US");
        }
        return b.label.localeCompare(a.label, "en-US");
      });
      return entryList.value.slice(currentPageStart.value, currentPageStart.value + itemsOnPage);
    });
    const sortByEntityId = () => {
      entitySortOrderAsc.value = !entitySortOrderAsc.value;
      nameSortOrderAsc.value = false;
    };
    const sortByName = () => {
      nameSortOrderAsc.value = !entitySortOrderAsc.value;
      entitySortOrderAsc.value = false;
    };
    const onNew = (address, label, entityId) => {
      addReportLabel(address, label, entityId);
    };
    const onDelete = () => {
      if (!modalEntry.value) {
        return;
      }
      deleteReportLabel(modalEntry.value.address, modalEntry.value.label);
    };
    const doShowReportLabelNewModal = () => {
      showReportLabelNewModal.value.display = true;
    };
    const doShowReportLabelDeleteModal = (reportLabel) => {
      modalEntry.value = reportLabel;
      showReportLabelDeleteModal.value.display = true;
    };
    return (_ctx, _cache) => {
      var _a;
      return openBlock(), createElementBlock("div", _hoisted_1$f, [
        showReportLabelNewModal.value.display ? (openBlock(), createBlock(_sfc_main$n, {
          key: 0,
          "show-modal": showReportLabelNewModal.value,
          "is-new": "",
          id: "",
          value: "",
          onSubmit: onNew
        }, null, 8, ["show-modal"])) : createCommentVNode("", true),
        modalEntry.value && ((_a = showReportLabelDeleteModal.value) == null ? void 0 : _a.display) ? (openBlock(), createBlock(_sfc_main$l, {
          key: 1,
          "show-modal": showReportLabelDeleteModal.value,
          title: unref(it)("setting.reportEntity.reportLabels.delete.title"),
          caption: unref(it)("setting.reportEntity.reportLabels.delete.caption"),
          "cancel-label": unref(it)("common.label.no"),
          "confirm-label": unref(it)("common.label.yes"),
          onConfirm: onDelete
        }, null, 8, ["show-modal", "title", "caption", "cancel-label", "confirm-label"])) : createCommentVNode("", true),
        filteredList.value.length > 0 ? (openBlock(), createElementBlock("div", {
          key: 2,
          class: normalizeClass(["col-span-12 item-text", __props.fullWidth ? "" : "pl-3 sm:pl-2.5 lg:pl-0 pr-0"])
        }, [
          createBaseVNode("div", _hoisted_2$f, [
            createBaseVNode("table", _hoisted_3$e, [
              createBaseVNode("thead", null, [
                createBaseVNode("tr", _hoisted_4$e, [
                  createBaseVNode("th", {
                    class: "text-left min-w-24 cursor-pointer pr-1 sm:pr-2",
                    onClick: _cache[0] || (_cache[0] = withModifiers(($event) => sortByEntityId(), ["stop"]))
                  }, [
                    createBaseVNode("div", _hoisted_5$b, [
                      createBaseVNode("span", null, toDisplayString(unref(it)("setting.reportEntity.reportLabels.table.header.entity")), 1),
                      createBaseVNode("i", {
                        class: normalizeClass(["cc-text-xl mt-0.5 text-gray-400", entitySortOrderAsc.value ? "mdi mdi-chevron-up" : "mdi mdi-chevron-down"])
                      }, null, 2)
                    ])
                  ]),
                  createBaseVNode("th", {
                    class: "text-left min-w-24 cursor-pointer pr-1 sm:pr-2",
                    onClick: _cache[1] || (_cache[1] = withModifiers(($event) => sortByName(), ["stop"]))
                  }, [
                    createBaseVNode("div", _hoisted_6$9, [
                      createBaseVNode("span", null, toDisplayString(unref(it)("setting.reportEntity.reportLabels.table.header.name")), 1),
                      createBaseVNode("i", {
                        class: normalizeClass(["cc-text-xl mt-0.5 text-gray-400", nameSortOrderAsc.value ? "mdi mdi-chevron-up" : "mdi mdi-chevron-down"])
                      }, null, 2)
                    ])
                  ]),
                  createBaseVNode("th", _hoisted_7$8, toDisplayString(unref(it)("setting.reportEntity.reportLabels.table.header.address")), 1),
                  !__props.readonly ? (openBlock(), createElementBlock("th", _hoisted_8$6, toDisplayString(unref(it)("setting.reportEntity.reportLabels.table.header.action")), 1)) : createCommentVNode("", true)
                ])
              ]),
              createBaseVNode("tbody", _hoisted_9$5, [
                (openBlock(true), createElementBlock(Fragment, null, renderList(filteredList.value, (reportLabel, index) => {
                  return openBlock(), createElementBlock("tr", {
                    class: "align-middle cc-text-sm cursor-pointer",
                    key: index
                  }, [
                    createBaseVNode("td", {
                      class: normalizeClass(["pt-2 pr-2 break-all md:whitespace-nowrap", (!__props.readonly ? "" : "cursor-pointer ") + (index !== filteredList.value.length - 1 ? "pb-2" : "")])
                    }, toDisplayString(reportLabel.entityId), 3),
                    createBaseVNode("td", {
                      class: normalizeClass(["pt-2 pr-2 break-all md:whitespace-nowrap", (!__props.readonly ? "" : "cursor-pointer ") + (index !== filteredList.value.length - 1 ? "pb-2" : "")])
                    }, toDisplayString(reportLabel.label), 3),
                    createBaseVNode("td", {
                      class: normalizeClass(["pt-2 cc-addr sm:text-sm", (!__props.readonly ? "" : "cursor-pointer ") + (index !== filteredList.value.length - 1 ? "pb-2" : "")])
                    }, toDisplayString(reportLabel.address), 3),
                    !__props.readonly ? (openBlock(), createElementBlock("td", {
                      key: 0,
                      class: normalizeClass(["pt-2 pl-2 sm:min-w-16 flex flex-col sm:flex-row flex-nowrap justify-center sm:justify-end items-center whitespace-nowrap space-y-1", index !== filteredList.value.length - 1 ? "pb-2" : ""])
                    }, [
                      createBaseVNode("div", null, [
                        createVNode(IconDelete, {
                          class: "h-5 flex-none cc-text-color-error cursor-pointer",
                          onClick: ($event) => doShowReportLabelDeleteModal(reportLabel)
                        }, null, 8, ["onClick"]),
                        createVNode(_sfc_main$m, {
                          anchor: "bottom middle",
                          "transition-show": "scale",
                          "transition-hide": "scale"
                        }, {
                          default: withCtx(() => [
                            createTextVNode(toDisplayString(unref(it)("setting.reportEntity.reportLabels.button.delete")), 1)
                          ]),
                          _: 1
                        })
                      ])
                    ], 2)) : createCommentVNode("", true)
                  ]);
                }), 128))
              ])
            ]),
            showPagination.value ? (openBlock(), createBlock(GridSpace, {
              key: 0,
              class: "mb-2"
            })) : createCommentVNode("", true),
            showPagination.value ? (openBlock(), createBlock(QPagination_default, {
              key: 1,
              modelValue: currentPage.value,
              "onUpdate:modelValue": _cache[2] || (_cache[2] = ($event) => currentPage.value = $event),
              max: maxPages.value,
              "max-pages": 6,
              "boundary-numbers": "",
              flat: "",
              color: "teal-90",
              "text-color": "teal-90",
              "active-color": "teal-90",
              "active-text-color": "teal-90",
              "active-design": "unelevated",
              class: "self-center"
            }, null, 8, ["modelValue", "max"])) : createCommentVNode("", true)
          ])
        ], 2)) : createCommentVNode("", true),
        !__props.readonly ? (openBlock(), createElementBlock("div", {
          key: 3,
          class: normalizeClass(["col-span-12 space-y-2 flex flex-col flex-nowrap", __props.fullWidth ? "" : "pl-3 sm:pl-2.5 lg:pl-0 pr-1"])
        }, [
          createBaseVNode("div", _hoisted_10$3, [
            createVNode(GridButtonSecondary, {
              label: unref(it)("setting.reportEntity.reportLabels.button.add"),
              link: doShowReportLabelNewModal,
              class: "col-span-12 sm:col-span-4 lg:col-span-3"
            }, null, 8, ["label"])
          ])
        ], 2)) : createCommentVNode("", true)
      ]);
    };
  }
});
const _hoisted_1$e = {
  key: 0,
  class: "col-span-12 grid grid-cols-12 w-full gap-2"
};
const _hoisted_2$e = ["onClick"];
const _hoisted_3$d = { class: "col-span-6 sm:col-span-4 lg:col-span-3 cc-tabs-button-static w-full px-4 py-2 rounded text-center whitespace-nowrap" };
const _hoisted_4$d = {
  key: 1,
  class: "col-span-12 grid grid-cols-12 w-full gap-2"
};
const _hoisted_5$a = ["onClick"];
const _sfc_main$e = /* @__PURE__ */ defineComponent({
  __name: "ReportEntityWalletSelection",
  setup(__props) {
    const { it } = useTranslation();
    const doSelect = (group) => {
      switchWalletGroupToSelectedEntityGroup(group);
    };
    return (_ctx, _cache) => {
      return unref(selectedEntityGroup) && unref(selectedEntityGroup).id === "all" ? (openBlock(), createElementBlock("div", _hoisted_1$e, [
        (openBlock(true), createElementBlock(Fragment, null, renderList(unref(walletGroupNameList), (group) => {
          var _a, _b, _c, _d;
          return openBlock(), createElementBlock("div", {
            class: normalizeClass(["col-span-6 sm:col-span-4 lg:col-span-3 w-full px-4 py-2 rounded text-center whitespace-nowrap cursor-pointer", ((_a = unref(selectedEntityGroup)) == null ? void 0 : _a.walletGroupNameList.includes(group)) ? "cc-tabs-button-active" : ((_b = unref(allEntityGroup)) == null ? void 0 : _b.walletGroupNameList.includes(group)) ? "cc-tabs-button" : "cc-tabs-button opacity-50"]),
            onClick: ($event) => doSelect(group)
          }, [
            createTextVNode(toDisplayString(group) + " ", 1),
            ((_c = unref(selectedEntityGroup)) == null ? void 0 : _c.walletGroupNameList.includes(group)) ? (openBlock(), createBlock(_sfc_main$m, {
              key: 0,
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => _cache[0] || (_cache[0] = [
                createTextVNode(toDisplayString("This wallet group is already part of a this entity."))
              ])),
              _: 1
            })) : ((_d = unref(allEntityGroup)) == null ? void 0 : _d.walletGroupNameList.includes(group)) ? (openBlock(), createBlock(_sfc_main$m, {
              key: 1,
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => _cache[1] || (_cache[1] = [
                createTextVNode(toDisplayString("This wallet group is not part of a special entity yet."))
              ])),
              _: 1
            })) : (openBlock(), createBlock(_sfc_main$m, {
              key: 2,
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => _cache[2] || (_cache[2] = [
                createTextVNode(toDisplayString("This wallet group is already part of another entity group."))
              ])),
              _: 1
            }))
          ], 10, _hoisted_2$e);
        }), 256)),
        createVNode(_sfc_main$i, {
          label: unref(it)("setting.reportEntity.allEntityGroups.label")
        }, null, 8, ["label"]),
        (openBlock(true), createElementBlock(Fragment, null, renderList(unref(selectedEntityGroup).entityGroupIdList, (group) => {
          return openBlock(), createElementBlock("div", _hoisted_3$d, toDisplayString(group), 1);
        }), 256))
      ])) : (openBlock(), createElementBlock("div", _hoisted_4$d, [
        (openBlock(true), createElementBlock(Fragment, null, renderList(unref(walletGroupNameList), (group) => {
          var _a, _b, _c, _d;
          return openBlock(), createElementBlock("div", {
            class: normalizeClass(["col-span-6 sm:col-span-4 lg:col-span-3 w-full px-4 py-2 rounded text-center whitespace-nowrap cursor-pointer", ((_a = unref(selectedEntityGroup)) == null ? void 0 : _a.walletGroupNameList.includes(group)) ? "cc-tabs-button-active" : ((_b = unref(allEntityGroup)) == null ? void 0 : _b.walletGroupNameList.includes(group)) ? "cc-tabs-button" : "cc-tabs-button opacity-50"]),
            onClick: ($event) => doSelect(group)
          }, [
            createTextVNode(toDisplayString(group) + " ", 1),
            ((_c = unref(selectedEntityGroup)) == null ? void 0 : _c.walletGroupNameList.includes(group)) ? (openBlock(), createBlock(_sfc_main$m, {
              key: 0,
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => _cache[3] || (_cache[3] = [
                createTextVNode(toDisplayString("This wallet group is already part of a this entity."))
              ])),
              _: 1
            })) : ((_d = unref(allEntityGroup)) == null ? void 0 : _d.walletGroupNameList.includes(group)) ? (openBlock(), createBlock(_sfc_main$m, {
              key: 1,
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => _cache[4] || (_cache[4] = [
                createTextVNode(toDisplayString("This wallet group is not part of a special entity yet."))
              ])),
              _: 1
            })) : (openBlock(), createBlock(_sfc_main$m, {
              key: 2,
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => _cache[5] || (_cache[5] = [
                createTextVNode(toDisplayString("This wallet group is already part of another entity group."))
              ])),
              _: 1
            }))
          ], 10, _hoisted_5$a);
        }), 256))
      ]));
    };
  }
});
const _hoisted_1$d = { class: "inline-flex items-top self-start justify-end pt-1 relative" };
const _hoisted_2$d = { class: "relative flex flex-row gap-2 justify-end items-center" };
const _hoisted_3$c = { key: 0 };
const _hoisted_4$c = { key: 1 };
const _hoisted_5$9 = { key: 2 };
const _hoisted_6$8 = { key: 3 };
const _hoisted_7$7 = { key: 4 };
const _hoisted_8$5 = { key: 5 };
const _hoisted_9$4 = { key: 6 };
const _hoisted_10$2 = {
  key: 0,
  class: "cc-badge-red cc-none inline-flex"
};
const _sfc_main$d = /* @__PURE__ */ defineComponent({
  __name: "ReportCBListEntryBalance",
  props: {
    costBasis: { type: Object, required: true },
    showDelete: { type: Boolean, required: false, default: false },
    showCostAndUnit: { type: Boolean, required: false, default: false }
  },
  emits: ["scamTokenFound", "delete"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { t } = useTranslation();
    const {
      formatADAString,
      formatTxType,
      formatDatetime: formatDatetime2,
      valueFromFormattedString
    } = useFormatter();
    const assetsFiltered = ref([]);
    const assetCnt = ref(0);
    const { isAssetOnBlockList } = useGuard();
    const spamAssets = ref([]);
    const update = async (balance) => {
      var _a, _b;
      const list = [];
      let count = 0;
      if (balance.au) {
        const [policy, asset] = balance.au.split(".");
        count++;
        const assetKey = policy + asset;
        if (isAssetOnBlockList(getAssetIdBech32(policy, asset))) {
          spamAssets.value.push(assetKey);
          emit("scamTokenFound");
        }
        list.push({
          asset: {
            p: policy,
            t: {
              a: asset,
              q: balance.av
            }
          },
          info: null
        });
        assetCnt.value = count;
        assetsFiltered.value = list;
        let missingInfo = null;
        for (const asset2 of assetsFiltered.value) {
          asset2.info = ((_a = accAssetInfoMap.value[asset2.asset.p]) == null ? void 0 : _a.find((a) => a.h === asset2.asset.t.a)) ?? null;
          if (!asset2.info) {
            if (!missingInfo) {
              missingInfo = { [asset2.asset.p]: [asset2.asset.t.a] };
            } else if (asset2.asset.p in missingInfo) {
              missingInfo[asset2.asset.p].push(asset2.asset.t.a);
            } else {
              missingInfo[asset2.asset.p] = [asset2.asset.t.a];
            }
          }
        }
        if (missingInfo) {
          const infos = await fetchAssetInfo(networkId.value, missingInfo);
          updateAccountAssetInfoMap(infos);
          for (const asset2 of assetsFiltered.value) {
            if (!asset2.info) {
              asset2.info = ((_b = infos[asset2.asset.p]) == null ? void 0 : _b.find((i) => i.h === asset2.asset.t.a)) ?? null;
            }
          }
        }
      } else {
        assetCnt.value = count;
        assetsFiltered.value = [];
      }
    };
    const getAssetColor = (type) => {
      switch (type) {
        case "f":
          return "local-cc-text-gray";
        case "b":
          return "local-cc-text-purple";
        case "r":
          return "local-cc-text-lime";
        case "d":
          return "local-cc-text-blue-light";
        case "c":
          return "local-cc-text-zinc";
        case "n":
          return "local-cc-text-blue-light";
        case "p":
          return "local-cc-text-yellow";
        default:
          return "";
      }
    };
    watch(() => props.costBasis, () => update(props.costBasis), { deep: true, immediate: true });
    return (_ctx, _cache) => {
      var _a;
      return openBlock(), createElementBlock("div", _hoisted_1$d, [
        createBaseVNode("div", _hoisted_2$d, [
          __props.costBasis.l ? (openBlock(), createElementBlock("span", _hoisted_3$c, '"' + toDisplayString(__props.costBasis.l) + '"', 1)) : createCommentVNode("", true),
          __props.costBasis.ts ? (openBlock(), createElementBlock("span", _hoisted_4$c, toDisplayString(unref(formatDatetime2)(new Date(__props.costBasis.ts), true, false)), 1)) : createCommentVNode("", true),
          __props.costBasis.lv && !unref(isZero)(__props.costBasis.lv) ? (openBlock(), createElementBlock("span", _hoisted_5$9, [
            _cache[1] || (_cache[1] = createTextVNode("lv: ")),
            createBaseVNode("span", {
              class: normalizeClass(unref(isLessThanZero)(__props.costBasis.lv) ? "local-cc-text-red" : "local-cc-text-green")
            }, toDisplayString(unref(formatADAString)(__props.costBasis.lv, true, 6, true, false, true)), 3)
          ])) : createCommentVNode("", true),
          __props.costBasis.pd && (__props.costBasis.lv && !unref(isZero)(__props.costBasis.lv) || __props.costBasis.fv) ? (openBlock(), createElementBlock("span", _hoisted_6$8, "pd: " + toDisplayString((_a = __props.costBasis.pd) == null ? void 0 : _a.toFixed(5).replace(".", ",")) + " " + toDisplayString(__props.costBasis.fu), 1)) : createCommentVNode("", true),
          __props.costBasis.fv ? (openBlock(), createElementBlock("span", _hoisted_7$7, "f: " + toDisplayString((__props.costBasis.fv.toFixed(4) ?? 0).replace(".", ",")) + " " + toDisplayString(__props.costBasis.fu), 1)) : createCommentVNode("", true),
          __props.costBasis.gl ? (openBlock(), createElementBlock("span", _hoisted_8$5, "g/l: " + toDisplayString((__props.costBasis.gl.toFixed(4) ?? 0).replace(".", ",")) + " " + toDisplayString(__props.costBasis.fu), 1)) : createCommentVNode("", true),
          createBaseVNode("span", null, "(" + toDisplayString(__props.costBasis.t) + ")", 1),
          assetCnt.value > 1 ? (openBlock(), createElementBlock("span", _hoisted_9$4, "ac: (" + toDisplayString(assetCnt.value) + ")", 1)) : createCommentVNode("", true),
          __props.showDelete ? (openBlock(), createElementBlock("i", {
            key: 7,
            class: "mdi mdi-trash-can cursor-pointer",
            onClick: _cache[0] || (_cache[0] = ($event) => emit("delete"))
          })) : createCommentVNode("", true),
          createBaseVNode("div", {
            class: normalizeClass("relative flex flex-row gap-2 justify-end items-center min-w-48 " + getAssetColor(__props.costBasis.t))
          }, [
            !unref(isZero)(__props.costBasis.av) && !__props.costBasis.au ? (openBlock(), createBlock(_sfc_main$o, {
              key: 0,
              amount: __props.costBasis.av,
              hideFractionIfZero: false,
              "text-c-s-s": "justify-end " + getAssetColor(__props.costBasis.t),
              colored: "",
              "with-sign": ""
            }, null, 8, ["amount", "text-c-s-s"])) : createCommentVNode("", true),
            assetsFiltered.value.length > 0 ? (openBlock(true), createElementBlock(Fragment, { key: 1 }, renderList(assetsFiltered.value, (asset, index) => {
              var _a2, _b;
              return openBlock(), createElementBlock("div", {
                key: index,
                class: "flex flex-row justify-end space-x-1"
              }, [
                createVNode(_sfc_main$o, {
                  "text-c-s-s": "justify-end " + (unref(isLessThanZero)(asset.asset.t.q) && __props.costBasis.t !== "c" ? "local-cc-text-red" : ""),
                  amount: asset.asset.t.q,
                  hideFractionIfZero: false,
                  decimals: ((_b = (_a2 = asset.info) == null ? void 0 : _a2.tr) == null ? void 0 : _b.d) ?? 0,
                  currency: "",
                  "with-sign": ""
                }, null, 8, ["text-c-s-s", "amount", "decimals"]),
                createBaseVNode("span", {
                  class: normalizeClass(["truncate", unref(isLessThanZero)(asset.asset.t.q) && __props.costBasis.t !== "c" ? "local-cc-text-red" : ""])
                }, toDisplayString(unref(getAssetName)(asset.asset.t.a, asset.info, true) + "-" + asset.asset.p[0]), 3),
                spamAssets.value.includes(asset.asset.p + asset.asset.t.a) ? (openBlock(), createElementBlock("div", _hoisted_10$2, [
                  createTextVNode(toDisplayString(unref(t)("common.scam.token.label")) + " ", 1),
                  createVNode(_sfc_main$m, {
                    anchor: "bottom middle",
                    "transition-show": "scale",
                    "transition-hide": "scale"
                  }, {
                    default: withCtx(() => [
                      createTextVNode(toDisplayString(unref(t)("common.scam.token.hover")), 1)
                    ]),
                    _: 1
                  })
                ])) : createCommentVNode("", true)
              ]);
            }), 128)) : createCommentVNode("", true)
          ], 2)
        ])
      ]);
    };
  }
});
const ReportCBListEntryBalance = /* @__PURE__ */ _export_sfc(_sfc_main$d, [["__scopeId", "data-v-0c05b22a"]]);
const _hoisted_1$c = { class: "col-span-12 grid grid-cols-12 gap-0" };
const _hoisted_2$c = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between cc-bg-white-0 border-b cc-p" };
const _hoisted_3$b = { class: "flex flex-col cc-text-sz" };
const _hoisted_4$b = { class: "m-2 sm:m-4 grid grid-cols-12 gap-2" };
const _hoisted_5$8 = { class: "col-span-4 h-full mt-3 flex flex-row justify-center items-center" };
const _hoisted_6$7 = { class: "col-span-12 grid grid-cols-12 gap-2" };
const _hoisted_7$6 = { class: "col-span-2 grid grid-cols-12 gap-2" };
const _hoisted_8$4 = { class: "q-gutter-sm row" };
const _hoisted_9$3 = ["selected", "value"];
const _hoisted_10$1 = ["selected", "value"];
const _hoisted_11$1 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between cc-bg-white-0 border-b cc-p" };
const _hoisted_12$1 = { class: "flex flex-col cc-text-sz" };
const _hoisted_13 = { class: "m-2 sm:m-4 grid grid-cols-12 gap-2" };
const _hoisted_14 = {
  key: 2,
  class: "relative col-span-12 px-2 py-1 cc-text-sz flex flex-col flex-grow flex-nowrap gap-0"
};
const _hoisted_15 = { class: "flex flex-row flex-nowrap justify-between items-start" };
const _hoisted_16 = { class: "h-full pr-1 flex flex-col self-start shrink" };
const _hoisted_17 = { class: "cc-flex-fixed flex flex-row flex-nowrap items-start" };
const _hoisted_18 = {
  key: 0,
  class: "relative cc-flex-fixed flex flex-col flex-nowrap items-start w-6 h-6"
};
const _hoisted_19 = {
  key: 1,
  class: "relative cc-flex-fixed flex flex-col flex-nowrap items-start w-6 h-6 -ml-1 mr-1"
};
const _hoisted_20 = { class: "mt-1.5 mr-2 cc-addr break-normal" };
const _hoisted_21 = { class: "relative flex flex-row items-center mt-1 sm:mt-0.5 gap-1" };
const _hoisted_22 = { class: "relative cc-text-bold mr-0.5 mt-px" };
const _hoisted_23 = {
  key: 0,
  class: "cc-badge-yellow text-center"
};
const _hoisted_24 = {
  key: 2,
  class: "cc-badge-blue text-center"
};
const _hoisted_25 = { class: "flex flex-col gap-1" };
const _hoisted_26 = { class: "ml-6 inline-flex flex-row flex-wrap gap-1 max-w-96" };
const _hoisted_27 = ["onClick"];
const _hoisted_28 = { class: "text-amber-600" };
const _hoisted_29 = {
  key: 0,
  class: "ml-6 mt-1 flex flex-row gap-1"
};
const _hoisted_30 = {
  key: 1,
  class: "ml-6 mt-1 flex flex-row gap-1"
};
const _hoisted_31 = {
  key: 1,
  class: "flex flex-col gap-1 justify-end items-end"
};
const _hoisted_32 = {
  key: 0,
  class: "col-span-12 flex flex-col justify-end items-end w-full gap-0"
};
const _hoisted_33 = {
  key: 0,
  class: "flex flex-row gap-1 text-red-600 font-bold italic"
};
const _hoisted_34 = { key: 0 };
const _hoisted_35 = {
  key: 2,
  class: "flex justify-end gap-1 mb-1"
};
const _sfc_main$c = /* @__PURE__ */ defineComponent({
  __name: "ReportTxListBalance",
  props: {
    metaData: { type: Object, required: true },
    entityId: { type: String, required: false, default: "" },
    isLastItem: { type: Boolean, required: false, default: false }
  },
  emits: ["filterByAccount", "filterBySC"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it, t } = useTranslation();
    const {
      formatADAString,
      formatTxType,
      formatDatetime: formatDatetime2,
      valueFromFormattedString
    } = useFormatter();
    const {
      entityId,
      metaData
    } = toRefs(props);
    const hasLeftOver = computed(() => !(metaData.value && !hasLeftOverValue(metaData.value)));
    const toggleWithTokens = ref(false);
    const onUpdateToggle = () => {
      console.log("onUpdateToggle", toggleWithTokens.value);
    };
    let selectManualTypeList = [
      {
        id: "i",
        value: "gain/loss"
      },
      {
        id: "b",
        value: "bought/sold"
      },
      {
        id: "f",
        value: "tx fee (tax relevant)"
      },
      {
        id: "r",
        value: "rewards"
      },
      {
        id: "d",
        value: "deposit (tax neutral)"
      },
      {
        id: "c",
        value: "cost basis of tokens"
      },
      {
        id: "n",
        value: "tax neutral (e.g. gift)"
      },
      {
        id: "p",
        value: "pass-through/foreign funds"
      }
    ];
    let selectManualUnitList = [
      {
        id: "EUR",
        value: "EUR"
      },
      {
        id: "USD",
        value: "USD"
      },
      {
        id: "GBP",
        value: "GBP"
      },
      {
        id: "ADA",
        value: "ADA"
      }
    ];
    const txType = computed(() => formatTxType(metaData.value.t, t));
    computed(() => {
      if (!metaData.value.cb) {
        return false;
      }
      return metaData.value.cb.length === 1 && metaData.value.cb[0].t === "f";
    });
    const scpId = computed(() => {
      var _a;
      return ((_a = metaData.value.scp) == null ? void 0 : _a.slice(0, 64)) ?? "";
    });
    const showDetailsModal = ref(false);
    const showConnectedModal = ref(false);
    const blockTime = ref(/* @__PURE__ */ new Date());
    const inputManualType = ref(selectManualTypeList[0]);
    const inputManualUnit = ref(selectManualUnitList[0]);
    const inputManualTxHash = ref("0");
    const inputManualAda = ref("0");
    const inputManualPrice = ref("0");
    const inputManualLabel = ref("");
    const inputTotalPrice = ref(0);
    const inputManualDate = ref(null);
    const coinsLeft = computed(() => {
      return formatADAString(metaData.value.leftover.coin + "");
    });
    const maLeft = computed(() => {
      return metaData.value.leftover.multiasset;
    });
    watch(metaData, async (balance) => {
      blockTime.value = new Date(getTimestampFromSlot(networkId.value, balance.s));
    }, { immediate: true, deep: true });
    const doMarkAsRewards = () => markBalanceRewards(networkId.value, metaData.value);
    const doMarkAsIncome = () => markBalanceAsTaxRelevant(networkId.value, metaData.value);
    const doMarkAsC = () => markBalanceAsC(networkId.value, metaData.value);
    const doResetMetaData = () => resetBalance(metaData.value);
    const doSetPriceManually = () => {
      let date = new Date(getTimestampFromSlot(networkId.value, metaData.value.s));
      let ada = formatADAString(metaData.value.leftover.coin);
      let label = "";
      inputManualAda.value = ada;
      inputManualDate.value = date.getFullYear() + "-" + (date.getMonth() + 1).toString().padStart(2, "0") + "-" + date.getDate().toString().padStart(2, "0");
      inputManualLabel.value = label;
      showDetailsModal.value = true;
    };
    const doSetTxManually = (txHash) => {
      inputManualTxHash.value = "";
      if (!txHash) {
        showConnectedModal.value = true;
        return;
      }
      inputManualTxHash.value = txHash;
      onSaveTxHash();
    };
    const onCloseModal = () => {
      showDetailsModal.value = false;
      showConnectedModal.value = false;
      inputManualTxHash.value = "";
      inputManualAda.value = "0";
      inputManualPrice.value = "0";
      inputManualDate.value = null;
      toggleWithTokens.value = false;
    };
    const updateTotalPrice = () => {
      inputTotalPrice.value = parseFloat(valueFromFormattedString(inputManualAda.value).number) * parseFloat(inputManualPrice.value);
    };
    const onSetManualAda = (ada) => {
      inputManualAda.value = ada;
      updateTotalPrice();
    };
    const onSetManualTxHash = (txHash) => {
      inputManualTxHash.value = txHash;
    };
    const onSetManualPrice = (price) => {
      inputManualPrice.value = price;
      updateTotalPrice();
    };
    const onSetManualLabel = (label) => {
      inputManualLabel.value = label;
    };
    const onSaveCostBasis = () => {
      var _a;
      const data = metaData.value;
      if (!data) {
        return;
      }
      const ada = valueFromFormattedString(inputManualAda.value);
      const cb = {
        t: inputManualType.value.id,
        av: getLovelace(ada.whole, ada.fraction),
        ts: new Date(inputManualDate.value).getTime(),
        i: data.cb.length,
        l: inputManualLabel.value,
        pd: parseFloat(inputManualPrice.value),
        fu: inputManualUnit.value.id
      };
      calcFiatValue(cb);
      markBalanceAsManual(data, cb);
      if (toggleWithTokens.value && ((_a = metaData.value) == null ? void 0 : _a.a.multiasset)) {
        switch (inputManualType.value.id) {
          case "n":
            markBalanceAsN(networkId.value, data, true);
            break;
          case "c":
            markBalanceAsC(networkId.value, data, true);
            break;
        }
      }
      onCloseModal();
    };
    const onSaveTxHash = () => {
      const data = metaData.value;
      const txHashStr = inputManualTxHash.value ?? "";
      const txHashList = trimAllStrings(txHashStr.split(",")).filter(isTxHash);
      console.log("onSaveTxHash", data, inputManualTxHash.value, txHashList);
      if (!data) {
        return;
      }
      const _metaData = getMetaData(props.entityId);
      const cbTxList = _metaData.balanceList.filter((d) => txHashList.includes(d.h));
      if (cbTxList.length === 0) {
        return;
      }
      console.log(cbTxList);
      markBalanceUsingCostBasis(networkId.value, data, cbTxList);
      onCloseModal();
    };
    const onChangedType = (event) => {
      inputManualType.value = selectManualTypeList.find((type) => type.id === event.target.value) ?? selectManualTypeList[0];
    };
    const onChangedUnit = (event) => {
      inputManualUnit.value = selectManualUnitList.find((type) => type.id === event.target.value) ?? selectManualUnitList[0];
    };
    const getLovelace = (whole, fraction) => {
      while (fraction.length < 6) {
        fraction = fraction + "0";
      }
      return whole + fraction;
    };
    const onDeleteCB = (index) => {
      console.log("onDeleteCB", index);
      const data = metaData.value;
      if (!data) {
        return;
      }
      data.cb.splice(index, 1);
      updateBalanceCB(data);
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$c, [
        showDetailsModal.value ? (openBlock(), createBlock(Modal, {
          key: 0,
          narrow: "",
          onClose: onCloseModal
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_2$c, [
              createBaseVNode("div", _hoisted_3$b, [
                createVNode(_sfc_main$i, {
                  label: "Set price manually",
                  "do-capitalize": ""
                })
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_4$b, [
              createVNode(GridInput, {
                class: "col-span-8 mt-2 sm:mt-0",
                "input-text": inputManualAda.value,
                "onUpdate:inputText": onSetManualAda,
                label: "Amount in ADA",
                alwaysShowInfo: false,
                "input-id": "inputManualAda",
                autocomplete: "off"
              }, {
                "icon-prepend": withCtx(() => [
                  createVNode(IconPencil, { class: "h-5 w-5" })
                ]),
                _: 1
              }, 8, ["input-text"]),
              createBaseVNode("div", _hoisted_5$8, [
                createVNode(QToggle_default, {
                  modelValue: toggleWithTokens.value,
                  "onUpdate:modelValue": [
                    _cache[0] || (_cache[0] = ($event) => toggleWithTokens.value = $event),
                    onUpdateToggle
                  ],
                  label: "With Tokens",
                  "left-label": ""
                }, null, 8, ["modelValue"])
              ]),
              createVNode(GridInput, {
                class: "col-span-12 mt-2 sm:mt-0",
                "input-text": inputManualPrice.value,
                "onUpdate:inputText": onSetManualPrice,
                label: "Price in EUR (total: " + inputTotalPrice.value.toFixed(2) + ")",
                alwaysShowInfo: false,
                "input-type": "number",
                "input-id": "inputManualPrice",
                autocomplete: "off"
              }, {
                "icon-prepend": withCtx(() => [
                  createVNode(IconPencil, { class: "h-5 w-5" })
                ]),
                _: 1
              }, 8, ["input-text", "label"]),
              createBaseVNode("div", _hoisted_6$7, [
                createVNode(_sfc_main$i, {
                  label: "Date: " + inputManualDate.value
                }, null, 8, ["label"]),
                createBaseVNode("div", _hoisted_7$6, [
                  createVNode(QBtn_default, {
                    icon: "event",
                    round: "",
                    color: "primary"
                  }, {
                    default: withCtx(() => [
                      createVNode(QPopupProxy_default, {
                        cover: "",
                        "transition-show": "scale",
                        "transition-hide": "scale",
                        class: "bg-transparent"
                      }, {
                        default: withCtx(() => [
                          createBaseVNode("div", _hoisted_8$4, [
                            createVNode(QDate_default, {
                              modelValue: inputManualDate.value,
                              "onUpdate:modelValue": _cache[1] || (_cache[1] = ($event) => inputManualDate.value = $event),
                              mask: "YYYY-MM-DD",
                              dark: true
                            }, null, 8, ["modelValue"])
                          ])
                        ]),
                        _: 1
                      })
                    ]),
                    _: 1
                  })
                ]),
                createBaseVNode("select", {
                  class: "col-span-5 cc-rounded-la cc-dropdown cc-text-sm",
                  required: true,
                  onChange: _cache[2] || (_cache[2] = ($event) => onChangedType($event))
                }, [
                  (openBlock(true), createElementBlock(Fragment, null, renderList(unref(selectManualTypeList), (type) => {
                    return openBlock(), createElementBlock("option", {
                      key: "type_" + type.id,
                      selected: type.id === inputManualType.value.id,
                      value: type.id
                    }, toDisplayString(type.value), 9, _hoisted_9$3);
                  }), 128))
                ], 32),
                createBaseVNode("select", {
                  class: "col-span-5 cc-rounded-la cc-dropdown cc-text-sm",
                  required: true,
                  onChange: _cache[3] || (_cache[3] = ($event) => onChangedUnit($event))
                }, [
                  (openBlock(true), createElementBlock(Fragment, null, renderList(unref(selectManualUnitList), (type) => {
                    return openBlock(), createElementBlock("option", {
                      key: "unit_" + type.id,
                      selected: type.id === inputManualUnit.value.id,
                      value: type.id
                    }, toDisplayString(type.value), 9, _hoisted_10$1);
                  }), 128))
                ], 32)
              ]),
              createVNode(GridInput, {
                class: "col-span-12 mt-2 sm:mt-0",
                "input-text": inputManualLabel.value,
                "onUpdate:inputText": onSetManualLabel,
                label: "Comment:",
                alwaysShowInfo: false,
                "input-id": "inputManualComment",
                autocomplete: "off"
              }, {
                "icon-prepend": withCtx(() => [
                  createVNode(IconPencil, { class: "h-5 w-5" })
                ]),
                _: 1
              }, 8, ["input-text"]),
              createVNode(GridButtonSecondary, {
                class: "col-span-6",
                label: "Cancel",
                onClick: onCloseModal
              }),
              createVNode(GridButtonSecondary, {
                class: "col-span-6",
                label: "Save",
                onClick: onSaveCostBasis
              })
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true),
        showConnectedModal.value ? (openBlock(), createBlock(Modal, {
          key: 1,
          narrow: "",
          onClose: onCloseModal
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_11$1, [
              createBaseVNode("div", _hoisted_12$1, [
                createVNode(_sfc_main$i, {
                  label: "Enter txHash of connected tx",
                  "do-capitalize": ""
                })
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_13, [
              createVNode(GridInput, {
                class: "col-span-12 mt-2 sm:mt-0",
                "input-text": inputManualTxHash.value,
                "onUpdate:inputText": onSetManualTxHash,
                label: "Amount in ADA",
                alwaysShowInfo: false,
                "input-id": "inputManualTxHash",
                autocomplete: "off"
              }, {
                "icon-prepend": withCtx(() => [
                  createVNode(IconPencil, { class: "h-5 w-5" })
                ]),
                _: 1
              }, 8, ["input-text"]),
              createVNode(GridButtonSecondary, {
                class: "col-span-6",
                label: "Cancel",
                onClick: onCloseModal
              }),
              createVNode(GridButtonSecondary, {
                class: "col-span-6",
                label: "Save",
                onClick: onSaveTxHash
              })
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true),
        unref(metaData) ? (openBlock(), createElementBlock("div", _hoisted_14, [
          createBaseVNode("div", _hoisted_15, [
            createBaseVNode("div", _hoisted_16, [
              createBaseVNode("div", _hoisted_17, [
                unref(metaData).a.coin === "0" ? (openBlock(), createElementBlock("div", _hoisted_18, _cache[8] || (_cache[8] = [
                  createBaseVNode("div", { class: "mt-1 rounded-full bg-yellow-500 dark:bg-yellow-600 w-4 h-4 flex justify-center items-center" }, [
                    createBaseVNode("i", { class: "mdi mdi-alert-octagon-outline text-xs" })
                  ], -1)
                ]))) : (openBlock(), createElementBlock("div", _hoisted_19, [
                  createBaseVNode("i", {
                    class: normalizeClass(["relative text-xl -mt-px", txType.value.icon])
                  }, null, 2)
                ])),
                createBaseVNode("div", _hoisted_20, toDisplayString(unref(formatDatetime2)(blockTime.value)), 1),
                createBaseVNode("div", _hoisted_21, [
                  createBaseVNode("div", _hoisted_22, toDisplayString(txType.value.name), 1),
                  hasLeftOver.value ? (openBlock(), createElementBlock("div", _hoisted_23, "not checked")) : createCommentVNode("", true),
                  createBaseVNode("div", {
                    class: "cc-badge-gray text-center",
                    onClick: doResetMetaData
                  }, "reset"),
                  unref(metaData).a.isSC ? (openBlock(), createElementBlock("div", {
                    key: 1,
                    class: "cc-badge-blue text-center cursor-pointer",
                    onClick: _cache[4] || (_cache[4] = ($event) => emit("filterBySC", unref(metaData)))
                  }, "SC")) : createCommentVNode("", true),
                  unref(metaData).d && !unref(isZero)(unref(metaData).d) ? (openBlock(), createElementBlock("div", _hoisted_24, "deposit")) : createCommentVNode("", true)
                ])
              ]),
              createBaseVNode("div", _hoisted_25, [
                createBaseVNode("div", _hoisted_26, [
                  (openBlock(true), createElementBlock(Fragment, null, renderList(unref(metaData).al, (a) => {
                    return openBlock(), createElementBlock("div", {
                      class: "text-green-700 cursor-pointer",
                      onClick: ($event) => emit("filterByAccount", a)
                    }, toDisplayString(a), 9, _hoisted_27);
                  }), 256)),
                  (openBlock(true), createElementBlock(Fragment, null, renderList(unref(metaData).el, (e) => {
                    return openBlock(), createElementBlock("div", _hoisted_28, toDisplayString(e) + " -", 1);
                  }), 256))
                ])
              ]),
              hasLeftOver.value ? (openBlock(), createElementBlock("div", _hoisted_29, [
                createVNode(_sfc_main$p, {
                  subject: unref(metaData).h,
                  type: "transaction",
                  label: unref(metaData).h,
                  "label-c-s-s": "cc-addr hover:text-gray-500"
                }, null, 8, ["subject", "label"]),
                createVNode(_sfc_main$q, {
                  "copy-text": unref(metaData).h,
                  class: "ml-1 inline-flex items-center justify-center"
                }, null, 8, ["copy-text"])
              ])) : createCommentVNode("", true),
              scpId.value && scpId.value !== unref(metaData).h ? (openBlock(), createElementBlock("div", _hoisted_30, [
                createVNode(_sfc_main$p, {
                  subject: scpId.value,
                  type: "transaction",
                  label: scpId.value,
                  "label-c-s-s": "cc-addr hover:text-gray-500"
                }, null, 8, ["subject", "label"]),
                createVNode(_sfc_main$q, {
                  "copy-text": scpId.value,
                  class: "ml-1 inline-flex items-center justify-center"
                }, null, 8, ["copy-text"])
              ])) : createCommentVNode("", true),
              createTextVNode(" " + toDisplayString(unref(metaData).scp), 1)
            ]),
            hasLeftOver.value ? (openBlock(), createBlock(_sfc_main$r, {
              key: 0,
              "tx-balance": unref(metaData).a
            }, null, 8, ["tx-balance"])) : (openBlock(), createElementBlock("div", _hoisted_31, [
              (openBlock(true), createElementBlock(Fragment, null, renderList(unref(metaData).cb, (cb, index) => {
                return openBlock(), createElementBlock("div", {
                  key: unref(getRandomId)(),
                  class: "flex flex-row gap-1 w-full justify-end"
                }, [
                  createVNode(ReportCBListEntryBalance, { "cost-basis": cb }, null, 8, ["cost-basis"])
                ]);
              }), 128))
            ]))
          ]),
          hasLeftOver.value || unref(metaData).cb.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_32, [
            hasLeftOver.value ? (openBlock(), createElementBlock("div", _hoisted_33, [
              createTextVNode("Left over: " + toDisplayString(coinsLeft.value) + " ", 1),
              maLeft.value ? (openBlock(), createElementBlock("span", _hoisted_34, toDisplayString(maLeft.value), 1)) : createCommentVNode("", true)
            ])) : createCommentVNode("", true),
            hasLeftOver.value ? (openBlock(true), createElementBlock(Fragment, { key: 1 }, renderList(unref(metaData).cb, (cb, index) => {
              return openBlock(), createElementBlock("div", {
                class: "flex flex-row gap-1 w-full justify-end",
                key: unref(getRandomId)()
              }, [
                cb ? (openBlock(), createBlock(ReportCBListEntryBalance, {
                  key: 0,
                  "cost-basis": cb,
                  "show-delete": "",
                  onDelete: ($event) => onDeleteCB(index)
                }, null, 8, ["cost-basis", "onDelete"])) : createCommentVNode("", true)
              ]);
            }), 128)) : createCommentVNode("", true),
            hasLeftOver.value ? (openBlock(), createElementBlock("div", _hoisted_35, [
              createBaseVNode("div", {
                class: "cc-badge-green text-center px-4 cursor-pointer",
                onClick: doMarkAsRewards
              }, "Rewards"),
              createBaseVNode("div", {
                class: "cc-badge-green text-center px-4 cursor-pointer",
                onClick: doMarkAsIncome
              }, "Use price of day"),
              createBaseVNode("div", {
                class: "cc-badge-green text-center px-4 cursor-pointer",
                onClick: doMarkAsC
              }, "Irrelevant"),
              createBaseVNode("div", {
                class: "cc-badge-blue text-center px-4 cursor-pointer",
                onClick: doSetPriceManually
              }, "Add Details"),
              createBaseVNode("div", {
                class: "cc-badge-blue text-center px-4 cursor-pointer",
                onClick: _cache[5] || (_cache[5] = ($event) => doSetTxManually())
              }, "Select CBTX"),
              unref(metaData).a.hashList && unref(metaData).a.hashList.length > 0 ? (openBlock(), createElementBlock(Fragment, { key: 0 }, [
                createTextVNode(toDisplayString(unref(metaData).a.hashList[0]), 1),
                createBaseVNode("div", {
                  class: "cc-badge-blue text-center px-4 cursor-pointer",
                  onClick: _cache[6] || (_cache[6] = ($event) => doSetTxManually(unref(metaData).a.hashList[0]))
                }, "Select CBTX")
              ], 64)) : createCommentVNode("", true),
              scpId.value && scpId.value !== unref(metaData).h ? (openBlock(), createElementBlock(Fragment, { key: 1 }, [
                createTextVNode(toDisplayString(scpId.value), 1),
                createBaseVNode("div", {
                  class: "cc-badge-blue text-center px-4 cursor-pointer",
                  onClick: _cache[7] || (_cache[7] = ($event) => doSetTxManually(scpId.value))
                }, "Smart Contract")
              ], 64)) : createCommentVNode("", true)
            ])) : createCommentVNode("", true)
          ])) : createCommentVNode("", true)
        ])) : createCommentVNode("", true),
        !__props.isLastItem ? (openBlock(), createBlock(GridSpace, {
          key: 3,
          hr: ""
        })) : createCommentVNode("", true)
      ]);
    };
  }
});
const _year = ref(2020);
const _month = ref(0);
const _day = ref(0);
const year = computed(() => _year.value);
const month = computed(() => _month.value);
const day = computed(() => _day.value);
const minSlotOfYear = computed(() => getSlotFromDateId("mainnet", { year: year.value, month: month.value, day: day.value, timezone: appTimezone.value }, false));
const maxSlotOfYear = computed(() => getSlotFromDateId("mainnet", { year: year.value, month: month.value, day: day.value, timezone: appTimezone.value }, true));
const prevDay = () => {
  _day.value--;
  if (_day.value < 0) {
    _day.value = 31;
  }
};
const nextDay = () => {
  _day.value++;
  if (_day.value > 31) {
    _day.value = 0;
  }
  if (_day.value !== 0) {
    if (_month.value === 0) {
      _month.value = 1;
    }
  }
};
const prevMonth = () => {
  _month.value--;
  if (_month.value < 0) {
    _month.value = 12;
  }
};
const nextMonth = () => {
  _month.value++;
  if (_month.value > 12) {
    _month.value = 0;
  }
};
const prevYear = () => {
  if (_year.value === 2020) {
    return;
  }
  _year.value--;
};
const nextYear = () => {
  if (_year.value === 2024) {
    return;
  }
  _year.value++;
};
const useReportTimeChanger = () => {
  return {
    year,
    month,
    day,
    minSlotOfYear,
    maxSlotOfYear,
    prevDay,
    nextDay,
    nextMonth,
    prevMonth,
    prevYear,
    nextYear
  };
};
const _hoisted_1$b = { class: "col-span-12 grid grid-cols-12 cc-page-gap cc-page-px cc-page-pt cc-text-sz pb-4" };
const _hoisted_2$b = { class: "col-span-8 grid grid-cols-12 cc-gap" };
const _hoisted_3$a = { class: "col-span-8 flex flex-col" };
const _hoisted_4$a = { class: "flex flex-row" };
const _hoisted_5$7 = { class: "col-span-12 grid grid-cols-12 cc-page-gap" };
const _hoisted_6$6 = { class: "col-span-12 flex flex-row justify-between items-center" };
const _hoisted_7$5 = {
  key: 0,
  class: "flex flex-row gap-2 h-6"
};
const _hoisted_8$3 = ["onClick"];
const _hoisted_9$2 = {
  key: 1,
  class: "grow"
};
const _hoisted_10 = { class: "col-span-12 flex justify-center" };
const _hoisted_11 = {
  key: 1,
  class: "col-span-12 grid grid-cols-12"
};
const _hoisted_12 = { class: "col-span-12 flex justify-center" };
const _sfc_main$b = /* @__PURE__ */ defineComponent({
  __name: "ReportTransactions",
  props: {
    entityId: { type: String, required: true }
  },
  emits: ["filter-by-account-id", "filter-by-sc"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { entityId } = toRefs(props);
    const { it } = useTranslation();
    const {
      minSlotOfYear: minSlotOfYear2,
      maxSlotOfYear: maxSlotOfYear2
    } = useReportTimeChanger();
    const filterRewards = ref(false);
    const filterChecked = ref(false);
    const filterIncome = ref(false);
    const filterIntra = ref(false);
    const filterByAccountId = ref("");
    const excludeAccountIdList = ref([]);
    const filterBySC = ref(null);
    const allMetaData = getAllMetaData();
    const metaData = computed(() => {
      const _entityId = entityId.value;
      if (!_entityId) {
        return null;
      }
      const data = allMetaData[_entityId];
      if (!data) {
        return null;
      }
      return allMetaData[_entityId];
    });
    const rawBalanceList = computed(() => {
      var _a;
      return ((_a = metaData.value) == null ? void 0 : _a.balanceList) ?? [];
    });
    const balanceList = computed(() => {
      var _a, _b, _c, _d;
      let result = rawBalanceList.value;
      const _filterBySC = filterBySC.value;
      if (_filterBySC) {
        console.log("FILTER close", (_a = metaData.value) == null ? void 0 : _a.closedSCList);
        console.log("FILTER open ", (_b = metaData.value) == null ? void 0 : _b.openSCList);
        const scp = ((_c = metaData.value) == null ? void 0 : _c.closedSCList.find((scp2) => scp2.id.startsWith(_filterBySC.h))) ?? ((_d = metaData.value) == null ? void 0 : _d.openSCList.find((scp2) => scp2.id.startsWith(_filterBySC.h)));
        console.log("FILTER scp", scp);
        if (scp) {
          const hashList = scp.hashList.map((h) => h.slice(0, 64));
          result = result.filter((b) => hashList.includes(b.h));
          return result;
        }
      }
      result = result.filter((b) => b.s >= minSlotOfYear2.value && b.s <= maxSlotOfYear2.value);
      if (filterChecked.value) {
        result = result.filter((b) => hasLeftOverValue(b));
      }
      if (filterIncome.value) {
        result = result.filter((b) => {
          var _a2, _b2, _c2;
          return !(((_a2 = b.cb) == null ? void 0 : _a2.some((cb) => cb.t === "i")) && !((_b2 = b.cb) == null ? void 0 : _b2.some((cb) => cb.t === "p")) && !((_c2 = b.cb) == null ? void 0 : _c2.some((cb) => cb.t === "c")));
        });
      }
      if (filterIntra.value) {
        result = result.filter((b) => !(b.cb.length === 1 && b.cb[0].t === "f" && !hasLeftOverValue(b)));
        result = result.filter((b) => !isZero(b.a.coin));
      }
      if (filterRewards.value) {
        result = result.filter((b) => {
          var _a2;
          return !((_a2 = b.tf) == null ? void 0 : _a2.rw);
        });
      }
      excludeAccountIdList.value.length > 0;
      for (const id of excludeAccountIdList.value) {
        result = result.filter((b) => !(b.al && b.al.length === 1 && b.al.includes(id)));
      }
      if (filterByAccountId.value) {
        result = result.filter((b) => {
          var _a2;
          return (_a2 = b.al) == null ? void 0 : _a2.includes(filterByAccountId.value);
        });
      }
      return result;
    });
    const numTxTotal = computed(() => balanceList.value.length);
    const numItemsPerPage = computed(() => 10);
    const numMaxPages = computed(() => Math.ceil(numTxTotal.value / numItemsPerPage.value));
    const currentPage = ref(1);
    watch(numMaxPages, () => {
      currentPage.value = 1;
    });
    const _dbPage = computed(() => (currentPage.value - 1) * numItemsPerPage.value);
    const txListPage = computed(() => {
      const numItems = balanceList.value.length;
      let endIndex = Math.min(_dbPage.value + numItemsPerPage.value, numItems);
      return balanceList.value.slice(_dbPage.value, endIndex);
    });
    onErrorCaptured((e) => {
      console.error("Transactions: onErrorCaptured", e);
      return true;
    });
    const showPagination = computed(() => numTxTotal.value > numItemsPerPage.value);
    const onFilterByAccount = (accountId) => {
      if (filterByAccountId.value === accountId) {
        filterByAccountId.value = "";
      } else {
        filterByAccountId.value = accountId;
      }
      emit("filter-by-account-id", filterByAccountId.value);
    };
    const onFilterBySC = (metaData2) => {
      console.log("onFilterBySC", metaData2);
      if (!filterBySC.value) {
        filterBySC.value = metaData2;
      } else {
        filterBySC.value = null;
      }
    };
    const excludeFromList = () => {
      if (excludeAccountIdList.value.includes(filterByAccountId.value)) {
        excludeAccountIdList.value = excludeAccountIdList.value.filter((id) => id !== filterByAccountId.value);
      } else {
        excludeAccountIdList.value = [...excludeAccountIdList.value, filterByAccountId.value];
      }
    };
    const removeFromExcludeList = (accountId) => {
      for (let i = excludeAccountIdList.value.length - 1; i >= 0; i--) {
        if (excludeAccountIdList.value[i] === accountId) {
          excludeAccountIdList.value.splice(i, 1);
        }
      }
    };
    const doMarkAsIncome = () => {
      var _a;
      console.log("doMarkAsIncome: num balances:", balanceList.value.length);
      for (const metaData2 of balanceList.value) {
        if (((_a = metaData2.al) == null ? void 0 : _a.length) !== 1) {
          continue;
        }
        if (isLessThanZero(metaData2.a.coin)) {
          continue;
        }
        if (metaData2.a.isSC) {
          continue;
        }
        markBalanceAsTaxRelevant(networkId.value, metaData2);
      }
    };
    const doMarkAsOutflowWithoutFee = () => {
      var _a;
      console.log("doMarkAsOutflowWithoutFee: num balances:", balanceList.value.length);
      for (const metaData2 of balanceList.value) {
        if (((_a = metaData2.al) == null ? void 0 : _a.length) !== 1) {
          continue;
        }
        if (isZeroOrGreater(metaData2.a.coin)) {
          continue;
        }
        if (metaData2.a.multiasset) {
          continue;
        }
        markBalanceAsTaxRelevant(networkId.value, metaData2, true);
      }
    };
    const doRemoveFeeMarks = () => {
      console.log("doRemoveFeeMarks: num balances:", balanceList.value.length);
      for (const metaData2 of balanceList.value) {
        resetBalance(metaData2);
      }
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$b, [
        createBaseVNode("div", _hoisted_2$b, [
          createBaseVNode("div", _hoisted_3$a, [
            createVNode(_sfc_main$i, {
              label: unref(it)("wallet.transactions.history.headline"),
              class: "col-span-1"
            }, null, 8, ["label"]),
            createBaseVNode("div", _hoisted_4$a, [
              createVNode(_sfc_main$j, {
                text: numTxTotal.value + " " + unref(it)("wallet.transactions.history.caption"),
                class: "truncate"
              }, null, 8, ["text"])
            ])
          ])
        ]),
        createBaseVNode("div", _hoisted_5$7, [
          createBaseVNode("div", _hoisted_6$6, [
            filterByAccountId.value ? (openBlock(), createElementBlock("div", _hoisted_7$5, [
              _cache[7] || (_cache[7] = createTextVNode(" Filter:")),
              createBaseVNode("div", {
                class: "cc-badge-green",
                onClick: _cache[0] || (_cache[0] = ($event) => filterByAccountId.value = "")
              }, toDisplayString(filterByAccountId.value), 1),
              createBaseVNode("div", {
                class: "cc-badge-green text-center px-4 cursor-pointer",
                onClick: doMarkAsIncome
              }, "All income: price of day"),
              createBaseVNode("div", {
                class: "cc-badge-yellow text-center px-4 cursor-pointer",
                onClick: doMarkAsOutflowWithoutFee
              }, "All outflow without fee"),
              createBaseVNode("div", {
                class: "cc-badge-yellow text-center px-4 cursor-pointer",
                onClick: doRemoveFeeMarks
              }, "Remove fee CBs"),
              createBaseVNode("div", {
                class: "cc-badge-green text-center px-4 cursor-pointer",
                onClick: excludeFromList
              }, "Exclude"),
              (openBlock(true), createElementBlock(Fragment, null, renderList(excludeAccountIdList.value, (accountId) => {
                return openBlock(), createElementBlock("span", {
                  onClick: ($event) => removeFromExcludeList(accountId)
                }, toDisplayString(accountId), 9, _hoisted_8$3);
              }), 256))
            ])) : (openBlock(), createElementBlock("div", _hoisted_9$2)),
            createBaseVNode("div", null, [
              createVNode(QToggle_default, {
                class: "col-span-8",
                modelValue: filterRewards.value,
                "onUpdate:modelValue": _cache[1] || (_cache[1] = ($event) => filterRewards.value = $event),
                "left-label": "",
                label: "Filter rewards"
              }, null, 8, ["modelValue"]),
              createVNode(QToggle_default, {
                class: "col-span-8",
                modelValue: filterChecked.value,
                "onUpdate:modelValue": _cache[2] || (_cache[2] = ($event) => filterChecked.value = $event),
                "left-label": "",
                label: "Filter checked tx"
              }, null, 8, ["modelValue"]),
              createVNode(QToggle_default, {
                class: "col-span-8",
                modelValue: filterIncome.value,
                "onUpdate:modelValue": _cache[3] || (_cache[3] = ($event) => filterIncome.value = $event),
                "left-label": "",
                label: "Filter income tx"
              }, null, 8, ["modelValue"]),
              createVNode(QToggle_default, {
                class: "col-span-8",
                modelValue: filterIntra.value,
                "onUpdate:modelValue": _cache[4] || (_cache[4] = ($event) => filterIntra.value = $event),
                "left-label": "",
                label: "Filter intra tx"
              }, null, 8, ["modelValue"])
            ])
          ]),
          showPagination.value ? (openBlock(), createBlock(GridSpace, {
            key: 0,
            class: "col-span-12",
            hr: ""
          })) : createCommentVNode("", true),
          createBaseVNode("div", _hoisted_10, [
            showPagination.value ? (openBlock(), createBlock(QPagination_default, {
              key: 0,
              modelValue: currentPage.value,
              "onUpdate:modelValue": _cache[5] || (_cache[5] = ($event) => currentPage.value = $event),
              max: numMaxPages.value,
              "max-pages": 6,
              "boundary-numbers": "",
              flat: "",
              color: "teal-90",
              "text-color": "teal-90",
              "active-color": "teal-90",
              "active-text-color": "teal-90",
              "active-design": "unelevated"
            }, null, 8, ["modelValue", "max"])) : createCommentVNode("", true)
          ]),
          createVNode(GridSpace, {
            class: "col-span-12",
            hr: ""
          }),
          unref(entityId) ? (openBlock(), createElementBlock("div", _hoisted_11, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(txListPage.value, (metaData2) => {
              return openBlock(), createBlock(_sfc_main$c, {
                key: metaData2.h,
                "entity-id": unref(entityId),
                "meta-data": metaData2,
                onFilterByAccount,
                onFilterBySC
              }, null, 8, ["entity-id", "meta-data"]);
            }), 128))
          ])) : createCommentVNode("", true),
          createBaseVNode("div", _hoisted_12, [
            showPagination.value ? (openBlock(), createBlock(QPagination_default, {
              key: 0,
              modelValue: currentPage.value,
              "onUpdate:modelValue": _cache[6] || (_cache[6] = ($event) => currentPage.value = $event),
              max: numMaxPages.value,
              "max-pages": 6,
              "boundary-numbers": "",
              flat: "",
              color: "teal-90",
              "text-color": "teal-90",
              "active-color": "teal-90",
              "active-text-color": "teal-90",
              "active-design": "unelevated"
            }, null, 8, ["modelValue", "max"])) : createCommentVNode("", true)
          ])
        ])
      ]);
    };
  }
});
const _hoisted_1$a = { class: "flex-grow flex-shrink flex flex-row flex-nowrap justify-start items-center cursor-pointer" };
const _hoisted_2$a = { class: "relative h-full flex flex-col flex-nowrap justify-center space-y-0.5 ml-2" };
const _hoisted_3$9 = {
  class: "relative cc-text-sz cc-text-bold mr-1 flex-1 flex items-center justify-between",
  style: { "line-height": "0.9rem" }
};
const _hoisted_4$9 = {
  class: "break-all text-sm cc-text-semi-bold pl-4 cc-addr flex gap-2",
  style: { "line-height": "0.9rem" }
};
const _hoisted_5$6 = {
  key: 0,
  class: "mdi mdi-cash-lock text-md ml-px cc-text-highlight",
  style: { "line-height": "0.1rem" }
};
const _hoisted_6$5 = {
  key: 1,
  class: "mdi mdi-circle text-xs ml-px cc-text-green",
  style: { "line-height": "0.1rem" }
};
const _hoisted_7$4 = ["disabled"];
const _hoisted_8$2 = ["disabled"];
const _hoisted_9$1 = ["disabled"];
const _sfc_main$a = /* @__PURE__ */ defineComponent({
  __name: "ReportAccountListButton",
  props: {
    walletId: { type: String, required: true },
    accountId: { type: String, required: true }
  },
  emits: ["select"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const {
      walletId,
      accountId
    } = toRefs(props);
    const {
      appWallet,
      appAccount,
      accountSettings
    } = useWalletAccount(walletId, accountId);
    const {
      minSlotOfYear: minSlotOfYear2,
      maxSlotOfYear: maxSlotOfYear2
    } = useReportTimeChanger();
    useQuasar();
    const { it, c } = useTranslation();
    const { formatDatetime: formatDatetime2 } = useFormatter();
    const _stopSync = ref(false);
    const _showTransactions = ref(false);
    const name = accountSettings.name;
    const path = accountSettings.path;
    const accountNetworkId = accountSettings.accountNetworkId;
    const rawData = computed(() => getRawData(accountId == null ? void 0 : accountId.value, false));
    const numRawDataLoaded = computed(() => {
      const _appAccount = appAccount.value;
      if (!_appAccount) {
        return false;
      }
      return rawData.value.balanceList.length;
    });
    computed(() => {
      const _appAccount = appAccount.value;
      if (!_appAccount) {
        return false;
      }
      return _appAccount.data.state.numTxHashes === numRawDataLoaded.value;
    });
    const lastReport = computed(() => {
      const _appAccount = appAccount.value;
      if (!_appAccount) {
        return null;
      }
      if (rawData.value.balanceList.length > 0) {
        return rawData.value.balanceList[rawData.value.balanceList.length - 1];
      }
      return null;
    });
    const reportDateStart = computed(() => {
      if (lastReport.value) {
        const date = getTimestampFromSlot(accountNetworkId.value, lastReport.value.s);
        return formatDatetime2(date, true, false);
      }
      return "last: -";
    });
    const stopCreateReport = () => {
      _stopSync.value = true;
    };
    const doShowTransactions = () => {
      _showTransactions.value = !_showTransactions.value;
    };
    const doCreateReport = async () => {
      const _appAccount = appAccount.value;
      console.log("doCreateReport", _appAccount);
      if (!_appAccount) {
        return;
      }
      _stopSync.value = false;
      await loadRawData(_appAccount, minSlotOfYear2.value, maxSlotOfYear2.value, _stopSync, true);
      _stopSync.value = false;
    };
    onUnmounted(() => {
      _stopSync.value = true;
    });
    return (_ctx, _cache) => {
      var _a, _b;
      return openBlock(), createElementBlock(Fragment, null, [
        ((_a = unref(appAccount)) == null ? void 0 : _a.data) ? (openBlock(), createElementBlock("div", {
          key: 0,
          class: normalizeClass(["ReportAccountListButton relative flex flex-row flex-nowrap space-x-px justify-between items-center cursor-pointer py-2 sm:py-2.5 mb-px cc-bg-slate-1 border-l-4 pl-2.5 pr-1.5", unref(appAccount).isSelectedAccount ? unref(c)("border") : unref(c)("hover")])
        }, [
          createBaseVNode("div", _hoisted_1$a, [
            createBaseVNode("div", _hoisted_2$a, [
              createBaseVNode("div", _hoisted_3$9, [
                createBaseVNode("div", _hoisted_4$9, [
                  createTextVNode(toDisplayString(unref(path)) + " - " + toDisplayString(unref(name)) + " ", 1),
                  unref(appAccount).isReadOnly ? (openBlock(), createElementBlock("i", _hoisted_5$6)) : createCommentVNode("", true),
                  unref(appAccount).isDappAccount ? (openBlock(), createElementBlock("i", _hoisted_6$5)) : createCommentVNode("", true),
                  createTextVNode(" | " + toDisplayString(reportDateStart.value) + " | " + toDisplayString(unref(isAccountLoadingRawReportingData)[unref(accountId)] ?? false ? "loading" : "idle") + " | no. tx: " + toDisplayString(numRawDataLoaded.value) + "/" + toDisplayString((_b = unref(appAccount)) == null ? void 0 : _b.data.state.numTxHashes) + " | ", 1),
                  createBaseVNode("button", {
                    class: "px-2 py-0.5 border rounded cc-addr -my-1",
                    tabindex: "0",
                    onClick: doCreateReport,
                    disabled: unref(isLoadingRawReportingData)
                  }, "Reload Raw Data", 8, _hoisted_7$4),
                  createBaseVNode("button", {
                    class: "px-2 py-0.5 border rounded cc-addr -my-1",
                    tabindex: "1",
                    onClick: stopCreateReport,
                    disabled: !unref(isLoadingRawReportingData)
                  }, "Stop", 8, _hoisted_8$2),
                  createBaseVNode("button", {
                    class: "px-2 py-0.5 border rounded cc-addr -my-1",
                    tabindex: "1",
                    onClick: doShowTransactions,
                    disabled: unref(isLoadingRawReportingData)
                  }, toDisplayString(_showTransactions.value ? "Hide" : "Show") + " Transactions ", 9, _hoisted_9$1)
                ])
              ])
            ]),
            _cache[0] || (_cache[0] = createBaseVNode("div", { class: "flex-grow flex-shrink" }, null, -1))
          ])
        ], 2)) : createCommentVNode("", true),
        _showTransactions.value ? (openBlock(), createBlock(_sfc_main$b, {
          key: 1,
          "entity-id": unref(accountId)
        }, null, 8, ["entity-id"])) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const _hoisted_1$9 = {
  key: 0,
  class: "ReportWalletListButton relative flex flex-col flex-nowrap"
};
const _hoisted_2$9 = { class: "flex-grow flex-shrink flex flex-row flex-nowrap justify-start items-center cursor-pointer" };
const _hoisted_3$8 = { class: "relative h-full flex flex-col flex-nowrap justify-center space-y-0.5 ml-2" };
const _hoisted_4$8 = {
  class: "relative cc-text-sz cc-text-bold mr-1 flex-1 flex items-center justify-between",
  style: { "line-height": "0.9rem" }
};
const _hoisted_5$5 = {
  class: "break-all text-sm cc-text-semi-bold",
  style: { "line-height": "0.9rem" }
};
const _hoisted_6$4 = {
  key: 0,
  class: "mdi mdi-cash-lock text-md ml-px cc-text-highlight",
  style: { "line-height": "0.1rem" }
};
const _hoisted_7$3 = {
  key: 1,
  class: "mdi mdi-circle text-xs ml-px cc-text-green",
  style: { "line-height": "0.1rem" }
};
const _sfc_main$9 = /* @__PURE__ */ defineComponent({
  __name: "ReportWalletListButton",
  props: {
    walletId: { type: String, required: true }
  },
  emits: ["select"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { walletId } = toRefs(props);
    const appWallet = useAppWallet(walletId);
    useQuasar();
    const { c } = useTranslation();
    const syncInfo = computed(() => {
      var _a;
      return (_a = appWallet.value) == null ? void 0 : _a.syncInfo;
    });
    computed(() => {
      var _a;
      return (_a = syncInfo.value) == null ? void 0 : _a.error;
    });
    computed(() => {
      var _a;
      return ((_a = syncInfo.value) == null ? void 0 : _a.state) === SyncState.syncing;
    });
    const showWalletGroup = ref(true);
    const toggleShow = () => {
      showWalletGroup.value = !showWalletGroup.value;
    };
    function onClickedOpen() {
      emit("select", props.walletId);
      toggleShow();
    }
    return (_ctx, _cache) => {
      var _a, _b, _c;
      return ((_a = unref(appWallet)) == null ? void 0 : _a.data) ? (openBlock(), createElementBlock("div", _hoisted_1$9, [
        createBaseVNode("div", {
          class: normalizeClass(["relative flex flex-row flex-nowrap space-x-px justify-between items-center cursor-pointer py-2 sm:py-2.5 mb-px cc-bg-light-0 border-l-4 pl-2.5 pr-1.5", unref(appWallet).isSelectedWallet ? unref(c)("border") : unref(c)("hover")]),
          onKeydown: [
            _cache[0] || (_cache[0] = withKeys(($event) => onClickedOpen(), ["enter"])),
            _cache[1] || (_cache[1] = withKeys(($event) => onClickedOpen(), ["space"]))
          ],
          onClick: _cache[2] || (_cache[2] = withModifiers(($event) => onClickedOpen(), ["stop"])),
          tabindex: "0"
        }, [
          createBaseVNode("div", _hoisted_2$9, [
            createBaseVNode("div", _hoisted_3$8, [
              createBaseVNode("div", _hoisted_4$8, [
                createBaseVNode("div", _hoisted_5$5, [
                  createTextVNode(toDisplayString((_b = unref(appWallet)) == null ? void 0 : _b.data.settings.name) + " ", 1),
                  unref(appWallet).isReadOnly ? (openBlock(), createElementBlock("i", _hoisted_6$4)) : createCommentVNode("", true),
                  unref(appWallet).isDappWallet ? (openBlock(), createElementBlock("i", _hoisted_7$3)) : createCommentVNode("", true)
                ])
              ])
            ]),
            _cache[3] || (_cache[3] = createBaseVNode("div", { class: "flex-grow flex-shrink" }, null, -1))
          ])
        ], 34),
        (openBlock(true), createElementBlock(Fragment, null, renderList(((_c = unref(appWallet)) == null ? void 0 : _c.accountList) ?? [], (appAccount) => {
          return openBlock(), createElementBlock("div", {
            key: "accountList_" + unref(walletId) + "_" + appAccount.id
          }, [
            showWalletGroup.value ? (openBlock(), createBlock(_sfc_main$a, {
              key: 0,
              "wallet-id": unref(walletId),
              "account-id": appAccount.id
            }, null, 8, ["wallet-id", "account-id"])) : createCommentVNode("", true)
          ]);
        }), 128))
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$8 = { class: "truncate flex flex-row flex-nowrap justify-center items-center" };
const _hoisted_2$8 = { class: "cc-text-bold" };
const _sfc_main$8 = /* @__PURE__ */ defineComponent({
  __name: "ReportWalletListGroup",
  props: {
    groupName: { type: String, required: true },
    walletIdList: { type: Array, required: true }
  },
  emits: ["select"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const showWalletGroup = ref(true);
    const toggleShow = () => {
      showWalletGroup.value = !showWalletGroup.value;
    };
    const onSelectWallet = (walletId) => {
      emit("select", walletId);
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createBaseVNode("div", {
          class: normalizeClass(["ReportWalletListGroup relative flex flex-row justify-between items-center cc-text-sz sm:cc-text-sx cc-nav-group pl-2 h-8 border-t border-b mb-px border-l-4 cursor-pointer", showWalletGroup.value ? "border-b" : ""]),
          onClick: withModifiers(toggleShow, ["stop"])
        }, [
          createBaseVNode("div", _hoisted_1$8, [
            createBaseVNode("i", {
              class: normalizeClass(["relative mr-1 text-xl", showWalletGroup.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"]),
              tabindex: "0",
              onKeydown: [
                withKeys(toggleShow, ["enter"]),
                withKeys(toggleShow, ["space"])
              ]
            }, null, 34),
            createBaseVNode("span", null, "(" + toDisplayString(__props.walletIdList.length) + ") ", 1),
            createBaseVNode("span", _hoisted_2$8, toDisplayString(__props.groupName), 1)
          ])
        ], 2),
        (openBlock(true), createElementBlock(Fragment, null, renderList(__props.walletIdList, (id) => {
          return openBlock(), createElementBlock("div", {
            key: "walletList_" + id
          }, [
            showWalletGroup.value ? (openBlock(), createBlock(_sfc_main$9, {
              key: 0,
              "wallet-id": id,
              onSelect: onSelectWallet
            }, null, 8, ["wallet-id"])) : createCommentVNode("", true)
          ]);
        }), 128))
      ], 64);
    };
  }
});
const _hoisted_1$7 = { class: "col-span-12 flex flex-row gap-2" };
const _hoisted_2$7 = {
  class: "p-4 col-span-2 rounded-xl",
  tabindex: "2"
};
const _hoisted_3$7 = {
  class: "p-4 col-span-2 rounded-xl",
  tabindex: "2"
};
const _hoisted_4$7 = {
  class: "p-4 col-span-2 rounded-xl",
  tabindex: "2"
};
const _sfc_main$7 = /* @__PURE__ */ defineComponent({
  __name: "ReportTimeChanger",
  setup(__props) {
    const {
      year: year2,
      month: month2,
      day: day2,
      prevYear: prevYear2,
      nextYear: nextYear2,
      prevMonth: prevMonth2,
      nextMonth: nextMonth2,
      prevDay: prevDay2,
      nextDay: nextDay2
    } = useReportTimeChanger();
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$7, [
        createBaseVNode("button", {
          class: "p-4 col-span-2 rounded-xl border hover:border-amber-400",
          tabindex: "0",
          onClick: _cache[0] || (_cache[0] = ($event) => unref(prevDay2)())
        }, "-"),
        createBaseVNode("div", _hoisted_2$7, toDisplayString(unref(day2)), 1),
        createBaseVNode("button", {
          class: "p-4 col-span-2 rounded-xl border hover:border-amber-400",
          tabindex: "1",
          onClick: _cache[1] || (_cache[1] = ($event) => unref(nextDay2)())
        }, "+"),
        createBaseVNode("button", {
          class: "p-4 col-span-2 rounded-xl border hover:border-amber-400",
          tabindex: "2",
          onClick: _cache[2] || (_cache[2] = ($event) => unref(prevMonth2)())
        }, "-"),
        createBaseVNode("div", _hoisted_3$7, toDisplayString(unref(month2)), 1),
        createBaseVNode("button", {
          class: "p-4 col-span-2 rounded-xl border hover:border-amber-400",
          tabindex: "3",
          onClick: _cache[3] || (_cache[3] = ($event) => unref(nextMonth2)())
        }, "+"),
        createBaseVNode("button", {
          class: "p-4 col-span-2 rounded-xl border hover:border-amber-400",
          tabindex: "4",
          onClick: _cache[4] || (_cache[4] = ($event) => unref(prevYear2)())
        }, "-"),
        createBaseVNode("div", _hoisted_4$7, toDisplayString(unref(year2)), 1),
        createBaseVNode("button", {
          class: "p-4 col-span-2 rounded-xl border hover:border-amber-400",
          tabindex: "5",
          onClick: _cache[5] || (_cache[5] = ($event) => unref(nextYear2)())
        }, "+")
      ]);
    };
  }
});
const _hoisted_1$6 = { class: "col-span-12 grid grid-cols-12 gap-2" };
const _hoisted_2$6 = { class: "col-span-12 flex flex-row gap-2" };
const _hoisted_3$6 = ["disabled"];
const _hoisted_4$6 = ["disabled"];
const _hoisted_5$4 = ["disabled"];
const _hoisted_6$3 = { class: "col-span-12 relative" };
const _sfc_main$6 = /* @__PURE__ */ defineComponent({
  __name: "ReportWalletList",
  setup(__props) {
    const {
      uiSelectedWalletId,
      uiSelectedAccountId,
      setUiSelectedWalletId,
      setUiSelectedAccountId
    } = useUiSelectedAccount();
    const {
      appWallet,
      appAccount
    } = useWalletAccount(uiSelectedWalletId, uiSelectedAccountId);
    useTranslation();
    const $q = useQuasar();
    const {
      year: year2,
      month: month2,
      minSlotOfYear: minSlotOfYear2,
      maxSlotOfYear: maxSlotOfYear2
    } = useReportTimeChanger();
    const inputRef = ref(null);
    const walletGroupNameList2 = computed(() => {
      var _a, _b;
      const list = ((_a = selectedEntityGroup.value) == null ? void 0 : _a.walletGroupNameList.concat()) ?? [];
      const entityGroupIdList = ((_b = selectedEntityGroup.value) == null ? void 0 : _b.entityGroupIdList) ?? [];
      for (const entityGroupId of entityGroupIdList) {
        const entityGroup = entityGroupList.value.find((g) => g.id === entityGroupId);
        if (entityGroup) {
          for (const walletGroupName of entityGroup.walletGroupNameList) {
            if (!list.includes(walletGroupName)) {
              list.push(walletGroupName);
            }
          }
        }
      }
      list.sort((a, b) => a.localeCompare(b, "en-US"));
      return list;
    });
    const _stopSync = ref(false);
    const doUpdateRawData = async () => {
      _stopSync.value = false;
      for (const groupName of walletGroupNameList2.value) {
        console.log("groupName", groupName);
        console.log("walletGroupMap", walletGroupMap.value);
        const walletIdList = walletGroupMap.value[groupName];
        if (!walletIdList) {
          continue;
        }
        for (const walletId of walletIdList) {
          if (_stopSync.value) {
            break;
          }
          const appWallet2 = getIAppWallet(walletId);
          console.log("appWallet", groupName, appWallet2 == null ? void 0 : appWallet2.data.settings.name, walletId);
          if (!appWallet2) {
            continue;
          }
          for (const appAccount2 of appWallet2.accountList) {
            if (_stopSync.value) {
              break;
            }
            await loadRawDataRewards(appAccount2);
          }
        }
      }
      _stopSync.value = false;
    };
    const doLoadRawReportingData = async () => {
      _stopSync.value = false;
      for (const groupName of walletGroupNameList2.value) {
        console.log("groupName", groupName);
        console.log("walletGroupMap", walletGroupMap.value);
        const walletIdList = walletGroupMap.value[groupName];
        if (!walletIdList) {
          continue;
        }
        for (const walletId of walletIdList) {
          if (_stopSync.value) {
            break;
          }
          const appWallet2 = getIAppWallet(walletId);
          console.log("appWallet", groupName, appWallet2 == null ? void 0 : appWallet2.data.settings.name, walletId);
          if (!appWallet2) {
            continue;
          }
          for (const appAccount2 of appWallet2.accountList) {
            if (_stopSync.value) {
              break;
            }
            await loadRawData(appAccount2, minSlotOfYear2.value, maxSlotOfYear2.value, _stopSync, false);
          }
        }
      }
      _stopSync.value = false;
      await doUpdateRawData();
    };
    const onSelectWallet = (walletId) => {
      setUiSelectedWalletId(walletId);
      nextTick(() => {
        var _a;
        if ((_a = appWallet.value) == null ? void 0 : _a.data.wallet.accountList.some((a) => a.id === "xpub1u4ej37k66sv")) {
          setUiSelectedAccountId("xpub1u4ej37k66sv");
        }
      });
    };
    const stopCreateReport = () => {
      _stopSync.value = true;
    };
    const doSave = async () => {
      var _a;
      const { downloadText } = useDownload();
      let _month2 = month2.value.toString().padStart(2, "0");
      if (_month2 === "00") {
        _month2 = "";
      } else {
        _month2 = "-" + _month2;
      }
      const name = year2.value + _month2 + "-raw-data-" + (((_a = selectedEntityGroup.value) == null ? void 0 : _a.id) ?? "unknown") + ".json";
      await downloadText(JSON.stringify(saveRawData(minSlotOfYear2.value, maxSlotOfYear2.value), null, 2), name);
    };
    const doReset = () => clearRawData();
    const processFile = (jsonObj) => {
      if (!(jsonObj == null ? void 0 : jsonObj.rawData) || typeof jsonObj.rawData !== "object") {
        showNotificationError("Invalid file format");
        return;
      }
      const rawData = jsonObj.rawData;
      const numTxAdded = addRawData(rawData);
      for (const accountId in numTxAdded) {
        if (numTxAdded[accountId] === 0) {
          continue;
        }
        if (numTxAdded[accountId] === -1) {
          showNotificationError("Invalid file format: " + accountId);
          continue;
        }
      }
    };
    function doImport() {
      if (inputRef.value) inputRef.value.click();
    }
    const onHandleFileSelect = async (e) => {
      const files = e.target.files;
      const calls = [];
      for (const file of files) {
        if (!file.type.match("application/json")) {
          showNotificationWarning("Unsupported file type: " + file.type);
          continue;
        }
        calls.push(loadFile(file));
      }
      const loadedFiles = await Promise.all(calls);
      for (const file of loadedFiles) {
        processFile(file);
      }
    };
    onMounted(() => {
      if (inputRef.value) {
        inputRef.value.addEventListener("change", onHandleFileSelect, false);
      }
    });
    onUnmounted(() => {
      _stopSync.value = true;
    });
    const showNotificationError = (msg) => {
      $q.notify({
        message: msg,
        type: "warning",
        position: "top-left",
        timeout: 8e3,
        closeBtn: true,
        progress: true
      });
    };
    const showNotificationWarning = (msg) => {
      $q.notify({
        message: msg,
        type: "warning",
        position: "top-left",
        timeout: 8e3,
        closeBtn: true,
        progress: true
      });
    };
    const loadFile = (file) => {
      const reader = new FileReader();
      return new Promise(async (resolve, reject) => {
        reader.onload = async (re) => {
          try {
            const loadedFile = JSON.parse(re.target.result);
            return resolve(loadedFile);
          } catch (err) {
            showNotificationError("Could not parse: " + (file == null ? void 0 : file.name));
            console.error("Could not parse:", file == null ? void 0 : file.name);
          }
          return reject("error 1");
        };
        reader.onerror = () => {
          showNotificationError("Could not load: " + (file == null ? void 0 : file.name));
          return reject("error 2");
        };
        reader.onabort = () => {
          showNotificationError("Could not load: " + (file == null ? void 0 : file.name));
          return reject("error 3");
        };
        reader.readAsText(file);
      });
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$6, [
        createBaseVNode("div", _hoisted_2$6, [
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "1",
            onClick: doLoadRawReportingData,
            disabled: unref(isLoadingRawReportingData)
          }, "Load Raw Data", 8, _hoisted_3$6),
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "1",
            onClick: doUpdateRawData,
            disabled: unref(isLoadingRawReportingData)
          }, "Update Data", 8, _hoisted_4$6),
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "2",
            onClick: doSave
          }, "Save Raw Data"),
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "3",
            onClick: doReset
          }, "Reset"),
          createBaseVNode("input", {
            type: "file",
            id: "files",
            name: "files[]",
            multiple: "",
            ref_key: "inputRef",
            ref: inputRef,
            hidden: ""
          }, null, 512),
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "4",
            onClick: doImport
          }, "Import Raw Data"),
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "5",
            onClick: stopCreateReport,
            disabled: !unref(isLoadingRawReportingData)
          }, "Stop", 8, _hoisted_5$4)
        ]),
        createVNode(_sfc_main$7),
        createBaseVNode("div", _hoisted_6$3, [
          (openBlock(true), createElementBlock(Fragment, null, renderList(walletGroupNameList2.value, (groupName) => {
            return openBlock(), createBlock(_sfc_main$8, {
              "group-name": groupName,
              "wallet-id-list": unref(walletGroupMap)[groupName] ?? [],
              onSelect: onSelectWallet
            }, null, 8, ["group-name", "wallet-id-list"]);
          }), 256))
        ])
      ]);
    };
  }
});
const { formatDatetime } = useFormatter();
const createMetadataCSVFile = (networkId2, _balanceList, target, useLocalTimezone = false, includeTxNotes = false) => {
  var _a, _b, _c;
  const fields = target.fields.concat();
  if (includeTxNotes) {
    fields.push("Note");
  }
  const n = "\n";
  const sep = ",";
  const adaSeparator = target.adaSeparator;
  let csv = fields.join(sep) + n;
  const balanceList = [..._balanceList];
  sortRawBalanceList(balanceList);
  for (const balance of balanceList) {
    if (!((_a = balance.a) == null ? void 0 : _a.coin)) throw new Error("Transaction malformed.");
    const splitFee = !!balance.a.hasInputs;
    let total = balance.a.coin ?? "0";
    let fee = "";
    if (splitFee) {
      fee = balance.f ?? "0";
      total = subtract(total, neg(fee));
      fee = '"' + divide(abs(fee), 1e6, 6).split(".").join(adaSeparator) + '"';
    }
    const value = '"' + divide(abs(total), 1e6, 6).split(".").join(adaSeparator) + '"';
    const isNeg = isLessThanZero(total);
    const isPos = isGreaterThanZero(total);
    const al = balance.al ?? [];
    const el = balance.el ?? [];
    const msg = el.join(", ") + (el.length > 0 && al.length > 0 ? " - " : "") + al.join(", ");
    csv += createLine(networkId2, fields, balance, useLocalTimezone, value, isNeg, isPos, fee, "ADA", msg, sep);
    csv += n;
    if (balance.a.multiasset) {
      for (const policyId in balance.a.multiasset) {
        const assetMap = balance.a.multiasset[policyId];
        for (const assetName in assetMap) {
          let quantity = assetMap[assetName];
          const ai = getAssetInfoLight(policyId, assetName);
          const name = ((_b = ai == null ? void 0 : ai.tr) == null ? void 0 : _b.n) ?? (ai == null ? void 0 : ai.n) ?? "";
          if ((_c = ai == null ? void 0 : ai.tr) == null ? void 0 : _c.d) {
            console.log(name, quantity, ai.tr.d, divide(quantity, Math.pow(10, ai.tr.d ?? 0)));
            quantity = divide(quantity, Math.pow(10, ai.tr.d ?? 0));
          }
          const isNeg2 = isLessThanZero(quantity);
          const isPos2 = isGreaterThanZero(quantity);
          const total2 = '"' + quantity.split(".").join(adaSeparator) + '"';
          csv += createLine(networkId2, fields, balance, useLocalTimezone, total2, isNeg2, isPos2, "", name, policyId + "." + assetName, sep);
          csv += n;
        }
      }
    }
  }
  return csv;
};
const createLine = (networkId2, fields, balance, useLocalTimezone, value, isNeg, isPos, fee, unit, msg, sep) => {
  console.log("createLine", networkId2, fields, balance, useLocalTimezone, value, fee, unit, msg, sep);
  const numFields = fields.length;
  let csv = "";
  for (let i = 0; i < numFields; i++) {
    const field = fields[i];
    switch (field) {
      case "Date":
      case "Koinly Date":
        const slotTime = new Date(getTimestampFromSlot(networkId2, balance.s));
        if (!useLocalTimezone) {
          csv += formatDatetime(slotTime, true, true, true);
        } else {
          const time = new Date(slotTime.getTime() - (/* @__PURE__ */ new Date()).getTimezoneOffset() * 6e4);
          csv += '"' + formatDatetime(time, true, true, true) + '"';
        }
        break;
      case "Sent Amount":
        if (isNeg) csv += value;
        break;
      case "Received Amount":
        if (isPos) csv += value;
        break;
      case "Amount":
        csv += isNeg ? "-" + value : value;
        break;
      case "Fee Amount":
        if (fee !== "" && fee !== "0")
          csv += fee;
        break;
      case "Net Worth Amount":
        break;
      case "Sent Currency":
        if (isNeg) csv += '"' + unit + '"';
        break;
      case "Received Currency":
        if (isPos) csv += '"' + unit + '"';
        break;
      case "Currency":
      case "Fee Currency":
        if (fee !== "" && fee !== "0") csv += '"' + unit + '"';
        break;
      case "Net Worth Currency":
        csv += '"' + unit + '"';
        break;
      case "Label":
        break;
      case "Description":
        if (msg && msg.length > 0) {
          csv += '"' + msg + '"';
        }
        break;
      case "TxHash":
        csv += '"' + balance.h + '"';
        break;
    }
    if (i <= numFields - 2) {
      csv += sep;
    }
  }
  return csv;
};
const _hoisted_1$5 = { class: "w-full col-span-12 grid grid-cols-12 cc-gap" };
const _hoisted_2$5 = { class: "col-span-12 grid grid-cols-12 cc-gap" };
const _hoisted_3$5 = ["selected", "value"];
const _hoisted_4$5 = { class: "col-span-12 flex flex-row flex-nowrap gap-2 justify-between" };
const _sfc_main$5 = /* @__PURE__ */ defineComponent({
  __name: "ReportExportCSVMeta",
  props: {
    textId: { type: String, required: false, default: "wallet.settings.exports" },
    entityId: { type: String, required: true }
  },
  setup(__props) {
    const props = __props;
    const $q = useQuasar();
    const { it } = useTranslation();
    const { downloadText } = useDownload();
    const {
      getCSVTarget,
      getCSVTargetList
    } = useCSVExport();
    const exportTargets = getCSVTargetList();
    const selectedTargetId = ref(ICSVExportTargetId.universal);
    const timezoneToggle = ref(false);
    function onExportTargetChange(event) {
      selectedTargetId.value = exportTargets[event.target.options.selectedIndex].id;
    }
    async function doExportCSV() {
      const allMetaData = getAllMetaData();
      const metaData = allMetaData[props.entityId];
      if (!metaData) {
        showError("No metadata available.");
        return;
      }
      const target = getCSVTarget(selectedTargetId.value);
      await doLoadMissingAssetInfo(metaData.balanceList);
      const csv = createMetadataCSVFile(networkId.value, metaData.balanceList, target, timezoneToggle.value);
      const fileName = "eternlio-entity-" + props.entityId + "-meta-" + target.id + ".csv";
      await downloadText(csv, fileName);
    }
    function showError(msg) {
      $q.notify({
        type: "negative",
        message: msg,
        position: "top-left",
        timeout: 4e3
      });
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$5, [
        createBaseVNode("div", _hoisted_2$5, [
          createVNode(_sfc_main$i, {
            label: unref(it)(__props.textId + ".csv.headline")
          }, null, 8, ["label"]),
          createVNode(_sfc_main$j, {
            text: unref(it)(__props.textId + ".csv.caption")
          }, null, 8, ["text"]),
          createVNode(_sfc_main$i, {
            label: unref(it)(__props.textId + ".csv.format")
          }, null, 8, ["label"]),
          createBaseVNode("select", {
            class: "col-span-12 md:col-span-6 cc-rounded-la cc-dropdown cc-text-sm",
            required: true,
            onChange: _cache[0] || (_cache[0] = ($event) => onExportTargetChange($event))
          }, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(unref(exportTargets), (target) => {
              return openBlock(), createElementBlock("option", {
                selected: target.id === selectedTargetId.value,
                value: target.label
              }, toDisplayString(target.label), 9, _hoisted_3$5);
            }), 256))
          ], 32),
          createVNode(_sfc_main$i, {
            label: unref(it)(__props.textId + ".csv.localTime.label")
          }, null, 8, ["label"]),
          createBaseVNode("div", _hoisted_4$5, [
            createVNode(_sfc_main$j, {
              class: "shrink",
              text: unref(it)(__props.textId + ".csv.localTime.caption")
            }, null, 8, ["text"]),
            createVNode(QToggle_default, {
              modelValue: timezoneToggle.value,
              "onUpdate:modelValue": _cache[1] || (_cache[1] = ($event) => timezoneToggle.value = $event)
            }, null, 8, ["modelValue"])
          ]),
          createVNode(GridButtonSecondary, {
            class: "col-span-12 h-10 mt-1",
            link: doExportCSV,
            label: unref(it)(__props.textId + ".csv.button.label"),
            icon: unref(it)(__props.textId + ".csv.button.icon")
          }, null, 8, ["label", "icon"])
        ])
      ]);
    };
  }
});
const _hoisted_1$4 = { class: "col-span-12 grid grid-cols-12 gap-2" };
const _hoisted_2$4 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between cc-bg-white-0 border-b cc-p" };
const _hoisted_3$4 = { class: "flex flex-col cc-text-sz" };
const _hoisted_4$4 = { class: "m-2 sm:m-4" };
const _hoisted_5$3 = { class: "col-span-12 flex flex-row gap-2" };
const _sfc_main$4 = /* @__PURE__ */ defineComponent({
  __name: "ReportEntityBalanceList",
  setup(__props) {
    const { it, t } = useTranslation();
    const $q = useQuasar();
    const filteredAccountId = ref("");
    const filteredSCData = ref(null);
    const onChangeFilterBySC = (metaData) => {
      filteredSCData.value = metaData;
    };
    const onChangeFilterByAccountId = (accountId) => {
      filteredAccountId.value = accountId;
    };
    const {
      year: year2,
      month: month2,
      minSlotOfYear: minSlotOfYear2,
      maxSlotOfYear: maxSlotOfYear2
    } = useReportTimeChanger();
    const showExportModal = ref(false);
    const onClose = () => {
      showExportModal.value = false;
    };
    const inputRef = ref(null);
    const walletGroupNameList2 = computed(() => {
      var _a, _b;
      const list = ((_a = selectedEntityGroup.value) == null ? void 0 : _a.walletGroupNameList.concat()) ?? [];
      const entityGroupIdList = ((_b = selectedEntityGroup.value) == null ? void 0 : _b.entityGroupIdList) ?? [];
      for (const entityGroupId of entityGroupIdList) {
        const entityGroup = entityGroupList.value.find((g) => g.id === entityGroupId);
        if (entityGroup) {
          for (const walletGroupName of entityGroup.walletGroupNameList) {
            if (!list.includes(walletGroupName)) {
              list.push(walletGroupName);
            }
          }
        }
      }
      list.sort((a, b) => a.localeCompare(b, "en-US"));
      return list;
    });
    const doSave = async () => {
      var _a;
      const entity = selectedEntityGroup.value;
      if (!entity) {
        return;
      }
      const { downloadText } = useDownload();
      let _month2 = month2.value.toString().padStart(2, "0");
      if (_month2 === "00") {
        _month2 = "";
      } else {
        _month2 = "-" + _month2;
      }
      const name = year2.value + _month2 + "-meta-data-" + (((_a = selectedEntityGroup.value) == null ? void 0 : _a.id) ?? "unknown") + ".json";
      await downloadText(JSON.stringify(saveMetaData(entity.id, minSlotOfYear2.value, maxSlotOfYear2.value), null, 2), name);
    };
    const doReset = () => clearMetaData();
    const _entityRawData = ref();
    const doUpdate = async () => {
      const entity = selectedEntityGroup.value;
      if (!entity) {
        return;
      }
      const metaData = getMetaData(entity.id);
      console.log("year", year2.value);
      console.log("minSlotOfYear", minSlotOfYear2.value);
      console.log("maxSlotOfYear", maxSlotOfYear2.value);
      console.log("rawData.balanceList", entity.id);
      for (const data of metaData.balanceList) {
        for (const cb of data.cb) {
          if (cb.t === "r") {
            cb.t = "i";
          }
        }
        if (data.t === ITxBalanceType.rewards) {
          for (const cb of data.cb) {
            if (cb.t === "i") {
              cb.t = "r";
            }
          }
        }
        for (const cb of data.cb) {
          if (cb.t === "i" || cb.t === "f" || cb.t === "r" || cb.t === "p") {
            cb.pd = 0;
            const dateId = getDateIdFromSlot("mainnet", data.s, appTimezone.value);
            addPriceOfDay(cb, dateId, "EUR");
          }
        }
      }
    };
    const doCreateMetaData = async () => {
      const entity = selectedEntityGroup.value;
      if (!entity) {
        return;
      }
      const accountIdList = [];
      for (const groupName of walletGroupNameList2.value) {
        const walletIdList = walletGroupMap.value[groupName];
        if (!walletIdList) {
          continue;
        }
        for (const walletId of walletIdList) {
          const appWallet = getIAppWallet(walletId);
          if (!appWallet) {
            continue;
          }
          for (const appAccount of appWallet.accountList) {
            accountIdList.push(appAccount.id);
          }
        }
      }
      _entityRawData.value = await combineData(entity.id, minSlotOfYear2.value, maxSlotOfYear2.value, accountIdList);
    };
    let _firstImport = true;
    const processFile = (jsonObj) => {
      if (!(jsonObj == null ? void 0 : jsonObj.metaData) || typeof jsonObj.metaData !== "object") {
        showNotificationError("Invalid file format");
        return;
      }
      const data = jsonObj.metaData;
      const numTxAdded = setMetaData(data, _firstImport);
      for (const accountId in numTxAdded) {
        if (numTxAdded[accountId] === 0) {
          continue;
        }
        if (numTxAdded[accountId] === -1) {
          showNotificationError("Invalid file format: " + accountId);
          continue;
        }
      }
    };
    function doImport() {
      if (inputRef.value) inputRef.value.click();
    }
    const onHandleFileSelect = async (e) => {
      const files = e.target.files;
      const calls = [];
      for (const file of files) {
        if (!file.type.match("application/json")) {
          showNotificationWarning("Unsupported file type: " + file.type);
          continue;
        }
        calls.push(loadFile(file));
      }
      const loadedFiles = await Promise.all(calls);
      for (const file of loadedFiles) {
        processFile(file);
      }
      _firstImport = false;
      inputRef.value.value = null;
    };
    onMounted(() => {
      if (inputRef.value) {
        inputRef.value.addEventListener("change", onHandleFileSelect, false);
      }
    });
    const showNotificationError = (msg) => {
      $q.notify({
        message: msg,
        type: "warning",
        position: "top-left",
        timeout: 8e3,
        closeBtn: true,
        progress: true
      });
    };
    const showNotificationWarning = (msg) => {
      $q.notify({
        message: msg,
        type: "warning",
        position: "top-left",
        timeout: 8e3,
        closeBtn: true,
        progress: true
      });
    };
    const loadFile = (file) => {
      const reader = new FileReader();
      return new Promise(async (resolve, reject) => {
        reader.onload = async (re) => {
          try {
            const loadedFile = JSON.parse(re.target.result);
            return resolve(loadedFile);
          } catch (err) {
            showNotificationError("Could not parse: " + (file == null ? void 0 : file.name));
            console.error("Could not parse:", file == null ? void 0 : file.name);
          }
          return reject("error 1");
        };
        reader.onerror = () => {
          showNotificationError("Could not load: " + (file == null ? void 0 : file.name));
          return reject("error 2");
        };
        reader.onabort = () => {
          showNotificationError("Could not load: " + (file == null ? void 0 : file.name));
          return reject("error 3");
        };
        reader.readAsText(file);
      });
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$4, [
        showExportModal.value ? (openBlock(), createBlock(Modal, {
          key: 0,
          narrow: "",
          onClose
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_2$4, [
              createBaseVNode("div", _hoisted_3$4, [
                createVNode(_sfc_main$i, {
                  label: unref(it)("preferences.exports.transactions.modalHeader"),
                  "do-capitalize": ""
                }, null, 8, ["label"]),
                createVNode(_sfc_main$j, {
                  text: unref(it)("preferences.exports.transactions.modalSubHeader")
                }, null, 8, ["text"])
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_4$4, [
              unref(selectedEntityGroup) ? (openBlock(), createBlock(_sfc_main$5, {
                key: 0,
                "entity-id": unref(selectedEntityGroup).id
              }, null, 8, ["entity-id"])) : createCommentVNode("", true)
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_5$3, [
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "1",
            onClick: doCreateMetaData
          }, "Create Meta Data"),
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "2",
            onClick: doSave
          }, "Save Metadata"),
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "3",
            onClick: doReset
          }, "Reset"),
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "4",
            onClick: doImport
          }, "Import Meta Data"),
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "4",
            onClick: doUpdate
          }, "Update Meta Data"),
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "4",
            onClick: _cache[0] || (_cache[0] = ($event) => showExportModal.value = true)
          }, "Export CSV"),
          createBaseVNode("input", {
            type: "file",
            id: "files",
            name: "files[]",
            multiple: "",
            ref_key: "inputRef",
            ref: inputRef,
            hidden: ""
          }, null, 512)
        ]),
        createVNode(_sfc_main$7),
        unref(selectedEntityGroup) ? (openBlock(), createBlock(_sfc_main$b, {
          key: 1,
          "entity-id": unref(selectedEntityGroup).id,
          onFilterByAccountId: onChangeFilterByAccountId,
          onFilterBySc: onChangeFilterBySC
        }, null, 8, ["entity-id"])) : createCommentVNode("", true)
      ]);
    };
  }
});
const _hoisted_1$3 = { class: "col-span-12 grid grid-cols-12 gap-2" };
const _hoisted_2$3 = {
  key: 0,
  class: "relative col-span-12 p-2 cc-text-sz flex flex-col flex-grow flex-nowrap gap-2"
};
const _hoisted_3$3 = { class: "flex flex-row flex-nowrap justify-between items-start" };
const _hoisted_4$3 = { class: "h-full pr-1 flex flex-col self-start" };
const _hoisted_5$2 = { class: "cc-flex-fixed flex flex-row flex-nowrap items-start" };
const _hoisted_6$2 = { class: "mt-1.5 mr-2 cc-addr break-normal" };
const _hoisted_7$2 = { class: "h-full w-full pr-1 flex flex-col self-start gap-2" };
const _hoisted_8$1 = { key: 1 };
const _hoisted_9 = { key: 3 };
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "ReportReportList",
  props: {
    report: { type: Object, required: true },
    // reportType:                 { type: String as () => 'total' | 'in' | 'out' | 'rewards', required: true },
    entityId: { type: String, required: false, default: "" },
    assetLimit: { type: Number, required: false, default: 2 },
    isLastItem: { type: Boolean, required: false, default: false },
    showPassThrough: { type: Boolean, required: false, default: true },
    showTokens: { type: Boolean, required: false, default: true },
    showDeposit: { type: Boolean, required: false, default: true },
    showTxFee: { type: Boolean, required: false, default: true },
    showRewards: { type: Boolean, required: false, default: true },
    showIncome: { type: Boolean, required: false, default: true },
    showNeutral: { type: Boolean, required: false, default: true },
    showBought: { type: Boolean, required: false, default: true }
  },
  emits: ["filterByAccount"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const { formatDatetime: formatDatetime2 } = useFormatter();
    const {
      report
      // reportType
    } = toRefs(props);
    const blockTime = ref(getTimestampFromSlot(networkId.value, report.value.slotStart));
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$3, [
        unref(report) ? (openBlock(), createElementBlock("div", _hoisted_2$3, [
          createBaseVNode("div", _hoisted_3$3, [
            createBaseVNode("div", _hoisted_4$3, [
              createBaseVNode("div", _hoisted_5$2, [
                createBaseVNode("div", _hoisted_6$2, toDisplayString(unref(formatDatetime2)(blockTime.value, true, false)), 1)
              ])
            ]),
            createBaseVNode("div", _hoisted_7$2, [
              unref(report).in.length > 0 ? (openBlock(), createBlock(GridSpace, {
                key: 0,
                hr: "",
                label: "in",
                class: "text-neutral-500"
              })) : createCommentVNode("", true),
              unref(report).in.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_8$1, [
                (openBlock(true), createElementBlock(Fragment, null, renderList(unref(report).in, (cb) => {
                  return openBlock(), createElementBlock(Fragment, null, [
                    (cb.t === "p" && __props.showPassThrough || cb.t === "d" && __props.showDeposit || cb.t === "c" && __props.showDeposit || cb.t === "f" && __props.showTxFee || cb.t === "r" && __props.showRewards || cb.t === "i" && __props.showIncome || cb.t === "n" && __props.showNeutral || cb.t === "b" && __props.showBought) && (__props.showTokens || !__props.showTokens && !cb.au || cb.au && typeof cb.lv === "string" && !unref(isZero)(cb.lv)) ? (openBlock(), createBlock(ReportCBListEntryBalance, {
                      key: 0,
                      "cost-basis": cb,
                      class: "w-full"
                    }, null, 8, ["cost-basis"])) : createCommentVNode("", true)
                  ], 64);
                }), 256))
              ])) : createCommentVNode("", true),
              unref(report).out.length > 0 ? (openBlock(), createBlock(GridSpace, {
                key: 2,
                hr: "",
                label: "out",
                class: "text-neutral-500"
              })) : createCommentVNode("", true),
              unref(report).out.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_9, [
                (openBlock(true), createElementBlock(Fragment, null, renderList(unref(report).out, (cb) => {
                  return openBlock(), createElementBlock(Fragment, null, [
                    (cb.t === "p" && __props.showPassThrough || cb.t === "d" && __props.showDeposit || cb.t === "c" && __props.showDeposit || cb.t === "f" && __props.showTxFee || cb.t === "r" && __props.showRewards || cb.t === "i" && __props.showIncome || cb.t === "n" && __props.showNeutral || cb.t === "b" && __props.showBought) && (__props.showTokens || !__props.showTokens && !cb.au || cb.au && typeof cb.lv === "string" && !unref(isZero)(cb.lv)) ? (openBlock(), createBlock(ReportCBListEntryBalance, {
                      key: 0,
                      "cost-basis": cb,
                      class: "w-full"
                    }, null, 8, ["cost-basis"])) : createCommentVNode("", true)
                  ], 64);
                }), 256))
              ])) : createCommentVNode("", true)
            ])
          ])
        ])) : createCommentVNode("", true),
        !__props.isLastItem ? (openBlock(), createBlock(GridSpace, {
          key: 1,
          hr: ""
        })) : createCommentVNode("", true)
      ]);
    };
  }
});
const _hoisted_1$2 = { class: "col-span-12 grid grid-cols-12 cc-page-gap cc-page-px cc-page-pt cc-text-sz pb-4" };
const _hoisted_2$2 = { class: "col-span-8 grid grid-cols-12 cc-gap" };
const _hoisted_3$2 = { class: "col-span-8 flex flex-col" };
const _hoisted_4$2 = { class: "col-span-12 grid grid-cols-12 cc-page-gap" };
const _hoisted_5$1 = { class: "col-span-12 flex justify-center" };
const _hoisted_6$1 = {
  key: 0,
  class: "col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_7$1 = { class: "col-span-12 flex justify-center" };
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "ReportList",
  props: {
    entityId: { type: String, required: true },
    assetLimit: { type: Number, required: false, default: 2 }
  },
  emits: ["toggleShowPassThrough", "toggleShowTokens"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { entityId } = toRefs(props);
    const allData = getAllReportData();
    const reportData = computed(() => {
      const _entityId = entityId.value;
      if (!_entityId) {
        return null;
      }
      const data = allData[_entityId];
      if (!data) {
        return null;
      }
      return allData[_entityId];
    });
    const showRewards = ref(true);
    const showTxFee = ref(true);
    const showNeutral = ref(true);
    const showIncome = ref(true);
    const showDeposit = ref(true);
    const showPassThrough = ref(false);
    const showTokens = ref(false);
    const showBought = ref(true);
    const showData = ref("day");
    const showAllAssets = ref(false);
    const list = computed(() => {
      var _a, _b, _c;
      if (showData.value === "day") {
        return ((_a = reportData.value) == null ? void 0 : _a.dayList) ?? [];
      }
      if (showData.value === "month") {
        return ((_b = reportData.value) == null ? void 0 : _b.monthList) ?? [];
      }
      if (showData.value === "year") {
        return ((_c = reportData.value) == null ? void 0 : _c.yearList) ?? [];
      }
      return [];
    });
    const balanceList = computed(() => {
      let result = list.value;
      return result;
    });
    const numTxTotal = computed(() => balanceList.value.length);
    const numItemsPerPage = computed(() => 10);
    const numMaxPages = computed(() => Math.ceil(numTxTotal.value / numItemsPerPage.value));
    const currentPage = ref(1);
    watch(numMaxPages, () => {
      currentPage.value = 1;
    });
    const _dbPage = computed(() => (currentPage.value - 1) * numItemsPerPage.value);
    const txListPage = computed(() => {
      const numItems = balanceList.value.length;
      let endIndex = Math.min(_dbPage.value + numItemsPerPage.value, numItems);
      return balanceList.value.slice(_dbPage.value, endIndex);
    });
    onErrorCaptured((e) => {
      console.error("Transactions: onErrorCaptured", e);
      return true;
    });
    const showPagination = computed(() => numTxTotal.value > numItemsPerPage.value);
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$2, [
        createBaseVNode("div", _hoisted_2$2, [
          createBaseVNode("div", _hoisted_3$2, [
            createVNode(_sfc_main$i, {
              label: "Report List",
              class: "col-span-1"
            })
          ])
        ]),
        createVNode(GridSpace, {
          class: "col-span-12",
          hr: ""
        }),
        createVNode(GridButtonSecondary, {
          label: "Rewards",
          class: "col-span-2",
          active: showRewards.value,
          onClick: _cache[0] || (_cache[0] = ($event) => showRewards.value = !showRewards.value)
        }, null, 8, ["active"]),
        createVNode(GridButtonSecondary, {
          label: "Income",
          class: "col-span-2",
          active: showIncome.value,
          onClick: _cache[1] || (_cache[1] = ($event) => showIncome.value = !showIncome.value)
        }, null, 8, ["active"]),
        createVNode(GridButtonSecondary, {
          label: "Tx Fees",
          class: "col-span-2",
          active: showTxFee.value,
          onClick: _cache[2] || (_cache[2] = ($event) => showTxFee.value = !showTxFee.value)
        }, null, 8, ["active"]),
        createVNode(GridButtonSecondary, {
          label: "Passthrough",
          class: "col-span-2",
          active: showPassThrough.value,
          onClick: _cache[3] || (_cache[3] = ($event) => {
            showPassThrough.value = !showPassThrough.value;
            emit("toggleShowPassThrough");
          })
        }, null, 8, ["active"]),
        createVNode(GridButtonSecondary, {
          label: "Tokens",
          class: "col-span-2",
          active: showTokens.value,
          onClick: _cache[4] || (_cache[4] = ($event) => {
            showTokens.value = !showTokens.value;
            emit("toggleShowTokens");
          })
        }, null, 8, ["active"]),
        createVNode(GridButtonSecondary, {
          label: "neutral",
          class: "col-span-2",
          active: showNeutral.value,
          onClick: _cache[5] || (_cache[5] = ($event) => showNeutral.value = !showNeutral.value)
        }, null, 8, ["active"]),
        createVNode(GridButtonSecondary, {
          label: "deposit",
          class: "col-span-2",
          active: showDeposit.value,
          onClick: _cache[6] || (_cache[6] = ($event) => showDeposit.value = !showDeposit.value)
        }, null, 8, ["active"]),
        createVNode(GridButtonSecondary, {
          label: "bought",
          class: "col-span-2",
          active: showBought.value,
          onClick: _cache[7] || (_cache[7] = ($event) => showBought.value = !showBought.value)
        }, null, 8, ["active"]),
        createVNode(GridSpace, {
          class: "col-span-12",
          hr: ""
        }),
        createVNode(GridButtonSecondary, {
          label: "Show Days",
          class: "col-span-2",
          active: showData.value === "day",
          onClick: _cache[8] || (_cache[8] = ($event) => showData.value = "day")
        }, null, 8, ["active"]),
        createVNode(GridButtonSecondary, {
          label: "Show Months",
          class: "col-span-2",
          active: showData.value === "month",
          onClick: _cache[9] || (_cache[9] = ($event) => showData.value = "month")
        }, null, 8, ["active"]),
        createVNode(GridButtonSecondary, {
          label: "Show Years",
          class: "col-span-2",
          active: showData.value === "year",
          onClick: _cache[10] || (_cache[10] = ($event) => showData.value = "year")
        }, null, 8, ["active"]),
        createVNode(GridButtonSecondary, {
          label: showAllAssets.value ? "Hide Assets" : "Show Assets",
          class: "col-span-2",
          onClick: _cache[11] || (_cache[11] = ($event) => showAllAssets.value = !showAllAssets.value)
        }, null, 8, ["label"]),
        showPagination.value ? (openBlock(), createBlock(GridSpace, {
          key: 0,
          class: "col-span-12",
          hr: ""
        })) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_4$2, [
          createBaseVNode("div", _hoisted_5$1, [
            showPagination.value ? (openBlock(), createBlock(QPagination_default, {
              key: 0,
              modelValue: currentPage.value,
              "onUpdate:modelValue": _cache[12] || (_cache[12] = ($event) => currentPage.value = $event),
              max: numMaxPages.value,
              "max-pages": 6,
              "boundary-numbers": "",
              flat: "",
              color: "teal-90",
              "text-color": "teal-90",
              "active-color": "teal-90",
              "active-text-color": "teal-90",
              "active-design": "unelevated"
            }, null, 8, ["modelValue", "max"])) : createCommentVNode("", true)
          ]),
          createVNode(GridSpace, {
            class: "col-span-12",
            hr: ""
          }),
          unref(entityId) ? (openBlock(), createElementBlock("div", _hoisted_6$1, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(txListPage.value, (report) => {
              return openBlock(), createBlock(_sfc_main$3, {
                key: report.year + "-" + report.month + "-" + report.day,
                "entity-id": unref(entityId),
                report,
                "asset-limit": showAllAssets.value ? __props.assetLimit : 2,
                "show-bought": showBought.value,
                "show-deposit": showDeposit.value,
                "show-income": showIncome.value,
                "show-neutral": showNeutral.value,
                "show-pass-through": showPassThrough.value,
                "show-tokens": showTokens.value,
                "show-tx-fee": showTxFee.value,
                "show-rewards": showRewards.value
              }, null, 8, ["entity-id", "report", "asset-limit", "show-bought", "show-deposit", "show-income", "show-neutral", "show-pass-through", "show-tokens", "show-tx-fee", "show-rewards"]);
            }), 128))
          ])) : createCommentVNode("", true),
          createBaseVNode("div", _hoisted_7$1, [
            showPagination.value ? (openBlock(), createBlock(QPagination_default, {
              key: 0,
              modelValue: currentPage.value,
              "onUpdate:modelValue": _cache[13] || (_cache[13] = ($event) => currentPage.value = $event),
              max: numMaxPages.value,
              "max-pages": 6,
              "boundary-numbers": "",
              flat: "",
              color: "teal-90",
              "text-color": "teal-90",
              "active-color": "teal-90",
              "active-text-color": "teal-90",
              "active-design": "unelevated"
            }, null, 8, ["modelValue", "max"])) : createCommentVNode("", true)
          ])
        ])
      ]);
    };
  }
});
const createDatevCSVFile = (datevRowList, year2) => {
  const csvYear = year2;
  const csvExportedAt = getFormattedDate$1(/* @__PURE__ */ new Date());
  const csvStartYear = csvYear + "0101";
  const csvStartDate = csvYear + "0101";
  const csvEndDate = csvYear + "1231";
  let csv = "";
  csv += `"EXTF";700;21;"Buchungsstapel";13;${csvExportedAt};;"AG";"tk";;1;64;${csvStartYear};4;${csvStartDate};${csvEndDate};"TK - Krypto";;1;0;0;"EUR";;;;;;;;;`;
  csv += "\n";
  csv += `Umsatz (ohne Soll/Haben-Kz);"Soll/Haben-Kennzeichen";"WKZ Umsatz";"Kurs";"Basis-Umsatz";"WKZ Basis-Umsatz";"Konto";"Gegenkonto (ohne BU-Schlüssel)";"BU-Schlüssel";"Belegdatum";"Belegfeld 1";"Belegfeld 2";"Skonto";"Buchungstext";"Postensperre";"Diverse Adressnummer";"Geschäftspartnerbank";"Sachverhalt";"Zinssperre";"Beleglink";"Beleginfo - Art 1";"Beleginfo - Inhalt 1";"Beleginfo - Art 2";"Beleginfo - Inhalt 2";"Beleginfo - Art 3";"Beleginfo - Inhalt 3";"Beleginfo - Art 4";"Beleginfo - Inhalt 4";"Beleginfo - Art 5";"Beleginfo - Inhalt 5";"Beleginfo - Art 6";"Beleginfo - Inhalt 6";"Beleginfo - Art 7";"Beleginfo - Inhalt 7";"Beleginfo - Art 8";"Beleginfo - Inhalt 8";"KOST1 - Kostenstelle";"KOST2 - Kostenstelle";"Kost-Menge";"EU-Land u. UStID";"EU-Steuersatz";"Abw. Versteuerungsart";"Sachverhalt L+L";"Funktionsergänzung L+L";"BU 49 Hauptfunktionstyp";"BU 49 Hauptfunktionsnummer";"BU 49 Funktionsergänzung";"Zusatzinformation - Art 1";"Zusatzinformation- Inhalt 1";"Zusatzinformation - Art 2";"Zusatzinformation- Inhalt 2";"Zusatzinformation - Art 3";"Zusatzinformation- Inhalt 3";"Zusatzinformation - Art 4";"Zusatzinformation- Inhalt 4";"Zusatzinformation - Art 5";"Zusatzinformation- Inhalt 5";"Zusatzinformation - Art 6";"Zusatzinformation- Inhalt 6";"Zusatzinformation - Art 7";"Zusatzinformation- Inhalt 7";"Zusatzinformation - Art 8";"Zusatzinformation- Inhalt 8";"Zusatzinformation - Art 9";"Zusatzinformation- Inhalt 9";"Zusatzinformation - Art 10";"Zusatzinformation- Inhalt 10";"Zusatzinformation - Art 11";"Zusatzinformation- Inhalt 11";"Zusatzinformation - Art 12";"Zusatzinformation- Inhalt 12";"Zusatzinformation - Art 13";"Zusatzinformation- Inhalt 13";"Zusatzinformation - Art 14";"Zusatzinformation- Inhalt 14";"Zusatzinformation - Art 15";"Zusatzinformation- Inhalt 15";"Zusatzinformation - Art 16";"Zusatzinformation- Inhalt 16";"Zusatzinformation - Art 17";"Zusatzinformation- Inhalt 17";"Zusatzinformation - Art 18";"Zusatzinformation- Inhalt 18";"Zusatzinformation - Art 19";"Zusatzinformation- Inhalt 19";"Zusatzinformation - Art 20";"Zusatzinformation- Inhalt 20";"Stück";"Gewicht";"Zahlweise";"Forderungsart";"Veranlagungsjahr";"Zugeordnete Fälligkeit";"Skontotyp";"Auftragsnummer";"Buchungstyp";"USt-Schlüssel (Anzahlungen)";"EU-Land (Anzahlungen)";"Sachverhalt L+L (Anzahlungen)";"EU-Steuersatz (Anzahlungen)";"Erlöskonto (Anzahlungen)";"Herkunft-Kz";"Buchungs GUID";"KOST-Datum";"SEPA-Mandatsreferenz";"Skontosperre";"Gesellschaftername";"Beteiligtennummer";"Identifikationsnummer";"Zeichnernummer";"Postensperre bis";"Bezeichnung SoBil-Sachverhalt";"Kennzeichen SoBil-Buchung";"Festschreibung";"Leistungsdatum";"Datum Zuord. Steuerperiode"`;
  csv += "\n";
  for (const row of datevRowList) {
    csv += getDatevLine(row);
  }
  return csv;
};
const getDatevLine = (row) => {
  var _a;
  let adaAmountKind = "";
  let adaAssetKind = "";
  let adaPDKind = "";
  let adaPD = "";
  let adaAmount = "";
  let adaAsset = "";
  let tokenAmountKind = "";
  let tokenTokenNameKind = "";
  let tokenPolicyIdKind = "";
  let tokenAssetNameKind = "";
  let tokenAmount = "";
  let tokenTokenName = "";
  let tokenPolicyId = "";
  let tokenAssetName = "";
  console.log(row);
  if (row.info) {
    if (row.info.lv) {
      adaAmountKind = "Menge";
      adaAmount = getCSVADAAmount(divide(row.info.lv, "1000000"));
      adaAssetKind = "Name";
      adaAsset = "ADA";
    }
    if (row.info.pd) {
      adaPDKind = "Tagespreis";
      adaPD = getCSVAmount(row.info.pd, 5);
    }
    if (row.info.au) {
      const [policyId, assetName] = row.info.au.split(".");
      if (!(!policyId || typeof assetName !== "string")) {
        const ai = getAssetInfoLight(policyId, assetName);
        tokenAmountKind = "Menge";
        tokenAmount = row.info.av;
        tokenTokenNameKind = "Name";
        tokenTokenName = ((_a = ai == null ? void 0 : ai.tr) == null ? void 0 : _a.n) ?? (ai == null ? void 0 : ai.n) ?? "";
        tokenPolicyIdKind = "policyId";
        tokenPolicyId = policyId;
        tokenAssetNameKind = "assetName";
        tokenAssetName = assetName;
      }
    }
  }
  return `${row.a};"${row.sh}";"";;;"";${row.i};${row.o};"";${row.d};"";"";;"${row.n}";0;"";;;;"";;"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";;"";;"";;;;;;"${adaAmountKind}";"${adaAmount}";"${adaAssetKind}";"${adaAsset}";"${adaPDKind}";"${adaPD}";"${tokenAmountKind}";"${tokenAmount}";"${tokenTokenNameKind}";"${tokenTokenName}";"${tokenPolicyIdKind}";"${tokenPolicyId}";"${tokenAssetNameKind}";"${tokenAssetName}";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";"";;;;;"";"";"";0;;
`;
};
const getFormattedDate$1 = (date) => {
  const year2 = date.getFullYear();
  const month2 = String(date.getMonth() + 1).padStart(2, "0");
  const day2 = String(date.getDate()).padStart(2, "0");
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");
  const seconds = String(date.getSeconds()).padStart(2, "0");
  const milliseconds = String(date.getMilliseconds()).padStart(3, "0");
  return `${year2}${month2}${day2}${hours}${minutes}${seconds}${milliseconds}`;
};
const convertCustomDatevRows = (customDatevRows, rowMap, year2) => {
  for (const datevRowKey in customDatevRows) {
    const list = customDatevRows[datevRowKey];
    const rowList = [];
    for (const row of list) {
      const parts = row.split(";");
      rowList.push({
        a: parts[0],
        sh: parts[1],
        i: parts[2],
        o: parts[3],
        d: parts[4],
        y: year2,
        n: parts[5]
      });
    }
    rowMap[datevRowKey] = rowList;
  }
  console.log(rowMap);
  return rowMap;
};
const _customDatevRows2020 = {
  //2020
  "9974,04;S;31;1210;3007": [
    // Deletes that row (it's from 2019)
    "10000,00;S;1210;540;0101;Umbuchung Deposit v.29-11-2019 - cr",
    "9965,34;S;31;1210;0101;ZA-Kauf ADA am 29-11-2019 - cr",
    "8,18;S;31;1210;0101;ZA-Kauf ADA am 29-11-2019 - cr",
    "0,52;S;31;1210;0101;ZA-Kauf ADA am 29-11-2019 - cr",
    "25,91;S;4972;1210;0101;ZA-Gebühren - cr",
    "0,02;S;4972;1210;0101;ZA-Gebühren - cr"
  ],
  "9973,95;S;31;1210;0709": [
    "10000,00;H;1200;1360;0709;ZA-Bank an Kraken - cr",
    "10000,00;S;1210;1360;0709;ZE-Kraken von Bank - cr",
    "9974,00;S;31;1210;0709;Kauf ADA - Kraken - crt",
    "25,93;S;4972;1210;0709;Kauf ADA Gebühren - cr",
    "0,05;S;4972;31;0709;Kauf ADA Gebühren - cr",
    "10000,00;H;1200;1360;0709;ZA-Fehlüberweisung an Kraken - cr",
    "10000,00;S;1210;1360;0709;ZE-Fehlüberweisung an Kraken - cr",
    "10000,00;H;1210;1360;0709;ZA-Fehlüberweisung an Bank - cr",
    "0,09;S;4972;1210;0709;ZA-Fehlüberweisung Gebühren - cr",
    "10000,00;S;1200;1360;0709;ZE-Fehlüberweisung an Bank - cr"
  ],
  "9885,72;S;31;1210;1811": [
    "25000,00;H;1200;1360;1811;ZA-Bank an Kraken - cr",
    "25000,00;S;1210;1360;1811;ZE-Kraken von Bank - cr",
    "15049,40;S;32;1210;1811;Kauf BTC - Kraken - cr",
    "39,13;S;4972;1210;1811;Kauf BTC Gebühren - cr",
    "9885,77;S;31;1210;1811;Kauf ADA - Kraken - crt",
    "25,70;S;4972;1210;1811;Kauf ADA Gebühren - cr",
    "0,05;S;4972;31;1811;Kauf ADA Gebühren - cr"
  ],
  "49875,24;S;31;1210;1911": [
    "50000,00;H;1200;1360;1911;ZA-Bank an Kraken - cr",
    "50000,00;S;1210;1360;1911;ZE-Kraken von Bank - cr",
    "49875,30;S;31;1210;1911;Kauf ADA - Kraken - crt",
    "124,70;S;4972;1210;1911;Kauf ADA Gebühren - cr",
    "0,05;S;4972;31;1911;Kauf ADA Gebühren - cr"
  ],
  "29,57;S;1210;1509;1212": [
    "7,63;S;4972;32;1212;ZA-Kraken an Wallet - cr",
    "29,57;S;1210;1509;1212;Verkauf ADA (aktiv) - crt",
    "29,57;S;32;1210;1212;Kauf BTC - cr",
    "0,07;S;4972;32;1212;Kauf BTC Gebühren - cr",
    "7,63;S;4972;32;1212;ZA-Kraken an Wallet - cr"
  ]
};
const _customDatevRows2021 = {
  //2021
  "896,40;S;1210;1509;2502": [
    "896,40;S;1210;1509;2502;Verkauf ADA (aktiv) - crt",
    "896,40;S;33;1210;2502;Kauf USDT - cr",
    "2,33;S;4972;33;2502;Kauf USDT Gebühren - cr",
    "2,15;S;4972;33;2502;ZA-Kraken an Wallet - cr",
    "429,01;S;2760;33;2502;ZA 25-02-2021 CZILLA-DEP 6713"
  ],
  "9902,04;S;1210;1509;0203": [
    "9902,04;S;1210;1509;0203;Verkauf ADA (aktiv) - crt",
    "25,75;S;4972;1210;0203;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;0203;Verkauf ADA Gebühren - cr",
    "9876,2;H;1210;1360;0203;ZA-Kraken an Bank - cr",
    "9876,2;S;1200;1360;0203;ZE-Bank von Kraken - cr"
  ],
  "10734,92;S;1210;1509;2203": [
    "10734,92;S;1210;1509;2203;Verkauf ADA (aktiv) - crt",
    "27,91;S;4972;1210;2603;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;2603;Verkauf ADA Gebühren - cr",
    "10706,91;H;1210;1360;2603;ZA-Kraken an Bank - cr",
    "10706,91;S;1200;1360;2603;ZE-Bank von Kraken - cr"
  ],
  "14800,00;S;1210;1509;1005": [
    "14800,00;S;1210;1509;1005;Verkauf ADA (aktiv) - crt",
    "23,68;S;4972;1210;1005;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;1005;Verkauf ADA Gebühren - cr",
    "14776,24;H;1210;1360;1005;ZA-Kraken an Bank - cr",
    "14776,24;S;1200;1360;1005;ZE-Bank von Kraken - cr"
  ],
  "12590,72;S;1210;1509;0806": [
    "12590,72;S;1210;1509;0806;Verkauf ADA (aktiv) - crt",
    "32,74;S;4972;1210;0806;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;0806;Verkauf ADA Gebühren - cr",
    "12557,89;H;1210;1360;0806;ZA-Kraken an Bank - cr",
    "12557,89;S;1200;1360;0806;ZE-Bank von Kraken - cr"
  ],
  "11335,10;S;1210;1509;2607": [
    "11335,10;S;1210;1509;2607;Verkauf ADA (aktiv) - crt",
    "29,47;S;4972;1210;2607;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;2607;Verkauf ADA Gebühren - cr",
    "11305,54;H;1210;1360;2607;ZA-Kraken an Bank - cr",
    "11305,54;S;1200;1360;2607;ZE-Bank von Kraken - cr"
  ],
  "21089,50;S;1210;1509;2008": [
    "21089,50;S;1210;1509;2008;Verkauf ADA (aktiv) - crt",
    "54,83;S;4972;1210;2008;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;2008;Verkauf ADA Gebühren - cr",
    "21034,57;H;1210;1360;2008;ZA-Kraken an Bank - cr",
    "21034,57;S;1200;1360;2008;ZE-Bank von Kraken - cr"
  ],
  "16762,56;S;1210;1509;1609": [
    "16762,56;S;1210;1509;1609;Verkauf ADA (aktiv) - crt",
    "43,58;S;4972;1210;1609;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;1609;Verkauf ADA Gebühren - cr",
    "16718,89;H;1210;1360;1609;ZA-Kraken an Bank - cr",
    "16718,89;S;1200;1360;1609;ZE-Bank von Kraken - cr"
  ],
  "14591,69;S;1210;1509;1910": [
    "14591,69;S;1210;1509;1910;Verkauf ADA (aktiv) - crt",
    "37,94;S;4972;1210;1910;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;1910;Verkauf ADA Gebühren - cr",
    "14553,66;H;1210;1360;1910;ZA-Kraken an Bank - cr",
    "14553,66;S;1200;1360;1910;ZE-Bank von Kraken - cr"
  ],
  "19768,54;S;1210;1509;0911": [
    "19768,54;S;1210;1509;0911;Verkauf ADA (aktiv) - crt",
    "51,40;S;4972;1210;0911;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;0911;Verkauf ADA Gebühren - cr",
    "19717,05;H;1210;1360;0911;ZA-Kraken an Bank - cr",
    "19717,05;S;1200;1360;0911;ZE-Bank von Kraken - cr"
  ],
  "15775,53;S;1210;1509;2311": [
    "15775,53;S;1210;1509;2311;Verkauf ADA (aktiv) - crt",
    "41,02;S;4972;1210;2311;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;2311;Verkauf ADA Gebühren - cr",
    "15734,42;H;1210;1360;2311;ZA-Kraken an Bank - cr",
    "15734,42;S;1200;1360;2311;ZE-Bank von Kraken - cr"
  ],
  "476,78;S;31;1210;2911": [
    "479,42;S;1210;33;2911;Verkauf USDT (passiv) - cr",
    "16,51;H;2760;33;2911;Gewinn - Verkauf USDT (passiv) - cr",
    "479,42;S;31;1210;2911;Kauf ADA - crt",
    "1,25;S;4972;31;2911;Kauf ADA Gebühren - cr",
    "1,39;S;4972;31;2911;ZA-Kraken an Wallet - cr"
  ],
  "17257,21;S;1210;1509;1012": [
    "17257,21;S;1210;1509;1012;Verkauf ADA (aktiv) - crt",
    "44,87;S;4972;1210;1012;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;1012;Verkauf ADA Gebühren - cr",
    "17212,26;H;1210;1360;1012;ZA-Kraken an Bank - cr",
    "17212,26;S;1200;1360;1012;ZE-Bank von Kraken - cr"
  ]
};
const _customDatevRows2022 = {
  //2022
  "15847,90;S;1210;1509;0601": [
    "15847,90;S;1210;1509;0601;Verkauf ADA (aktiv) - crt",
    "41,20;S;4972;1210;0601;Verkauf ADA Gebühren - cr"
  ],
  "26512,74;S;1210;1509;1701": [
    "26512,74;S;1210;1509;1701;Verkauf ADA (aktiv) - crt",
    "68,93;S;4972;1210;1701;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;1701;Verkauf ADA Gebühren - cr",
    "42250,41;H;1210;1360;1701;ZA-Kraken an Bank - cr",
    "42250,41;S;1200;1360;1701;ZE-Bank von Kraken - cr"
  ],
  "22760,08;S;1210;1509;0802": [
    "22760,08;S;1210;1509;0802;Verkauf ADA (aktiv) - crt",
    "59,18;S;4972;1210;0802;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;0802;Verkauf ADA Gebühren - cr",
    "22700,81;H;1210;1360;0802;ZA-Kraken an Bank - cr",
    "22700,81;S;1200;1360;0802;ZE-Bank von Kraken - cr"
  ],
  "73742,32;S;1210;1509;2202": [
    "73742,32;S;1210;1509;2202;Verkauf ADA (aktiv) - crt",
    "191,73;S;4972;1210;2202;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;0703;Verkauf ADA Gebühren - cr",
    "39999,91;H;1210;1360;0802;ZA-Kraken an Bank - cr",
    "39999,91;S;1200;1360;0802;ZE-Bank von Kraken - cr",
    "0,09;S;4972;1210;2804;Verkauf ADA Gebühren - cr",
    "33550,50;H;1210;1360;2804;ZA-Kraken an Bank - cr",
    "33550,50;S;1200;1360;2804;ZE-Bank von Kraken - cr"
  ],
  "21056,71;S;1210;1509;1205": [
    "21056,71;S;1210;1509;1205;Verkauf ADA (aktiv) - crt",
    "54,75;S;4972;1210;1205;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;2505;Verkauf ADA Gebühren - cr",
    "21001,87;H;1210;1360;2505;ZA-Kraken an Bank - cr",
    "21001,87;S;1200;1360;2505;ZE-Bank von Kraken - cr"
  ],
  "53040,08;S;1210;1509;2006": [
    "53040,08;S;1210;1509;2006;Verkauf ADA (aktiv) - crt",
    "234,17;S;4972;1210;2202;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;2706;Verkauf ADA Gebühren - cr",
    "45000,00;H;1210;1360;2706;ZA-Kraken an Bank - cr",
    "45000,00;S;1200;1360;2706;ZE-Bank von Kraken - cr",
    "0,09;S;4972;1210;1908;Verkauf ADA Gebühren - cr",
    "44830,11;H;1210;1360;1908;ZA-Kraken an Bank - cr",
    "44830,11;S;1200;1360;1908;ZE-Bank von Kraken - cr"
  ],
  "37024,38;S;1210;31;2006": [
    "37024,38;S;1210;31;2006;Verkauf ADA (passiv) - crt"
  ],
  "43236,06;S;1210;1509;0210": [
    "43236,06;S;1210;1509;0210;Verkauf ADA (aktiv) - crt",
    "112,41;S;4972;1210;0210;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;0210;Verkauf ADA Gebühren - cr",
    "43123,55;H;1210;1360;0210;ZA-Kraken an Bank - cr",
    "43123,55;S;1200;1360;0210;ZE-Bank von Kraken - cr"
  ],
  "28453,74;S;1210;1509;0411": [
    "28453,74;S;1210;1509;0411;Verkauf ADA (aktiv) - crt",
    "110,41;S;4972;1210;0411;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;1211;Verkauf ADA Gebühren - cr",
    "42353,63;H;1210;1360;1211;ZA-Kraken an Bank - cr",
    "42353,63;S;1200;1360;1211;ZE-Bank von Kraken - cr"
  ],
  "14010,39;S;1210;31;0411": [
    "14010,39;S;1210;31;0411;Verkauf ADA (passiv) - crt"
  ],
  "28844,05;S;1210;1509;1212": [
    "28844,05;S;1210;1509;1212;Verkauf ADA (aktiv) - crt",
    "74,99;S;4972;1210;1212;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;1212;Verkauf ADA Gebühren - cr",
    "28768,97;H;1210;1360;1212;ZA-Kraken an Bank - cr",
    "28768,97;S;1200;1360;1212;ZE-Bank von Kraken - cr"
  ],
  "9710,78;S;1210;1509;3012": [
    "9710,78;S;1210;1509;3012;Verkauf ADA (aktiv) - crt",
    "31,24;S;4972;1210;3012;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;3012;Verkauf ADA Gebühren - cr",
    "11984,25;H;1210;1360;3012;ZA-Kraken an Bank - cr",
    "11984,25;S;1200;1360;3012;ZE-Bank von Kraken - cr"
  ],
  "2304,80;S;1210;31;3012": [
    "2304,80;S;1210;31;3012;Verkauf ADA (passiv) - crt"
  ]
};
const _customDatevRows2023 = {
  //2023
  "15114,04;S;1210;1509;0901": [
    "15114,04;S;1210;1509;0901;Verkauf ADA (aktiv) - crt",
    "39,53;S;4972;1210;0901;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;0901;Verkauf ADA Gebühren - cr",
    "15162,37;H;1210;1360;0901;ZA-Kraken an Bank - cr",
    "15162,37;S;1200;1360;0901;ZE-Bank von Kraken - cr"
  ],
  "87,94;S;1210;31;0901": [
    "87,94;S;1210;31;0901;Verkauf ADA (passiv) - crt"
  ],
  "10949,87;S;1210;1509;1401": [
    "10949,87;S;1210;1509;1401;Verkauf ADA (aktiv) - crt",
    "40,61;S;4972;1210;1401;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;1401;Verkauf ADA Gebühren - cr",
    "16878,25;H;1210;1360;1401;ZA-Kraken an Bank - cr",
    "16878,25;S;1200;1360;1401;ZE-Bank von Kraken - cr"
  ],
  "5969,07;S;1210;31;1401": [
    "5969,07;S;1210;31;1401;Verkauf ADA (passiv) - crt"
  ],
  "17534,71;S;1210;1509;0902": [
    "17534,71;S;1210;1509;0902;Verkauf ADA (aktiv) - crt",
    "69,79;S;4972;1210;0902;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;0902;Verkauf ADA Gebühren - cr",
    "26771,49;H;1210;1360;0902;ZA-Kraken an Bank - cr",
    "26771,49;S;1200;1360;0902;ZE-Bank von Kraken - cr"
  ],
  "9306,66;S;1210;31;0902": [
    "9306,66;S;1210;31;0902;Verkauf ADA (passiv) - crt"
  ],
  "24633,60;S;1210;1509;0203": [
    "24633,60;S;1210;1509;0203;Verkauf ADA (aktiv) - crt",
    "86,02;S;4972;1210;0203;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;0203;Verkauf ADA Gebühren - cr",
    "33000,30;H;1210;1360;0203;ZA-Kraken an Bank - cr",
    "33000,30;S;1200;1360;0203;ZE-Bank von Kraken - cr"
  ],
  "8452,81;S;1210;31;0203": [
    "8452,81;S;1210;31;0203;Verkauf ADA (passiv) - crt"
  ],
  "13310,36;S;1210;1509;2803": [
    "13310,36;S;1210;1509;2803;Verkauf ADA (aktiv) - crt",
    "34,61;S;4972;1210;2803;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;2803;Verkauf ADA Gebühren - cr",
    "13275,66;H;1210;1360;2803;ZA-Kraken an Bank - cr",
    "13275,66;S;1200;1360;2803;ZE-Bank von Kraken - cr"
  ],
  "33220,93;S;1210;1509;1104": [
    "33220,93;S;1210;1509;1104;Verkauf ADA (aktiv) - crt",
    "86,37;S;4972;1210;1104;Verkauf ADA Gebühren - cr",
    "0,09;S;4972;1210;1104;Verkauf ADA Gebühren - cr",
    "33134,46;H;1210;1360;1104;ZA-Kraken an Bank - cr",
    "33134,46;S;1200;1360;1104;ZE-Bank von Kraken - cr"
  ],
  "31184,19;S;1210;1509;2805": [
    "31184,19;S;1210;1509;2805;Verkauf ADA (aktiv) - crt",
    "81,08;S;4972;1210;2805;Verkauf ADA Gebühren - cr",
    "1,00;S;4972;1210;2805;Verkauf ADA Gebühren - cr",
    "31102,11;H;1210;1360;2805;ZA-Kraken an Bank - cr",
    "31102,11;S;1200;1360;2805;ZE-Bank von Kraken - cr"
  ],
  "29099,52;S;1210;1509;0906": [
    "29099,52;S;1210;1509;0906;Verkauf ADA (aktiv) - crt",
    "75,66;S;4972;1210;0906;Verkauf ADA Gebühren - cr",
    "1,00;S;4972;1210;0906;Verkauf ADA Gebühren - cr",
    "29022,87;H;1210;1360;0906;ZA-Kraken an Bank - cr",
    "29022,87;S;1200;1360;0906;ZE-Bank von Kraken - cr"
  ],
  "32175,47;S;1210;1509;1407": [
    "32175,47;S;1210;1509;1407;Verkauf ADA (aktiv) - crt",
    "83,66;S;4972;1210;1407;Verkauf ADA Gebühren - cr",
    "1,00;S;4972;1210;1407;Verkauf ADA Gebühren - cr",
    "32090,81;H;1210;1360;1407;ZA-Kraken an Bank - cr",
    "32090,81;S;1200;1360;1407;ZE-Bank von Kraken - cr"
  ],
  "23809,31;S;1210;1509;0709": [
    "23809,31;S;1210;1509;0709;Verkauf ADA (aktiv) - crt",
    "351,86;S;4972;1210;0709;Verkauf ADA Gebühren - cr",
    "1,00;S;4972;1210;0709;Verkauf ADA Gebühren - cr",
    "23456,45;H;1210;1360;0709;ZA-Kraken an Bank - cr",
    "23456,45;S;1200;1360;0709;ZE-Bank von Kraken - cr"
  ],
  "24498,83;S;1210;1509;0410": [
    "24498,83;S;1210;1509;0410;Verkauf ADA (aktiv) - crt",
    "63,70;S;4972;1210;0410;Verkauf ADA Gebühren - cr",
    "1,00;S;4972;1210;0410;Verkauf ADA Gebühren - cr",
    "24434,13;H;1210;1360;0410;ZA-Kraken an Bank - cr",
    "24434,13;S;1200;1360;0410;ZE-Bank von Kraken - cr"
  ],
  "26062,66;S;1210;1509;2410": [
    "26062,66;S;1210;1509;2410;Verkauf ADA (aktiv) - crt",
    "67,76;S;4972;1210;2410;Verkauf ADA Gebühren - cr",
    "1,00;S;4972;1210;2410;Verkauf ADA Gebühren - cr",
    "25993,90;H;1210;1360;2410;ZA-Kraken an Bank - cr",
    "25993,90;S;1200;1360;2410;ZE-Bank von Kraken - cr"
  ],
  "22336,95;S;1210;1509;0611": [
    "22336,95;S;1210;1509;0611;Verkauf ADA (aktiv) - crt",
    "85,41;S;4972;1210;0611;Verkauf ADA Gebühren - cr",
    "1,00;S;4972;1210;0611;Verkauf ADA Gebühren - cr",
    "32763,88;H;1210;1360;0611;ZA-Kraken an Bank - cr",
    "32763,88;S;1200;1360;0611;ZE-Bank von Kraken - cr"
  ],
  "10513,35;S;1210;31;0611": [
    "10513,35;S;1210;31;0611;Verkauf ADA (passiv) - crt"
  ],
  "34465,42;S;1210;1509;1311": [
    "34465,42;S;1210;1509;1311;Verkauf ADA (aktiv) - crt",
    "82,72;S;4972;1210;1311;Verkauf ADA Gebühren - cr",
    "1,00;S;4972;1210;1311;Verkauf ADA Gebühren - cr",
    "34381,71;H;1210;1360;1311;ZA-Kraken an Bank - cr",
    "34381,71;S;1200;1360;1311;ZE-Bank von Kraken - cr"
  ],
  "23837,06;S;1210;1509;0812": [
    "23837,06;S;1210;1509;0812;Verkauf ADA (aktiv) - crt",
    "61,98;S;4972;1210;0812;Verkauf ADA Gebühren - cr",
    "1,00;S;4972;1210;0812;Verkauf ADA Gebühren - cr",
    "23774,08;H;1210;1360;0812;ZA-Kraken an Bank - cr",
    "23774,08;S;1200;1360;0812;ZE-Bank von Kraken - cr"
  ],
  "28957,14;S;1210;1509;1312": [
    "28957,14;S;1210;1509;1312;Verkauf ADA (aktiv) - crt",
    "69,50;S;4972;1210;1312;Verkauf ADA Gebühren - cr",
    "1,00;S;4972;1210;1312;Verkauf ADA Gebühren - cr",
    "28886,63;H;1210;1360;1312;ZA-Kraken an Bank - cr",
    "28886,63;S;1200;1360;1312;ZE-Bank von Kraken - cr"
  ]
};
const getCustomDatevRows = (year2) => {
  const obj = {};
  if (year2 >= 2020) {
    convertCustomDatevRows(_customDatevRows2020, obj, 2020);
  }
  if (year2 >= 2021) {
    convertCustomDatevRows(_customDatevRows2021, obj, 2021);
  }
  if (year2 >= 2022) {
    convertCustomDatevRows(_customDatevRows2022, obj, 2022);
  }
  if (year2 >= 2023) {
    convertCustomDatevRows(_customDatevRows2023, obj, 2023);
  }
  return obj;
};
const createReportsCSVFile = (networkId2, rowList, year2, useLocalTimezone = false) => {
  getFormattedDate(/* @__PURE__ */ new Date());
  let csv = "";
  for (const row of rowList) {
    csv += getReportLine(networkId2, row);
  }
  return csv;
};
const getReportLine = (networkId2, row) => {
  var _a;
  let adaPD = "";
  let adaFV = "";
  let adaFU = "";
  let adaAmount = "";
  let adaAsset = "";
  let tokenAmount = "";
  let tokenTokenName = "";
  let tokenPolicyId = "";
  let tokenAssetName = "";
  console.log(row);
  if (row.info) {
    if (row.info.lv) {
      adaAmount = getCSVADAAmount(divide(row.info.lv, "1000000"));
      adaAsset = "ADA";
      if (row.info.pd) {
        adaPD = getCSVAmount(row.info.pd, 5);
        adaFU = row.info.fu ?? "";
        adaFV = getCSVAmount2(bigToNum(multiply(divide(row.info.lv, "1000000"), row.info.pd)), 5);
      }
    }
    if (row.info.au) {
      const [policyId, assetName] = row.info.au.split(".");
      if (!(!policyId || typeof assetName !== "string")) {
        const ai = getAssetInfoLight(policyId, assetName);
        tokenAmount = row.info.av;
        tokenTokenName = ((_a = ai == null ? void 0 : ai.tr) == null ? void 0 : _a.n) ?? (ai == null ? void 0 : ai.n) ?? "";
        tokenPolicyId = policyId;
        tokenAssetName = assetName;
      }
      adaFU = row.info.fu ?? "";
      adaFV = row.a;
    }
  } else {
    adaFV = row.a;
  }
  return `${row.d};"${adaAsset}";${adaAmount};"${adaFU}";${adaPD};${adaFV};"${row.n}";${tokenAmount};"${tokenTokenName}";"${tokenPolicyId}";"${tokenAssetName}"
`;
};
const getFormattedDate = (date) => {
  const year2 = date.getFullYear();
  const month2 = String(date.getMonth() + 1).padStart(2, "0");
  const day2 = String(date.getDate()).padStart(2, "0");
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");
  const seconds = String(date.getSeconds()).padStart(2, "0");
  const milliseconds = String(date.getMilliseconds()).padStart(3, "0");
  return `${year2}${month2}${day2}${hours}${minutes}${seconds}${milliseconds}`;
};
const _hoisted_1$1 = { class: "col-span-12 grid grid-cols-12 gap-2" };
const _hoisted_2$1 = { class: "col-span-12 flex flex-row gap-2" };
const _hoisted_3$1 = { class: "col-span-12 grid grid-cols-12 cc-page-gap cc-page-px cc-page-pt cc-text-sz pb-4" };
const _hoisted_4$1 = { class: "col-span-2" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "ReportCreation",
  setup(__props) {
    const {
      uiSelectedWalletId,
      uiSelectedAccountId
    } = useUiSelectedAccount();
    useWalletAccount(uiSelectedWalletId, uiSelectedAccountId);
    const $q = useQuasar();
    const {
      year: year2,
      minSlotOfYear: minSlotOfYear2,
      maxSlotOfYear: maxSlotOfYear2
    } = useReportTimeChanger();
    const {
      formatTxType,
      formatADAString
    } = useFormatter();
    const showRewards = ref(true);
    const showTxFee = ref(true);
    const showNeutral = ref(true);
    const showIncome = ref(true);
    const showDeposit = ref(true);
    const showPassThrough = ref(false);
    const showTokens = ref(false);
    const showBought = ref(true);
    const hasPassive = ref(false);
    const has1YearTaxFree = ref(true);
    const inputRef = ref(null);
    computed(() => {
      var _a, _b;
      const list = ((_a = selectedEntityGroup.value) == null ? void 0 : _a.walletGroupNameList.concat()) ?? [];
      const entityGroupIdList = ((_b = selectedEntityGroup.value) == null ? void 0 : _b.entityGroupIdList) ?? [];
      for (const entityGroupId of entityGroupIdList) {
        const entityGroup = entityGroupList.value.find((g) => g.id === entityGroupId);
        if (entityGroup) {
          for (const walletGroupName of entityGroup.walletGroupNameList) {
            if (!list.includes(walletGroupName)) {
              list.push(walletGroupName);
            }
          }
        }
      }
      list.sort((a, b) => a.localeCompare(b, "en-US"));
      return list;
    });
    const _report = computed(() => {
      var _a;
      return getAllReportData()[((_a = selectedEntityGroup.value) == null ? void 0 : _a.id) ?? ""];
    });
    const _reportAdaAmount = computed(() => {
      var _a;
      const list = ((_a = _report.value) == null ? void 0 : _a.ledgerTaxFree) ?? [];
      let amount = "0";
      for (const cb of list) {
        if (!cb.au) {
          amount = add(amount, cb.av);
        }
      }
      return formatADAString(amount);
    });
    computed(() => {
      var _a;
      return (((_a = _report.value) == null ? void 0 : _a.datevRowList) ?? []).filter((row) => row.y === year2.value);
    });
    ref(false);
    const doSave = async () => {
      const entity = selectedEntityGroup.value;
      if (!entity) {
        return;
      }
      const { downloadText } = useDownload();
      await downloadText(JSON.stringify(saveReportData(entity.id), null, 2), "report-data-" + entity.id + ".json");
    };
    const doReset = () => clearReportData();
    const _entityReports = ref();
    const doCreateReports = async () => {
      const entity = selectedEntityGroup.value;
      if (!entity) {
        return;
      }
      _entityReports.value = await createReportData(entity.id, minSlotOfYear2.value, maxSlotOfYear2.value, getAccountIdListByEntity(entity));
    };
    const doCalcLedger = async () => {
      const entity = selectedEntityGroup.value;
      if (!entity) {
        return;
      }
      _entityReports.value = await createLedger(entity.id, hasPassive.value, has1YearTaxFree.value, getCustomDatevRows(year2.value));
    };
    const loadMissingAssetInfo = async (reports) => {
      var _a, _b;
      const assetList = [];
      for (const row of reports.datevRowList.filter((row2) => row2.y === year2.value)) {
        if ((((_b = (_a = row.info) == null ? void 0 : _a.au) == null ? void 0 : _b.length) ?? 0) > 0) {
          if (row.info.au.includes(".")) {
            assetList.push(row.info.au);
          }
        }
      }
      await doLoadMissingAssetInfoByStringList(assetList);
    };
    const doExportDatev = async () => {
      const entity = selectedEntityGroup.value;
      if (!entity) {
        return;
      }
      const reports = getReports(entity.id);
      await loadMissingAssetInfo(reports);
      const rows = reports.datevRowList.filter((row) => row.y === year2.value);
      const csv = createDatevCSVFile(rows, year2.value);
      const { downloadText } = useDownload();
      await downloadText(csv, year2.value + "-datev-csv-" + entity.id + ".csv");
    };
    const doExportCSV = async () => {
      const entity = selectedEntityGroup.value;
      if (!entity) {
        return;
      }
      const reports = getReports(entity.id);
      await loadMissingAssetInfo(reports);
      console.log(reports);
      const rows = reports.csvRowList.filter((row) => row.y === year2.value);
      const csv = createReportsCSVFile(networkId.value, rows, year2.value);
      const { downloadText } = useDownload();
      await downloadText(csv, year2.value + "-reports-csv-" + entity.id + ".csv");
    };
    const processFile = (jsonObj) => {
      if (!(jsonObj == null ? void 0 : jsonObj.reports) || typeof jsonObj.reports !== "object") {
        showNotificationError("Invalid file format");
        return;
      }
      const data = jsonObj.reports;
      setReportData(data);
    };
    function doImport() {
      if (inputRef.value) inputRef.value.click();
    }
    const onHandleFileSelect = async (e) => {
      const files = e.target.files;
      const calls = [];
      for (const file of files) {
        if (!file.type.match("application/json")) {
          showNotificationWarning("Unsupported file type: " + file.type);
          continue;
        }
        calls.push(loadFile(file));
      }
      const loadedFiles = await Promise.all(calls);
      for (const file of loadedFiles) {
        processFile(file);
      }
    };
    onMounted(() => {
      if (inputRef.value) {
        inputRef.value.addEventListener("change", onHandleFileSelect, false);
      }
    });
    const showNotificationError = (msg) => {
      $q.notify({
        message: msg,
        type: "warning",
        position: "top-left",
        timeout: 8e3,
        closeBtn: true,
        progress: true
      });
    };
    const showNotificationWarning = (msg) => {
      $q.notify({
        message: msg,
        type: "warning",
        position: "top-left",
        timeout: 8e3,
        closeBtn: true,
        progress: true
      });
    };
    const loadFile = (file) => {
      const reader = new FileReader();
      return new Promise(async (resolve, reject) => {
        reader.onload = async (re) => {
          try {
            const loadedFile = JSON.parse(re.target.result);
            return resolve(loadedFile);
          } catch (err) {
            showNotificationError("Could not parse: " + (file == null ? void 0 : file.name));
            console.error("Could not parse:", file == null ? void 0 : file.name);
          }
          return reject("error 1");
        };
        reader.onerror = () => {
          showNotificationError("Could not load: " + (file == null ? void 0 : file.name));
          return reject("error 2");
        };
        reader.onabort = () => {
          showNotificationError("Could not load: " + (file == null ? void 0 : file.name));
          return reject("error 3");
        };
        reader.readAsText(file);
      });
    };
    return (_ctx, _cache) => {
      var _a, _b, _c, _d, _e, _f, _g, _h, _i, _j, _k, _l;
      return openBlock(), createElementBlock("div", _hoisted_1$1, [
        createBaseVNode("div", _hoisted_2$1, [
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "1",
            onClick: doCreateReports
          }, "Create Reports"),
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "2",
            onClick: doSave
          }, "Save Reports"),
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "3",
            onClick: doReset
          }, "Reset"),
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "4",
            onClick: doImport
          }, "Import Reports"),
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "4",
            onClick: doCalcLedger
          }, "Calculate Ledger"),
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "4",
            onClick: doExportDatev
          }, "Export DATEV"),
          createBaseVNode("button", {
            class: "border hover:border-amber-400 p-4 col-span-2 rounded-xl",
            tabindex: "4",
            onClick: doExportCSV
          }, "Export CSV"),
          createVNode(QToggle_default, {
            class: "col-span-8",
            modelValue: hasPassive.value,
            "onUpdate:modelValue": _cache[0] || (_cache[0] = ($event) => hasPassive.value = $event),
            "left-label": "",
            label: "Has passive account"
          }, null, 8, ["modelValue"]),
          createVNode(QToggle_default, {
            class: "col-span-8",
            modelValue: has1YearTaxFree.value,
            "onUpdate:modelValue": _cache[1] || (_cache[1] = ($event) => has1YearTaxFree.value = $event),
            "left-label": "",
            label: "Tax fee after one year"
          }, null, 8, ["modelValue"]),
          createBaseVNode("input", {
            type: "file",
            id: "files",
            name: "files[]",
            multiple: "",
            ref_key: "inputRef",
            ref: inputRef,
            hidden: ""
          }, null, 512)
        ]),
        createVNode(_sfc_main$7),
        unref(selectedEntityGroup) ? (openBlock(), createBlock(_sfc_main$2, {
          key: 0,
          "entity-id": unref(selectedEntityGroup).id,
          "asset-limit": 99999,
          onToggleShowPassThrough: _cache[2] || (_cache[2] = ($event) => showPassThrough.value = !showPassThrough.value),
          onToggleShowTokens: _cache[3] || (_cache[3] = ($event) => showTokens.value = !showTokens.value)
        }, null, 8, ["entity-id"])) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_3$1, [
          createVNode(_sfc_main$i, {
            label: "Ledger at the end of the time frame",
            class: "col-span-9"
          }),
          createBaseVNode("div", _hoisted_4$1, toDisplayString(_reportAdaAmount.value), 1),
          createVNode(GridSpace, {
            hr: "",
            label: "tax free"
          }),
          (openBlock(true), createElementBlock(Fragment, null, renderList((_a = _report.value) == null ? void 0 : _a.ledgerTaxFree, (cb) => {
            return openBlock(), createElementBlock(Fragment, null, [
              (cb.t === "p" && showPassThrough.value || cb.t === "d" && showDeposit.value || cb.t === "c" && showDeposit.value || cb.t === "f" && showTxFee.value || cb.t === "r" && showRewards.value || cb.t === "i" && showIncome.value || cb.t === "n" && showNeutral.value || cb.t === "b" && showBought.value) && (showTokens.value || !showTokens.value && !cb.au || cb.au && typeof cb.lv === "string" && !unref(isZero)(cb.lv)) ? (openBlock(), createBlock(ReportCBListEntryBalance, {
                key: 0,
                "cost-basis": cb,
                class: "w-full col-span-12"
              }, null, 8, ["cost-basis"])) : createCommentVNode("", true)
            ], 64);
          }), 256)),
          ((_b = _report.value) == null ? void 0 : _b.ledgerPassive) !== ((_c = _report.value) == null ? void 0 : _c.ledgerActive) && (((_d = _report.value) == null ? void 0 : _d.ledgerPassive.length) ?? 0) > 0 ? (openBlock(), createBlock(GridSpace, {
            key: 0,
            hr: "",
            label: "passive"
          })) : createCommentVNode("", true),
          ((_e = _report.value) == null ? void 0 : _e.ledgerPassive) !== ((_f = _report.value) == null ? void 0 : _f.ledgerActive) && (((_g = _report.value) == null ? void 0 : _g.ledgerPassive.length) ?? 0) > 0 ? (openBlock(true), createElementBlock(Fragment, { key: 1 }, renderList((_h = _report.value) == null ? void 0 : _h.ledgerPassive, (cb) => {
            return openBlock(), createElementBlock(Fragment, null, [
              (cb.t === "p" && showPassThrough.value || cb.t === "d" && showDeposit.value || cb.t === "c" && showDeposit.value || cb.t === "f" && showTxFee.value || cb.t === "r" && showRewards.value || cb.t === "i" && showIncome.value || cb.t === "n" && showNeutral.value || cb.t === "b" && showBought.value) && (showTokens.value || !showTokens.value && !cb.au || cb.au && typeof cb.lv === "string" && !unref(isZero)(cb.lv)) ? (openBlock(), createBlock(ReportCBListEntryBalance, {
                key: 0,
                "cost-basis": cb,
                class: "w-full col-span-12"
              }, null, 8, ["cost-basis"])) : createCommentVNode("", true)
            ], 64);
          }), 256)) : createCommentVNode("", true),
          createVNode(GridSpace, {
            hr: "",
            label: "active"
          }),
          (((_i = _report.value) == null ? void 0 : _i.ledgerActive.length) ?? 0) > 0 ? (openBlock(true), createElementBlock(Fragment, { key: 2 }, renderList((_j = _report.value) == null ? void 0 : _j.ledgerActive, (cb) => {
            return openBlock(), createElementBlock(Fragment, null, [
              (cb.t === "p" && showPassThrough.value || cb.t === "d" && showDeposit.value || cb.t === "c" && showDeposit.value || cb.t === "f" && showTxFee.value || cb.t === "r" && showRewards.value || cb.t === "i" && showIncome.value || cb.t === "n" && showNeutral.value || cb.t === "b" && showBought.value) && (showTokens.value || !showTokens.value && !cb.au || cb.au && typeof cb.lv === "string" && !unref(isZero)(cb.lv)) ? (openBlock(), createBlock(ReportCBListEntryBalance, {
                key: 0,
                "cost-basis": cb,
                class: "w-full col-span-12"
              }, null, 8, ["cost-basis"])) : createCommentVNode("", true)
            ], 64);
          }), 256)) : createCommentVNode("", true),
          createVNode(GridSpace, {
            hr: "",
            label: "pass-through"
          }),
          (((_k = _report.value) == null ? void 0 : _k.ledgerPassThrough.length) ?? 0) > 0 ? (openBlock(true), createElementBlock(Fragment, { key: 3 }, renderList((_l = _report.value) == null ? void 0 : _l.ledgerPassThrough, (cb) => {
            return openBlock(), createElementBlock(Fragment, null, [
              (cb.t === "p" && showPassThrough.value || cb.t === "d" && showDeposit.value || cb.t === "c" && showDeposit.value || cb.t === "f" && showTxFee.value || cb.t === "r" && showRewards.value || cb.t === "i" && showIncome.value || cb.t === "n" && showNeutral.value || cb.t === "b" && showBought.value) && (showTokens.value || !showTokens.value && !cb.au || cb.au && typeof cb.lv === "string" && !unref(isZero)(cb.lv)) ? (openBlock(), createBlock(ReportCBListEntryBalance, {
                key: 0,
                "cost-basis": cb,
                class: "w-full col-span-12"
              }, null, 8, ["cost-basis"])) : createCommentVNode("", true)
            ], 64);
          }), 256)) : createCommentVNode("", true),
          createVNode(GridSpace, {
            hr: "",
            label: "export"
          })
        ])
      ]);
    };
  }
});
const _hoisted_1 = {
  key: 0,
  class: "w-full max-w-full flex flex-col flex-nowrap justify-center items-center border-t border-b cc-menu-group"
};
const _hoisted_2 = { class: "cc-page-wallet" };
const _hoisted_3 = { class: "col-span-12 grid grid-cols-12 cc-gap-lg" };
const _hoisted_4 = { class: "col-span-12 grid grid-cols-12 cc-gap-lg" };
const _hoisted_5 = { class: "col-span-12 grid grid-cols-12 cc-gap-lg" };
const _hoisted_6 = { class: "col-span-12 grid grid-cols-12 cc-gap-lg" };
const _hoisted_7 = { class: "col-span-12 grid grid-cols-12 cc-gap-lg" };
const _hoisted_8 = { class: "col-span-12 grid grid-cols-12 cc-gap-lg" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Report2",
  setup(__props) {
    const { it } = useTranslation();
    const $q = useQuasar();
    const selectedEntity = computed(() => {
      var _a, _b;
      return ((_a = selectedEntityGroup.value) == null ? void 0 : _a.id) ? ": " + ((_b = selectedEntityGroup.value) == null ? void 0 : _b.id) : "";
    });
    const selectedEntityExt = computed(() => {
      var _a, _b, _c;
      return ((_a = selectedEntityGroup.value) == null ? void 0 : _a.id) ? ": " + ((_b = selectedEntityGroup.value) == null ? void 0 : _b.id) + " (" + ((_c = selectedEntityGroup.value) == null ? void 0 : _c.walletGroupNameList.length) + " wallet groups)" : "";
    });
    onErrorCaptured((e, instance, info) => {
      $q.notify({
        type: "negative",
        message: "error: " + ((e == null ? void 0 : e.message) ?? "no error message") + " info: " + info,
        position: "top-left",
        timeout: 1e4
      });
      console.error("Report2: onErrorCaptured", e);
      return true;
    });
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$t, {
        containerCSS: "",
        "align-top": "",
        "add-scroll": true
      }, {
        header: withCtx(() => [
          _cache[1] || (_cache[1] = createBaseVNode("div", { class: "h-16 md:h-20 w-full max-w-full flex flex-row flex-nowrap justify-center items-center border-t border-b mb-px cc-text-sx-dense cc-bg-white-0 overflow-hidden" }, [
            createBaseVNode("div", { class: "relative w-full h-full flex flex-row flex-nowrap justify-between items-center max-w-6xl px-1 xxs:px-3 lg:px-6 xl:px-6 space-x-2" })
          ], -1)),
          !unref(isSignMode)() ? (openBlock(), createElementBlock("div", _hoisted_1, _cache[0] || (_cache[0] = [
            createBaseVNode("nav", {
              class: "relative overflow-x-auto overflow-hidden w-full flex flex-row flex-nowrap items-start justify-center px-2.5 space-x-1.5 xxs:space-x-1 sm:space-x-0 md:space-x-1",
              "aria-label": "Tabs"
            }, null, -1)
          ]))) : createCommentVNode("", true)
        ]),
        default: withCtx(() => [
          createBaseVNode("div", _hoisted_2, [
            createVNode(_sfc_main$s, {
              label: unref(it)("setting.reportEntity.label") + selectedEntity.value,
              caption: unref(it)("setting.reportEntity.caption")
            }, {
              setting: withCtx(() => [
                createBaseVNode("div", _hoisted_3, [
                  createVNode(_sfc_main$g)
                ])
              ]),
              _: 1
            }, 8, ["label", "caption"]),
            createVNode(_sfc_main$s, {
              label: unref(it)("setting.reportEntity.selectedWalletGroups.label") + selectedEntityExt.value,
              caption: unref(it)("setting.reportEntity.selectedWalletGroups.caption")
            }, {
              setting: withCtx(() => [
                createBaseVNode("div", _hoisted_4, [
                  createVNode(_sfc_main$e)
                ])
              ]),
              _: 1
            }, 8, ["label", "caption"]),
            createVNode(_sfc_main$s, {
              label: unref(it)("setting.reportEntity.reportLabels.label"),
              caption: unref(it)("setting.reportEntity.reportLabels.caption")
            }, {
              setting: withCtx(() => [
                createBaseVNode("div", _hoisted_5, [
                  createVNode(_sfc_main$f)
                ])
              ]),
              _: 1
            }, 8, ["label", "caption"]),
            createVNode(_sfc_main$s, {
              label: unref(it)("setting.reportEntity.reportGeneration.label") + selectedEntityExt.value,
              caption: unref(it)("setting.reportEntity.reportGeneration.caption")
            }, {
              setting: withCtx(() => [
                createBaseVNode("div", _hoisted_6, [
                  createVNode(_sfc_main$6)
                ])
              ]),
              _: 1
            }, 8, ["label", "caption"]),
            createVNode(_sfc_main$s, {
              label: unref(it)("setting.reportEntity.reportRefinement.label") + selectedEntityExt.value,
              caption: unref(it)("setting.reportEntity.reportRefinement.caption")
            }, {
              setting: withCtx(() => [
                createBaseVNode("div", _hoisted_7, [
                  createVNode(_sfc_main$4)
                ])
              ]),
              _: 1
            }, 8, ["label", "caption"]),
            createVNode(_sfc_main$s, {
              label: unref(it)("setting.reportEntity.reportProcessing.label") + selectedEntityExt.value,
              caption: unref(it)("setting.reportEntity.reportProcessing.caption")
            }, {
              setting: withCtx(() => [
                createBaseVNode("div", _hoisted_8, [
                  createVNode(_sfc_main$1)
                ])
              ]),
              _: 1
            }, 8, ["label", "caption"])
          ])
        ]),
        _: 1
      });
    };
  }
});
export {
  _sfc_main as default
};
