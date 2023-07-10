// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "sismo-connect-solidity/SismoLib.sol";

contract ArbitrumShield is ERC721, SismoConnect {
    using SismoConnectHelper for SismoConnectVerifiedResult;

    uint256 private _tokenId;
    string private _baseTokenURI;

    bytes16 private constant COINBASE_SHIELD_GROUP_ID =
        0x842e4d1671d72526762a77ade9feb49a;

    constructor(
        string memory baseTokenURI,
        bytes16 appId,
        bool isImpersonationMode
    )
        ERC721("ArbitrumShield", "AS")
        SismoConnect(buildConfig(appId, isImpersonationMode))
    {
        _baseTokenURI = baseTokenURI;
    }

    function verifySismoConnectResponse(bytes memory response) public {
        SismoConnectVerifiedResult memory result = verify({
            responseBytes: response,
            auth: buildAuth({authType: AuthType.VAULT}),
            claim: buildClaim({
                groupId: COINBASE_SHIELD_GROUP_ID,
                claimType: ClaimType.GTE
            }),
            signature: buildSignature({message: abi.encode(msg.sender)})
        });
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

    function getCoinbaseShieldGroupId() public pure returns (bytes16) {
        return COINBASE_SHIELD_GROUP_ID;
    }
}
