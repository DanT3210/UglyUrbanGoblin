// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract UglyUrbanGoblin is ERC1155, Ownable, ReentrancyGuard {
  
  uint256 constant MAX_SUPPLY = 300;
  uint8 maxTx = 10;
  uint8 maxPerAccount = 20; 
  uint16 public maxSupply = 100;
  uint256 artPrice;
  string public name;
  string public symbol;

  mapping(uint => string) public tokenURI;
//uint id_, string memory uri_, uint artPrice_
  constructor() ERC1155("") {
    name = "UGLY URBAN GOLBLIN";
    symbol = "UUG";
    artPrice=50000000000000000;
    //setURI(id_,uri_);
    //tokenURI[id_] = uri_;
    //_mint(_msgSender(), id_, 100, "");
  } 

  receive() external payable {}

  function mint(address _to, uint id, uint amount) external {
    uint256 currentTx=balanceOf(_to,id);
    require(amount > 0 && amount <= maxPerAccount, "Purchase: amount prohibited");
    uint256 _supply=currentTx+amount;
    require(_supply<=maxPerAccount, "Purchase: Max supply reached");
    //require(msg.value>=artPrice*amount, "Purchase: Needs more funds");    
    _mint(_to, id, amount, "");
  }

  /*function mintBatch(address _to, uint[] memory ids, uint[] memory amounts) external onlyOwner {
        for(uint256 i = 0; i < ids.length; i++){
            require(amounts.length == ids.length, "MintBatch: amounts and ids length mismatch");
            require(amounts[i] > 0 && amounts[i] <= maxTx, "MintBatch: amount prohibited");

            uint256 id=ids[i];
            uint256 _idSupply=balanceOf(_to,id);
            uint256 _Totalsupply=_idSupply+amounts[i];
            
            require(_Totalsupply<=maxTx && amounts[id]<=maxTx, "MintBatch: Max supply reached");

            //updateSupply(id, amounts[i],msg.sender);

        }    
    _mintBatch(_to, ids, amounts, "");
  }*/

  function burn(uint _id, uint _amount) external {
    require(balanceOf(_msgSender(),_id)>0,"BURN You're not an Owner");
    _burn(msg.sender, _id, _amount);
  }

 /* function burnBatch(uint[] memory _ids, uint[] memory _amounts) external onlyOwner{
    _burnBatch(msg.sender, _ids, _amounts);
  }*/

  function setURI(uint _id, string memory _uri) external onlyOwner {
    tokenURI[_id] = _uri;
    emit URI(_uri, _id);
  }

  function uri(uint _id) public override view returns (string memory) {
    return tokenURI[_id];
  }
    
  /*function updateArtPrice(uint256 _newPrice)public onlyOwner{
    artPrice=_newPrice;
  }   */    

  function withdraw() public payable onlyOwner nonReentrant(){
    require(payable(msg.sender).send(address(this).balance));
  }

}
    