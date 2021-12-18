# live network agnostic

from brownie import MockV3Aggregator, network
from scripts.helpful_scripts import get_account

DECIMALS = 8
# This is 2,000
INITIAL_VALUE = 200000000000

# Use this script if you want to deploy mocks to a testnet
def deploy_mocks():
    print(f"\nThe active network is {network.show_active()}")
    print("Deploying Mocks...\n")
    account = get_account()
    m3a = MockV3Aggregator.deploy(DECIMALS, INITIAL_VALUE, {"from": account})
    # price_feed_address = m3a.address
    print("Mocks Deployed!\n")


def main():
    deploy_mocks()
