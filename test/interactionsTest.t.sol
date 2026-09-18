// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/fundMe.sol";
import {DeployFundMe} from "../script/deployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../script/interactions.s.sol";

contract InteractionsTest is Test {
    FundMe public fundMe;

    function setUp() public {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testFund() public {
        FundFundMe fundFundMe = new FundFundMe();

        fundFundMe.run(payable(address(fundMe)));

        assertEq(address(fundMe).balance, 0.1 ether);
    }

    function testWithdraw() public {
        FundFundMe fundFundMe = new FundFundMe();

        fundFundMe.run(payable(address(fundMe)));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();

        withdrawFundMe.run(payable(address(fundMe)));

        assertEq(address(fundMe).balance, 0);
    }
}
