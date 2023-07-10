// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract ArbitrumShield is ERC721 {
    uint256 private _tokenId;
    string private _baseTokenURI;

    constructor(string memory baseTokenURI) ERC721("ArbitrumShield", "AS") {
        _baseTokenURI = baseTokenURI;
    }

    function mint() public {
        _safeMint(msg.sender, _tokenId);
        _tokenId++;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        _requireMinted(tokenId);
        return _baseTokenURI;
    }
}
