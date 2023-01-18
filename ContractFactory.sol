//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./NewContract.sol";

contract ContractFactory {
    address owner;
    uint256 public contractCreated;

    constructor(){
        owner = msg.sender;
    }
    
    //after receiving tokens, create a new contract and set the msg.sender as deployer
    receive() external payable {
        new NewContract(msg.sender);
        contractCreated += 1;
    }


    modifier onlyOwner {
        require(msg.sender == owner,"you are not the contract owner!");
        _;
    }

    //withdraw function for owner of the contract
    function withdraw() payable public onlyOwner {
        uint256 contractBalance = address(this).balance;
        (bool success,) = msg.sender.call{value:contractBalance}("");
        require(success, "withdraw failed!");
    }

    //transfer function to send arbitrary amount of tokens to an arbitrary address directly only by owner of the contract
    function transfer(address payable _to, uint256 _amount) public payable onlyOwner{
        (bool sent, ) = _to.call{value:_amount}("");
        require(sent, "transaction failed!");
    }
}
