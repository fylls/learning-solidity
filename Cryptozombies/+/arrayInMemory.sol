function getArray() external pure returns (uint256[] memory) {
    // Instantiate a new array in memory with a length of 3
    uint256[] memory values = new uint256[](3);

    // Put some values to it
    values[0] = 1;
    values[1] = 2;
    values[2] = 3;

    return values;
}
