const JesusCoin = artifacts.require('JesusCoin');
const MiniSwapFactory = artifacts.require('MiniSwapFactory');
const DefiLoans = artifacts.require('DefiLoans');

module.exports = function(deployer) {

    deployer.deploy(JesusCoin)
        .then(() => JesusCoin.deployed())
        .then(() => deployer.deploy(MiniSwapFactory))
        // .then(() => deployer.deploy(DefiLoans, MiniSwapExchange.address, JesusCoin.address))
}