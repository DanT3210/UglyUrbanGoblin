// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";


contract sneakers is ERC721, ERC721URIStorage,ERC2981, Ownable, ReentrancyGuard {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    string public uriPrefix = "";
    string public uriSuffix = ".json";
    address payable private paySplitter;

    //Sneaker Price List
    mapping(uint id => uint price) private sneakersPrice;

    //Seller amount list
    mapping(address seller=>uint amount) private sellerBalance;

    receive() external payable {}

    constructor(address payable payment_) ERC721("Sneaker Market", "SNKRS") {
        paySplitter=payment_;
        //_setDefaultRoyalty(_msgSender(),100);
    }

    //GETTERS//
    function getPrice(uint id_)public view returns(uint){
        return sneakersPrice[id_];
    }     

    function totalSneakers() public view returns (uint256) {
        return _tokenIdCounter.current();
    }   

    function getSellerAmount()public view returns(uint256){
        return sellerBalance[_msgSender()];
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

    //Publish, Buy & Withdraw
    function Publish(uint256 qty_, string  memory uri_, uint256[] memory price_) public{
        address owner=_msgSender();
            _mintLoop(owner, qty_, uri_, price_);
            //_setDefaultRoyalty(owner,100);
    }
  
    function Buy(address from_, uint256 tokenId_) public payable nonReentrant{
        require(msg.value>=getPrice(tokenId_), "ERROR:Need more fund");
        address to=_msgSender();
            _approve(to, tokenId_);
            safeTransferFrom(from_,to, tokenId_, "");
            transferFunds(msg.value, from_);
    }    

    function Withdraw()public payable nonReentrant{
        address seller=_msgSender();
        require(sellerBalance[seller]>0, "ERROR: No funds to Withdraw");
        uint amount = sellerBalance[seller];
            require(address(this).balance >= amount, "Address: insufficient balance");
                (bool success, ) = seller.call{value: amount}("");
                require(success, "Address: unable to send value, recipient may have reverted");  
        sellerBalance[seller] -= amount;   
            
    }

    //INTERNALS//
    function _mintLoop(address receiver_, uint256 mintAmount_, string  memory uri_, uint256[] memory price_) internal {
        require(price_.length==mintAmount_, "ERROR: Price lenght doesn't match Qty");
        for (uint256 i = 0; i<mintAmount_; i++) {
            _tokenIdCounter.increment();
            uint256 counter=_tokenIdCounter.current();
                _safeMint(receiver_, counter);
                uriPrefix=uri_;
                tokenURI(counter);
                sneakersPrice[counter]=price_[i];
        }
    }    

    function _burn(uint256 tokenId_) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId_);
    }  

    function transferFunds(uint256 balance_, address from_) internal{ 
     uint256 devFee=devFeeCalculation(balance_);
     require(payable(paySplitter).send(devFee));
     sellerBalance[from_]+=balance_-devFee;
    }          

    function remove(uint tokenId_)external onlyOwner{
        _burn(tokenId_);
     }  

    //OWNER/DEVELOPER FEE PER COMPLETED TX//
    function devFeeCalculation(uint256 itemPrice_)private pure returns(uint256){
        return (itemPrice_*5/100);
    }        
}