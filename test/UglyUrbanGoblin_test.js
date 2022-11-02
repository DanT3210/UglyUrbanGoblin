const { expect,assert } = require("chai");
const { Contract } = require("ethers");
const { ethers } = require("hardhat");
//const {expect}=require("@nomicfoundation/hardhat-chai-matchers")


let price, owner, addr1, addr2, addr3, hardhatMarket, itemStatus;

describe("Minting Test", function () {

  it("Deployment", async function () {
    [owner, addr1, addr2, addr3] = await ethers.getSigners();
    const UglyUrban = await ethers.getContractFactory("UglyUrbanGoblin");

    GoblinContract = await UglyUrban.deploy();

   console.log("DEPLOY IT");
   //console.log("Listed");
  });

  it("Mint", async function(){
    //const removeItem= await GoblinContract.mint(addr2.address,"1","0");
    await expect(GoblinContract.mint(addr2.address,"1","0")).to.be.revertedWith("Purchase: amount prohibited");
    
  }); 

  it("Mint 10", async function(){
    const removeItem= await GoblinContract.mint(addr2.address,"1","10");
    //await expect(GoblinContract.mint(addr2.address,"1","10")).to.be.revertedWith("Purchase: amount prohibited");
    const mappinVar=await GoblinContract.balanceOf(addr2.address, "1");
    console.log(mappinVar.toString());
    assert.equal(mappinVar.toString(),"10");
  });   
});