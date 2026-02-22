// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../../contracts/crdt/array/Bool.sol";

contract BoolTest {
    Bool boolContainer = new Bool();

    function assertGet(uint256 idx, bool expected) internal {
        (bool value, bool ok) = boolContainer.get(idx);
        require(ok && value == expected);
    }
    
    function setUp() public {     
        require(boolContainer.nonNilCount() == 0); 
    
        boolContainer.push(true);
        boolContainer.push(false);
        boolContainer.push(false);
        boolContainer.push(true);
        require(boolContainer.nonNilCount() == 4); 

        assertGet(0, true);
        assertGet(1, false);
        assertGet(2, false);
        assertGet(3, true);

        boolContainer.set(0, false);
        boolContainer.set(1, true);
        boolContainer.set(2, true);
        boolContainer.set(3, false);

        assertGet(0, false);
        assertGet(1, true);
        assertGet(2, true);
        assertGet(3, false);

        require(!boolContainer.pop());
        require(boolContainer.pop());
        require(boolContainer.pop());
        require(!boolContainer.pop());
        require(boolContainer.nonNilCount() == 0);  
        boolContainer.push(true);
        boolContainer.push(true);

        require(boolContainer.fullLength() == 6);  

        require(!boolContainer.exists(0));
        require(!boolContainer.exists(1));
        require(!boolContainer.exists(2));
        require(!boolContainer.exists(3));
        require(boolContainer.exists(4));
        require(boolContainer.exists(5));       
    }
}
