const fs = require("fs");
const { network } = require("hardhat");

const frontEndContractsFile="../ugly_urban_fronend/constants/contractAddresses.json";
const frontEndAbiFile="../ugly_urban_fronend/constants/abi.json";

module.exports = async () => {
    if (process.env.UPGRDAE_FRONTRND) {
        console.log("Writing to front end...");
        await updateContractAddresses();
        await updateAbi();
        console.log("Front end written!");
    }
}

async function updateAbi() {
    const Goblin = await ethers.getContract("NFT_Collection");
    fs.writeFileSync(frontEndAbiFile, Goblin.interface.format(ethers.utils.FormatTypes.json));
    console.log("Upgraded ABI");
}

async function updateContractAddresses() {
    const Goblin = await ethers.getContract("NFT_Collection");
    const contractAddresses = JSON.parse(fs.readFileSync(frontEndContractsFile, "utf8"));
    if (network.config.chainId.toString() in contractAddresses) {
        if (!contractAddresses[network.config.chainId.toString()].includes(Goblin.address)) {
            contractAddresses[network.config.chainId.toString()].push(Goblin.address);
        }
    } else {
        contractAddresses[network.config.chainId.toString()] = [Goblin.address];
    }
    fs.writeFileSync(frontEndContractsFile, JSON.stringify(contractAddresses));
    console.log("Upgraded Contract");
}
module.exports.tags = ["all", "frontend"];