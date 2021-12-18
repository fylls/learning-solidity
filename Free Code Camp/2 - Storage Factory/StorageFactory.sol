// SPDX-License_Identifier: MIT
// Factory Patters

pragma solidity ^0.6.0;

// we can actually deploy contracts from another contract and then call those functions as well

// this is a way for us to actually deploy contracts and interact with contracts from another
// contract, now to deploy a contract we do need all the functionality of that contract imported

import "./SimpleStorage.sol";

// can create SimpleStorage contracts & be a SimpleStorage cotract itself

contract StorageFactory is SimpleStorage {
    // keep track of all the different simple storage contracts that we deployed
    SimpleStorage[] public simpleStorageArray;

    // StorageFactory contract can deploy SimpleStorage contracts
    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber)
        public
    {
        // Address & ABI
        SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(
            _simpleStorageNumber
        );
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        return
            SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]))
                .retrieve();
    }
}

// we'll learn about interfaces in the next lesson which will allow us to actually interact with the
// contract without having all the functions defined
