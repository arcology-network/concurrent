// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../../contracts/crdt/map/StringUint256.sol";
import "../../../../contracts/multiprocess/Multiprocess.sol";

contract StringUint256MapTest {
    StringUint256Map map = new StringUint256Map();

    function assertGet(string memory key, uint256 expected) internal {
        (uint256 value, bool ok) = map.get(key);
        require(ok && value == expected);
    }

    function assertValueAt(uint256 idx, uint256 expected) internal {
        (uint256 value, bool ok) = map.valueAt(idx);
        require(ok && value == expected);
    }

    function testBasic() public {     
        string memory k1 = "0x33333378901234567890123456789012345678900x3333337890123456789012345678901234567890";
        string memory k2 = "0x123";
        string memory k3 = "0x3333337890123456789012345678901234567890";
        string memory k4 = "0x333333";

        require(map.nonNilCount() == 0); 
        map.set(k1, 11);
        map.set(k2, 22);
        map.set(k3, 33);
        require(map.nonNilCount() == 3); 
       
        require(map.exist(k1)); 
        require(map.exist(k2)); 
        require(map.exist(k3)); 
        require(!map.exist(k4)); 

        assertGet(k1, 11); 
        assertGet(k2, 22); 
        assertGet(k3, 33); 

        assertValueAt(0, 11);
        assertValueAt(1, 22);
        assertValueAt(2, 33);

        require(keccak256(bytes(map.keyAt(0))) == keccak256(bytes(k1))); 
        require(keccak256(bytes(map.keyAt(1))) == keccak256(bytes(k2))); //  cause error
        require(keccak256(bytes(map.keyAt(2))) == keccak256(bytes(k3))); 

        map.del(k1);
        map.del(k2);
        map.del(k3);
        require(map.nonNilCount() == 0); 
    }
}
