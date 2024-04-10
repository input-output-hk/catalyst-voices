import AddIcon from "@mui/icons-material/Add";
import ClearIcon from "@mui/icons-material/Clear";
import { noop } from "lodash-es";
import { useState, type ReactNode } from "react";
import { twMerge } from "tailwind-merge";

type Props = {
  heading: string;
  render: () => ReactNode;
  onAddClick?: () => void;
  onRemoveClick?: () => void;
};

function TxBuilderSingleFieldSection({
  heading,
  render,
  onAddClick = noop,
  onRemoveClick = noop,
}: Props) {
  const [isOpen, setIsOpen] = useState(false);

  function handleToggle() {
    isOpen ? onRemoveClick() : onAddClick();

    setIsOpen((prev) => !prev);
  }

  return (
    <section className="flex flex-col gap-2">
      <div className="flex gap-2 items-center">
        <h3 className="font-semibold text-sm">{heading}</h3>
        <button type="button" onClick={handleToggle}>
          {isOpen ? <ClearIcon /> : <AddIcon />}
        </button>
      </div>
      <div className={twMerge(!isOpen && "hidden")}>{render()}</div>
    </section>
  );
}

export default TxBuilderSingleFieldSection;
