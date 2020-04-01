const JesusCoin = artifacts.require('JesusCoin')
const MiniSwapExchange = artifacts.require('MiniSwapExchange')
const DefiLoans = artifacts.require('DefiLoans')

module.exports = async function(callback) {

	let token = await JesusCoin.deployed()

	// Deploy exchange

	let exchange = await MiniSwapExchange.new(token.address)

	await token.approve(exchange.address, 5000000000, {from: accounts[0]})

	await exchange.addLiquidity(5000000000,5000000000, {from: accounts[0], value: 5000000000})
	
	console.log("Exchange at " + exchange.address)

	let loans = await DefiLoans.new(exchange.address, token.address)

	// Provide some liquidity for loans contract

	await loans.send(web3.utils.toWei("10000","ether"))
	
    callback()
}

