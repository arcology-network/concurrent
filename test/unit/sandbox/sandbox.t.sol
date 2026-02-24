// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../contracts/multiprocess/Multiprocess.sol";
import "../../../contracts/crdt/array/Bool.sol";
import "../../../contracts/crdt/array/U256.sol";
import "../../../contracts/crdt/scalar/U256Cum.sol";
import "../../../contracts/crdt/map/StringUint256.sol";
import "../../../contracts/crdt/map/AddressU256Cum.sol";

contract SimpleConflictTest {
    uint256 data;
    function testCall() public {
        Multiprocess mp = new Multiprocess(2);
        mp.addJob(100000, 0, address(this), abi.encodeWithSignature("assign(uint256)", 1)); // Only one will go through
        mp.addJob(100000, 0, address(this), abi.encodeWithSignature("assign(uint256)", 2)); // Only one will go through
        mp.run();

        // Only one of the two assignments will succeed due to conflict.
    }

    function assign(uint256 v) public { 
        data = v;
    } 
}