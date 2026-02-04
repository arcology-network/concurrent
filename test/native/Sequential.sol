// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

contract SequentialTest {   
   uint256 x = 1 ;
   function testAdd() public {
     x += 1;
   }

   function testCheck() public view {
     require(x == 2);
   }

  //  function testCheck2() public {
  //   require();
  // }
}
