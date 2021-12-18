# import modules
import os
import json
from web3 import Web3
from dotenv import load_dotenv
from solcx import compile_standard, install_solc

# load env variables
load_dotenv()

# load file
with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()

# load Solc (needed to compile)
print("Installing...")
install_solc("0.6.0")
print("intalled")

# compile solidity source code
compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {
                    "*": ["abi", "metadata", "evm.bytecode", "evm.bytecode.sourceMap"]
                }
            }
        },
    },
    solc_version="0.6.0",
)

# save compiled solidity code (ABI) as JSON
with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)

#
# fmt: off
#

# get bytecode
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"]["bytecode"]["object"]

# get abi
abi = json.loads(compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["metadata"])["output"]["abi"]

#
# fmt: on
#

# deploy to a simulated env (ganache) - faster for testing
w3 = Web3(Web3.HTTPProvider("HTTP://127.0.0.1:8545"))
my_address = "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1"
private_key = os.getenv("PRIVATE_KEY")
chain_id = 1337

# deploy to rinkeby  testnet
# w3 = Web3(Web3.HTTPProvider(os.getenv("RINKEBY_RPC_URL")))
# chain_id = 4

# create the contract in Python
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)

# get the latest transaction
nonce = w3.eth.getTransactionCount(my_address)

# sending a transaction

# 1) built the transaction (contract deploying)
transaction = SimpleStorage.constructor().buildTransaction(
    {"chainId": chain_id, "from": my_address, "nonce": nonce}
)

# 2) sign he transaction
signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)
print("Deploying Contract...")

# 3) send the transaction to the blockchian
tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
print("Waiting for transaction to finish...")

# 4) get receipt (block- confirmation)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print(f"Done! Contract deployed to {tx_receipt.contractAddress}")

# Working with deployed Contracts

simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)
print(f"Initial Stored Value {simple_storage.functions.retrieve().call()}")

# call Store function to update favoriteNumber
# 1) built the transaction (contract deploying)
store_transaction = simple_storage.functions.store(15).buildTransaction(
    {"chainId": chain_id, "from": my_address, "nonce": nonce + 1}
)

# 2) sign he transaction
signed_store_txn = w3.eth.account.sign_transaction(
    store_transaction, private_key=private_key
)

# 3) send the transaction to the blockchian
tx_store_hash = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
print("Updating stored Value...")

# 4) get receipt (print new updated value)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_store_hash)
print(f"Done! Value updated to {simple_storage.functions.retrieve().call()}")
