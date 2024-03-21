import { toast } from "react-toastify";

import type { ExtensionArguments } from "types/cardano";

type Props = {
  heading: string;
  value: string | string[] | null | ExtensionArguments[];
  from?: string;
};

function InfoItem({ heading, value, from }: Props) {
  async function handleCopy(value: string) {
    await navigator.clipboard.writeText(value);

    toast.success("Value copied.");
  }

  return (
    <div className="gap-2">
      <div className="flex gap-2 items-center">
        <div className="text-xs bg-black/10 px-2 rounded">{from?.toUpperCase()}</div>
        <h3 className="font-semibold">{heading}: </h3>
      </div>
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
    </div>
  );
}

export default InfoItem;
