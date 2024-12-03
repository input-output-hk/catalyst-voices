import { fx as AdaHandleError, L as api, fr as isValidSendAddress, d as defineComponent, a5 as toRefs, z as ref, D as watch, u as unref, o as openBlock, a as createBlock, h as withCtx, c as createElementBlock, e as createBaseVNode, q as createVNode, j as createCommentVNode, fF as addressBook, K as networkId, fG as updateAddressBookEntry, a7 as useQuasar, f as computed, n as normalizeClass, b as withModifiers, t as toDisplayString, H as Fragment, I as renderList, aH as QPagination_default, gu as deleteAddressBookEntry, i as createTextVNode, Q as QSpinnerDots_default } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { I as IconPencil } from "./IconPencil.js";
import { I as IconDelete } from "./IconDelete.js";
import { G as GridSpace } from "./GridSpace.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { i as isMilkomedaAddress } from "./vue-json-pretty.js";
import { G as GridInput } from "./GridInput.js";
import { _ as _sfc_main$3 } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$2 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { M as Modal } from "./Modal.js";
import { _ as _sfc_main$5 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$4 } from "./ConfirmationModal.vue_vue_type_script_setup_true_lang.js";
const isAdaHandle = (value) => !!value && value.startsWith("$");
const resolveAdaHandle = async (networkId2, adaHandle) => {
  var _a, _b;
  if (!isAdaHandle(adaHandle)) {
    throw AdaHandleError.invalidAdaHandle;
  }
  const url = `/${networkId2}/v2/misc/adahandle`;
  const res = await api.post(url, {
    assetName: adaHandle.slice(1).toLowerCase()
  }).catch((err) => {
    console.warn("Error: Ada Handle: failed", networkId2, err);
  });
  if (((_a = res == null ? void 0 : res.data) == null ? void 0 : _a.address) && ((_b = res == null ? void 0 : res.data) == null ? void 0 : _b.fingerprint)) {
    if (!isValidSendAddress(networkId2, res.data.address)) {
      throw AdaHandleError.invalidAddress;
    }
    return {
      address: res.data.address,
      fingerprint: res.data.fingerprint
    };
  }
  throw AdaHandleError.adaHandleNotResolved;
};
const _hoisted_1$1 = {
  key: 0,
  class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p"
};
const _hoisted_2$1 = { class: "flex flex-col cc-text-sz" };
const _hoisted_3$1 = { class: "cc-layout-p" };
const _hoisted_4$1 = { class: "grid grid-cols-12 cc-gap" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "AddressBookNewEntryModal",
  props: {
    showModal: { type: Object, required: true },
    title: { type: String, required: false, default: "" },
    caption: { type: String, required: false, default: "" },
    showAddrInput: { type: Boolean, required: false, default: true },
    editInput: { type: Boolean, required: false, default: false },
    oldName: { type: String, required: false, default: "" },
    oldAddr: { type: String, required: false, default: "" }
  },
  emits: ["close", "submit"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const { showModal } = toRefs(props);
    const nameInput = ref(props.oldName ?? "");
    const nameInputError = ref("");
    const addrInput = ref(props.oldAddr ?? "");
    const addrInputError = ref("");
    const validName = ref(nameInput.value.length !== 0);
    const validAddr = ref(addrInput.value.length !== 0);
    const validateNameInput = async () => {
      nameInputError.value = "";
      if (!nameInput.value || nameInput.value.length === 0) {
        return;
      }
      const _isAdaHandle = isAdaHandle(nameInput.value);
      if (!_isAdaHandle && (nameInput.value.length < 3 || nameInput.value.length > 40)) {
        nameInputError.value = it("setting.addressbook.add.name.error.length");
        return;
      }
      const addrBookEntry = addressBook.value.entryList.find((e) => e.name === nameInput.value);
      if (addrBookEntry && (!props.editInput || props.editInput && props.oldName !== nameInput.value)) {
        nameInputError.value = it("setting.addressbook.add.name.error.duplicate");
        return;
      }
      if (_isAdaHandle && nameInput.value.length > 1) {
        try {
          const handle = await resolveAdaHandle(networkId.value, nameInput.value);
          if (handle) {
            addrInput.value = handle.address;
          } else {
            nameInputError.value = it("wallet.send.error.handle");
          }
        } catch (err) {
          nameInputError.value = it("wallet.send.error.handle");
        }
      }
    };
    const validateAddrInput = () => {
      addrInputError.value = "";
      if (!addrInput.value || addrInput.value.length === 0) {
        return;
      }
      if (!isValidSendAddress(networkId.value, addrInput.value) && !isMilkomedaAddress(addrInput.value)) {
        addrInputError.value = it("setting.addressbook.add.addr.error.format");
        return;
      }
      const addrBookEntry = addressBook.value.entryList.find((e) => e.address === addrInput.value);
      if (addrBookEntry && (!props.editInput || props.editInput && props.oldAddr !== addrInput.value)) {
        addrInputError.value = it("setting.addressbook.add.addr.error.duplicate").replace("###name###", addrBookEntry.name);
      }
    };
    let tname = -1;
    let taddr = -1;
    watch(nameInput, () => {
      clearTimeout(tname);
      validName.value = false;
      tname = setTimeout(async () => {
        await validateNameInput();
        nameInput.value.length > 0 && nameInputError.value.length === 0 ? validName.value = true : validName.value = false;
      }, 250);
    });
    watch(addrInput, () => {
      clearTimeout(taddr);
      validAddr.value = false;
      taddr = setTimeout(() => {
        validateAddrInput();
        addrInput.value.length > 0 && addrInputError.value.length === 0 ? validAddr.value = true : validAddr.value = false;
      }, 250);
    });
    const onAddToAddressBook = async () => {
      if (!networkId.value || !validName.value || !validAddr.value) {
        return;
      }
      const tmpName = props.editInput ? props.oldName : nameInput.value;
      await updateAddressBookEntry(networkId.value, nameInput.value, addrInput.value, tmpName);
      emit("submit");
      onClose();
    };
    const onResetName = () => {
      nameInput.value = "";
      nameInputError.value = "";
      validName.value = false;
    };
    const onResetAddr = () => {
      addrInput.value = "";
      addrInputError.value = "";
      validAddr.value = false;
    };
    const onClose = () => {
      showModal.value.display = false;
      onResetName();
      onResetAddr();
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
          __props.title ? (openBlock(), createElementBlock("div", _hoisted_1$1, [
            createBaseVNode("div", _hoisted_2$1, [
              createVNode(_sfc_main$2, { label: __props.title }, null, 8, ["label"])
            ])
          ])) : createCommentVNode("", true)
        ]),
        content: withCtx(() => [
          createBaseVNode("div", _hoisted_3$1, [
            createVNode(GridInput, {
              "input-text": nameInput.value,
              "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => nameInput.value = $event),
              "input-error": nameInputError.value,
              "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => nameInputError.value = $event),
              class: "col-span-12 lg:col-span-4 pb-2",
              onLostFocus: validateNameInput,
              onEnter: onAddToAddressBook,
              onReset: onResetName,
              label: unref(it)("setting.addressbook.add.name.label"),
              "input-hint": unref(it)("setting.addressbook.add.name.hint"),
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
            }, 8, ["input-text", "input-error", "label", "input-hint"]),
            __props.showAddrInput ? (openBlock(), createBlock(GridInput, {
              key: 0,
              "input-text": addrInput.value,
              "onUpdate:inputText": _cache[2] || (_cache[2] = ($event) => addrInput.value = $event),
              "input-error": addrInputError.value,
              "onUpdate:inputError": _cache[3] || (_cache[3] = ($event) => addrInputError.value = $event),
              class: "col-span-12 lg:col-span-8 pb-2",
              onLostFocus: validateAddrInput,
              onEnter: onAddToAddressBook,
              onReset: onResetAddr,
              label: unref(it)("setting.addressbook.add.addr.label"),
              "input-hint": unref(it)("setting.addressbook.add.addr.hint"),
              alwaysShowInfo: false,
              showReset: !unref(isAdaHandle)(nameInput.value),
              "input-disabled": unref(isAdaHandle)(nameInput.value),
              "input-id": "inputAddr",
              "input-type": "text"
            }, {
              "icon-prepend": withCtx(() => [
                createVNode(IconPencil, { class: "h-5 w-5" })
              ]),
              _: 1
            }, 8, ["input-text", "input-error", "label", "input-hint", "showReset", "input-disabled"])) : createCommentVNode("", true),
            createBaseVNode("div", _hoisted_4$1, [
              createVNode(GridButtonSecondary, {
                label: unref(it)("setting.addressbook.button.cancel"),
                link: onClose,
                class: "col-start-0 col-span-6 lg:col-start-7 lg:col-span-3"
              }, null, 8, ["label"]),
              createVNode(_sfc_main$3, {
                label: __props.editInput ? unref(it)("setting.addressbook.button.save") : unref(it)("setting.addressbook.button.add"),
                link: onAddToAddressBook,
                disabled: !validName.value || !validAddr.value || __props.editInput && nameInput.value === __props.oldName && addrInput.value === __props.oldAddr,
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
const _hoisted_1 = { class: "cc-grid" };
const _hoisted_2 = { class: "cc-area-light flex flex-col flex-nowrap p-2 md:px-3" };
const _hoisted_3 = { class: "table-auto divide-y" };
const _hoisted_4 = { class: "cc-text-bold cc-text-sz capitalize text-middle" };
const _hoisted_5 = { class: "flex flex-row flex-nowrap justify-start items-center" };
const _hoisted_6 = { class: "text-left" };
const _hoisted_7 = {
  key: 0,
  class: "text-right"
};
const _hoisted_8 = { class: "divide-y" };
const _hoisted_9 = ["onClick"];
const _hoisted_10 = ["onClick"];
const _hoisted_11 = {
  key: 0,
  class: "mt-1"
};
const _hoisted_12 = {
  key: 1,
  class: "mt-1"
};
const _hoisted_13 = {
  key: 0,
  class: "h-5 text-xl flex-none flex sm:mr-2 cursor-pointer justify-center items-center"
};
const _hoisted_14 = ["onClick"];
const _hoisted_15 = { class: "flex flex-row flex-nowrap justify-start items-center space-x-2" };
const itemsOnPage = 8;
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "AddressBook",
  props: {
    label: { type: Boolean, required: false, default: false },
    textId: { type: String, required: false, default: "setting.addressbook" },
    readonly: { type: Boolean, required: false, default: false },
    fullWidth: { type: Boolean, required: false, default: false }
  },
  emits: ["submit"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const $q = useQuasar();
    const { it } = useTranslation();
    const modalTitle = ref("");
    const modalCaption = ref("");
    const modalLabelCancel = ref(it("common.label.no"));
    const modalLabelConfirm = ref(it("common.label.yes"));
    const modalEntry = ref(null);
    const showModalAddEntry = ref({ display: false });
    const showModalDeleteEntry = ref({ display: false });
    const editInput = ref(false);
    const oldName = ref("");
    const oldAddr = ref("");
    const nameSortOrderAsc = ref(true);
    const syncing = ref([]);
    const entryList = computed(() => {
      var _a;
      return ((_a = addressBook.value) == null ? void 0 : _a.entryList) ?? [];
    });
    const currentPage = ref(1);
    const showPagination = computed(() => entryList.value.length > itemsOnPage);
    const currentPageStart = computed(() => (currentPage.value - 1) * itemsOnPage);
    const maxPages = computed(() => Math.ceil(entryList.value.length / itemsOnPage));
    const filteredEntryList = computed(() => {
      entryList.value.sort((a, b) => {
        if (nameSortOrderAsc.value) {
          return a.name.localeCompare(b.name, "en-US");
        }
        return b.name.localeCompare(a.name, "en-US");
      });
      return entryList.value.slice(currentPageStart.value, currentPageStart.value + itemsOnPage);
    });
    const syncHandleAddress = async (index, name, address) => {
      syncing.value[index] = true;
      try {
        const handle = await resolveAdaHandle(networkId.value, name);
        console.warn("syncHandleAddress", index, name, address, handle);
        if (handle.address !== address) {
          const success = await updateAddressBookEntry(networkId.value, name, handle.address);
          $q.notify({
            type: success ? "positive" : "negative",
            message: it("setting.addressbook.sync." + (success ? "update" : "error")),
            position: "top-left",
            timeout: 2e3
          });
        } else {
          $q.notify({
            type: "positive",
            message: it("setting.addressbook.sync.noupdate"),
            position: "top-left",
            timeout: 2e3
          });
        }
      } catch (err) {
        $q.notify({
          type: "negative",
          message: it("setting.addressbook.sync.error"),
          position: "top-left",
          timeout: 2e3
        });
      }
      syncing.value[index] = false;
    };
    const onEditAddressBookEntry = (name, address) => {
      editInput.value = true;
      oldName.value = name;
      oldAddr.value = address;
      modalTitle.value = it("setting.addressbook.edit.title.global.label");
      modalCaption.value = it("setting.addressbook.edit.title.global.caption");
      showModalAddEntry.value.display = true;
    };
    const onShowModalDeleteEntry = (entry) => {
      modalEntry.value = entry;
      modalTitle.value = it("setting.addressbook.delete.label");
      modalCaption.value = it("setting.addressbook.delete.confirm").replace("###name###", entry.name);
      showModalDeleteEntry.value.display = true;
    };
    const onDeleteAddressBookEntry = (name) => {
      showModalDeleteEntry.value.display = false;
      deleteAddressBookEntry(networkId.value, name);
    };
    const onAddToAddressBook = () => {
      onClose();
    };
    const onClose = () => {
      editInput.value = false;
      oldName.value = "";
      oldAddr.value = "";
      showModalAddEntry.value.display = false;
      showModalDeleteEntry.value.display = false;
    };
    const onClickedAddAddressBookEntry = () => {
      modalTitle.value = it("setting.addressbook.add.title.label");
      modalCaption.value = it("setting.addressbook.add.title.caption");
      showModalAddEntry.value.display = true;
    };
    const onClickedAddressBookEntry = (address) => {
      emit("submit", address);
    };
    return (_ctx, _cache) => {
      var _a, _b;
      return openBlock(), createElementBlock("div", _hoisted_1, [
        ((_a = showModalAddEntry.value) == null ? void 0 : _a.display) ? (openBlock(), createBlock(_sfc_main$1, {
          key: 0,
          "show-modal": showModalAddEntry.value,
          title: modalTitle.value,
          caption: modalCaption.value,
          "edit-input": editInput.value,
          "old-name": oldName.value,
          "old-addr": oldAddr.value,
          onClose: onAddToAddressBook
        }, null, 8, ["show-modal", "title", "caption", "edit-input", "old-name", "old-addr"])) : createCommentVNode("", true),
        ((_b = showModalDeleteEntry.value) == null ? void 0 : _b.display) ? (openBlock(), createBlock(_sfc_main$4, {
          key: 1,
          "show-modal": showModalDeleteEntry.value,
          title: modalTitle.value,
          caption: modalCaption.value,
          "cancel-label": modalLabelCancel.value,
          "confirm-label": modalLabelConfirm.value,
          onConfirm: _cache[0] || (_cache[0] = ($event) => {
            var _a2;
            return onDeleteAddressBookEntry(((_a2 = modalEntry.value) == null ? void 0 : _a2.name) ?? "");
          })
        }, null, 8, ["show-modal", "title", "caption", "cancel-label", "confirm-label"])) : createCommentVNode("", true),
        filteredEntryList.value.length > 0 ? (openBlock(), createElementBlock("div", {
          key: 2,
          class: normalizeClass(["col-span-12 item-text", __props.fullWidth ? "" : "pl-3 sm:pl-2.5 lg:pl-0"])
        }, [
          createBaseVNode("div", _hoisted_2, [
            createBaseVNode("table", _hoisted_3, [
              createBaseVNode("thead", null, [
                createBaseVNode("tr", _hoisted_4, [
                  createBaseVNode("th", {
                    class: "text-left min-w-24 cursor-pointer pr-1 sm:pr-2",
                    onClick: _cache[1] || (_cache[1] = withModifiers(($event) => nameSortOrderAsc.value = !nameSortOrderAsc.value, ["stop"]))
                  }, [
                    createBaseVNode("div", _hoisted_5, [
                      createBaseVNode("span", null, toDisplayString(unref(it)("setting.addressbook.table.header.name")), 1),
                      createBaseVNode("i", {
                        class: normalizeClass(["cc-text-xl mt-0.5 text-gray-400", nameSortOrderAsc.value ? "mdi mdi-chevron-up" : "mdi mdi-chevron-down"])
                      }, null, 2)
                    ])
                  ]),
                  createBaseVNode("th", _hoisted_6, toDisplayString(unref(it)("setting.addressbook.table.header.address")), 1),
                  !__props.readonly ? (openBlock(), createElementBlock("th", _hoisted_7, toDisplayString(unref(it)("setting.addressbook.table.header.action")), 1)) : createCommentVNode("", true)
                ])
              ]),
              createBaseVNode("tbody", _hoisted_8, [
                (openBlock(true), createElementBlock(Fragment, null, renderList(filteredEntryList.value, (entry, index) => {
                  return openBlock(), createElementBlock("tr", {
                    class: "align-middle cc-text-sm cursor-pointer",
                    key: index
                  }, [
                    createBaseVNode("td", {
                      class: normalizeClass(["pt-2 pr-2 break-all md:whitespace-nowrap", (!__props.readonly ? "" : "cursor-pointer ") + (index !== filteredEntryList.value.length - 1 ? "pb-2" : "")]),
                      onClick: withModifiers(($event) => onClickedAddressBookEntry(entry), ["stop"])
                    }, toDisplayString(entry.name), 11, _hoisted_9),
                    createBaseVNode("td", {
                      class: normalizeClass(["pt-2 cc-addr sm:text-sm", (!__props.readonly ? "" : "cursor-pointer ") + (index !== filteredEntryList.value.length - 1 ? "pb-2" : "")]),
                      onClick: withModifiers(($event) => onClickedAddressBookEntry(entry), ["stop"])
                    }, toDisplayString(entry.address), 11, _hoisted_10),
                    !__props.readonly ? (openBlock(), createElementBlock("td", {
                      key: 0,
                      class: normalizeClass(["pt-2 pl-2 sm:min-w-16 flex flex-col sm:flex-row flex-nowrap justify-center sm:justify-end items-center whitespace-nowrap space-y-1", index !== filteredEntryList.value.length - 1 ? "pb-2" : ""])
                    }, [
                      !unref(isAdaHandle)(entry.name) ? (openBlock(), createElementBlock("div", _hoisted_11, [
                        createVNode(IconPencil, {
                          class: "h-5 flex-none sm:mr-2 cursor-pointer",
                          onClick: ($event) => onEditAddressBookEntry(entry.name, entry.address)
                        }, null, 8, ["onClick"]),
                        createVNode(_sfc_main$5, {
                          anchor: "bottom middle",
                          "transition-show": "scale",
                          "transition-hide": "scale"
                        }, {
                          default: withCtx(() => [
                            createTextVNode(toDisplayString(unref(it)("setting.addressbook.button.edit")), 1)
                          ]),
                          _: 1
                        })
                      ])) : (openBlock(), createElementBlock("div", _hoisted_12, [
                        syncing.value[index] ? (openBlock(), createElementBlock("div", _hoisted_13, [
                          createVNode(QSpinnerDots_default, {
                            color: "gray",
                            class: "-mt-px"
                          })
                        ])) : createCommentVNode("", true),
                        !syncing.value[index] ? (openBlock(), createElementBlock("i", {
                          key: 1,
                          class: "h-5 text-xl flex-none sm:mr-2 cursor-pointer mdi mdi-sync",
                          onClick: ($event) => syncHandleAddress(index, entry.name, entry.address)
                        }, null, 8, _hoisted_14)) : createCommentVNode("", true),
                        createVNode(_sfc_main$5, {
                          anchor: "bottom middle",
                          "transition-show": "scale",
                          "transition-hide": "scale"
                        }, {
                          default: withCtx(() => [
                            createTextVNode(toDisplayString(unref(it)("setting.addressbook.button.sync")), 1)
                          ]),
                          _: 1
                        })
                      ])),
                      createBaseVNode("div", null, [
                        createVNode(IconDelete, {
                          class: "h-5 flex-none cc-text-color-error cursor-pointer",
                          onClick: ($event) => onShowModalDeleteEntry(entry)
                        }, null, 8, ["onClick"]),
                        createVNode(_sfc_main$5, {
                          anchor: "bottom middle",
                          "transition-show": "scale",
                          "transition-hide": "scale"
                        }, {
                          default: withCtx(() => [
                            createTextVNode(toDisplayString(unref(it)("setting.addressbook.button.delete")), 1)
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
          createBaseVNode("div", _hoisted_15, [
            createVNode(GridButtonSecondary, {
              label: unref(it)("setting.addressbook.button.addEntry"),
              link: onClickedAddAddressBookEntry,
              class: "w-48"
            }, null, 8, ["label"])
          ])
        ], 2)) : createCommentVNode("", true)
      ]);
    };
  }
});
export {
  _sfc_main as _,
  _sfc_main$1 as a,
  isAdaHandle as i,
  resolveAdaHandle as r
};
