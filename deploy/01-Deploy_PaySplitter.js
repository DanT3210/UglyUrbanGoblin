const { getNamedAccounts, deployments, network } = require('hardhat');
//const { networkConfig } = require('../helper-hardhat-config');


module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()
  const chainId = network.config.chainId

  log('----------------------------------------------------')
  log('Deploying PaySplitter and waiting for confirmations...')
  const deployContract = await deploy('PaySplitter', {
    from: deployer,
    log: true,
    args: [],
    // we need to wait if on a live network so we can verify properly
    waitConfirmations: network.config.blockConfirmations || 1,
  })
}


module.exports.tags = ['all', 'FlowerArt']