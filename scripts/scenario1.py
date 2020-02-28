from brownie import *

template = uniswap_exchange.deploy({'from': accounts[0]})
factory = uniswap_factory.deploy({'from': accounts[0]})

factory.initializeFactory(template)

token = erc20.deploy("TOKEN", "TOK", 0, 1000000, {'from': accounts[0]})

factory.createExchange(token)

from brownie import Contract

exchange = Contract(
	"Exchange",
	factory.getExchange(token),
	uniswap_exchange.abi
	)

tx = exchange.addLiquidity(0, 10000000000, 10000000000, {'from': accounts[0], 'value': 10000000000})
