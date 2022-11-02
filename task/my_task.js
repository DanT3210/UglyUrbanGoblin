//const { networkConfig } = require('../helper-hardhat-config');

const {task}=require("hardhat/config");

task("block_number","Prints the current block #").setAction(
    async (taskArgs, hre)=>{
        const blockNumber=await hre.ethers.provider.getBlockNumber();
        console.log(`FBlock #: ${blockNumber}`);
    });

task("accounts", "Prints the list of accounts", async () => {
    const accounts = await ethers.getSigners();
  
    for (const account of accounts) {
      console.log(account.address);
    }
  });
