// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../../contracts/crdt/map/AddressBoolean.sol";
import "../../../../contracts/multiprocess/Multiprocess.sol";

contract AddressBooleanMapConcurrentTest {
    AddressBooleanMap map = new AddressBooleanMap();

    function assertGet(address key, bool expected) internal {
        (bool value, bool ok) = map.get(key);
        require(ok && value == expected);
    }

    function assertValueAt(uint256 idx, bool expected) internal {
        (bool value, bool ok) = map.valueAt(idx);
        require(ok && value == expected);
    }

    function testCall() public {     
        address addr1 = 0x1111111110123456789012345678901234567890;
        address addr2 = 0x2222222220123456789012345678901234567890;
        address addr3 = 0x3333337890123456789012345678901234567890;
        address addr4 = 0x4444444890123456789012345678901234567890;

        setter(addr1);
        setter(addr2);
        setter(addr3);

        require(map.exist(addr1)); 
        require(map.exist(addr2)); 
        require(map.exist(addr3)); 
        require(!map.exist(addr4)); 

        assertGet(addr1, true); 
        assertGet(addr2, true); 
        assertGet(addr3, true); 

        assertValueAt(0, true);
        assertValueAt(1, true);
        assertValueAt(2, true);

        require(map.keyAt(0) == addr1); 
        require(map.keyAt(1) == addr2); 
        require(map.keyAt(2) == addr3); 

        map.del(addr1);
        map.del(addr2);
        map.del(addr3);
        require(map.nonNilCount() == 0); 
    }

    function setter(address v) public {
        map.set(v, true);
    }
}
