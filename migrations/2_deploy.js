const JesusCoin = artifacts.require('JesusCoin');
const MiniSwapFactory = artifacts.require('MiniSwapFactory');

module.exports = function(deployer) {

    deployer.deploy(JesusCoin)
        .then(() => JesusCoin.deployed())
        .then(() => deployer.deploy(MiniSwapFactory))
}