from brownie import SimpleStorage, accounts, config

# reads to ropsten blockchain, contracts already deployed


def read_contract():
    simple_storage = SimpleStorage[-1]  # most recent
    print(simple_storage.retrieve())


def main():
    read_contract()
