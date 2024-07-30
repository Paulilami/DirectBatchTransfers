pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC3643/IERC3643.sol";
import "@openzeppelin/contracts/token/ERC4907/IERC4907.sol";
import "@openzeppelin/contracts/token/ERC3525/IERC3525.sol";
import "@openzeppelin/contracts/token/ERC4626/IERC4626.sol";

contract UniversalTokenTransfer {

  struct Bundle {
    address tokenAddress;
    uint256 tokenId;
    uint256 amount; 
  }

  function transferMultipleTokens(Bundle[] calldata _bundledTokens, address _recipient) public nonReentrant {
    require(_bundledTokens.length > 0, "No tokens provided");

    address[] memory erc1155Addresses = new address[](0);
    uint256[] memory erc1155Ids = new uint256[](0);
    uint256[] memory erc1155Amounts = new uint256[](0);

    address[] memory erc721Addresses = new address[](0);
    uint256[] memory erc721Ids = new uint256[](0);

    for (uint256 i = 0; i < _bundledTokens.length; i++) {
      Bundle memory bundle = _bundledTokens[i];

      if (IERC165(bundle.tokenAddress).supportsInterface(type(IERC1155).interfaceId)) {
        erc1155Addresses = push(erc1155Addresses, bundle.tokenAddress);
        erc1155Ids = push(erc1155Ids, bundle.tokenId);
        erc1155Amounts = push(erc1155Amounts, bundle.amount);
      } else if (IERC165(bundle.tokenAddress).supportsInterface(type(IERC721).interfaceId)) {
        erc721Addresses = push(erc721Addresses, bundle.tokenAddress);
        erc721Ids = push(erc721Ids, bundle.tokenId);
      } else {
        _transferIndividual(bundle.tokenAddress, bundle.tokenId, bundle.amount, _recipient);
      }
    }


    if (erc1155Addresses.length > 0) {
      IERC1155(erc1155Addresses[0]).safeBatchTransferFrom(msg.sender, _recipient, erc1155Ids, erc1155Amounts, "");
    }
     if (erc721Addresses.length > 1) {
      IERC721(erc721Addresses[0]).safeBatchTransferFrom(msg.sender, _recipient, erc721Ids, "");
    } else {

      for (uint256 i = 0; i < erc721Addresses.length; i++) {
        IERC721(erc721Addresses[i]).transferFrom(msg.sender, _recipient, erc721Ids[i]);
      }
    }

function _transferIndividual(address _tokenAddress, uint256 _tokenId, uint256 _amount, address _recipient) internal nonReentrant {
  if (IERC165(_tokenAddress).supportsInterface(type(IERC721).interfaceId)) {
    revert("Use transferMultipleTokens for ERC721 transfers");
  } else if (IERC165(_tokenAddress).supportsInterface(type(IERC1155).interfaceId)) {
    revert("Use transferMultipleTokens for ERC1155 transfers");
  }
  if (IERC165(_tokenAddress).supportsInterface(type(IERC3643).interfaceId)) {
    IERC3643(_tokenAddress).transferFrom(msg.sender, _recipient, _tokenId);
  } else if (IERC165(_tokenAddress).supportsInterface(type(IERC4907).interfaceId)) {
    IERC4907(_tokenAddress).transferFrom(msg.sender, _recipient, _tokenId);
  } else if (IERC165(_tokenAddress).supportsInterface(type(IERC3525).interfaceId)) {
    require(_amount > 0, "Amount must be greater than zero for ERC3525");
    IERC3525(_tokenAddress).transferFrom(msg.sender, _recipient, _tokenId, 0, _amount);
  } else if (IERC165(_tokenAddress).supportsInterface(type(IERC4626).interfaceId)) {
    require(_amount > 0, "Amount must be greater than zero for ERC4626");
    IERC4626(_tokenAddress).transferFrom(msg.sender, _recipient, _amount);
  } else {
    revert("Unsupported token standard");
  }
}

  function push(address[] memory array, address element) internal pure returns (address[] memory) {
    address[] memory newArray = new address[](array.length + 1);
    for (uint256 i = 0; i < array.length; i++) {
      newArray[i] = array[i];
    }
    newArray[array.length] = element;
    return newArray;
  }

}
