// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract AddFiveStorage is SimpleStorage {
    // is is "inherit" function
    // +5 
    //overrides
    //virtual override
    function store(uint256 _newNumber) public override {
        myFavoriteNumber = _newNumber + 5;
    }
    }
