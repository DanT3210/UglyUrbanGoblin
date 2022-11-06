require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();
require("@nomiclabs/hardhat-etherscan");
require("./task/my_task");
require("hardhat-deploy");
//require("@nomicfoundation/hardhat-chai-matchers")

//const RINKEBY_RPC_URL = process.env.RINKEBY_RPC_URL || "https://eth-rinkeby.alchemyapi.io/v2/your-api-key";
const GOERLI_RPC_URL=process.env.GOERLI_RPC_URL || "https://eth-goerli.g.alchemy.com/v2/7aKFaFYTJuVBsJFGJadeeMs22gCI07Th";
const POLYGON_RPC_URL=process.env.POLYGON_RPC_URL || "https://polygon-mainnet.g.alchemy.com/v2/nCf5wpNSLNnsor8gW9D43ldTP-KyGYeI";
const PRIVATE_KEY = process.env.PRIVATE_KEY || "0x";
const ETHERSCAN_KEY=process.env.ETHERSCAN_KEY || "0x";
const POLYGON_KEY=process.env.POLYGON_KEY || "0x";

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    localhost: {
      chainId: 31337,
    },
    goerli: {
      url: GOERLI_RPC_URL,
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId:5,
    },
    polygon: {
      url: POLYGON_RPC_URL,
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
      chainId:137,
    }    
  },  
  etherscan:{
    apiKey: ETHERSCAN_KEY,//POLYGON_KEY,
 },  
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  mocha: {
    timeout: 40000
  },  
  namedAccounts: {
    deployer: {
      default: 0, // here this will by default take the first account as deployer
    },
    addr1:{
      default: 1,
    },
  },  
};
