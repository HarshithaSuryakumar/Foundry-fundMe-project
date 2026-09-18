// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/fundMe.sol";

contract FundFundMe is Script {
    uint256 public constant SEND_VALUE = 0.1 ether;

    function fundFundMe(address payable fundMeAddress) public {
        vm.startBroadcast();

        FundMe(fundMeAddress).fund{value: SEND_VALUE}();

        vm.stopBroadcast();
    }

    function run(address payable fundMeAddress) external {
        fundFundMe(fundMeAddress);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address payable fundMeAddress) public {
        vm.startBroadcast();

        FundMe(fundMeAddress).withdraw();

        vm.stopBroadcast();
    }

    function run(address payable fundMeAddress) external {
        withdrawFundMe(fundMeAddress);
    }
}
