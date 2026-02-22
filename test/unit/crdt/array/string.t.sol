// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../../contracts/crdt/array/String.sol";

contract StringTest {
    String container = new String();

    function assertGet(uint256 idx, string memory expected) internal {
        (string memory value, bool ok) = container.get(idx);
        require(ok && keccak256(bytes(value)) == keccak256(bytes(expected)));
    }
    
    function testInitialState() public {     
        require(container.nonNilCount() == 0); 
   
        string memory str0 = "Test string 0";
        string memory str1 = "Test string 1";
        string memory str2 = "Test string 2";
        string memory str3 = "Test string 3";

        container.push(str0);
        container.push(str1);
        container.push(str2);
        container.push(str3);
        require(container.nonNilCount() == 4); 

        assertGet(0, str0);
        assertGet(1, str1);
        assertGet(2, str2);
        assertGet(3, str3);

        container.set(0, str3);
        container.set(1, str2);
        container.set(2, str1);
        container.set(3, str0);

        assertGet(3, str0);
        assertGet(2, str1);
        assertGet(1, str2);
        assertGet(0, str3);

        require(keccak256(bytes(container.pop())) == keccak256(bytes(str0)));
        require(keccak256(bytes(container.pop())) == keccak256(bytes(str1)));
        require(keccak256(bytes(container.pop())) == keccak256(bytes(str2)));
        require(keccak256(bytes(container.pop())) == keccak256(bytes(str3)));

        require(container.nonNilCount() == 0);       
    }
}
