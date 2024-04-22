import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { connectToContract } from './contractSlice';
import { Button, FormControl, FormLabel, Input, Select, VStack } from '@chakra-ui/react';

const Transfer = () => {
  const dispatch = useDispatch();
  const contract = useSelector((state: any) => state.contract.contract);
  const [tokens, setTokens] = useState([] as string[]);
  const [selectedToken, setSelectedToken] = useState('');
  const [amount, setAmount] = useState('');
  const [recipient, setRecipient] = useState('');

  useEffect(() => {
    dispatch(connectToContract('your-contract-address'));
  }, [dispatch]);

  useEffect(() => {
    if (contract) {
      // Fetch the list of tokens from the contract
      // and update the `tokens` state
    }
  }, [contract]);

  const handleTransfer = async () => {
    if (contract && selectedToken && amount && recipient) {
      // Call the appropriate function on the contract
      // to transfer the token
    }
  };

  return (
    <VStack spacing={4}>
      <FormControl>
        <FormLabel>Token</FormLabel>
        <Select
          value={selectedToken}
          onChange={(e) => setSelectedToken(e.target.value)}
        >
          {tokens.map((token) => (
            <option key={token} value={token}>
              {token}
            </option>
          ))}
        </Select>
      </FormControl>
      <FormControl>
        <FormLabel>Amount</FormLabel>
        <Input
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
        />
      </FormControl>
      <FormControl>
        <FormLabel>Recipient</FormLabel>
        <Input
          value={recipient}
          onChange={(e) => setRecipient(e.target.value)}
        />
      </FormControl>
      <Button
        colorScheme="blue"
        onClick={handleTransfer}
      >
        Transfer
      </Button>
    </VStack>
  );
};

export default Transfer;
