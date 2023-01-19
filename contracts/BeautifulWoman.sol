// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract BeautifulWoman is ERC721, ERC721URIStorage,ERC2981, Ownable, ReentrancyGuard {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    
    uint256 public cost = 0.05 ether;
    uint256 internal maxSupply = 10;

    bool internal oneTime;

    string public uriPrefix = "";
    string public uriSuffix = ".json";

    address payable private paySplitter;

    constructor(address payable payment) ERC721("Beautiful Woman Collection", "BWC") {
        uriPrefix="ipfs://QmQ4LEyCP3C62Z5b8wVzrcrkjdKeaTe9FtmNFsw2s7H2X1/";
        paySplitter=payment;
        maxSupply=0;
    }

    //GETTERS//
    function totalSupply() public view returns (uint256) {
        return _tokenIdCounter.current();
    }   

    function _baseURI() internal view virtual override returns (string memory) {
        return uriPrefix;
    }    

    function mint(uint256 _mintAmount) public onlyOwner {
       require(!oneTime,"ERC721-MINT:Out of stock!");
        _mintLoop(msg.sender, _mintAmount);
        oneTime=true;
    }
    /*function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }*/

    // The following functions are overrides required by Solidity.

    function tokenURI(uint256 _tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory){
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix)) : "";
    }    



    //INTERNALS//
    function _mintLoop(address _receiver, uint256 _mintAmount) internal {
        for (uint256 i = 0; i < _mintAmount; i++) {
            _tokenIdCounter.increment();
            _safeMint(_receiver, _tokenIdCounter.current());
            //_setTokenURI(tokenId, uri);
        }
    }    

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }    

// EIP2981 standard Interface return. Adds to ERC1155 and ERC165 Interface returns.
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721,ERC2981) returns (bool){
        return (
            interfaceId == type(ERC2981).interfaceId ||
            super.supportsInterface(interfaceId)
        );
    }

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
      
}