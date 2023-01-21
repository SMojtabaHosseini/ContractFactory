//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./NewContract.sol";

contract ContractFactory {
    address owner;
    uint256 public contractCreated;
    mapping (address => uint256) public contractsPerAddress;
    address[] allUsers;

    constructor(){
        owner = msg.sender;
    }
    
    ///receive, create a new contract, update users details
    receive() external payable {
        new NewContract(msg.sender);
        contractCreated += 1;
        addUser(msg.sender);
    }


    modifier onlyOwner {
        require(msg.sender == owner,"you are not the contract owner!");
        _;
    }

    ///to add users in the list and update the number of contracts they deployed
    function addUser (address _address) private {
        
        if (contractsPerAddress[_address]==0){
            allUsers.push(_address);
        }
        contractsPerAddress[_address] += 1;
    }
    
    ///to get all addresses that used our contract
    function getAllUsers() public view returns(address[] memory){
        return allUsers;
    }

    ///to get how many users used our contract factory
    function totalUsers() public view returns(uint256){
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
