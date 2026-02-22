// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../../contracts/crdt/array/Bytes.sol";

contract ByteTest {
    Bytes container = new Bytes();    

    function assertGet(uint256 idx, bytes memory expected) internal {
        (bytes memory value, bool ok) = container.get(idx);
        require(ok && keccak256(value) == keccak256(expected));
    }

    function testInitialState() public {       
        require(container.nonNilCount() == 0); 
 
        bytes memory arr1 = '0x1000000000000000000000000000000000000000000000000000000000000001';
        bytes memory arr2 = '0x0x2000000000000000000000000000000000000000000000000000000000000002';

        container.push(arr1);  
        container.push(arr2); 

        require(container.nonNilCount() == 2); 
        assertGet(0, arr1);
        assertGet(1, arr2);

        container.set(1, arr2);       
        assertGet(0, arr1);
        assertGet(1, arr2);
        require(keccak256(container.pop()) == keccak256(arr2));

        container.clear();
        require(container.nonNilCount() == 0); 
    }
}
