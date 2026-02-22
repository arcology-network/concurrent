// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../../contracts/crdt/map/AddressU256Cum.sol";
// import "../multiprocess/Multiprocess.sol";

contract AddressU256CumMapTest {
    AddressU256CumMap map = new AddressU256CumMap();

    function assertGet(address key, uint256 expected) internal {
        (uint256 value, bool ok) = map.get(key);
        require(ok && value == expected);
    }

    function assertValueAt(uint256 idx, uint256 expected) internal {
        (uint256 value, bool ok) = map.valueAt(idx);
        require(ok && value == expected);
    }

    function assertValueAtMissing(uint256 idx) internal {
        (, bool ok) = map.valueAt(idx);
        require(!ok);
    }

    function testInitialState() public {     
        address addr1 = 0x1111111110123456789012345678901234567890;
        address addr2 = 0x2222222220123456789012345678901234567890;
        address addr3 = 0x3333337890123456789012345678901234567890;
        address addr4 = 0x4444444890123456789012345678901234567890;

        require(map.nonNilCount() == 0); 

        map.set(addr1, 0, 0, 1000);  
        map.set(addr2, 0, 0, 1000);
        map.set(addr3, 0, 0, 1000);
        require(map.nonNilCount() == 3); 

        (address k, uint256 idx, uint256 v) = map.min();
        assertGet(k, v);
        require(idx == 0 && v == 0);

        map.set(addr2, 31, 0, 1000);
        (k, idx, v) = map.max();
        require(v == 31); 

        map.set(addr3, 32);
        (k, idx, v) = map.max();
        require(v == 32 && idx == 2); 
        
        require(map.exist(addr1)); 
        require(map.exist(addr2)); 
        require(map.exist(addr3)); 
        require(!map.exist(addr4)); 

        assertGet(addr1, 0); 
        assertGet(addr2, 31); 
        assertGet(addr3, 32); 
        require(!map.exist(addr4)); 

        require(map.keyAt(0) == addr1);
        require(map.keyAt(1) == addr2);
        require(map.keyAt(2) == addr3);

        map.del(addr1);
        map.del(addr2);
        map.del(addr3);
        require(map.nonNilCount() == 0); 

        map.set(addr1, 110);  
        map.set(addr2, 210);
        map.set(addr3, 310);
        require(map.nonNilCount() == 3); 

        // assertValueAt(0, 110);
        // assertValueAt(1, 210);
        // assertValueAt(2, 310);

        // map.resetByInd(0);
        // map.resetByInd(1);
        // map.resetByInd(2);

        // assertValueAtMissing(0);
        // assertValueAtMissing(1);
        // assertValueAtMissing(2);
        // require(map.nonNilCount() == 3); 


        // map.set(addr1, 410);  
        // map.set(addr2, 510);
        // map.set(addr3, 610);
        // assertValueAt(0, 410);
        // assertValueAt(1, 510);
        // assertValueAt(2, 610);

        // map.resetByKey(addr1);
        // map.resetByKey(addr2);
        // map.resetByKey(addr3);

        // assertValueAtMissing(0);
        // assertValueAtMissing(1);
        // assertValueAtMissing(2);

        // assertGet(addr1, 0);
        // assertGet(addr2, 0);
        // assertGet(addr3, 0);
    }
}
