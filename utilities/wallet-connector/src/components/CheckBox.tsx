import { noop } from "lodash-es";
import CheckBoxOutlineBlankIcon from '@mui/icons-material/CheckBoxOutlineBlank';
import CheckBoxIcon from '@mui/icons-material/CheckBox';
import { twMerge } from "tailwind-merge";

type Props = {
  variant?: "radio" | "checkbox",
  value: boolean;
  label?: string;
  onChange?: (value: boolean) => void;
}

function CheckBox({ variant = "checkbox", value, label, onChange = noop }: Props) {
  return (
    <button type="button" className="flex gap-2" onClick={() => onChange(!value)}>
      <div>
        {value ? <CheckBoxIcon /> : <CheckBoxOutlineBlankIcon />}
      </div>
      {label && <div>{label}</div>}
    </button>
  )
}

export default CheckBox;