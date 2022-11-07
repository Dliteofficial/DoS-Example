// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract DenialOfServiceFix {

    //ERRORS!!!
    error ZeroBid();
    error NotBiddingEnough();
    error YouHaveZeroBalance();
    
    // Stores the information on who the king of 
    // the contract is and how much he/she bid to be the king
    address public KingOfEther;
    uint public highestBid;

    mapping (address => uint) public balances;

    // Function allows people to bid to 
    //become the king og the contract
    function bid () public payable {
        if (msg.value <= 0) revert ZeroBid();
        if (msg.value <= highestBid) revert NotBiddingEnough();

        balances[msg.sender] += msg.value;

        KingOfEther = msg.sender;
        highestBid = msg.value;
    }

    function withdraw () public {
        if (balances[msg.sender] == 0) revert YouHaveZeroBalance();

        payable(msg.sender).transfer(balances[msg.sender]);
    }

}
