const MiniSwapFactory = artifacts.require('MiniSwapFactory')
const MiniSwapExchange = artifacts.require('MiniSwapExchange')
const JesusCoin = artifacts.require('JesusCoin')

module.exports = async function(callback) {

	let token = await JesusCoin.deployed()

	let exchange1 = await MiniSwapExchange.new(token.address)
	let exchange2 = await MiniSwapExchange.new(token.address)

	await token.approve(exchange1.address, 5000000000)
	await exchange1.addLiquidity(5000000000,5000000000, {from: accounts[0], value: 5000000000})

    callback();
}