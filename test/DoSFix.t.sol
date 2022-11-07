//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/DoSFix.sol";

contract DenialOfServiceFixTest is Test {

    DenialOfServiceFix public denialofservice;
    address private attacker;
    address private someUser;

    function setUp () public {
        denialofservice = new DenialOfServiceFix();

        vm.label(address (denialofservice), "DoS Contract");

        vm.label (attacker, "Attacker");
        attacker = address(2);
        vm.deal(attacker, 100 ether);

        vm.label (someUser, "someUser");
        someUser = address(3);
        vm.deal(someUser, 100 ether);

        vm.label (address(this), "Attacking SMC");
        vm.deal (address(this), 100 ether);
    }

    function firstTest () private {
        vm.startPrank (attacker);

        uint currentBid = denialofservice.highestBid();
        uint newBid = currentBid + 1 ether;
        denialofservice.bid{value: newBid} ();
        assertEq(denialofservice.KingOfEther(), attacker);
        assertEq (denialofservice.highestBid(), newBid);
        
        vm.stopPrank();
    }


    function testWithdraw () public {
        firstTest();

        vm.startPrank(address(this));
        uint currentBid = denialofservice.highestBid();
        uint newBid = currentBid + 1 ether;
        denialofservice.bid{value: newBid} ();
        if (denialofservice.KingOfEther() == address(this)) {
            emit log_string("Bidding successful");

            //THe line below ensures that the withdraw function doesnt work
            //because thats how we know if the secondTest() passed or not...
            vm.expectRevert();

            denialofservice.withdraw();
        }
        vm.stopPrank();

        secondTest();
    }


    function secondTest () private {
        vm.startPrank (someUser);

        uint currentBid = denialofservice.highestBid();
        uint newBid = currentBid + 1 ether;
        denialofservice.bid{value: newBid} ();
        assertEq(denialofservice.KingOfEther(), someUser);
        assertEq (denialofservice.highestBid(), newBid);
        
        vm.stopPrank();
    }

}