import { d as defineComponent, a7 as useQuasar, z as ref, o as openBlock, c as createElementBlock, e as createBaseVNode, aA as renderSlot, a as createBlock, h as withCtx, q as createVNode, u as unref, j as createCommentVNode, b as withModifiers } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { _ as _sfc_main$1 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { M as Modal } from "./Modal.js";
import { Q as QrcodeStream } from "./QrcodeStream.js";
const _hoisted_1 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_2 = { class: "flex flex-col cc-text-sz" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "ScanQrCode2",
  props: {
    disabled: { type: Boolean, required: false, default: false }
  },
  emits: ["decode"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { it } = useTranslation();
    useQuasar();
    const open = ref(false);
    const cameraToUse = ref("rear");
    const deviceCount = ref(1);
    function scanQrCode() {
      open.value = !open.value;
    }
    const switchCamera = async () => {
      if (cameraToUse.value === "rear") {
        cameraToUse.value = "front";
      } else {
        cameraToUse.value = "rear";
      }
    };
    function onDecode(str) {
      emit("decode", { content: str });
      open.value = false;
    }
    const onClose = () => {
      open.value = false;
    };
    async function onInit(promise) {
      try {
        await promise;
        const devices = (await navigator.mediaDevices.enumerateDevices()).filter(
          ({ kind }) => kind === "videoinput"
        );
        deviceCount.value = devices.length;
      } catch (error) {
        let desc = "";
        if (error.name === "NotAllowedError") {
          desc = "ERROR: you need to grant camera access permission";
        } else if (error.name === "NotFoundError") {
          desc = "ERROR: no camera on this device";
        } else if (error.name === "NotSupportedError") {
          desc = "ERROR: secure context required (HTTPS, localhost)";
        } else if (error.name === "NotReadableError") {
          desc = "ERROR: is the camera already in use?";
        } else if (error.name === "OverconstrainedError") {
          desc = "ERROR: installed cameras are not suitable";
        } else if (error.name === "StreamApiNotSupportedError") {
          desc = "ERROR: Stream API is not supported in this browser";
        } else if (error.name === "InsecureContextError") {
          desc = "ERROR: Camera access is only permitted in secure context. Use HTTPS or localhost rather than HTTP.";
        } else {
          desc = `ERROR: Camera error (${error.name})`;
        }
        console.warn("ERROR", desc);
      }
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("button", {
        onClick: withModifiers(scanQrCode, ["stop", "prevent"]),
        class: "qr-code-button"
      }, [
        _cache[0] || (_cache[0] = createBaseVNode("i", { class: "mdi mdi-qrcode drop-shadow text-xl" }, null, -1)),
        renderSlot(_ctx.$slots, "default"),
        open.value ? (openBlock(), createBlock(Modal, {
          key: 0,
          "full-width-on-mobile": "",
          onClose
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_1, [
              createBaseVNode("div", _hoisted_2, [
                createVNode(_sfc_main$1, {
                  label: unref(it)("wallet.qr.scan.headline")
                }, null, 8, ["label"])
              ])
            ])
          ]),
          content: withCtx(() => [
            createVNode(QrcodeStream, {
              class: "shadow cc-rounded",
              onDecode,
              onInit,
              camera: cameraToUse.value
            }, null, 8, ["camera"])
          ]),
          footer: withCtx(() => [
            deviceCount.value > 1 ? (openBlock(), createElementBlock("div", {
              key: 0,
              onClick: switchCamera,
              class: "flex flex-col content-center items-center justify-center p-2"
            }, [
              createVNode(GridButtonSecondary, {
                class: "col-start-0 col-span-6 md:col-start-12 md:col-span-1 h-11 p-2",
                icon: unref(it)("wallet.qr.switch.icon"),
                label: unref(it)("wallet.qr.switch.label"),
                link: switchCamera,
                type: "button"
              }, null, 8, ["icon", "label"])
            ])) : createCommentVNode("", true)
          ]),
          _: 1
        })) : createCommentVNode("", true)
      ]);
    };
  }
});
export {
  _sfc_main as _
};
