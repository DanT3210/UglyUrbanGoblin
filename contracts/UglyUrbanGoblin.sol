// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/common/ERC2981Upgradeable.sol";


contract UglyUrbanGoblin is Initializable, UUPSUpgradeable, ERC1155Upgradeable,ERC2981Upgradeable, OwnableUpgradeable, ReentrancyGuardUpgradeable {
  

  /*uint256  public MAX_PER_ACCT; */
  uint256  public constant ART_SUPPLY=100;
  uint256 private artPrice;
  string private name;
  string private symbol;
  address payable private paySplitter;

  // ID+QTY=>Total Supply per ID
  mapping(uint => uint)private artSypply;
  // ID+URI=> Token URI per ID
  mapping(uint => string) private tokenURI;

  function _initializableNFT(uint256 artPrice_, string memory name_, string memory symbol_, address _payment)public initializer{
    artPrice=artPrice_;
    name=name_;
    symbol=symbol_;
    paySplitter = payable (_payment);
    

    __Ownable_init();
    __UUPSUpgradeable_init();
    __ReentrancyGuard_init();
    __ERC1155_init("");   
    __ERC2981_init();  
  }

  ///@dev required by the OZ UUPS module
  function _authorizeUpgrade(address) internal override onlyOwner {}
  
  function mint(address _to, uint id, uint amount) external payable nonReentrant{
    require(amount > 0, "Mint: amount/Tx prohibited");
    require(artSypply[id]<=ART_SUPPLY, "Mint: Art max supply reached");
    require(balanceOf(_to,id)+amount<6, "Mint: Supply/Tx reached");
    require(msg.value>=artPrice*amount, "Mint: Needs more funds"); 
     artSypply[id]+=amount;   
    _mint(_to, id, amount, "");
    transferFunds(msg.value);
  }

  function mintBatch(address _to, uint[] memory ids, uint[] memory amounts) external onlyOwner {
        for(uint256 i = 0; i < ids.length; i++){
            require(amounts.length == ids.length, "MintBatch: amounts and ids length mismatch");
            require(amounts[i] > 0 && amounts[i]<=ART_SUPPLY, "MintBatch: amount/Tx prohibited");
            uint256 id=ids[i];
            require(artSypply[id]<=ART_SUPPLY, "MintBatch: Art max supply reached");
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

  function uri(uint _id) public override virtual view returns (string memory) {
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

  function getName()public view returns(string memory){
    return name;
  }

  function getSymbol()public view returns(string memory){
    return symbol;
  }

  // EIP2981 standard Interface return. Adds to ERC1155 and ERC165 Interface returns.
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155Upgradeable,ERC2981Upgradeable) returns (bool){
        return (
            interfaceId == type(ERC2981Upgradeable).interfaceId ||
            super.supportsInterface(interfaceId)
        );
    }
  
  function transferFunds(uint256 balance) private{ 
    require(payable(paySplitter).send(balance));
  }
}