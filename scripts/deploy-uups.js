/*const { upgrades } = require("hardhat");
const hre=require("hardhat");
const {ethers,run, network}=require("hardhat");

const ART_PRICE = 100;
const NAME="My Goblin";
const SYMBOLE="UUG";
const PAYSPLITER="0x5FbDB2315678afecb367f032d93F642f64180aa3";

async function main() {
 const myGoblin = await ethers.getContractFactory("UglyUrbanGoblin");
 console.log("Deploying NFT...");

 const goblin = await upgrades.deployProxy(myGoblin, [ART_PRICE,"NAME",SYMBOLE,PAYSPLITER], {
   initializer: "initialize",
 });
 await goblin.deployed();

 console.log("NFT deployed to:", goblin.address);
}

main();*/
const { ethers, upgrades } = require("hardhat");

const ART_PRICE = 200000000;
const NAME="Girls Fhasionable Collection";
const SYMBOLE="GFC";
const PAYSPLITER="0x0a5615760137a8b4d2428eba3A58f2287df8A00D";
//Polygon-PaySplitter:0x1A97e0A41333d6d58E42aeDD23Eb92f80805B536--OLD
//Polygon-Payspliter: 0x0a5615760137a8b4d2428eba3A58f2287df8A00D
//Goerli-PaySplitter: 0x921C8A97d595164F8FE6d913E945f5AA36C4E4a5
async function main() {
 const GOBLIN = await ethers.getContractFactory("NFT_Collection");

 console.log("Deploying implemantation...");

 const goblin = await upgrades.deployProxy(GOBLIN, [ART_PRICE,NAME,SYMBOLE,PAYSPLITER], {
   initializer: "_initializableNFT",
 });
 await goblin.deployed();

 console.log("Implementation deployed to:", goblin.address);
}

main();