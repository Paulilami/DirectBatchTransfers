import { createClient, WagmiConfig } from 'wagmi';
import { alchemyProvider } from 'wagmi-provider';
import { alchemyApiKey } from './src/config';

export default <WagmiConfig client={createClient({ provider: alchemyProvider({ apiKey: alchemyApiKey }) })} />;
