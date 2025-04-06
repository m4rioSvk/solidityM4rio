//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {FundMe} from "../../src/FundMe.sol";
import{DeployFundMe} from "../../script/DeployFundMe.s.sol";


contract FundMeTest is Test {
    FundMe fundMe; //here it initialize to state variable instead of local
    address USER = makeAddr("user");
    address USER1 = makeAddr("user1");
    uint256 constant SEND_VALUE = 0.1 ether; // 10000000000000
    uint256 constant STARTING_BALANCE = 100 ether;
    uint256 constant GAS_PRICE = 1;
   

    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();


        vm.deal(USER1, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public view{
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }
    function testOwnerIsMsgSender() public view{
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert(); //next line should revert!
        // assert(This tx fails.reverts)
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(address(this));
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.startPrank(USER1);
        fundMe.fund{value: SEND_VALUE}();
        vm.stopPrank();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER1);
    }

    modifier funded() {
        vm.prank(USER1);
        fundMe.fund{value: SEND_VALUE};
        assert(address(fundMe).balance > 0);
        _;
    }


    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw(); 
    }

//    function testWithDrawWithASingleFunder() public funded {
//     //Arrange
//     uint256 startingOwnerBalance = fundMe.getOwner().balance;
//     uint256 startingFundMeBalance = address(fundMe).balance;

    //Acct
    // uint256 gasStart = gasleft();
    // vm.txGasPrice(GAS_PRICE);
    // vm.prank(fundMe.getOwner());
    //fundMe.withdraw();

    // uint256 gasEnd = gasleft();
    // uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
    // console.log(gasUsed);

    //Assert
    
    //uint256 endingOwnerBalance = fundMe.getOwner().balance;
    //uint256 endingFundMeBalance = address(fundMe).balance;
    // console.log(endingFundMeBalance);
    // console.log(startingFundMeBalance);
    // console.log(endingOwnerBalance);
    //assertEq(endingFundMeBalance, 0);
    //assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
//    }

   function testWithdrawFromMultipleFundersCheaper() public funded {
    // Arrange
    uint160 numberOfFunders = 10;
    uint160 startingFunderIndex = 1;
    for(uint160 i = startingFunderIndex; i < numberOfFunders; i++){
        // vm.prank
        // vm.deal
        hoax(address(i), STARTING_BALANCE);
        fundMe.fund{value: SEND_VALUE}();
    }

    uint256 startingOwnerBalance = fundMe.getOwner().balance;
    uint256 startingFundMeBalance = address(fundMe).balance;

    // Act
    vm.startPrank(fundMe.getOwner());
    fundMe.cheaperWithdraw();
    vm.stopPrank();

    // Assert
    assert(address(fundMe).balance == 0);
        startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance;
   }
}