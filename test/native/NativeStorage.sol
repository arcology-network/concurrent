// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

contract NativeStorage {   
        uint256 x = 1 ;
        uint256 y = 100 ;
     //    uint256[3] public shortArr;
     //    uint256[32] public mediumArr;
     //    uint256[33] public longArr;

   function setUp() public { 
        testIncrementX();
        testIncrementY();
        require(x == 2);
        require(y == 102);   

     //    shortArr[2] = 1;
     //    mediumArr[31] = 1;
     //    longArr[32] = 1;
   }
   function testCall() public{
        testIncrementX();
        testIncrementY();
        require(x == 3);
        require(y == 104);

     //    require(shortArr[2] == 1);
     //    require(mediumArr[31] == 1);
     //    require(longArr[32] == 1);        
   }

    function testIncrementX() public {
        x ++;
    }

    function testIncrementY() public {
       y += 2;
    }

    function testCheckX(uint256 value) view public {
        require(x == value);
    }

    function testCheckY(uint256 value) view public {
         require(y == value);
    }

    function testCheck() public {
     require(x == 3);
     require(y == 104);

     // require(shortArr[2] == 1);
     // require(mediumArr[31] == 1);
     // require(longArr[32] == 1);   
   }

   function testCall2() public{
     testIncrementX();
     testIncrementY();
   }

   function testCheck2() public {
     require(x == 3);
     require(y == 104);
     // require(y == 104);
   }

   function testCheck3() public {
     require(x == 4);
     require(y == 106);
     // require(y == 104);
   }
}

contract TestFailed {   
     uint256 x = 1;
     uint256 y = 100;

     function setUp() public {}

     function testCall() public {
          require(x == 1);
     }
}


