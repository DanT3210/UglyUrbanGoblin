const { ethers, upgrades } = require("hardhat");

const PROXY = "0xE0cbfe5908a35D08Af0bE9BF9c272cBE2892aBA3";

async function main() {
 const Ugly = await ethers.getContractFactory("Ugly_V2");
 console.log("Upgrading implemantation...");
 await upgrades.upgradeProxy(PROXY, Ugly);
 console.log("Upgraded successfully");
}

main();