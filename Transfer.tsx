import React, { useState } from 'react';
import { useAccount } from 'wagmi';
import { useContractWrite } from 'wagmi';
import { IERC721__factory, IERC1155__factory } from 'wagmi-ui/contracts';
import { ethers } from 'ethers';
import { useRouter } from 'next/router';
import { TokenDropdown, TokenInput, RecipientInput, TransferButton, ConnectWalletButton } from './index';

interface TransferProps {}

const Transfer: React.FC<TransferProps> = () => {
  const { address } = useAccount();
  const router = useRouter();
  const [selectedToken, setSelectedToken] = useState('');
  const [amount, setAmount] = useState('');
  const [recipient, setRecipient] = useState('');
  const [isTransferring,setIsTransferring] = useState(false);

  const { write: transferERC721 } = useContractWrite({
    address: selectedToken,
    abi: IERC721__factory.abi,
    functionName: 'transferFrom',
    args: [address as `0x${string}`, recipient, amount],
  });

  const { write: transferERC1155 } = useContractWrite({
    address: selectedToken,
    abi: IERC1155__factory.abi,
    functionName: 'safeTransferFrom',
    args: [address as `0x${string}`, recipient, amount, ''],
  });

  const handleTransfer = async () => {
    if (selectedToken && amount && recipient) {
      setIsTransferring(true);

      if (IERC165(selectedToken).supportsInterface(type(IERC721).interfaceId)) {
        await transferERC721();
      } else if (IERC165(selectedToken).supportsInterface(type(IERC1155).interfaceId)) {
        await transferERC1155();
      }

      setIsTransferring(false);
      router.push('/');
    }
  };

  return (
    <div>
      <h1>Transfer Tokens</h1>
      <TokenDropdown onSelect={setSelectedToken} />
      <TokenInput onChange={setAmount} />
      <RecipientInput onChange={setRecipient} />
      <TransferButton onClick={handleTransfer} disabled={isTransferring} />
      <ConnectWalletButton onClick={() => router.push('/connect-wallet')} />
    </div>
  );
};

export default Transfer;
