// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {ArbitrumShield} from "src/ArbitrumShield.sol";

contract DeployScript is Script {
    bytes16 private constant APP_ID = 0x4895f3f40962d377e5119f5a5e67ca5d;
    bool private constant IS_IMPERSONATION_MODE = true;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        ArbitrumShield arbitrumShield = new ArbitrumShield(
            "ipfs://bafybeihehkiq5e46fpt2zwemf7jtaqb75zfuxw24vlscwxql5ifkuqbfgy/",
            APP_ID,
            IS_IMPERSONATION_MODE
        );
        console.log("NFT Contract deployed at", address(arbitrumShield));
        vm.stopBroadcast();
    }
}
