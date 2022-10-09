// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract lottery{
    address public manager;
    address payable[] public participants;

    constructor(){
        manager = msg.sender;
    }

    receive() external payable{
        require(msg.value > 1 wei); //minimum value of ether to be deposited should be greater than 1 ether
        participants.push(payable(msg.sender));
        
    }   

    function getBalance() public view returns(uint){
        require(msg.sender == manager); // only manager can check balance
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    function selectWinner() public {
        require(msg.sender == manager);
        require(participants.length>=3);
        uint r = random();
        uint index = r % participants.length;
        address payable winner;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
        
    }

}