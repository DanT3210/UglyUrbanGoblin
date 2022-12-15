const { getNamedAccounts, deployments, nt3etwork } = require('hardhat');
//const { networkConfig } = require('../helper-hardhat-config');

let addr1, addr2, addr3;

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments
  const { deployer, addr1, addr2 } = await getNamedAccounts()
  const chainId = network.config.chainId
  //[addr1, addr2, addr3] = await ethers.getSigners();

  log('----------------------------------------------------')
  log('Deploying MyPaySplitter and waiting for confirmations...')
  const deployContract = await deploy('MyPaySplitter', {
    from: deployer,
    log: true,
    args: [[deployer], [80]],
    // we need to wait if on a live network so we can verify properly
    waitConfirmations: network.config.blockConfirmations || 1,
  })
  console.log("paySplit deployed to:", deployContract.address);
  //console.log("Account Address 1:", addr1);
}


module.exports.tags = ['all', 'PaySplitter']