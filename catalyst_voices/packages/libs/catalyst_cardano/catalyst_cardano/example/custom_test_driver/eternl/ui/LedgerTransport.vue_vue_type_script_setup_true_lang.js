import { d as defineComponent, j1 as getLedgerTransport, z as ref, D as watch, jP as setLedgerTransport, o as openBlock, c as createElementBlock, e as createBaseVNode, t as toDisplayString, u as unref, i as createTextVNode, n as normalizeClass, q as createVNode, h as withCtx, cb as QToggle_default } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$1 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1 = { class: "col-span-12 flex flex-row justify-between xs:justify-start" };
const _hoisted_2 = { class: "flex flex-row flex-nowrap items-center mr-4" };
const _hoisted_3 = { class: "flex flex-row flex-nowrap items-center" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "LedgerTransport",
  props: {
    disabled: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const props = __props;
    const { it } = useTranslation();
    const ledgerTransport = getLedgerTransport();
    const enableBluetooth = ref(ledgerTransport.value === "Bluetooth");
    watch(enableBluetooth, () => {
      if (enableBluetooth.value) {
        setBluetooth();
      } else {
        setUSB();
      }
    });
    const setBluetooth = () => {
      if (ledgerTransport.value === "Bluetooth") return;
      setLedgerTransport("Bluetooth");
      enableBluetooth.value = true;
    };
    const setUSB = () => {
      if (ledgerTransport.value === "USB") return;
      setLedgerTransport("USB");
      enableBluetooth.value = false;
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createBaseVNode("div", _hoisted_2, toDisplayString(unref(it)("wallet.pair.setting.ledger.label")) + ": ", 1),
        createBaseVNode("div", _hoisted_3, [
          createBaseVNode("div", {
            onClick: _cache[0] || (_cache[0] = ($event) => setUSB()),
            class: "flex flex-row flex-nowrap items-center cursor-pointer"
          }, [
            _cache[3] || (_cache[3] = createTextVNode(" USB ")),
            createBaseVNode("i", {
              class: normalizeClass(["mdi mdi-usb drop-shadow text-xl", enableBluetooth.value ? "text-gray-700" : "text-green-700"])
            }, [
              createVNode(_sfc_main$1, {
                anchor: "top middle",
                offset: [0, 30],
                "transition-show": "scale",
                "transition-hide": "scale"
              }, {
                default: withCtx(() => [
                  createTextVNode(toDisplayString(!enableBluetooth.value ? unref(it)("wallet.pair.setting.ledger.usb") : unref(it)("wallet.pair.setting.ledger.bluetooth")), 1)
                ]),
                _: 1
              })
            ], 2)
          ]),
          createVNode(QToggle_default, {
            modelValue: enableBluetooth.value,
            "onUpdate:modelValue": _cache[1] || (_cache[1] = ($event) => enableBluetooth.value = $event),
            disable: props.disabled,
            color: "blue",
            "checked-icon": "mdi-bluetooth",
            "unchecked-icon": "mdi-usb",
            "keep-color": ""
          }, {
            default: withCtx(() => [
              createVNode(_sfc_main$1, {
                anchor: "top middle",
                offset: [0, 30],
                "transition-show": "scale",
                "transition-hide": "scale"
              }, {
                default: withCtx(() => [
                  createTextVNode(toDisplayString(!enableBluetooth.value ? unref(it)("wallet.pair.setting.ledger.usb") : unref(it)("wallet.pair.setting.ledger.bluetooth")), 1)
                ]),
                _: 1
              })
            ]),
            _: 1
          }, 8, ["modelValue", "disable"]),
          createBaseVNode("div", {
            onClick: _cache[2] || (_cache[2] = ($event) => setBluetooth()),
            class: "flex flex-row flex-nowrap items-center cursor-pointer"
          }, [
            createBaseVNode("i", {
              class: normalizeClass(["mdi mdi-bluetooth text-xl", enableBluetooth.value ? "text-green-700" : "text-gray-700"])
            }, [
              createVNode(_sfc_main$1, {
                anchor: "top middle",
                offset: [0, 30],
                "transition-show": "scale",
                "transition-hide": "scale"
              }, {
                default: withCtx(() => [
                  createTextVNode(toDisplayString(!enableBluetooth.value ? unref(it)("wallet.pair.setting.ledger.usb") : unref(it)("wallet.pair.setting.ledger.bluetooth")), 1)
                ]),
                _: 1
              })
            ], 2),
            _cache[4] || (_cache[4] = createTextVNode(" Bluetooth "))
          ])
        ])
      ]);
    };
  }
});
export {
  _sfc_main as _
};
