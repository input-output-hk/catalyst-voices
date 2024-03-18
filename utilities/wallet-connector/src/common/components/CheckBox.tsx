import CheckBoxIcon from "@mui/icons-material/CheckBox";
import CheckBoxOutlineBlankIcon from "@mui/icons-material/CheckBoxOutlineBlank";
import RadioButtonCheckedIcon from "@mui/icons-material/RadioButtonChecked";
import RadioButtonUncheckedIcon from "@mui/icons-material/RadioButtonUnchecked";
import { noop } from "lodash-es";

type Props = {
  variant?: "radio" | "checkbox",
  value: boolean;
  label?: string;
  onChange?: (value: boolean) => void;
};

function CheckBox({
  variant = "checkbox",
  value,
  label = "",
  onChange = noop
}: Props) {
  return (
    <button type="button" className="flex gap-2" onClick={() => onChange(!value)}>
      {variant === "checkbox" ? (
        <div>
          {value ? <CheckBoxIcon /> : <CheckBoxOutlineBlankIcon />}
        </div>
      ) : (
        <div>
          {value ? <RadioButtonCheckedIcon /> : <RadioButtonUncheckedIcon />}
        </div>
      )}
      {label && <div>{label}</div>}
    </button>
  );
}

export default CheckBox;