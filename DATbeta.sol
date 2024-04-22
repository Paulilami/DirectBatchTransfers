pragma solidity ^0.8.0;

// Import necessary interfaces for each token standard
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC3643/IERC3643.sol";
import "@openzeppelin/contracts/token/ERC4907/IERC4907.sol";
import "@openzeppelin/contracts/token/ERC3525/IERC3525.sol";
import "@openzeppelin/contracts/token/ERC4626/IERC4626.sol";

contract UniversalTokenTransfer {

  // Struct for bundled tokens
  struct Bundle {
    address tokenAddress;
    uint256 tokenId;
    uint256 amount; // Optional for ERC1155 and ERC3525
  }

  // Function to transfer multiple tokens in a single transaction
  function transferMultipleTokens(Bundle[] calldata _bundledTokens, address _recipient) public nonReentrant {
    // Input validation (optional)
    require(_bundledTokens.length > 0, "No tokens provided");

    // Batch transfers for ERC1155 and ERC721 (if applicable)
    address[] memory erc1155Addresses = new address[](0);
    uint256[] memory erc1155Ids = new uint256[](0);
    uint256[] memory erc1155Amounts = new uint256[](0);

    address[] memory erc721Addresses = new address[](0);
    uint256[] memory erc721Ids = new uint256[](0);

    for (uint256 i = 0; i < _bundledTokens.length; i++) {
      Bundle memory bundle = _bundledTokens[i];

      // Separate arrays for ERC1155 and ERC721 for batch transfers
      if (IERC165(bundle.tokenAddress).supportsInterface(type(IERC1155).interfaceId)) {
        erc1155Addresses = push(erc1155Addresses, bundle.tokenAddress);
        erc1155Ids = push(erc1155Ids, bundle.tokenId);
        erc1155Amounts = push(erc1155Amounts, bundle.amount);
      } else if (IERC165(bundle.tokenAddress).supportsInterface(type(IERC721).interfaceId)) {
        erc721Addresses = push(erc721Addresses, bundle.tokenAddress);
        erc721Ids = push(erc721Ids, bundle.tokenId);
      } else {
        // Handle other token standards with individual transfers
        _transferIndividual(bundle.tokenAddress, bundle.tokenId, bundle.amount, _recipient);
      }
    }

    // Perform batch transfers for ERC1155 and ERC721 if applicable
    if (erc1155Addresses.length > 0) {
      IERC1155(erc1155Addresses[0]).safeBatchTransferFrom(msg.sender, _recipient, erc1155Ids, erc1155Amounts, "");
    }
     if (erc721Addresses.length > 1) {
      // Use ERC721.safeBatchTransferFrom for gas efficiency (check standard support)
      IERC721(erc721Addresses[0]).safeBatchTransferFrom(msg.sender, _recipient, erc721Ids, "");
    } else {
      // Individual ERC721 transfers if not batchable
      for (uint256 i = 0; i < erc721Addresses.length; i++) {
        IERC721(erc721Addresses[i]).transferFrom(msg.sender, _recipient, erc721Ids[i]);
      }
    }

 // Helper function for individual transfers (needs implementation)
function _transferIndividual(address _tokenAddress, uint256 _tokenId, uint256 _amount, address _recipient) internal nonReentrant {
  // 1. Check for ERC721 and ERC1155 efficiently (assuming they don't support individual transferFrom with data)
  if (IERC165(_tokenAddress).supportsInterface(type(IERC721).interfaceId)) {
    revert("Use transferMultipleTokens for ERC721 transfers");
  } else if (IERC165(_tokenAddress).supportsInterface(type(IERC1155).interfaceId)) {
    revert("Use transferMultipleTokens for ERC1155 transfers");
  }

  // 2. Perform standard transfer for known standards (consider gas costs)
  if (IERC165(_tokenAddress).supportsInterface(type(IERC3643).interfaceId)) {
    // Potentially cheaper: ERC3643 transferFrom (no data usually)
    IERC3643(_tokenAddress).transferFrom(msg.sender, _recipient, _tokenId);
  } else if (IERC165(_tokenAddress).supportsInterface(type(IERC4907).interfaceId)) {
    // Potentially cheaper: ERC4907 transferFrom (no data usually)
    IERC4907(_tokenAddress).transferFrom(msg.sender, _recipient, _tokenId);
  } else if (IERC165(_tokenAddress).supportsInterface(type(IERC3525).interfaceId)) {
    // Require valid amount and perform ERC3525 transfer with amount
    require(_amount > 0, "Amount must be greater than zero for ERC3525");
    IERC3525(_tokenAddress).transferFrom(msg.sender, _recipient, _tokenId, 0, _amount);
  } else if (IERC165(_tokenAddress).supportsInterface(type(IERC4626).interfaceId)) {
    // Require valid amount and perform ERC4626 transfer with amount
    require(_amount > 0, "Amount must be greater than zero for ERC4626");
    IERC4626(_tokenAddress).transferFrom(msg.sender, _recipient, _amount);
  } else {
    revert("Unsupported token standard");
  }
}

  // Helper function to push elements to dynamic arrays (avoids stack-too-deep errors)
  function push(address[] memory array, address element) internal pure returns (address[] memory) {
    address[] memory newArray = new address[](array.length + 1);
    for (uint256 i = 0; i < array.length; i++) {
      newArray[i] = array[i];
    }
    newArray[array.length] = element;
    return newArray;
  }

  // ... (other functions)
}
