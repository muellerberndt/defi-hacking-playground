const MiniSwapFactory = artifacts.require('MiniSwapFactory')
const MiniSwapExchange = artifacts.require('MiniSwapExchange')
const JesusCoin = artifacts.require('JesusCoin')

module.exports = async function(callback) {

	let token = await JesusCoin.deployed()

	console.log(token);
	
	let factory = await MiniSwapFactory.deployed()

	let result = await factory.deploy(token.address, {from: accounts[0]})

	exchange1 = MiniSwapExchange.at(result.logs[0].args.addr)

	result = await factory.deploy(token.address, {from: accounts[0]})

	exchange2 = MiniSwapExchange.at(result.logs[0].args.addr)

    callback();
}