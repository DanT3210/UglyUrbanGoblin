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

  task("balance", "Prints an account's balance")
  .addParam("account", "The account's address")
  .setAction(async (taskArgs) => {
    const balance = await ethers.provider.getBalance(taskArgs.account);

    console.log(ethers.utils.formatEther(balance), "ETH");
  });
