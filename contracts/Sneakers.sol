// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";


contract sneakers is ERC721, ERC721URIStorage,ERC2981, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    
    uint256 public cost;

    string public uriPrefix = "";
    string public uriSuffix = ".json";
    address payable private paySplitter;

    mapping(uint id => uint price) private sneakersPrice;

    receive() external payable {}

    constructor(address payable payment) ERC721("Sneaker Market", "SNKRS") {
        paySplitter=payment;
        _setDefaultRoyalty(paySplitter,200);
    }

    //GETTERS//
    function totalSneakers() public view returns (uint256) {
        return _tokenIdCounter.current();
    }   

    function contractAmount()public view returns(uint256){
        return address(this).balance;
    }

    function publish(uint256 qty_, string  memory uri_, uint256[] memory price_) public{
        _mintLoop(msg.sender, qty_, uri_, price_);
    }

    // The following functions are overrides required by Solidity.
    function tokenURI(uint256 _tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory){
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory currentBaseURI = uriPrefix;
        return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix)) : "";
    }    
    
    // EIP2981 standard Interface return. Adds to ERC1155 and ERC165 Interface returns.
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721,ERC2981) returns (bool){
        return (
            interfaceId == type(ERC2981).interfaceId ||
            super.supportsInterface(interfaceId)
        );
    }    

    //INTERNALS//
    function _mintLoop(address _receiver, uint256 _mintAmount, string  memory uri_, uint256[] memory price_) internal {
        require(price_.length==_mintAmount, "ERROR: Price lenght doesn't match Qty");
        for (uint256 i = 0; i < _mintAmount; i++) {
            _tokenIdCounter.increment();
            uint256 counter=_tokenIdCounter.current();
            _safeMint(_receiver, counter);
            uriPrefix=uri_;
            tokenURI(counter);
            sneakersPrice[counter]=price_[i];
        }
    }    

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }  

    //EXTERNAL//
    function myRoyalty(uint96 feeNumerator) external onlyOwner {
        _setDefaultRoyalty(paySplitter,feeNumerator);

    }  

     function myTokenRoyalty( uint256 tokenId, uint96 feeNumerator)external onlyOwner{
      _setTokenRoyalty(tokenId,paySplitter,feeNumerator);

     }

     function resetMyTokenRoyalty(uint tokenID)external onlyOwner{
      _resetTokenRoyalty(tokenID);
     }     

     function remove(uint tokenId)external onlyOwner{
         _burn(tokenId);
     }  
     
    function transferFunds(uint256 balance) external onlyOwner{ 
      require(payable(paySplitter).send(balance));
    }      

    function getPrice(uint id_)public view returns(uint){
        return sneakersPrice[id_];
    }     
}