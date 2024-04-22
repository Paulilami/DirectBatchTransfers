import React from 'react';

interface TransferButtonProps {
  onClick: () => void;
}

const TransferButton: React.FC<TransferButtonProps> = ({ onClick }) => {
  return <button onClick={onClick}>Transfer</button>;
};

export default TransferButton;
