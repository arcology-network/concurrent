// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../../contracts/crdt/array/Int256.sol";

contract Int256Test {
    Int256 container = new Int256();

    function assertGet(uint256 idx, int256 expected) internal {
        (int256 value, bool ok) = container.get(idx);
        require(ok && value == expected);
    }
    
    function testInitialState() public {     
       require(container.nonNilCount() == 0); 
    
        container.push((10));
        container.push((-20));
        container.push((30));
        container.push((40));
        require(container.nonNilCount() == 4); 
        
        assertGet(0, (10));
        assertGet(1, (-20));
        assertGet(2, (30));
        assertGet(3, (40));    

        container.set(0, (-11));
        container.set(1, (12));
        container.set(2, (13));
        container.set(3, (14));

        assertGet(0, (-11));
        assertGet(1, (12));
        assertGet(2, (13));
        assertGet(3, (14));

        require(container.pop() == (14));
        require(container.pop() == (13));
        require(container.pop() == (12));
        require(container.pop() == (-11));
        require(container.nonNilCount() == 0); 
    }
}
