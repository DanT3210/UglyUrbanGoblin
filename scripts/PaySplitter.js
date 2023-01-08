const hre=require("hardhat");
const {ethers,run, network, getNamedAccounts}=require("hardhat");

let addr1;

async function main() {

  const { deployer} = await getNamedAccounts();
  //Goerli addr1="0xA58f464C7A744333a409d2f8EA3BE08EABc5b203";
  addr1="0x024ea54cb67a2ea5c74821fb27b72c77daa6a50a";
  //Polygon CGF---0x024ea54cb67a2ea5c74821fb27b72c77daa6a50a

  const MainContract = await hre.ethers.getContractFactory("MyPaySplitter");
  const contractMain=await MainContract.deploy([deployer,addr1],[80,20]);
  await contractMain.deployed();

  console.log(`Contract has been deployed to ${contractMain.address}`);

  if(network.config.chainId===5 && process.env.ETH_KEY){
    await contractMain.deployTransaction.wait(6);
    await verify(contractMain.address,[[deployer,addr1],[80,20]]);
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
