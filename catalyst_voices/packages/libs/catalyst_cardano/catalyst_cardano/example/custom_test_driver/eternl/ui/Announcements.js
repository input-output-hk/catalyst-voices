var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
import { bO as Dexie, bP as getLastAnnouncementCheck, a2 as now, bQ as setLastAnnouncementCheck, L as api, d as defineComponent, z as ref, bI as onBeforeMount, ar as appLanguageTag, bN as isIosApp, bR as isAndroidApp, $ as isBexApp, o as openBlock, c as createElementBlock, e as createBaseVNode, q as createVNode, h as withCtx, u as unref, Q as QSpinnerDots_default, H as Fragment, I as renderList, t as toDisplayString, i as createTextVNode, B as useFormatter } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$3 } from "./Page.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$2 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$1 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
import "./NetworkId.js";
class AnnouncementsDB extends Dexie {
  constructor() {
    super("eternl-announcements");
    __publicField(this, "list");
    this.version(2).stores({
      list: "headline"
    });
  }
}
const dbMap = {};
const getDB = async (id = "announcements") => {
  let db = dbMap[id];
  if (!db) {
    db = new AnnouncementsDB();
    dbMap[id] = db;
  }
  if (!db.isOpen()) {
    await db.open();
  }
  return db;
};
const getAll = () => getDB().then((db) => db.list.toArray());
const put = (item) => getDB().then((db) => db.list.put(item));
const bulkPut = (list) => getDB().then((db) => db.list.bulkPut(list));
const clear = () => getDB().then((db) => db.list.clear());
const remove = () => Dexie.delete("eternl-announcements");
const AnnouncementDB = {
  getAll,
  put,
  bulkPut,
  clear,
  remove
};
const getAnnouncements = async (networkId, language = "en") => {
  const announcementsDb = await loadAnnouncements(networkId, language);
  const lac = parseInt(getLastAnnouncementCheck().value);
  if (announcementsDb.length === 0 || lac + 60 * 60 * 1e3 < now()) {
    const announcements = await fetchAnnouncements(networkId, language);
    await AnnouncementDB.clear();
    await AnnouncementDB.bulkPut(announcements);
    setLastAnnouncementCheck(now().toString());
    return announcements;
  } else {
    return announcementsDb;
  }
};
const loadAnnouncements = async (networkId, language = "en") => {
  return (await AnnouncementDB.getAll()).filter((ann) => ann.language === language).sort((a, b) => b.datetime - a.datetime);
};
const fetchAnnouncements = async (networkId, language = "en") => {
  const url = "/" + networkId + "/v1/misc/announcements";
  const res = await api.post(url, {
    lang: language
  }).catch((err) => {
  });
  if (res && res.data.length > 0) {
    return res.data;
  }
  if (language !== "en") {
    const res2 = await api.post(url, {
      lang: "en"
    }).catch((err) => {
      throw new Error("Announcements can not be fetched.");
    });
    if (res2) {
      return res2.data;
    }
  }
  return [];
};
const _hoisted_1 = { class: "relative w-full h-full cc-rounded flex flex-row-reverse flex-nowrap" };
const _hoisted_2 = { class: "relative h-full flex-1 overflow-hidden focus:outline-none flex flex-col flex-nowrap" };
const _hoisted_3 = { class: "cc-page-wallet cc-text-sz pt-4 sm:pt-6 md:pt-14 px-4 sm:px-8" };
const _hoisted_4 = {
  key: 0,
  class: "col-span-12 mt-2 pt-4 flex justify-center items-center"
};
const _hoisted_5 = {
  key: 1,
  class: "col-span-12 mt-2 pt-4 grid gap-6 lg:grid-cols-1 lg:gap-x-5 lg:gap-y-4"
};
const _hoisted_6 = { class: "text-sm" };
const _hoisted_7 = ["datetime"];
const _hoisted_8 = ["href"];
const _hoisted_9 = ["innerHTML"];
const _hoisted_10 = ["innerHTML"];
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Announcements",
  setup(__props) {
    const { it } = useTranslation();
    const { formatDatetime } = useFormatter();
    const announcements = ref([]);
    const showSpinner = ref(true);
    onBeforeMount(async () => {
      announcements.value = (await getAnnouncements("mainnet", (appLanguageTag.value.languageTag ?? "en").split("-")[0])).filter((entry) => {
        if (isIosApp()) {
          return entry.ios;
        } else if (isAndroidApp()) {
          return entry.android;
        } else if (isBexApp()) {
          return entry.bex;
        } else {
          return entry.web;
        }
      }).sort((a, b) => a.datetime < b.datetime ? 1 : -1);
      showSpinner.value = false;
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createBaseVNode("main", _hoisted_2, [
          createVNode(_sfc_main$3, {
            containerCSS: "",
            "align-top": ""
          }, {
            default: withCtx(() => [
              createBaseVNode("div", _hoisted_3, [
                createVNode(_sfc_main$1, {
                  label: unref(it)("announcements.headline"),
                  class: "cc-text-2xl sm:mt-4"
                }, null, 8, ["label"]),
                createVNode(GridSpace, { hr: "" }),
                showSpinner.value ? (openBlock(), createElementBlock("div", _hoisted_4, [
                  createVNode(QSpinnerDots_default, {
                    color: "grey",
                    size: "3em"
                  })
                ])) : (openBlock(), createElementBlock("div", _hoisted_5, [
                  (openBlock(true), createElementBlock(Fragment, null, renderList(announcements.value, (post, index) => {
                    return openBlock(), createElementBlock("div", {
                      key: post.datetime + "." + index
                    }, [
                      createBaseVNode("p", _hoisted_6, [
                        createBaseVNode("time", {
                          datetime: post.datetime.toString()
                        }, toDisplayString(unref(formatDatetime)(post.datetime, true, false)), 9, _hoisted_7),
                        createBaseVNode("a", {
                          href: post.targetUrl,
                          target: "_blank"
                        }, [
                          _cache[0] || (_cache[0] = createBaseVNode("i", { class: "mdi mdi-open-in-new mx-1" }, null, -1)),
                          createVNode(_sfc_main$2, {
                            anchor: "top middle",
                            "transition-show": "scale",
                            "transition-hide": "scale"
                          }, {
                            default: withCtx(() => [
                              createTextVNode(toDisplayString(unref(it)("announcements.openWiki")), 1)
                            ]),
                            _: 1
                          })
                        ], 8, _hoisted_8)
                      ]),
                      createBaseVNode("div", null, [
                        createBaseVNode("h1", {
                          class: "cc-text-md font-semibold",
                          innerHTML: post.headline
                        }, null, 8, _hoisted_9),
                        createBaseVNode("div", {
                          innerHTML: post.summary
                        }, null, 8, _hoisted_10)
                      ]),
                      createVNode(GridSpace, {
                        class: "pt-4",
                        hr: ""
                      })
                    ]);
                  }), 128))
                ]))
              ])
            ]),
            _: 1
          })
        ])
      ]);
    };
  }
});
const Announcements = /* @__PURE__ */ _export_sfc(_sfc_main, [["__scopeId", "data-v-3f226c47"]]);
export {
  Announcements as default
};
