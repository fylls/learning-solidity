contract multiple {
    function multipleReturns()
        internal
        returns (
            uint256 a,
            uint256 b,
            uint256 c
        )
    {
        return (1, 2, 3);
    }

    function processMultipleReturns() external {
        uint256 a;
        uint256 b;
        uint256 c;
        // This is how you do multiple assignment:
        (a, b, c) = multipleReturns();
    }

    // Or if we only cared about one of the values:
    function getLastReturnValue() external {
        uint256 c;
        // We can just leave the other fields blank:
        (, , c) = multipleReturns();
    }
}
