import React from 'react';
import { useAccount, useContractRead } from 'wagmi';
import { IERC20__factory, IERC721__factory, IERC1155__factory } from 'wagmi-ui/contracts';

interface TokenDropdownProps {
  onSelect: (tokenAddress: string) => void;
}

const TokenDropdown: React.FC<TokenDropdownProps> = ({ onSelect }) => {
  const { address } = useAccount();
  const [tokens, setTokens] = React.useState<{ address: string; symbol: string }[]>([]);

  const { data: erc20Tokens } = useContractRead({
    address: address as `0x${string}`,
    abi: IERC20__factory.abi,
    functionName: 'map',
    args: [(token) => [token.symbol, token.address]],
  });

  const { data: erc721Tokens } = useContractRead({
    address: address as `0x${string}`,
    abi: IERC721__factory.abi,
    functionName: 'map',
    args: [(token) => [token.name, token.address]],
  });

  const { data: erc1155Tokens } = useContractRead({
    address: address as `0x${string}`,
    abi: IERC1155__factory.abi,
    functionName: 'map',
    args: [(token) => [token.name, token.address]],
  });

  React.useEffect(() => {
    if (erc20Tokens && erc721Tokens && erc1155Tokens) {
      const allTokens = [...(erc20Tokens as string[]), ...(erc721Tokens as string[]), ...(erc1155Tokens as string[])];
      const uniqueTokens = Array.from(new Set(allTokens)).map((token) => {
        const [name, address] = token.split(':');
        return { address, symbol: name };
      });
      setTokens(uniqueTokens);
    }
  }, [erc20Tokens, erc721Tokens, erc115
