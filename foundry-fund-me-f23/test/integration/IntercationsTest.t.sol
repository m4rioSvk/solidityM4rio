//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {FundMe} from "../../src/FundMe.sol";
import{DeployFundMe} from "../../script/DeployFundMe.s.sol";
import{FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract IntercatonsTest is Test {
    FundMe fundMe; //here it initialize to state variable instead of local

    address USER = makeAddr("user");
    address USER1 = makeAddr("user1");
    uint256 constant SEND_VALUE = 0.1 ether; // 10000000000000
    uint256 constant STARTING_BALANCE = 100 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER1, STARTING_BALANCE);
    }

    function TestUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        // vm.prank(USER1);
        // vm.deal(USER1, 1e18);
        fundFundMe.fundFundMe(address(fundMe));

        // address funder = fundMe.getFunder(0);
        // assertEq(funder, USER1);

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);

    }
    
}