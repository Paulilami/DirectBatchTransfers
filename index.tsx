import React from 'react';
import { ChakraProvider } from '@chakra-ui/react';
import { WagmiConfig, createClient } from 'wagmi';
import { alchemyProvider } from 'wagmi-provider';
import { ConnectKitProvider } from 'connectkit';
import { Transfer } from '../components';

const client = createClient({
  provider: alchemyProvider({ apiKey: 'your-alchemy-api-key' }),
});

const App: React.FC = () => {
  return (
    <WagmiConfig client={client}>
      <ChakraProvider>
        <ConnectKitProvider>
          <Transfer />
        </ConnectKitProvider>
      </ChakraProvider>
    </WagmiConfig>
  );
};

export default App;
