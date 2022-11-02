const hre=require("hardhat");
const {ethers,run, network}=require("hardhat");


async function main() {
  const MainContract = await hre.ethers.getContractFactory("UglyUrbanGoblin");
  const contractMain=await MainContract.deploy();
  await contractMain.deployed();

  console.log(`Contract has been deployed to ${contractMain.address}`);

  if(network.config.chainId===5 && process.env.ETH_KEY){
    await contractMain.deployTransaction.wait(6);
    await verify(contractMain.address,[]);
  }
}

async function verify(contractAddress, args){
  try{
  await run("verify:verify",{
    address:contractAddress,
    constructorArguments: args,
  })
}catch (e){
  if(e.message.toLowerCase.includes("already verify")){
    console.log("Already Verified");
  }else {
    console.log(e);
  }
}
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
