// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";


contract ChiaroscuroBeauties is ERC721, ERC721URIStorage,ERC2981, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    
    uint256 public cost = 0.05 ether;
    uint256 public availableSupply = 10;

    string public uriPrefix = "";
    string public uriSuffix = ".json";

    address payable private paySplitter;

    receive() external payable {}

    constructor(address payable payment, string  memory uri_) ERC721("Women of Dark Elegance", "WDE") {
        uriPrefix= uri_;
        paySplitter=payment;
    }

    //GETTERS//
    function totalSupply() public view returns (uint256) {
        return _tokenIdCounter.current();
    }   

    function contractAmount()public view returns(uint256){
        return address(this).balance;
    }

    function mint(address mintTo, uint256 _mintAmount) public onlyOwner {
        uint256 total=totalSupply();
       require(total<=availableSupply,"ERC721-MINT:Out of stock!");
        _mintLoop(mintTo, _mintAmount);
        availableSupply=availableSupply-_mintAmount;
    }

    // The following functions are overrides required by Solidity.
    function tokenURI(uint256 _tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory){
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory currentBaseURI = _baseURI();
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
    function _mintLoop(address _receiver, uint256 _mintAmount) internal {
        for (uint256 i = 0; i < _mintAmount; i++) {
            _tokenIdCounter.increment();
            _safeMint(_receiver, _tokenIdCounter.current());
        }
    }    

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }  

    function _baseURI() internal view virtual override returns (string memory) {
        return uriPrefix;
    }    

    //EXTERNAL//
    function myRoyalty(uint96 feeNumerator) external onlyOwner {
        _setDefaultRoyalty(paySplitter,feeNumerator);

    }  

     function myTokenRoyalty( uint256 tokenId, uint96 feeNumerator)external onlyOwner{
      _setTokenRoyalty(tokenId,paySplitter,feeNumerator);

     }

     function removeDefaultRoyalty()external onlyOwner{
      _deleteDefaultRoyalty();
     }

     function resetMyTokenRoyalty(uint tokenID)external onlyOwner{
      _resetTokenRoyalty(tokenID);
     }     

     function burnToken(uint tokenId)external onlyOwner{
         _burn(tokenId);
     }  
     
    function transferFunds(uint256 balance) external onlyOwner{ 
      require(payable(paySplitter).send(balance));
    }           
}