 <div align="center">

# Learning Solidity

Notes from [this](https://www.youtube.com/playlist?list=PLvfQp12V0hS2PQd9-X-E2AjmXj1o05WOo) free Youtube course by [HashLips](https://www.youtube.com/channel/UC1LV4_VQGBJHTJjEWUmy8nA)

![solio](https://user-images.githubusercontent.com/55017307/142409945-cb25c3d0-34d1-4315-91f2-b98c9f176fe2.gif)

</div>

---

### Smart Contract

It's like a box. Once this box is deployed on the blockchain, each smart contract has an address much like your wallet your metamask What can an address do on the blockchain? it can receive funds and it can send funds. It's basically an address which behaves like an address with extra features and functions and we the developers can write those extra features and functions

---

### Variables

- `public` variables

```solidity
string public name
```

This variable is going to be called name this is considered as a state variable and this variable is going to live on the blockchain along with this smart contract forever forever and ever.

It would just have one call function which is basically given to us automatically because under the hood of solidity whenever you declare something as public it automatically creates a `getter function` that allows the smart contract to return the actual value of this variables

- `private` variables

by default vars are private. They cannot exit of the smart contract

- `internal` variables

Can only be accessed by our smart contract or derived (inherited) contracts

---

### ⚠️Warning

Don't store sensitive information inside variables. anything is visible on the blockchain

---

### Casting

from one datatype to another

```solidity
address public contract = address(0x7Baca58130a7B3607Cf79724Bcce07Cf6BAC7c81)
address public payable contract = payable(0x7Baca57130A7B3607Cf79724Bcce07Cf6ABC7c81)

int8 myInt8 = 8
int256 myInt256 = int256(myInt8)
```

---

### Global Variables

3 global variables: block, tx, msg

`this = contract.address`

`msg.sender` - the address of the sender

`msg.value` - ether sent to the function (in wei)

---

### Variable Scoping

local variables expire after function execution
only saved to memory when needed

local variables = variables defined inside functions

---

### Visibility

`public` - any contract and account can call

`private` - only inside the contract that defines the function

`internal`- only inside contract that inherits an internal function

`external` - only other contracts and accounts can call

State variables can be declared as public, private, or internal but not externa

---

### View & Pure

`View` functions declares that no state will be changed.

`Pure` functions declares that no state variable will be changed or read

---

### Money Units

```solidity
assert(1 wei == 1);
assert(1 szabo == 1e12);
assert(1 finney == 1e15);
assert(1 ether == 1e18);
assert(2 ether == 2000 fenny);
```

---

### Time Units

```solidity
assert(1 seconds == 1);
assert(1 minutes == 60 seconds);
assert(1 hours == 60 minutes);
assert(1 day == 24 hours);
assert(1 week == 7 days);
```

---

### Gas

The `gas spent` is actually how much ethers it took the contract to run through the whole program and execute what it needed to execute.

The `gas limit` is what i am willing to pay to process a transaction.

not enough gas means that there was not enough computing power to complete this transaction and it reverts you usually get back the funds but you lose the gas fees

---

### Mappings

```solidity
contract MyMappings {
    mapping(uint256 => address) nfts;
    uint256 counter = 0;

    function getOwnerOfNFT(uint256 _id) public view returns (address) {
        return nfts[_id];
    }

    function mintNFT(address _address) public {
        nfts[counter] = _address;
        counter++;
    }

}
```

---

### Enums

```solidity
contract MyEnums {

    enum Rarity {
        original, // 0
        rare, // 1
        super_rare // 2
    }

    Rarity public rarity;

    constructor() {
        rarity = Rarity.rare;
    }

    function makeSuperRare() public {
        rarity = Rarity.super_rare;
    }
}
```

---

### Data Location

`storage` - variable is a state variable (store on blockchain)

`memory` - variable is in memory and it exists while a function is being called

`calldata` - special data location that contains function arguments, only available for external functions. calldata is not used very often

---

For data location, both `calldata` and `memory` can be applied to complex data types (array, struct, mapping). The difference is just that with `calldata` as location, the params cannot be modified. While with `memory` the params can be modified. The data location is not tied with complex data types.

---

### Structs

```solidity
contract MyStructs {

    struct NFT {
        string name;
        uint256 dna;
    }

    NFT[] public nftList; // storage location, it costs to have this on the blockchain

    function addNFT(string memory _name, uint256 _dna) public {
        // NFT memory newNFT;
        // newNFT.name = _name;
        // newNFT.dna = _dna;
        NFT memory newNFT = NFT(_name, _dna);
        nftList.push(newNFT);
    }

    function addNFTS(NFT[] calldata _nfts) public {
        nftList = _nfts;
    }

    function updateNFTStorage(uint256 _index, string memory _name) public {
        NFT storage nftToBeUpdated = nftList[_index];
        nftToBeUpdated.name = _name;
    }

    function updateNFTMemory(uint256 _index, string memory _name) public {
        NFT memory nftToBeUpdated = nftList[_index]; // copying data
        nftToBeUpdated.name = _name;
        nftList[_index] = nftToBeUpdated; // real update
    }

    function getNftName(uint256 _index) public view returns(string memory){
        return nftList[_index].name;
    }
}
```

---

### Functions

```solidity
contract MyFunctions {

    uint256 myUint = 42;
    string myString = "Daniel";
    bool myBool = true;
    uint256[] myArr = [3,3,3];


   function myPureFunc(uint256 _x, uint256 _y) public pure returns (uint256 xy){
       return _x + _y;
   }

   function myViewFunc() internal view returns (string memory){
       return myString;
   }

   function myUpdateFunc() public returns (string memory){
       myString = "HashLips";
       string memory savedString = myViewFunc();
       return savedString;
   }

   function myReturnsFunc() external view returns (uint256, string memory, bool, uint256[] memory){
       return (myUint, myString, myBool, myArr);
   }

   function myNoReturnFunc() external {
       myBool = false;
   }

}
```

---

### Errors & Checks

`require` is used to validate inputs and conditions before execution.

`revert` is similar to require. It is useful when the condition to check is complex.

`assert` is used to check for code that should never be false. Failing assertion probably means that there is a bug.

asserts should never really be used just lightly because it will break execution if it doesn't pass.
As a solidity developer you'll be fine just by using require statements and revert statements to check your logic. Asserts are mainly used to check internal logic of functions: It can really hurt a smart contract if it's used wrong

```solidity
contract MyErrorsAndChecks {

    uint256 public maxAmount = 100;

    function updateMax() public {
        maxAmount = 50;
    }

    function myFunc(uint256 _x, uint256 _y) public view returns (uint256 xy){
        require(_x < _y, "X is bigger that Y");
        checkMax();
        return _x + _y;
    }

    function myPureRevertFunc(uint256 _x, uint256 _y) public pure returns (uint256 xy) {
        if(_x == 10) revert("X is 10");
        return _x + _y;
    }

    function checkMax() internal view {
        assert(maxAmount == 100);
    }
}
```

---

### Modifiers

It's like putting a require statement inside a function but making it reusable for other functions as well.

`_;` = rest of the code to execute

```solidity
contract MyModifier {

    uint256 public myNum = 0;
    bool public paused = false;
    address public owner;

    constructor () {
        owner = address(msg.sender);
    }

    modifier paused(bool _bypass) {
        if(_bypass == true) {
            require(paused == false, "Contract is paused");
        }
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function setPaused() public {
        paused = true;
    }

    function addToNum() public paused(true) onlyOwner {
        myNum++;
    }

     function sunFromNum() public paused(false) onlyOwner {
        myNum--;
    }

}
```

---

### Events

Sometimes we want to know when things happen on the blockchain and the only response we get as a front-end user of the blockchain is when a transaction actually takes place, when an NFT is mined and actually then comes back with a receipt but there's actually another way where we can read the data of the logs of the blockchain.

Events allows us to capture a piece in in space and time and tells us what exactly happened on that transaction by passing in some data that we can save on the event logs.

Events are a great way for front-end users and normal users to actually see what took place on the blockchain with a particular smart contract and functions. Think of it as a message board and whenever we do something important we want to log it and put it onto the blockchain so that on a later time we can retrieve it we can read from it and it just helps to store what happened on that blockchain and with a transaction.

I also want to note that to make it easier to follow through and search for logs on the event chain you can sometimes add a `index` in front of your type definition, you can easily look up this data based on this id.

```solidity
contract MyEvents {

    event CreatedNFT(address indexed user, uint256 id, uint256 dna);

    function createNft(uint256 _id, uint256 _dna) public {
        // create the nft and save to the storage
        emit CreatedNFT(msg.sender, _id, _dna);
    }

}
```

---

### Constructor

A constructive function is something that can be called once and only once and is called automatically when you deploy a smart contract.

Keep in mind when your constructor has parameters you would need to provide the verification on ether scan or polygon scan with that abi that not the abi the byte code of that constructor functions values

if you inherit from a contract that needs a constructor you will get an error `should be marked as abstract` this usually implies that we are not
fully implementing all the features that's needed to be implemented from the constructor

```solidity
contract MyConstructor {

    string public name;

    constructor(string memory _name) {
        name = _name;
    }

}

contract MySecondContract is MyConstructor {
    constructor(string memory _name) MyConstructor(_name) {}
}
```

---

### Inheritance

getting underlining functions and state variables (all of them except private ones) The contracts are merging, we only need to deploy one.

```solidity
contract 1 {}
contract 2 is  1 {}
```

---

if you want to overwrite a function then basically it needs to be marked as `virtual` the virtual field will basically indicate to us that we will be able to `override`.

This is a way of overriding functions and you will see this happen a lot in the erc721 space especially when you want to get the `tokenURI` sometimes the token uri function is overwritten to kind of promote different scenarios sometimes we want to overwrite it to hide the reveal of an nft or something like that so you take the underlying function that it inherits from and you adapt it to your own needs by overwriting it that's all you need to understand.

```solidity
contract MyInheritance_A {
    string internal name = "HashLips";

}

contract MyInheritance_B is MyInheritance_A {

    function getName() public view virtual returns (string memory) {
        return name;
    }

}

// no need to inherit from A since "B is A"

contract MyInheritance_C is MyInheritance_B  {

    function getName() public view virtual override returns (string memory) {
        return "Daniel";
    }
}
```

---

### Interface

blueprint. Is basically just an interface telling a smart contract what functions and methods it should implement. In order to follow its structure it has to implement all these functions and write executable actions for them, you notice that this `Ierc721` interface has a function but this function doesn't have an open and closing curling brace the reason for that is this just defines how the method signature looks like and it's up to the person implementing the interface to write code for these methods. Interfaces support inheritance.

Why is it important for us to have interfaces?

We are assured that they are going to implement these two functions and the functionality is up to them to execute it but we at least know that these functions will exist for our program to call and that's exactly how the erc721 and the Ierc721 interface works.

It's a promise to tell the front end or to tell the person who's working with that smart contract that these methods will indeed be there let's go and test them out we can see our count is zero and we can go and increment our count and we can see it work and it's implementing an interface

All declarations of functions must be external like we have over there the reason is because the calls come from the outside a interface can also not declare its own constructor like a normal contract can and you can also not declare state variables.

```solidity
interface ICounter {
    function count() external view returns (uint256);
    function addToCount() external;
}

contract MyInterface is ICounter {

        uint256 counter = 0;

        function count() external view override returns (uint256) {
            return counter;
        }

        function addToCount() external override {
            counter++;
        }

}
```

---

### Sending Ethers

`transfer`- (2300 gas, throws error)
`send` - (2300 gas, returns bool)
`call` -  (forward all gas or set gas, returns bool)

### ⚠️Warning

Which method should you use?
`call` in combination with re-entrancy guard is the recommended method to use after December 2019.

---

### Receiving Ethers


`receive()` - external payable
`fallback()` - external payable

receive() is called if msg.data is empty, otherwise fallback() is called. A contract receiving Ether must have at least one of the functions below

---

### payable

now functions can receive ether

```solidity
contract MyPayable {

   address payable public myAddress;

   constructor() payable {
       myAddress = payable(msg.sender);
   }

   function deposit() public payable {}

   function getThisContractsBalance() public view returns (uint256){
       uint256 amount = address(this).balance;
       return amount;
   }

   function transferEth(address payable _user) public payable {
       _user.transfer(msg.value);
   }

   function sendEth(address payable _user) public payable {
        bool didSend = _user.send(msg.value);
        require(didSend, "This failed to send");
   }

   function callEth(address payable _user) public payable {
       (bool success, ) = _user.call{value: msg.value}("");
       require(success, "failed to send");
   }

   receive() external payable {}

   fallback() external payable {}

}
```

---

### Calling other contrcts

```solidity
// 0x5FD6eB55D12E759a21C09eF703fe0CBa1DC9d88D
contract MyOtherContract {
    uint256 public age = 29;

    function getAge() public view returns (uint256) {
        return age;
    }

}

contract MyContractCalls {

    function getAgeFromOtherContract(address _contractAddress) public view returns (uint256) {
        MyOtherContract other = MyOtherContract(_contractAddress); // get instance of where the contract lives
        uint256 age = other.getAge();
        return age;
    }

}
```

---

### Imports

```solidity
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "./MyLoop.sol";


contract NFT {
    uint256 dna;
    string name;

    constructor(string memory _name, uint256 _dna) {
        name = _name;
        dna = _dna;
    }
}

contract MyImport is ERC721, MyLoop {
    NFT[] public nfts;
    string myName = "Daniel";
    bytes32 myBytesName = "Daniel";

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){}

    function addNft(string memory _name, uint256 _dna) public {
        NFT nft = new NFT(_name, _dna);
        nfts.push(nft);
    }

    function myHashedName(string memory _name) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_name));
    }

}
```
