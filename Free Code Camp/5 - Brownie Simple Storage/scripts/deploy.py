# import os
from brownie import accounts, config, SimpleStorage, network

# brownie compiles, saves as json, gets abi and bytecode & adds local blockchain (ganache) automatically
# with brownie we can even import contracts
# brownie


def deploy_simple_storage():
    account = get_account()

    simple_storage = SimpleStorage.deploy({"from": account})
    stored_value = simple_storage.retrieve()
    print(stored_value)

    transaction = simple_storage.store(15, {"from": account})
    transaction.wait(1)  # how many block we want to wait
    updated_stored_value = simple_storage.retrieve()
    print(updated_stored_value)


def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        # accounts.add(os.getenv("PRIVATE_KEY"))
        return accounts.add(config["wallets"]["from_key"])


def main():
    deploy_simple_storage()
