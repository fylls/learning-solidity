from brownie import FundMe, MockV3Aggregator, network, config
from scripts.helpful_scripts import (
    get_account,
    deploy_mocks,
    LOCAL_BLOCKCHAIN_ENVIRONMENTS,
)


def deploy_fund_me():
    account = get_account()

    # if we are onn a persistent netwokrk like rinkeby, use associated address otherwise, deploy mocks

    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        # fmt: off
        price_feed_address = config["networks"][network.show_active()]["eth_usd_price_feed"]
        # fmt: on
    else:
        deploy_mocks()
        price_feed_address = MockV3Aggregator[-1].address  # most recent

    fund_me = FundMe.deploy(
        price_feed_address,
        {"from": account},
        publish_source=config["networks"][network.show_active()].get("verify"),
    )

    print(f"Contract deployed to {fund_me.address}")
    return fund_me


def main():
    deploy_fund_me()
