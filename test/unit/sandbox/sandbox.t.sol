// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../contracts/multiprocess/Multiprocess.sol";
import "../../../contracts/crdt/array/Bool.sol";
import "../../../contracts/crdt/array/U256.sol";
import "../../../contracts/crdt/scalar/U256Cum.sol";
import "../../../contracts/crdt/map/StringUint256.sol";
import "../../../contracts/crdt/map/AddressU256Cum.sol";

// contract ParaAddressUint256ConflictTest {  
//     AddressU256CumMap container = new AddressU256CumMap();

//     address addr1 = 0x1111111110123456789012345678901234567890;
//     address addr2 = 0x2222222220123456789012345678901234567890;
//     address addr3 = 0x3333337890123456789012345678901234567890;
//     address addr4 = 0x4444444440123456789012345678901234567890;
//     address addr5 = 0x5555555550123456789012345678901234567890;

//     address[] public addrs;

//     function assertGet(address key, uint256 expected) internal {
//         (uint256 value, bool ok) = container.get(key);
//         require(ok && value == expected);
//     }

//     function setUp() public {
//         addrs.push(addr1);
//         addrs.push(addr2);
//         addrs.push(addr3);
//         addrs.push(addr4);
//         addrs.push(addr5);
//     }

//     function testCall() public  { 
//         setUp();

//         container.set(addr1, 18, 17, 111);
//         container.set(addr2, 19, 18, 112);                
//         container.set(addr3, 20, 19, 113);

//         assertGet(addr1, 18);
//         assertGet(addr2, 19);
//         assertGet(addr3, 20);
//         require(container.nonNilCount() == 3);
//         // testPusher(2);

//         Multiprocess mp = new Multiprocess(4); 
//         mp.addJob(500000, 0, address(this), abi.encodeWithSignature("setter(uint256)", 1)); // Addr 2: 19
//         // mp.addJob(500000, 0, address(this), abi.encodeWithSignature("setter(uint256)", 2));// Addr 3 : 20
//         mp.addJob(500000, 0, address(this), abi.encodeWithSignature("pusher(uint256)", 3));// Addr 4
//         // mp.addJob(500000, 0, address(this), abi.encodeWithSignature("pusher(uint256)", 4));// Addr 5
//         mp.run();


//         assertGet(addr1, 18); // Sequentially added
//         assertGet(addr2, 20); // Concurrently added, delta 1
//         // assertGet(addr3, 33); 

//         // Runtime.print(container.get(addr2));
//         // Runtime.print(container.get(addr4));
//         // Runtime.print(container.get(addr5));
//         assertGet(addr4, 33);
//         assertGet(addr5, 34);

//         // Runtime.print(container.get(addr2));
//         // Runtime.print(container.get(addr3));

//         // One push will failed.
//         // require(container.nonNilCount() == 4);
//     }

//     function setter(uint256 num) public {
//         container.set(addrs[num], 1); // Set delta to 1
//     }

//     function pusher(uint256 num) public {
//         container.set(addrs[num], int256(30 + num), 17, 111);
//     }
// }



contract ParaAddressUint256PushSetConflictTest {  
    AddressU256CumMap container = new AddressU256CumMap();
    address addr1 = 0x1111111110123456789012345678901234567890;
    address addr2 = 0x2222222220123456789012345678901234567890;

    function assertGet(address key, uint256 expected) internal {
        (uint256 value, bool ok) = container.get(key);
        require(ok && value == expected);
    }

    function testCall() public  { 
        container.set(addr1, 18, 17, 111);
        assertGet(addr1, 18);

        Multiprocess mp = new Multiprocess(4); 
        mp.addJob(500000, 0, address(this), abi.encodeWithSignature("setter()")); // Addr 2: 19
        mp.addJob(500000, 0, address(this), abi.encodeWithSignature("pusher()"));// Addr 4
        mp.run();

        assertGet(addr1, 18); // Sequentially added
        assertGet(addr2, 33); // Concurrently added, delta 1
    }

    function setter() public {
        container.set(addr1, 1); // Set delta to 1
    }

    function pusher() public {
        container.set(addr2, 33, 17, 111);
    }
}

