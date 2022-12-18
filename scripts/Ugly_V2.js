const { ethers, upgrades } = require("hardhat");

const PROXY = "0xf51339D46d3113adaFdC0b516818e5E0201f1d29";

async function main() {
 const Ugly = await ethers.getContractFactory("Ugly_V2");
 console.log("Upgrading implemantation...");
 await upgrades.upgradeProxy(PROXY, Ugly);
 console.log("Upgraded successfully");
}

main();