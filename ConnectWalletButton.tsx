import React from 'react';
import { useAccount } from 'wagmi';

interface ConnectWalletButtonProps {
  onClick: () => void;
}

const ConnectWalletButton: React.FC<ConnectWalletButtonProps> = ({ onClick }) => {
  const { isConnected } = useAccount();

  return (
    <button onClick={onClick} disabled={isConnected}>
      Connect Wallet
    </button>
  );
};

export default ConnectWalletButton;
