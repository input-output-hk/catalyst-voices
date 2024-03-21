import { Disclosure } from "@headlessui/react";
import { toast } from "react-toastify";

import type { ExtensionArguments } from "types/cardano";

type Props = {
  heading: string;
  value: string | string[] | null | ExtensionArguments[];
  raw?: string;
  from?: string;
};

function InfoItem({ heading, value, raw, from }: Props) {
  async function handleCopy(value: string) {
    await navigator.clipboard.writeText(value);

    toast.success("Value copied.");
  }

  return (
    <Disclosure as="div" className="gap-2" defaultOpen={true}>
      <Disclosure.Button>
        <div className="flex gap-2 items-center">
          <div className="text-xs bg-black/10 px-2 rounded">{from?.toUpperCase()}</div>
          <h3 className="font-semibold">{heading}: </h3>
        </div>
      </Disclosure.Button>
      <Disclosure.Panel className="grid gap-1">
        {typeof raw !== "undefined" && Boolean(String(raw)) && (
          <div>
            <button type="button" className="inline" onClick={() => handleCopy(raw)}>
              <p className="w-fit break-all hover:underline cursor-copy text-left text-[10px] text-black/50">{raw}</p>
            </button>
          </div>
        )}
        {typeof value === "string" ? (
          <button
            type="button"
            className="w-fit break-all hover:underline cursor-copy text-left text-sm"
            onClick={() => handleCopy(value)}
          >
            <p>{value || "-"}</p>
          </button>
        ) : Array.isArray(value) && value.length ? (
          <ol className="list-disc list-inside">
            {value
              .map((v) => (typeof v === "object" ? JSON.stringify(v) : v))
              .map((v) => (
                <ol key={v}>
                  <button
                    type="button"
                    className="w-fit break-all hover:underline cursor-copy text-left text-sm"
                    onClick={() => handleCopy(v)}
                  >
                    {v || "-"}
                  </button>
                </ol>
              ))}
          </ol>
        ) : (
          <p className="w-fit break-all text-sm">{String(value) || "-"}</p>
        )}
      </Disclosure.Panel>
    </Disclosure>
  );
}

export default InfoItem;
