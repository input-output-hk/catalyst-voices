import type { ExtractedWalletApi } from "types/cardano";

type Props = {
  selectedWallets: string[];
  walletApi: Record<string, ExtractedWalletApi>;
};

function SignDataPanel({}: Props) {
  return (
    <div className="grid gap-4">
      <div className="grid gap-2">
        <h2 className="font-semibold text-center">Not Implemented.</h2>
      </div>
    </div>
  );
}

export default SignDataPanel;
