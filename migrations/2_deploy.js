const JesusCoin = artifacts.require('JesusCoin');
const MiniSwapExchange = artifacts.require('MiniSwapExchange');
const DefiLoans = artifacts.require('DefiLoans');

module.exports = async function (deployer, network) {

    await deployer.deploy(JesusCoin);
    const token = await JesusCoin.deployed();

    await deployer.deploy(MiniSwapExchange(token.address));
    const exchange = await MiniSwapExchange.deployed();

    deployer.deploy(DefiLoans(token.address, exchange.address));

};
