// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./UglyUrbanGoblin.sol";

contract Ugly_V2 is UglyUrbanGoblin {
   function uglyVersion() external pure returns (uint256) {
       return 2;
   }    
  
}