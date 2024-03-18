import InputIcon from "@mui/icons-material/Input";
import type { ReactNode } from "react";
import { twMerge } from "tailwind-merge";

type Props = {
  variant: "inline" | "block";
  name: string;
  children: ReactNode;
};

function InputBlock({ variant, name, children }: Props) {
  return (
    <div className={twMerge("gap-2", variant === "inline" ? "flex" : "grid")}>
      <div className="flex gap-2">
        <InputIcon />
        <h3>{name}:</h3>
      </div>
      <div>
        {children}
      </div>
    </div>
  );
}

export default InputBlock;