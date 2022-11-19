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

const ART_PRICE = 100;
const NAME="My Goblin";
const SYMBOLE="UUG";
const PAYSPLITER="0x64b91B14D28642C55Af08647Ce2D832ae1187f98";
async function main() {
 const GOBLIN = await ethers.getContractFactory("UglyUrbanGoblin");

 console.log("Deploying implemantation...");

 const goblin = await upgrades.deployProxy(GOBLIN, [ART_PRICE,NAME,SYMBOLE,PAYSPLITER], {
   initializer: "_initializableNFT",
 });
 await goblin.deployed();

 console.log("Implementation deployed to:", goblin.address);
}

main();