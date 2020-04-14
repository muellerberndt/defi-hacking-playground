const JesusCoin = artifacts.require('JesusCoin')
const FixedPriceTraderEZMode = artifacts.require('FixedPriceTraderEZMode')

module.exports = async function(callback) {

	let token = await JesusCoin.deployed()

	// Deploy trader 1 with an exchange rate of 100 wei/token

	let trader1 = await FixedPriceTraderEZMode.new(token.address, 100)

	console.log("Trader1 deployed at " + trader1.address)

	await token.approve(trader1.address, 1000000)  // Using "from:" field here appears to cause the script to fail

	await trader1.sellTokens(1000)

	// Deploy trader 2 with an exchange rate of 200 wei/token

	let trader2 = await FixedPriceTraderEZMode.new(token.address, 200)

	console.log("Trader2 deployed at " + trader2.address)

	await trader2.send(web3.utils.toWei("100","ether"))

	await token.approve(trader2.address, 1000000)

	await trader2.sellTokens(1000)

    callback()
	
}