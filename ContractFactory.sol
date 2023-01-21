//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./NewContract.sol";

contract ContractFactory {
    address owner;
    uint256 public contractCreated;
    ///to store how many contracts each user deployed
    mapping (address => uint256) public contractsPerAddress;
    ///to store users and be able to retrieve how many users used our contract factory
    address[] allUsers;

    constructor(){
        owner = msg.sender;
    }

    receive() external payable {
        new NewContract(msg.sender);
        contractCreated += 1;
        addUser(msg.sender);
    }


    modifier onlyOwner {
        require(msg.sender == owner,"you are not the contract owner!");
        _;
    }

    ///function to add users in the list and update the number of contracts they deployed
    function addUser (address _address) internal {
        
        if (contractsPerAddress[_address]==0){
            allUsers.push(_address);
        }
        contractsPerAddress[_address] += 1;
    }

    ///function to get how many users used our contract factory
    function getAllUsers() public view returns(uint256){
        return allUsers.length;
    }

    ///to withdraw funds only by owner
    function withdraw() payable public onlyOwner {
        uint256 contractBalance = address(this).balance;
        (bool success,) = msg.sender.call{value:contractBalance}("");
        require(success, "withdraw failed!");
    }

    ///to transfer funds in the contract to an address directly without withdrawal
    function transfer(address payable _to, uint256 _amount) public payable onlyOwner{
        (bool sent, ) = _to.call{value:_amount}("");
        require(sent, "transaction failed!");
    }
}
