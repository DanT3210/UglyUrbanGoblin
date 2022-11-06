// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract UglyUrbanGoblin is ERC1155, Ownable, ReentrancyGuard {
  
  uint8 constant private maxTx = 100;
  uint8 constant public maxPerAccount = 10; 
  uint32 constant public ART_SUPPLY=100;
  uint256 private artPrice;
  string private name;
  string private symbol;
  address payable private paySplitter;

  // ID+QTY=>Total Supply per ID
  mapping(uint => uint)private artSypply;
  // ID+URI=> TOken URI per ID
  mapping(uint => string) private tokenURI;


  constructor(string memory name_, string memory symbol_, uint256 artPrice_, address _payment) ERC1155(""){
    name = name_;//"UGLY URBAN GOLBLIN";
    symbol = symbol_;//"UUG"
    artPrice=artPrice_;//50000000000000000;
    paySplitter = payable (_payment);
  } 

  
  function mint(address _to, uint id, uint amount) external payable nonReentrant(){
    require(amount > 0 && amount <= maxPerAccount, "Mint: amount/Tx prohibited");
    require(balanceOf(_to,id)+amount<=maxPerAccount, "Mint: Supply/Tx reached");
    require(artSypply[id]<ART_SUPPLY, "Mint: Art max supply reached");
    require(msg.value>=artPrice*amount, "Mint: Needs more funds");    
    _mint(_to, id, amount, "");
    artSypply[id]+=amount;
    transferFunds(msg.value);
  }

  function mintBatch(address _to, uint[] memory ids, uint[] memory amounts) external onlyOwner {
        for(uint256 i = 0; i < ids.length; i++){
            require(amounts.length == ids.length, "MintBatch: amounts and ids length mismatch");
            require(amounts[i] > 0 && amounts[i] <= maxTx, "MintBatch: amount/Tx prohibited");

            uint256 id=ids[i];
            require(artSypply[id]<ART_SUPPLY, "MintBatch: Art max supply reached");
            //uint balance=balanceOf(_to,id);
            //require(balance<=maxTx && amounts[id]<=maxTx, "MintBatch: Max/Tx reached");

            artSypply[id]+=amounts[i];
        }    
    _mintBatch(_to, ids, amounts, "");
  }

  function burn(uint _id, uint _amount) external {
    require(balanceOf(_msgSender(),_id)>0,"BURN You're not an Owner");
    _burn(msg.sender, _id, _amount);
  }

  function burnBatch(uint[] memory _ids, uint[] memory _amounts) external{
    for(uint256 i; i>=_ids.length; i++){
      require(balanceOf(_msgSender(),_ids[i])>0,"BATCH_BURN You're not an Owner");
      _burnBatch(msg.sender, _ids, _amounts);
    }
  }

  function setURI(uint _id, string memory _uri) external onlyOwner {
    tokenURI[_id] = _uri;
    emit URI(_uri, _id);
  }

  function uri(uint _id) public override view onlyOwner returns (string memory) {
    return tokenURI[_id];
  }

  function totalArtSupply(uint id_) public view returns (uint) {
    return artSypply[id_];
  }

  function getArtPrice() public view returns(uint256){
    return artPrice;
  }
    
  function updateArtPrice(uint256 _newPrice)public onlyOwner{
    artPrice=_newPrice;
  }  

  function transferFunds(uint256 balance) private{
    require(payable(paySplitter).send(balance));
  }
}