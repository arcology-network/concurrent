// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../../contracts/crdt/array/Bytes.sol";
import "../../../../contracts/crdt/array/Bool.sol";

contract PairTest {
    Bytes bytesContainer = new Bytes();
    Bool boolContainer = new Bool();

    function assertGetBytes(uint256 idx, bytes memory expected) internal {
        (bytes memory value, bool ok) = bytesContainer.get(idx);
        require(ok && keccak256(value) == keccak256(expected));
    }

    function assertGetBool(uint256 idx, bool expected) internal {
        (bool value, bool ok) = boolContainer.get(idx);
        require(ok && value == expected);
    }

    function testInitialState() public {     
        require(bytesContainer.nonNilCount() == 0); 
 
        bytes memory arr1 = '0x1000000000000000000000000000000000000000000000000000000000000001';
        bytes memory arr2 = '0x2000000000000000000000000000000000000000000000000000000000000002';

        bytesContainer.push(arr1);  
        bytesContainer.push(arr1); 

        require(bytesContainer.nonNilCount() == 2); 

        assertGetBytes(1, arr1);

        bytesContainer.set(1, arr2);       

        assertGetBytes(0, arr1);
        assertGetBytes(1, arr2);
        require(keccak256(bytesContainer.pop()) == keccak256(arr2));

        bytesContainer.pop();
        require(bytesContainer.nonNilCount() == 0); 

        require(boolContainer.nonNilCount() == 0); 
    
        boolContainer.push(true);
        boolContainer.push(false);
        boolContainer.push(false);
        boolContainer.push(true);
        require(boolContainer.nonNilCount() == 4); 

        assertGetBool(0, true);
        assertGetBool(1, false);
        assertGetBool(2, false);
        assertGetBool(3, true);

        boolContainer.set(0, false);
        boolContainer.set(1, true);
        boolContainer.set(2, true);
        boolContainer.set(3, false);

        assertGetBool(0, false);
        assertGetBool(1, true);
        assertGetBool(2, true);
        assertGetBool(3, false);

        require(!boolContainer.pop());
        require(boolContainer.pop());
        require(boolContainer.pop());
        require(!boolContainer.pop());
        require(boolContainer.nonNilCount() == 0);         
    }
}
