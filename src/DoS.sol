// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract DenialOfService {

    //ERRORS!!!
    error ZeroBid();
    error NotBiddingEnough();

    // Stores the information on who the king of 
    // the contract is and how much he/she bid to be the king
    address public KingOfEther;
    uint public highestBid;

    // Function allows people to bid to 
    //become the king og the contract
    function bid () public payable {
        if (msg.value <= 0) revert ZeroBid();
        if (msg.value <= highestBid) revert NotBiddingEnough();

        payable (KingOfEther).transfer(highestBid);

        KingOfEther = msg.sender;
        highestBid = msg.value;
    }

}
