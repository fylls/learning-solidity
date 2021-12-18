// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

// this contract can accept payments

contract FundMe {
    using SafeMathChainlink for uint256;

    // keep track of all the poeple who send me some monney

    mapping(address => uint256) public addressToAmountFunded;

    address[] public funders;

    // sets the owner
    // constructor is the fist function to be executed after deployment

    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function fund() public payable {
        uint256 mimimumUSD = 50 * 10**18;
        require(
            getConversionRate(msg.value) >= mimimumUSD,
            "You need to spend more ETH!"
        );
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    //     we just made
    // a contract call to another contract from
    // our contract using an interface this is
    // why interfaces are so powerful because
    // they're a minimalistic view into another
    // contract

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        return priceFeed.version();

        //return AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e).version();
    }

    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );

        // lots of unused local variable

        // (
        //     uint80 roundID,
        //     int256 price,
        //     uint256 startedAt,
        //     uint256 timeStamp,
        //     uint80 answeredInRound
        // ) = priceFeed.latestRoundData();

        (, int256 answer, , , ) = priceFeed.latestRoundData();

        return uint256(answer * 10000000000); // conversion in gwei
    }

    // 1000000000
    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }

    // changing the behaviour of functions in a declarative way

    modifier onlyOwner() {
        //_; we can use it here as well but we want the require to be executed BEFORE the rest of the code
        require(msg.sender == owner);
        _; // run the rest of the code
    }

    // 'this' refers to the conntract we are executing (we are currently in)
    // only the contract ower can call the withdraw fuction

    function withdraw() public payable onlyOwner {
        msg.sender.transfer(address(this).balance);

        // resetting all founders balance
        for (uint256 fIndex = 0; fIndex < funders.length; fIndex++) {
            address funder = funders[fIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
}
