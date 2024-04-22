import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { ethers } from 'ethers';

export const connectToContract = createAsyncThunk(
  'contract/connect',
  async (contractAddress: string) => {
    const provider = new ethers.providers.InfuraProvider('mainnet', 'your-infura-id');
    const contract = new ethers.Contract(contractAddress, ['function getBalance() view returns (uint256)'], provider);
    return contract;
  }
);

const contractSlice = createSlice({
  name: 'contract',
  initialState: {
    contract: null as ethers.Contract | null,
    status: 'idle',
    error: null as Error | null,
  },
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(connectToContract.pending, (state) => {
        state.status = 'loading';
      })
      .addCase(connectToContract.fulfilled, (state, action) => {
        state.status = 'succeeded';
        state.contract = action.payload;
      })
      .addCase(connectToContract.rejected, (state, action) => {
        state.status = 'failed';
        state.error = action.error;
      });
  },
});

export default contractSlice.reducer;
