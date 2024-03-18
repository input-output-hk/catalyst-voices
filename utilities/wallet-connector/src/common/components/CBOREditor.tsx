import SwapHorizIcon from "@mui/icons-material/SwapHoriz";
import { decode, encode } from "cborg";
import { noop } from "lodash-es";
import { useEffect, useState, type CSSProperties } from "react";
import AceEditor from "react-ace";
import { useDropzone } from "react-dropzone";
import { toast } from "react-toastify";
import { twMerge } from "tailwind-merge";

import bin2hex from "common/helpers/bin2hex";
import diag2hex from "common/helpers/diag2hex";
import hex2bin from "common/helpers/hex2bin";
import hex2diag from "common/helpers/hex2diag";
import readFile from "common/helpers/readFile";

import "ace-builds/src-noconflict/ext-language_tools";
import "ace-builds/src-noconflict/mode-json";
import "ace-builds/src-noconflict/mode-text";

type Side = "lhs" | "rhs";
type Mode = "bin2diag" | "bin2json";

type Props = {
  value: string;
  isReadOnly?: boolean;
  onChange?: (value: string) => void;
};

const EDITOR_STYLE: CSSProperties = {
  width: "100%",
  fontFamily: "Fira Code, monospace",
  fontSize: 12,
  height: "240px"
} as const;

function CBOREditor({
  value,
  isReadOnly = false,
  onChange = noop
}: Props) {
  const [shouldRefresh, setShouldRefresh] = useState(true);
  const [mode, setMode] = useState<Mode>("bin2diag");
  const [focusingSide, setFocusingSide] = useState<Side | null>(null);
  const [lhsValue, setLhsValue] = useState("");
  const [rhsValue, setRhsValue] = useState("");

  const {getRootProps, getInputProps, isDragActive, open} = useDropzone({
    accept: {
      "text/plain": [".txt"],
      "application/json": [".json"],
      "application/octet-stream": [".bin"],
    },
    multiple: false,
    disabled: isReadOnly,
    noClick: true,
    onDrop: async ([ acceptedFile ]: File[]) => {
      if (!acceptedFile) {
        return void toast.error("Invalid file.");
      }

      if (acceptedFile.type === "application/octet-stream") {
        const result = await readFile(acceptedFile, "buffer") as ArrayBuffer;
        onChange(bin2hex(new Uint8Array(result)));
      } else if (acceptedFile.type === "application/json") {
        const result = await readFile(acceptedFile, "text") as string;
        try {
          const finalResult = bin2hex(encode(JSON.parse(result)));
          onChange(finalResult);
        } catch (err) {
          toast.error("Failed to read a JSON file.");
        }
      } else if (acceptedFile.type === "text/plain") {
        const result = await readFile(acceptedFile, "text") as string;
        onChange(bin2hex(hex2bin(result)));
      } else {
        toast.error(`The uploaded file type is unacceptable (${acceptedFile.type}).`);
      }

      setShouldRefresh(true);
      setFocusingSide(null);
    }
  });

  useEffect(() => {
    if (shouldRefresh) {
      try {
        const rhsValue = mode === "bin2diag"
        ? hex2diag(value)
        : JSON.stringify(value ? decode(hex2bin(value)) : undefined, null, 2);

        setRhsValue(rhsValue);
      } catch (e) {
        setRhsValue(String(e));
      }
      
      setLhsValue(value);
      setShouldRefresh(false);
    }
  }, [value, shouldRefresh]); // eslint-disable-line react-hooks/exhaustive-deps

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
        : bin2hex(encode(JSON.parse(value)));

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
    <div
      className={twMerge("relative rounded-md border border-solid border-black/10 overflow-hidden", isDragActive && "border-secondary")}
      {...getRootProps()}
    >
      <input {...getInputProps()} />
      <div className={twMerge("absolute bg-secondary/50 w-full h-full z-10", isDragActive ? "block" : "hidden")}></div>
      <div className="px-2 py-1 flex items-center justify-between">
        <p className="flex gap-2 text-sm">
          <span>CBOR Editor</span>
          {!isReadOnly && (
            <>
              <span>|</span>
              <button type="button" className="hover:underline" onClick={open}>Upload</button>
            </>
          )}
        </p>
        <p className="flex gap-1 items-center text-sm">
          <span>bin</span>
          <button type="button" onClick={switchMode}>
            <SwapHorizIcon fontSize="small" />
          </button>
          <span>{mode === "bin2diag" ? "diag" : "json"}</span>
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
          mode={mode === "bin2diag" ? "text" : "json"}
          onChange={handleRhsChange}
          onFocus={() => setFocusingSide("rhs")}
          editorProps={{ $blockScrolling: true }}
        />
      </div>
    </div>
  );
}

export default CBOREditor;