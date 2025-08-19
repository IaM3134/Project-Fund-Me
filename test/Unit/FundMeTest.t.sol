// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    address USER = makeAddr("user");

    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, 10 ether);
    }

    function testDemo() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testIfVersionIsCorrect() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testIfEnoughEthIsSent() public {
        vm.expectRevert(); //it expects that the next line will fail, if it does than it will compile successfully
        fundMe.fund();
    }

    function testFundUpdates() public {
        vm.prank(USER);
        fundMe.fund{value: 10e18}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, 10e18);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: 10e18}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testwithdrawWithSingleFunder() public funded {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        //assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFunMeBalance = address(fundMe).balance;
        assertEq(endingFunMeBalance, 0);
        assertEq(
            endingOwnerBalance,
            startingOwnerBalance + startingFundMeBalance
        );
    }

    function testwithdrawWithMultipleFunder() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), 10e18);
            fundMe.fund{value: 10e18}();
        }

        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        //assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFunMeBalance = address(fundMe).balance;
        assertEq(endingFunMeBalance, 0);
        assertEq(
            endingOwnerBalance,
            startingOwnerBalance + startingFundMeBalance
        );
    }

    function testwithdrawWithMultipleFundercheaper() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), 10e18);
            fundMe.fund{value: 10e18}();
        }

        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        //Act
        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        //assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFunMeBalance = address(fundMe).balance;
        assertEq(endingFunMeBalance, 0);
        assertEq(
            endingOwnerBalance,
            startingOwnerBalance + startingFundMeBalance
        );
    }
}
