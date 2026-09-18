// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_ANSWER = 2000e8;

    address public activeNetworkConfig;

    MockV3Aggregator public mockPriceFeed;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (address) {
        return 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    }

    function getAnvilEthConfig() public returns (address) {
        vm.startBroadcast();

        mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_ANSWER);

        vm.stopBroadcast();

        return address(mockPriceFeed);
    }
}
