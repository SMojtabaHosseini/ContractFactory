//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./NewContract.sol";

contract ContractFactory {
    address owner;
    uint256 public contractCreated;

    constructor(){
        owner = msg.sender;
    }

    receive() external payable {
        new NewContract(msg.sender);
        contractCreated += 1;
    }


    modifier onlyOwner {
        require(msg.sender == owner,"you are not the contract owner!");
        _;
    }

    function withdraw() payable public onlyOwner {
        uint256 contractBalance = address(this).balance;
        (bool success,) = msg.sender.call{value:contractBalance}("");
        require(success, "withdraw failed!");
    }

    function transfer(address payable _to, uint256 _amount) public payable onlyOwner{
        (bool sent, ) = _to.call{value:_amount}("");
        require(sent, "transaction failed!");
    }
}
