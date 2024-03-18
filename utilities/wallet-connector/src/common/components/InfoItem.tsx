import { toast } from "react-toastify";

import type { ExtensionArguments } from "types/cardano";

type Props = {
  heading: string;
  value: string | string[] | null | ExtensionArguments[];
};

function InfoItem({ heading, value }: Props) {
  async function handleCopy(value: string) {
    await navigator.clipboard.writeText(value);

    toast.success("Value coppied.");
  }

  return (
    <div className="gap-2">
      <h3 className="font-semibold">{heading}: </h3>
      {typeof value === "string" ? (
        <button type="button" className="w-fit break-all hover:underline cursor-copy" onClick={() => handleCopy(value)}>
          <p>{value || "-"}</p>
        </button>
      ) : Array.isArray(value) && value.length ? (
        <ol className="list-disc list-inside">
          {value.map((v) => typeof v === "object" ? JSON.stringify(v) : v).map((v) => (
            <ol key={v}>
              <button type="button" className="w-fit break-all hover:underline cursor-copy" onClick={() => handleCopy(v)}>
                {v || "-"}
              </button>
            </ol>
          ))}
        </ol>
      ) : (
        <p className="w-fit break-all">{String(value) || "-"}</p>
      )}
    </div>
  );
}

export default InfoItem;