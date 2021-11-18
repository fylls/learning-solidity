contract notOdds {
    function getEvens() external pure returns (uint256[] memory) {
        uint256[] memory evens = new uint256[](5);
        // Keep track of the index in the new array:
        uint256 counter = 0;
        // Iterate 1 through 10 with a for loop:
        for (uint256 i = 1; i <= 10; i++) {
            // If `i` is even...
            if (i % 2 == 0) {
                // Add it to our array
                evens[counter] = i;
                // Increment counter to the next empty index in `evens`:
                counter++;
            }
        }
        return evens;
    }
}
