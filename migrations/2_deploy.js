const JesusCoin = artifacts.require('JesusCoin');
const MiniSwapExchange = artifacts.require('MiniSwapExchange');
const DefiLoans = artifacts.require('DefiLoans');

module.exports = function(deployer) {

    deployer.deploy(JesusCoin)
        .then(() => JesusCoin.deployed())
        .then(() => deployer.deploy(MiniSwapExchange, JesusCoin.address))
        .then(() => deployer.deploy(DefiLoans, MiniSwapExchange.address, JesusCoin.address))
}