const JesusCoin = artifacts.require('JesusCoin');
const MiniSwapExchange = artifacts.require('MiniSwapExchange');
const DefiLoans = artifacts.require('DefiLoans');

module.exports = function(deployer) {

    // Deploy the Storage contract
    deployer.deploy(JesusCoin)
        // Wait until the storage contract is deployed
        .then(() => JesusCoin.deployed())
        // Deploy the InfoManager contract, while passing the address of the
        // Storage contract
        .then(() => deployer.deploy(MiniSwapExchange, JesusCoin.address))
        .then(() => deployer.deploy(DefiLoans, MiniSwapExchange.address, JesusCoin.address))
}