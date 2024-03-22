import WarningIcon from "@mui/icons-material/Warning";
import { twMerge } from "tailwind-merge";

type Props = {
  variant: "warn" | "error";
  text: string;
};

function Badge({ variant, text }: Props) {
  return (
    <div
      className={twMerge(
        "p-4 rounded-md border border-solid overflow-hidden",
        variant === "warn" && "bg-amber-100 border-amber-500",
        variant === "error" && "bg-rose-100 border-rose-500"
      )}
    >
      <div className="flex gap-4">
        <WarningIcon
          className={twMerge(
            variant === "warn" && "text-amber-500",
            variant === "error" && "text-rose-500"
          )}
        />
        <p>{text}</p>
      </div>
    </div>
  );
}

export default Badge;
