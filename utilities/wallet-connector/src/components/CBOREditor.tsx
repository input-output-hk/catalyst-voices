import SwapHorizIcon from '@mui/icons-material/SwapHoriz';
import { noop } from "lodash-es";
import { useState, type CSSProperties, useEffect } from "react";
import AceEditor from "react-ace";
import hex2diag from "common/helpers/hex2diag";

import "ace-builds/src-noconflict/ext-language_tools";
import "ace-builds/src-noconflict/mode-text";
import diag2hex from 'common/helpers/diag2hex';

type Props = {
  value: string;
  isReadOnly?: boolean;
  onChange?: (value: string) => void;
}

const EDITOR_STYLE: CSSProperties = {
  width: "100%",
  fontFamily: "Fira Code, monospace",
  fontSize: 12,
  height: "240px"
} as const;

// bg-gray-100 font-mono text-xs h-[240px] overflow-y-auto

function CBOREditor({
  value,
  isReadOnly = false,
  onChange = noop
}: Props) {
  const [shouldRefresh, setShouldRefresh] = useState(true);
  const [focusingSide, setFocusingSide] = useState<"bin" | "diag">("bin");
  const [binValue, setBinValue] = useState("");
  const [diagValue, setDiagValue] = useState("");

  useEffect(() => {
    if (shouldRefresh) {
      setDiagValue(hex2diag(value));
      setBinValue(value);
      setShouldRefresh(false);
    }
  }, [ value, shouldRefresh ]);

  function handleBinChange(value: string) {
    setBinValue(value);

    const result = hex2diag(value);

    result.includes("Error:")
      ? setDiagValue(hex2diag(value))
      : (
        onChange(value),
        setShouldRefresh(true)
      );
  }

  function handleDiagChange(value: string) {
    setDiagValue(value);

    const result = diag2hex(value);

    result.includes("Error:")
      ? setBinValue(result)
      : (
        onChange(result),
        setShouldRefresh(true)
      );
  }

  return (
    <div className="rounded-md border border-solid border-black/10 overflow-hidden">
      <div className="px-2 py-1 flex items-center justify-between">
        <p className="flex gap-2 text-sm">
          <span>CBOR Editor</span>
          <span>|</span>
          <button type="button" className="hover:underline">Upload</button>
          <span>|</span>
          <button type="button" className="hover:underline">Export</button>
        </p>
        <p className="flex gap-1 items-center text-sm">
          <span>bin</span>
          <SwapHorizIcon fontSize="small" />
          <span>diag</span>
        </p>
      </div>
      <div className="grid grid-cols-2">
        <AceEditor
          value={focusingSide === "bin" ? undefined : binValue}
          style={EDITOR_STYLE}
          mode="text"
          onChange={handleBinChange}
          onFocus={() => setFocusingSide("bin")}
          editorProps={{ $blockScrolling: true }}
        />
        <AceEditor
          value={focusingSide === "diag" ? undefined : diagValue}
          style={EDITOR_STYLE}
          mode="text"
          onChange={handleDiagChange}
          onFocus={() => setFocusingSide("diag")}
          editorProps={{ $blockScrolling: true }}
        />
      </div>
    </div>
  )
}

export default CBOREditor;