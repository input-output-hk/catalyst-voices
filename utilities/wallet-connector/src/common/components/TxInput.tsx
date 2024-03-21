import { noop } from "lodash-es";
import { useState } from "react";
import { twMerge } from "tailwind-merge";

import CBOREditor from "./CBOREditor";
import TxBuilder from "./TxBuilder";

type Mode = "raw" | "builder";

type Props = {
  value: string;
  isReadOnly?: boolean;
  onChange?: (value: string) => void;
};

function TxInput({ value, isReadOnly = false, onChange = noop }: Props) {
  const [mode, setMode] = useState<Mode>("raw");

  return (
    <div className="grid gap-2">
      <div className="flex border border-solid border-black/10 rounded-md overflow-hidden w-fit">
        <button type="button" className={twMerge("px-4 py-1", mode === "raw" && "bg-secondary text-white")} onClick={() => setMode("raw")}>
          <p>Raw</p>
        </button>
        <button type="button" className={twMerge("px-4 py-1", mode === "builder" && "bg-secondary text-white")} onClick={() => setMode("builder")}>
          <p>Builder</p>
        </button>
      </div>
      <div>
        {mode === "raw" ? (
          <CBOREditor value={value} isReadOnly={isReadOnly} onChange={onChange} />
        ) : (
          <TxBuilder />
        )}
      </div>
    </div>
  );
}

export default TxInput;