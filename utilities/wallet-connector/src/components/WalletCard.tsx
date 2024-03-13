import { noop } from "lodash-es";
import CheckBoxOutlineBlankIcon from '@mui/icons-material/CheckBoxOutlineBlank';
import CheckBoxIcon from '@mui/icons-material/CheckBox';
import { twMerge } from "tailwind-merge";

type Props = {
  isChecked: boolean;
  isEnabled: boolean;
  name: string;
  onClick?: () => void;
}

function WalletCard({ isChecked, isEnabled, name, onClick = noop }: Props) {
  return (
    <button type="button" className="flex gap-2 bg-white rounded-md p-2 shadow" onClick={onClick}>
      <div>
        {isChecked ? <CheckBoxIcon /> : <CheckBoxOutlineBlankIcon />}
      </div>
      <div>{name}</div>
      <div className="flex items-center justify-center h-full">
        <div className={twMerge("w-[8px] h-[8px] rounded-xl", isEnabled ? "bg-lime-400" : "bg-rose-400")}></div>
      </div>
    </button>
  )
}

export default WalletCard;