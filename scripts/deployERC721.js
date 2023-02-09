const hre=require("hardhat");
const {ethers,run, network}=require("hardhat");

const PAYSPLITER="0xaEd24166D587E3AE683De41738847286400A6a59";
const URI_="ipfs://Qmdvrs4wq6BSLNkhjZS3DyX5uS3Pq4W8NxL862rdzUgMQ3/"

async function main() {
  const MainContract = await hre.ethers.getContractFactory("ChiaroscuroBeauties");
  const contractMain=await MainContract.deploy(PAYSPLITER,URI_);
  await contractMain.deployed();

  console.log(`Contract has been deployed to ${contractMain.address}`);

  if(network.config.chainId===5 && process.env.ETH_KEY){
    await contractMain.deployTransaction.wait(6);
    await verify(contractMain.address,[PAYSPLITER,URI_]);
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
