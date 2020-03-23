const JesusCoin = artifacts.require('JesusCoin')
const MiniSwapExchange = artifacts.require('MiniSwapExchange')

module.exports = async function(callback) {

	let token = await JesusCoin.deployed()

	// Deploy exchange 1

	let exchange = await MiniSwapExchange.new(token.address)

	await token.approve(exchange1.address, 5000000000, {from: accounts[0]})

	await exchange1.addLiquidity(5000000000,5000000000, {from: accounts[0], value: 5000000000})
	
	console.log("Exchange at " + exchange1.address);

	// Deploy exchange 2

	let defiloans = await MiniSwapExchange.new(token.address)

	await token.approve(exchange2.address, 5000000000, {from: accounts[0]})

	await exchange2.addLiquidity(5000000000,5000000000, {from: accounts[0], value: 5000000000})
	
	console.log("Exchange1 at " + exchange1.address);

    callback();
}