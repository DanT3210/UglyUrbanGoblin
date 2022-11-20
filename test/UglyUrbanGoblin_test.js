const { expect,assert } = require("chai");
const { Contract } = require("ethers");
const { ethers } = require("hardhat");
//const {expect}=require("@nomicfoundation/hardhat-chai-matchers")


let price, owner, addr1, addr2, addr3, hardhatMarket, itemStatus, artPrice_, name_, symbol_, paySplitter;

describe("Minting Test", function () {
  artPrice_=100;
  name_="Goblin";
  symbol_="MGM";
  paySplitter=owner;

  it("Deployment", async function () {
    [owner, addr1, addr2, addr3] = await ethers.getSigners();
    const UglyUrban = await ethers.getContractFactory("UglyUrbanGoblin");

    GoblinContract = await UglyUrban.deploy();

    const intilize= await GoblinContract._initializableNFT(artPrice_,name_,symbol_,owner.address);

   console.log("DEPLOY IT");
   //console.log("Listed");
  });

  it("Mint", async function(){
    //const removeItem= await GoblinContract.mint(addr2.address,"1","0");
    await expect(GoblinContract.mint(addr2.address,"1","0")).to.be.revertedWith("Mint: amount/Tx prohibited");
    
  }); 

  it("Mint 10", async function(){
    //const removeItem= await GoblinContract.mint(addr2.address,"1","10");
    await expect(GoblinContract.mint(addr2.address,"1","10")).to.be.revertedWith("Mint: Needs more funds");
    //await expect(GoblinContract.mint(addr2.address,"1","10")).to.be.revertedWith("Mint: amount/Tx prohibited");
    const mappinVar=await GoblinContract.balanceOf(addr2.address, "1");
    console.log(mappinVar.toString());
    assert.equal(mappinVar.toString(),"0");
  });

  it("Burn Art", async function(){
    await expect(GoblinContract.burn("1","10")).to.be.revertedWith("BURN You're not an Owner");
  });
  
  it("NFT Price", async function(){
    const Art_Price= await GoblinContract.getArtPrice();
    console.log("Art Price is", Art_Price.toString());
  });

  it("Set URI not Owner", async function(){
    await expect(GoblinContract.connect(addr2).setURI("1","ipfs://QmQwpJwqV9zmvdv7WidfkFX2nSaCBdmYKkUS8yrNzKXw2j/1.json")).to.be.revertedWith("Ownable: caller is not the owner");
  });

  it("Set URI Owner", async function(){
    const setURI=await GoblinContract.setURI("1","ipfs://QmQwpJwqV9zmvdv7WidfkFX2nSaCBdmYKkUS8yrNzKXw2j/1.json");
    console.log("URI has been set",setURI.toString());
  });

  it("Show URI", async function(){
    const showURI=await GoblinContract.uri("1");
    console.log("URI:", showURI.toString());
  });

  it("Update Price as Owner", async function(){
    const updatePrice= await GoblinContract.updateArtPrice("200");
  });

  it("Update Price not Owner", async function(){
    await expect (GoblinContract.connect(addr2).updateArtPrice("20")).to.be.revertedWith("Ownable: caller is not the owner");
  });  

});