const { getNamedAccounts, deployments, network } = require('hardhat');
//const { networkConfig } = require('../helper-hardhat-config');
let name, symbol,price;

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()
  const chainId = network.config.chainId

  log('----------------------------------------------------')
  log('Deploying Contract and waiting for confirmations...')
  const deployContract = await deploy('NFT_Collection', {
    from: deployer,
    log: true,
    args: [],
    // we need to wait if on a live network so we can verify properly
    waitConfirmations: network.config.blockConfirmations || 1,
  })
}


module.exports.tags = ['all', 'UglyUrbanGoblin']