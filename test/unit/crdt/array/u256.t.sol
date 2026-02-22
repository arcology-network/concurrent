// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../../contracts/crdt/array/U256.sol";

contract U256Test {
    U256 container = new U256();

    function assertGet(uint256 idx, uint256 expected) internal {
        (uint256 value, bool ok) = container.get(idx);
        require(ok && value == expected);
    }
    U256[] array;

    function testInitialState() public {     
        require(container.nonNilCount() == 0); 
    
        container.push(uint256(10));
        container.push(uint256(20));
        container.push(uint256(30));
        container.push(uint256(40));
        require(container.nonNilCount() == 4); 

        (uint256 i, uint256 v) = container.min();
        require(i == 0 && v == 10); 

        (i, v) = container.max();
        require(i == 3 && v == 40); 

        assertGet(0, uint256(10));
        assertGet(1, uint256(20));
        assertGet(2, uint256(30));
        assertGet(3, uint256(40));    

        container.set(0, uint256(11));
        container.set(1, uint256(12));
        container.set(2, uint256(13));
        container.set(3, uint256(14));

        assertGet(0, uint256(11));
        assertGet(1, uint256(12));
        assertGet(2, uint256(13));
        assertGet(3, uint256(14));

        require(container.pop() == uint256(14));
        require(container.pop() == uint256(13));
        require(container.pop() == uint256(12));
        require(container.pop() == uint256(11));
        require(container.nonNilCount() == 0); 
    }
}
