// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {
    //uint256 public favoriteNumber
    //type visbility name
    SimpleStorage[] public listOfSimpleStorageContracts; //simpleStorage is variable name, SimpleStorage is function
    
    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        listOfSimpleStorageContracts.push(newSimpleStorageContract);
    }

    function sfStorage(uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public {
        //address
        //ABI
        listOfSimpleStorageContracts[_simpleStorageIndex].store(_newSimpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256) {
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
    }
}