import AddIcon from "@mui/icons-material/Add";
import ClearIcon from "@mui/icons-material/Clear";
import { noop } from "lodash-es";
import type { ReactNode } from "react";
import { twMerge } from "tailwind-merge";

type Props = {
  heading: string;
  render: (index: number) => ReactNode;
  fields: {
    id: string;
  }[];
  onAddClick?: () => void;
  onRemoveClick?: (index: number) => void;
};

function TxBuilderMultiFieldsSection({
  heading,
  render,
  fields,
  onAddClick = noop,
  onRemoveClick = noop,
}: Props) {
  return (
    <section className="flex flex-col gap-2">
      <div className="flex gap-2 items-center">
        <h3 className="font-semibold text-sm">{heading}</h3>
        <button type="button" onClick={onAddClick}>
          <AddIcon />
        </button>
      </div>
      <div className={twMerge("grid gap-2", fields.length ? "grid" : "hidden")}>
        {fields.map((field, i) => (
          <div key={field.id} className="flex items-center gap-2">
            {render(i)}
            <button type="button" onClick={() => onRemoveClick(i)}>
              <ClearIcon />
            </button>
          </div>
        ))}
      </div>
    </section>
  );
}

export default TxBuilderMultiFieldsSection;
