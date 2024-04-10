import { Menu } from "@headlessui/react";
import KeyboardArrowDownIcon from "@mui/icons-material/KeyboardArrowDown";
import KeyboardArrowUpIcon from "@mui/icons-material/KeyboardArrowUp";
import { noop } from "lodash-es";
import { twMerge } from "tailwind-merge";

type Props = {
  value: string;
  items: {
    label: string;
    value: string;
    disabled?: boolean;
  }[];
  onSelect?: (value: string) => void;
};

function Dropdown({ value, items, onSelect = noop }: Props) {
  const valueLabel = items.find((item) => item.value === value)?.label ?? value;

  return (
    <Menu as="div" className="relative inline-block text-left">
      <Menu.Button className="flex items-center w-full rounded-md border border-solid border-black/10 p-2">
        {({ open }) => (
          <>
            <p className="truncate">{valueLabel}</p>
            {open ? <KeyboardArrowUpIcon /> : <KeyboardArrowDownIcon />}
          </>
        )}
      </Menu.Button>
      <Menu.Items className="absolute left-0 mt-2 w-56 origin-top-left divide-y divide-gray-100 rounded-md bg-white shadow-lg ring-1 ring-black/5 focus:outline-none z-50">
        {items.map((item) => (
          <Menu.Item key={item.value}>
            {({ active }) => (
              <button
                type="button"
                disabled={item.disabled}
                onClick={() => onSelect(item.value)}
                className={twMerge(
                  active ? "bg-secondary text-white" : "text-gray-900",
                  "group flex w-full items-center rounded-md px-2 py-2 text-sm"
                )}
              >
                <p className="truncate">{item.label}</p>
              </button>
            )}
          </Menu.Item>
        ))}
      </Menu.Items>
    </Menu>
  );
}

export default Dropdown;
