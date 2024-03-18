import CheckBoxIcon from "@mui/icons-material/CheckBox";
import CheckBoxOutlineBlankIcon from "@mui/icons-material/CheckBoxOutlineBlank";
import RadioButtonCheckedIcon from "@mui/icons-material/RadioButtonChecked";
import RadioButtonUncheckedIcon from "@mui/icons-material/RadioButtonUnchecked";
import { noop } from "lodash-es";
import { twMerge } from "tailwind-merge";

type Props = {
  isChecked: boolean;
  isEnabled: boolean;
  name: string;
  isEnabledStatusDisplayed?: boolean;
  variant?: "checkbox" | "radio"
  onClick?: () => void;
};

function WalletCard({
  isChecked,
  isEnabled,
  name,
  variant = "checkbox",
  isEnabledStatusDisplayed = false,
  onClick = noop
}: Props) {
  return (
    <button type="button" className="flex items-center gap-2 bg-white rounded-md p-2 shadow" onClick={onClick}>
      {variant === "checkbox" ? (
        <div>
          {isChecked ? <CheckBoxIcon /> : <CheckBoxOutlineBlankIcon />}
        </div>
      ) : (
        <div>
          {isChecked ? <RadioButtonCheckedIcon /> : <RadioButtonUncheckedIcon />}
        </div>
      )}
      <div>{name}</div>
      {isEnabledStatusDisplayed && (
        <div className="flex items-center justify-center h-full">
          <div className={twMerge("w-[8px] h-[8px] rounded-xl", isEnabled ? "bg-lime-400" : "bg-rose-400")}></div>
        </div>
      )}
    </button>
  );
}

export default WalletCard;