import React from 'react';
import type { AppProps } from 'next/app';
import { ChakraProvider } from '@chakra-ui/react';
import { WagmiConfig, createClient } from 'wagmi';
import { alchemyProvider } from 'wagmi-provider';
import { ConnectKitProvider } from 'connectkit';

const client = createClient({
  provider: alchemyProvider({ apiKey: 'your-alchemy-api-key' }),
});

function MyApp({ Component, pageProps }: AppProps) {
  return (
    <WagmiConfig client={client}>
      <ChakraProvider>
        <ConnectKitProvider>
          <Component {...pageProps} />
        </ConnectKitProvider>
      </ChakraProvider>
    </WagmiConfig>
  );
}

export default MyApp;
