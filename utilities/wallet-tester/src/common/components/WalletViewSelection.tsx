import { noop } from "lodash-es";

import WalletCard from "./WalletCard";

type Props = {
  selectedWallet: string;
  wallets: string[];
  onSelect?: (wallet: string) => void;
};

function WalletViewSelection({ wallets, selectedWallet, onSelect = noop }: Props) {
  if (!wallets.length) {
    return null;
  }

  return (
    <div className="flex flex-wrap gap-4">
      {wallets.map((wallet) => (
        <WalletCard
          variant="radio"
          isChecked={wallet === selectedWallet}
          isEnabled={false}
          key={wallet}
          name={wallet}
          onClick={() => onSelect(wallet)}
        />
      ))}
    </div>
  );
}

export default WalletViewSelection;
