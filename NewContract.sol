//SPDX-License-Identifier:MIT;
pragma solidity ^0.8.0;

contract NewContract{
    address public deployer;
    constructor(address _deployer) {
        deployer = _deployer;
    }
}
