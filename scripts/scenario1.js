const JesusCoin = artifacts.require('JesusCoin')
const FixedPriceTrader = artifacts.require('FixedPriceTrader')

module.exports = async function(callback) {

	let token = await JesusCoin.deployed()

	// Deploy trader 1 with an exchange rate of 100 wei/token

	let trader1 = await FixedPriceTrader.new(token.address, 100)

	console.log("Trader1 deployed at " + trader1.address)

	await trader1.send(web3.utils.toWei("1","ether"))

	await token.approve(trader1.address, 1000, {from: accounts[0]})

	await trader1.sellTokens(1000)

	// Deploy trader 2 with an exchange rate of 200 wei/token

	let trader2 = await FixedPriceTrader.new(token.address, 200)

	console.log("Trader2 deployed at " + trader1.address)

	await trader2.send(web3.utils.toWei("1","ether"))

	await token.approve(trader2.address, 1000, {from: accounts[0]})

	await trader2.sellTokens(1000)

    callback()
	
}