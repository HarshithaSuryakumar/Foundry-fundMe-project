// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

import {PriceConvertor} from "./priceConvertor.sol";

error NotOwner();

contract FundMe {
    using PriceConvertor for uint256;

    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;

    mapping(address => uint256) public addressToAmountFunded;

    address[] public funders;

    address public immutable i_owner;

    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    // Allows users to fund the contract
    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "You need to spend more ETH!");

        addressToAmountFunded[msg.sender] += msg.value;

        funders.push(msg.sender);
    }

    // Returns Chainlink price feed version
    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = s_priceFeed;
        return priceFeed.version();
    }

    // Only owner can call certain functions
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    // Normal withdraw function
    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];

            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");

        require(callSuccess, "Call failed");
    }

    // Gas-optimized withdraw function
    function cheaperWithdraw() public onlyOwner {
        // Copy storage array into memory
        address[] memory fundersMem = funders;

        // Use memory array inside the loop
        for (uint256 funderIndex = 0; funderIndex < fundersMem.length; funderIndex++) {
            address funder = fundersMem[funderIndex];

            addressToAmountFunded[funder] = 0;
        }

        // Reset funders array
        funders = new address[](0);

        // Send all ETH to owner
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");

        require(callSuccess, "Call failed");
    }

    // Called when ETH is sent directly to the contract
    receive() external payable {
        fund();
    }

    // Called when a function that doesn't exist is called
    fallback() external payable {
        fund();
    }
}
