const { expect } = require("chai");
const { ethers } = require("hardhat");

let price, owner, addr1, addr2, addr3, hardhatMarket, itemStatus;

describe("NFT contract Test", function () {

  it("Deployment", async function () {
    [owner, addr1, addr2, addr3] = await ethers.getSigners();
    const UglyUrban = await ethers.getContractFactory("UglyUrbanGoblin");

    GoblinContract = await UglyUrban.deploy();

   console.log("DEPLOY IT");
   //console.log("Listed");
  });
/*
  it("Remove item", async function(){
    const removeItem= await hardhatMarket.connect(owner).RemoveSingleItem("0");
    const itemListed_var=await hardhatMarket.SellerList("0", owner.address);
    itemStatus= await hardhatMarket.getStatus("0", owner.address);
    console.log(itemStatus);
    console.log("ITEM REMOVED--------------------");
    console.log(itemListed_var);
  });  */
});