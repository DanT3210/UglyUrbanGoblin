// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./UglyUrbanGoblin.sol";

contract Ugly_V2 is UglyUrbanGoblin {
  

  /*uint256  public MAX_PER_ACCT; 
  uint256  public ART_SUPPLY;*/
  uint256 private artPrice;
  string private name;
  string private symbol;
  address payable private paySplitter;

  // ID+QTY=>Total Supply per ID
  mapping(uint => uint)private artSypply;
  // ID+URI=> Token URI per ID
  mapping(uint => string) private tokenURI;



  function uri(uint _id) public view override returns (string memory) {
    return tokenURI[_id];
  }


  function nft_name() public view returns(string memory){
    return name;
  }

  function nft_symbol()public view returns(string memory){
    return symbol;
  }
  
}