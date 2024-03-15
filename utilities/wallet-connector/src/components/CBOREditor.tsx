import SwapHorizIcon from '@mui/icons-material/SwapHoriz';
import { noop } from "lodash-es";
import { useState, type CSSProperties, useEffect } from "react";
import AceEditor from "react-ace";
import JSON5 from "json5";
import hex2diag from "common/helpers/hex2diag";

import "ace-builds/src-noconflict/ext-language_tools";
import "ace-builds/src-noconflict/mode-text";
import diag2hex from 'common/helpers/diag2hex';
import { decode, encode } from 'cborg';
import hex2bin from 'common/helpers/hex2bin';
import bin2hex from 'common/helpers/bin2hex';

type Side = "lhs" | "rhs";
type Mode = "bin2diag" | "bin2json";

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
  const [mode, setMode] = useState<Mode>("bin2diag");
  const [focusingSide, setFocusingSide] = useState<Side>("lhs");
  const [lhsValue, setLhsValue] = useState("");
  const [rhsValue, setRhsValue] = useState("");

  useEffect(() => {
    if (shouldRefresh) {
      try {
        const rhsValue = mode === "bin2diag"
        ? hex2diag(value)
        : JSON5.stringify(decode(hex2bin(value)), null, 2);

        setRhsValue(rhsValue);
      } catch (e) {
        setRhsValue(String(e));
      }
      
      setLhsValue(value);
      setShouldRefresh(false);
    }
  }, [value, shouldRefresh]);

  function handleLhsChange(value: string) {
    setLhsValue(value);

    const result = hex2diag(value);

    result.includes("Error:")
      ? setRhsValue(hex2diag(value))
      : (
        onChange(value),
        setShouldRefresh(true)
      );
  }

  function handleRhsChange(value: string) {
    setRhsValue(value);

    try {
      const result = mode === "bin2diag"
        ? diag2hex(value)
        : bin2hex(encode(JSON5.parse(value)));

      result.includes("Error:")
        ? setLhsValue(result)
        : (
          onChange(result),
          setShouldRefresh(true)
        );
    } catch (e) {
      setLhsValue(String(e));
    }
  }

  function switchMode() {
    setFocusingSide("lhs");
    setMode((prev) => prev === "bin2diag" ? "bin2json" : "bin2diag");
    setShouldRefresh(true);
  }

  return (
    <div className="rounded-md border border-solid border-black/10 overflow-hidden">
      <div className="px-2 py-1 flex items-center justify-between">
        <p className="flex gap-2 text-sm">
          <span>CBOR Editor</span>
          {!isReadOnly && (
            <>
              <span>|</span>
              <button type="button" className="hover:underline">Upload</button>
            </>
          )}
          <span>|</span>
          <button type="button" className="hover:underline">Export</button>
        </p>
        <p className="flex gap-1 items-center text-sm">
          <span>bin</span>
          <button type="button" onClick={switchMode}>
            <SwapHorizIcon fontSize="small" />
          </button>
          <span>{mode === "bin2diag" ? "diag" : "json5"}</span>
        </p>
      </div>
      <div className="grid grid-cols-2">
        <AceEditor
          value={focusingSide === "lhs" ? undefined : lhsValue}
          style={EDITOR_STYLE}
          readOnly={isReadOnly}
          mode="text"
          onChange={handleLhsChange}
          onFocus={() => setFocusingSide("lhs")}
          editorProps={{ $blockScrolling: true }}
        />
        <AceEditor
          value={focusingSide === "rhs" ? undefined : rhsValue}
          style={EDITOR_STYLE}
          readOnly={isReadOnly}
          mode="text"
          onChange={handleRhsChange}
          onFocus={() => setFocusingSide("rhs")}
          editorProps={{ $blockScrolling: true }}
        />
      </div>
    </div>
  )
}

export default CBOREditor;