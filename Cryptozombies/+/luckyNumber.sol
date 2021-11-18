contract LuckyNumber {
    mapping(address => uint256) numbers;

    function setNum(uint256 _num) public {
        numbers[msg.sender] = _num;
    }

    function getNum(address _myAddress) public view returns (uint256) {
        return numbers[_myAddress];
    }
}
