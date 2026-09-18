// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/fundMe.sol";
import {DeployFundMe} from "../script/deployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;

    address USER = makeAddr("user");
    uint256 SEND_VALUE = 0.1 ether;

    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testWithdrawGasCost() public {
        vm.deal(USER, 1 ether);

        vm.prank(USER); //Make user the next call
        fundMe.fund{value: SEND_VALUE}();

        vm.prank(fundMe.i_owner());
        fundMe.withdraw();
    }
    
   
}