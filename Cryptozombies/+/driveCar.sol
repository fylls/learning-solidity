contract car {
    // A mapping to store a user's age:
    mapping(uint256 => uint256) public age;

    // Modifier that requires this user to be older than a certain age:
    modifier olderThan(uint256 _age, uint256 _userId) {
        require(age[_userId] >= _age);
        _;
    }

    // Must be older than 16 to drive a car (in the US, at least).
    // We can call the `olderThan` modifier with arguments like so:
    function driveCar(uint256 _userId) public olderThan(16, _userId) {
        // Some function logic
    }
}
