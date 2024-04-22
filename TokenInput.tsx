import React from 'react';

interface TokenInputProps {
  onChange: (value: string) => void;
}

const TokenInput: React.FC<TokenInputProps> = ({ onChange }) => {
  return (
    <input
      type="number"
      placeholder="Amount"
      onChange={(e) => onChange(e.target.value)}
    />
  );
};

export default TokenInput;
