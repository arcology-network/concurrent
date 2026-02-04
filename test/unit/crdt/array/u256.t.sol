// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../../contracts/crdt/array/U256.sol";

contract U256Test {
    U256 container = new U256();
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

        require(container.get(0) == uint256(10));
        require(container.get(1) == uint256(20));
        require(container.get(2) == uint256(30));
        require(container.get(3) == uint256(40));    

        container.set(0, uint256(11));
        container.set(1, uint256(12));
        container.set(2, uint256(13));
        container.set(3, uint256(14));

        require(container.get(0) == uint256(11));
        require(container.get(1) == uint256(12));
        require(container.get(2) == uint256(13));
        require(container.get(3) == uint256(14));

        require(container.pop() == uint256(14));
        require(container.pop() == uint256(13));
        require(container.pop() == uint256(12));
        require(container.pop() == uint256(11));
        require(container.nonNilCount() == 0); 
    }
}
