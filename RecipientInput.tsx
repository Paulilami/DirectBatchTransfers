import React from 'react';

interface RecipientInputProps {
  onChange: (value: string) => void;
}

const RecipientInput: React.FC<RecipientInputProps> = ({ onChange }) => {
  return (
    <input
      type="text"
      placeholder="Recipient wallet address"
      onChange={(e) => onChange(e.target.value)}
    />
  );
};

export default RecipientInput;
