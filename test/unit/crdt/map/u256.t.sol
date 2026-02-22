// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../../contracts/crdt/map/U256.sol";
import "../../../../contracts/crdt/scalar/U256Cum.sol";
import "../../../../contracts/multiprocess/Multiprocess.sol";

contract U256MapTest {
    U256Map map = new U256Map();

    function assertGet(uint256 key, uint256 expected) internal {
        (uint256 value, bool ok) = map.get(key);
        require(ok && value == expected);
    }

    function assertValueAt(uint256 idx, uint256 expected) internal {
        (uint256 value, bool ok) = map.valueAt(idx);
        require(ok && value == expected);
    }

    function testInitialState() public {     
        require(map.nonNilCount() == 0); 
        map.set(10, 100);
        map.set(11, 111);
        require(map.nonNilCount() == 2); 

        assertValueAt(0, 100);
        assertValueAt(1, 111);

        require(map.keyAt(0) == 10); 
        require(map.keyAt(1) == 11); 

        require(!map.exist(0));
        require(map.exist(10)); 
        require(map.exist(11)); 

        assertGet(11, 111);       
        assertGet(10, 100); 

        map.del(10);
        require(map.nonNilCount() == 1); 

        require(map.exist(11));
        map.del(11);
        require(map.nonNilCount() == 0); 

        require(!map.exist(10));
        require(!map.exist(11));
    }
}
