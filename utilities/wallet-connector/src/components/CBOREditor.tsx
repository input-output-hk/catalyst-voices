import SwapHorizIcon from '@mui/icons-material/SwapHoriz';
import { noop } from "lodash-es";
import { useState, type CSSProperties } from "react";
import AceEditor from "react-ace";
import hex2diag from "common/helpers/hex2diag";

import "ace-builds/src-noconflict/ext-language_tools";
import "ace-builds/src-noconflict/mode-text";

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
  const [prevValue, setPrevValue] = useState("");

  function handleBinChange(value: string) {
    onChange(value);
  }

  function handleDiagChange(value: string) {

  }

  console.log(hex2diag("a16474686973a26269736543424f522163796179f5"));

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
          value={value}
          style={EDITOR_STYLE}
          mode="text"
          onChange={handleBinChange}
          editorProps={{ $blockScrolling: true }}
        />
        <AceEditor
          value={hex2diag(value)}
          style={EDITOR_STYLE}
          mode="text"
          onChange={handleDiagChange}
          editorProps={{ $blockScrolling: true }}
        />
      </div>
    </div>
  )
}

export default CBOREditor;