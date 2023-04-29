// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/* L00kin PFP Minter
██╗      ██████╗  ██████╗ ██╗  ██╗██╗███╗   ██╗
██║     ██╔═████╗██╔═████╗██║ ██╔╝██║████╗  ██║
██║     ██║██╔██║██║██╔██║█████╔╝ ██║██╔██╗ ██║
██║     ████╔╝██║████╔╝██║██╔═██╗ ██║██║╚██╗██║
███████╗╚██████╔╝╚██████╔╝██║  ██╗██║██║ ╚████║
╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝

██████╗ ███████╗██████╗     ███╗   ███╗██╗███╗   ██╗████████╗███████╗██████╗
██╔══██╗██╔════╝██╔══██╗    ████╗ ████║██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗
██████╔╝█████╗  ██████╔╝    ██╔████╔██║██║██╔██╗ ██║   ██║   █████╗  ██████╔╝
██╔═══╝ ██╔══╝  ██╔═══╝     ██║╚██╔╝██║██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗
██║     ██║     ██║         ██║ ╚═╝ ██║██║██║ ╚████║   ██║   ███████╗██║  ██║
╚═╝     ╚═╝     ╚═╝         ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
*/

contract L00kinPFPMinter is ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    IERC721Enumerable public immutable l00kinCitizenId;

    uint256 public constant FEE = 25000000000000000; // 0.025 ETH

    Counters.Counter private _tokenIds;

    constructor(address _l00kinCitizenId) ERC721("L00KIN PFP MINTER ", "PFP") {
        l00kinCitizenId = IERC721Enumerable(_l00kinCitizenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal virtual override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view virtual override (ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
    }

    function mint(string memory _tokenURI) public payable returns (uint256) {
        require((l00kinCitizenId.balanceOf(msg.sender) > 0 || msg.value >= FEE), "Not enough funds to pay the fee");
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        return newItemId;
    }

    function withdraw() public onlyOwner payable {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}
