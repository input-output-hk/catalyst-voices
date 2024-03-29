import { Combobox as HeadlessCombobox } from "@headlessui/react";
import CheckIcon from "@mui/icons-material/Check";
import UnfoldMoreIcon from "@mui/icons-material/UnfoldMore";
import { noop, unionBy } from "lodash-es";
import { useState } from "react";
import { twMerge } from "tailwind-merge";

type Props = {
  value: string;
  label?: string;
  items: {
    label: string;
    value: string;
  }[];
  onInput: (value: string) => void;
  onSelect: (value: string) => void;
};

function Combobox({ value, items, label, onInput = noop, onSelect = noop }: Props) {
  const [input, setInput] = useState("");

  const inputItem = { label: input, value: input };

  function handleInput(value: string) {
    onInput(value);
    setInput(value);
  }

  function handleSelect(value: string) {
    onSelect(value);
    setInput(value);
  }

  return (
    <HeadlessCombobox as="div" className="relative mt-1" value={value} onChange={handleSelect}>
      <div className="relative flex gap-2 w-full rounded-md border border-solid border-black/10 p-2">
        <HeadlessCombobox.Input
          className="w-full truncate focus:outline-none"
          onChange={(event) => handleInput(event.target.value)}
        />
        <span className="absolute text-sm text-gray-500 transform -translate-y-4 scale-75 top-2 z-10 origin-[0] bg-white px-2 peer-focus:px-2 peer-focus:text-blue-600 peer-placeholder-shown:scale-100 peer-placeholder-shown:-translate-y-1/2 peer-placeholder-shown:top-1/2 peer-focus:top-2 peer-focus:scale-75 peer-focus:-translate-y-4 rtl:peer-focus:translate-x-1/4 rtl:peer-focus:left-auto start-1">
          {label}
        </span>
        <HeadlessCombobox.Button className="flex items-center pr-2">
          <UnfoldMoreIcon className="h-5 w-5 text-gray-400" aria-hidden="true" />
        </HeadlessCombobox.Button>
      </div>
      <HeadlessCombobox.Options className="absolute mt-1 max-h-60 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black/5 focus:outline-none sm:text-sm z-50">
        {unionBy([inputItem, ...items], "value").map(({ label, value }) => (
          <HeadlessCombobox.Option
            className={({ active }) =>
              twMerge(
                "relative cursor-default select-none py-2 px-4",
                active ? "bg-secondary text-white" : "text-gray-900"
              )
            }
            key={value}
            value={value}
          >
            {({ active, selected }) => (
              <div className="flex gap-2 items-center">
                <CheckIcon
                  className={twMerge("h-5 w-5", selected ? "visible" : "invisible")}
                  aria-hidden="true"
                />
                <span title={label} className="truncate">
                  {label}
                </span>
              </div>
            )}
          </HeadlessCombobox.Option>
        ))}
      </HeadlessCombobox.Options>
    </HeadlessCombobox>
  );
}

export default Combobox;
