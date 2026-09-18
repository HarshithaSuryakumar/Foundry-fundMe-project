// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MockV3Aggregator {
    uint8 public decimals;
    int256 public answer;

    constructor(
        uint8 _decimals,
        int256 _answer
    ) {
        decimals = _decimals;
        answer = _answer;
    }

    function version() public pure returns (uint256) {
        return 4;
    }

    function latestRoundData()
        public
        view
        returns (
            uint80,
            int256,
            uint256,
            uint256,
            uint80
        )
    {
        return (
            0,
            answer,
            0,
            block.timestamp,
            0
        );
    }
}