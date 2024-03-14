import { useState, type CSSProperties } from "react";
import AceEditor from "react-ace";
import SwapHorizIcon from '@mui/icons-material/SwapHoriz';
import { encode, decode } from "cborg";
import { noop } from "lodash-es";
import hex2bin from "common/helpers/hex2bin";

import "ace-builds/src-noconflict/mode-text";
import "ace-builds/src-noconflict/ext-language_tools";

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
    
  }

  function handleDiagChange(value: string) {

  }

  const tmp = decode(hex2bin("a16474686973a26269736543424f522163796179f5"), { })

  // console.log(tokensToDiagnostic(hex2bin("a16474686973a26269736543424f522163796179f5")));

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
          value={JSON.stringify(tmp, null, 2)}
          style={EDITOR_STYLE}
          mode="text"
          onChange={handleBinChange}
          editorProps={{ $blockScrolling: true }}
        />
        <AceEditor
          value={value}
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