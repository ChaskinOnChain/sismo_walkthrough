// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {ArbitrumShield} from "src/ArbitrumShield.sol";

contract DeployScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        console.log(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);
        ArbitrumShield arbitrumShield = new ArbitrumShield(
            "ipfs://bafybeihehkiq5e46fpt2zwemf7jtaqb75zfuxw24vlscwxql5ifkuqbfgy/"
        );
        console.log("NFT Contract deployed at", address(arbitrumShield));
        vm.stopBroadcast();
    }
}
