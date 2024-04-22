import { ethers } from 'ethers';
import { IERC721__factory, IERC1155__factory } from 'wagmi-ui/contracts';
import contractAddresses from '../constants/contractAddresses.json';
import contractAbi from '../constants/contractAbi.json';

const provider = new ethers.providers.Web3Provider(window.ethereum as any);
const signer = provider.getSigner();
const contractAddress = contractAddresses[process.env.NEXT_PUBLIC_CHAIN_ID][0];
const contractInstance = new ethers.Contract(contractAddress, contractAbi, signer);

export { provider, signer, contractInstance };
