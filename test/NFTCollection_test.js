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
    const UglyUrban = await ethers.getContractFactory("NFT_Collection");

    GoblinContract = await UglyUrban.deploy();

    const intilize= await GoblinContract._initializableNFT(artPrice_,name_,symbol_,owner.address);

   console.log("DEPLOY IT");
   //console.log("Listed");
  });

  it("Mint", async function(){
    //const removeItem= await GoblinContract.mint(addr2.address,"1","0");
    await expect(GoblinContract.mint(addr2.address,"1","0")).to.be.revertedWith("Mint: amount/Tx prohibited");
    
  }); 

  it("ArtSupply", async function(){
    const artSupplyVar=await GoblinContract.totalArtSupply("1");
    console.log(artSupplyVar.toString());
  });

  it("Mint 6", async function(){
    //const removeItem= await GoblinContract.mint(addr2.address,"1","5");
    //await expect(GoblinContract.mint(addr2.address,"1","6")).to.be.revertedWith("Mint: Art max supply reached");
    await expect(GoblinContract.mint(addr2.address,"1","6")).to.be.revertedWith("Mint: Supply/Tx reached");
    /*const mappinVar=await GoblinContract.balanceOf(addr2.address, "1");
    console.log(mappinVar.toString());
    assert.equal(mappinVar.toString(),"0");*/
  });

  it("Mint 5", async function(){
    //const removeItem= await GoblinContract.mint(addr2.address,"1","5");
    await expect(GoblinContract.mint(addr2.address,"1","5")).to.be.revertedWith("Mint: Needs more funds");
    //await expect(GoblinContract.mint(addr2.address,"1","6")).to.be.revertedWith("Mint: Supply/Tx reached");
    /*const mappinVar=await GoblinContract.balanceOf(addr2.address, "1");
    console.log(mappinVar.toString());
    assert.equal(mappinVar.toString(),"0");*/
    //const mintVar=await GoblinContract.mint(addr1.address, "1", "5"); 
  });  

  it("mintBatch 5", async function(){
    const mintVar=await GoblinContract.mintBatch(addr1.address, [1], [5]); 
    const artSupplyVar=await GoblinContract.totalArtSupply("1");
    console.log(artSupplyVar.toString());
  });

  it("mintBatch 96", async function(){
    const mintVar=await GoblinContract.mintBatch(addr2.address, [1], [95]); 
    const artSupplyVar=await GoblinContract.totalArtSupply("1");
    console.log(artSupplyVar.toString());
  });  

  it("Burn Art not Owner", async function(){
    await expect(GoblinContract.burn("1","10")).to.be.revertedWith("ERC1155: burn amount exceeds balance");
  });

  it("BanceOff", async function(){
    const balanceVar=await GoblinContract.balanceOf(addr1.address,"1");
    console.log(balanceVar.toString());
  });

    //*************************REVIEW OWNER ADDR1***********************
  it("Burn Art as Owner", async function(){
    const burnVar=await GoblinContract.connect(addr2).burn("1","90");
    const artSupplyVar=await GoblinContract.totalArtSupply("1");
    console.log(artSupplyVar.toString());
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
  });

  it("Show URI", async function(){
    const showURI=await GoblinContract.uri("1");
    console.log("URI:", showURI.toString());
  });

  it("Update Price as Owner", async function(){
    const updatePrice= await GoblinContract.updateArtPrice("200");
    const Art_Price= await GoblinContract.getArtPrice();
    console.log("Art Price is", Art_Price.toString());
  });

  it("Update Price not Owner", async function(){
    await expect (GoblinContract.connect(addr2).updateArtPrice("20")).to.be.revertedWith("Ownable: caller is not the owner");
  });  

});