import React from 'react';
import { useRouter } from 'next/router';
import { ConnectKitButton } from 'connectkit';

const ConnectWallet: React.FC = () => {
  const router = useRouter();

  return (
    <div>
      <h1>Connect Wallet</h1>
      <ConnectKitButton onConnect={() => router.push('/')} />
    </div>
  );
};

export default ConnectWallet;
