import WarningIcon from "@mui/icons-material/Warning";

type Props = {
  variant: "warn";
  text: string;
};

function Badge({ text }: Props) {
  return (
    <div className="p-4 rounded-md bg-amber-100 border border-solid border-amber-500 overflow-hidden">
      <div className="flex gap-4">
        <WarningIcon className="text-amber-500" />
        <p>{text}</p>
      </div>
    </div>
  );
}

export default Badge;