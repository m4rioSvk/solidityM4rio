//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.19; //stating our version, solidity version, ^ anything newer can work with this contract too

contract SimpleStorage {
        uint256 public myFavoriteNumber; //0
        //uint256[] listOfFavoriteNumbers; // []
        struct Person {
            uint256 favoriteNumber;
            string name;
        }

        //dynamic array = [] empty array
        //statis array = [3] maximum 3 values

        Person [] public listOfPeople; //[]

        mapping (string => uint256) public nameToFavoriteNumber;

        // Person public pat = Person({favoriteNumber: 7, name: "Pat"});
        // Person public nami = Person({favoriteNumber: 8, name: "Nami"});
        // Person public mario = Person({favoriteNumber: 14, name: "Mario"});

        function store(uint256 _favoriteNumber) public virtual {
            myFavoriteNumber = _favoriteNumber; //+5
        }

        function retrieve() public view returns(uint256) {
            return myFavoriteNumber;
        }
        //calldata, memory, storage
        function addPerson(string calldata _name, uint256 _favoriteNumber) public {
            listOfPeople.push( Person (_favoriteNumber, _name) );
            nameToFavoriteNumber[_name] = _favoriteNumber;
        }
}
