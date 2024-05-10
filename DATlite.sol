pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC3643/IERC3643.sol";
import "@openzeppelin/contracts/token/ERC4907/IERC4907.sol";
import "@openzeppelin/contracts/token/ERC3525/IERC3525.sol";
import "@openzeppelin/contracts/token/ERC4626/IERC4626.sol";

contract UniversalTokenTransfer {

    function transferERC721(address _tokenAddress, uint256 _tokenId, address _recipient) public {
        IERC721(_tokenAddress).transferFrom(msg.sender, _recipient, _tokenId);
    }

    function transferERC1155(address _tokenAddress, uint256 _tokenId, uint256 _amount, address _recipient) public {
        IERC1155(_tokenAddress).safeTransferFrom(msg.sender, _recipient, _tokenId, _amount, "");
    }

    function transferERC3643(address _tokenAddress, uint256 _tokenId, address _recipient) public {
        IERC3643(_tokenAddress).transferFrom(msg.sender, _recipient, _tokenId);
    }

    function transferERC4907(address _tokenAddress, uint256 _tokenId, address _recipient) public {
        IERC4907(_tokenAddress).transferFrom(msg.sender, _recipient, _tokenId);
    }

    function transferERC3525(address _tokenAddress, uint256 _tokenId, uint256 _slot, uint256 _amount, address _recipient) public {
        IERC3525(_tokenAddress).transferFrom(msg.sender, _recipient, _tokenId, _slot, _amount);
    }

    function transferERC4626(address _vaultAddress, uint256 _shares, address _recipient) public {
        IERC4626(_vaultAddress).transfer(_recipient, _shares);
    }

    function transferMultipleTokens(
        address[] calldata _tokenAddresses,
        uint256[] calldata _tokenIds,
        uint256[] calldata _amounts, // For ERC1155 and ERC3525
        uint256[] calldata _slots, // For ERC3525
        address _recipient
    ) public {
        require(
            _tokenAddresses.length == _tokenIds.length && 
            _tokenIds.length == _amounts.length &&
            (_slots.length == 0 || _slots.length == _amounts.length), 
            "Array lengths must match"
        );

        for (uint256 i = 0; i < _tokenAddresses.length; i++) {
            address tokenAddress = _tokenAddresses[i];
            uint256 tokenId = _tokenIds[i];
            uint256 amount = _amounts[i];
            uint256 slot = _slots[i];

            if (IERC165(tokenAddress).supportsInterface(type(IERC721).interfaceId)) {
                transferERC721(tokenAddress, tokenId, _recipient);
            } else if (IERC165(tokenAddress).supportsInterface(type(IERC1155).interfaceId)) {
                transferERC1155(tokenAddress, tokenId, amount, _recipient);
            } else if (IERC165(tokenAddress).supportsInterface(type(IERC3643).interfaceId)) {
                transferERC3643(tokenAddress, tokenId, _recipient);
            } else if (IERC165(tokenAddress).supportsInterface(type(IERC4907).interfaceId)) {
                transferERC4907(tokenAddress, tokenId, _recipient);
            } else if (IERC165(tokenAddress).supportsInterface(type(IERC3525).interfaceId)) {
                transferERC3525(tokenAddress, tokenId, slot, amount, _recipient); 
            } else if (IERC165(tokenAddress).supportsInterface(type(IERC4626).interfaceId)) {
                transferERC4626(tokenAddress, amount, _recipient); // Amount represents shares for ERC4626 
            } else {
                revert("Unsupported token standard");
            }
        }
    }
}

