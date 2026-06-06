/*
*   Copyright (c) 2025 Arcology Network

*   This program is free software: you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation, either version 3 of the License, or
*   (at your option) any later version.

*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.

*   You should have received a copy of the GNU General Public License
*   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

import "../../contracts/crdt/array/U256.sol";
import "../../contracts/multiprocess/Multiprocess.sol";

contract Integration {
    uint256 number;
    U256 u256Array = new U256();
    Multiprocess mp = new Multiprocess(2);

    event counterQuery(uint256 value);

    // Helper: assert that get(idx) returns expected and is present.
    function assertGet(uint256 idx, uint256 expected) internal {
        (uint256 value, bool ok) = u256Array.get(idx);
        require(ok && value == expected);
    }

    // Initialize baseline state and schedule a deferred push.
    constructor() {
        number = 11;
        Runtime.defer("deferrablePush(uint256)", 100000);  
    }
    
    // Sanity check: constructing a fresh U256 container succeeds.
    function containerInitialization() external {
        U256 anotherArray2 = new U256();
    }

    // Run two push jobs concurrently and verify array contents/length.
    function multiprocessPush() external {
        mp.addJob(4000000, 0, address(this), abi.encodeWithSignature("push(uint256)", 0)); // Will require about 1.5M gas
        mp.addJob(4000000, 0, address(this), abi.encodeWithSignature("push(uint256)", 1));
        mp.run();

        require(u256Array.fullLength() == 2);     
        assertGet(0, 0);    
        assertGet(1, 1);    

        emit counterQuery(u256Array.fullLength());
    }

    // Enqueue clear jobs and execute them via the multiprocess runner.
    function multiprocessClear() external {
        mp.addJob(4000000, 0, address(this), abi.encodeWithSignature("testClearMp()")); // Will require about 1.5M gas
        mp.addJob(4000000, 0, address(this), abi.encodeWithSignature("testClearMp()"));
        mp.run();         
    }    

    // Enqueue run jobs and execute them via the multiprocess runner.
    function multiprocessRun() external {
        mp.addJob(4000000, 0, address(this), abi.encodeWithSignature("runMp()")); // Will require about 1.5M gas
        mp.addJob(4000000, 0, address(this), abi.encodeWithSignature("runMp()"));
        mp.run(); 
    }  

    // Return x plus a constant.
    function addConst(uint256 x) external pure returns (uint256) {
        return x + 42;
    }

    // Add x to the stored number and return the new value.
    function addNum(uint256 x) external returns (uint256) {
        number = number + x;
        return number;
    }
    
    // Set the stored number.
    function set(uint256 x) external {
        number = x;
    }

    // Read the stored number.
    function getNum() external view returns (uint256) {
        return number;
    }

    // A Placeholder function that does nothing but consume some gas.
    function doNothing() external {}

    // Append a value to the U256 array.
    function push(uint256 v) external {
        u256Array.push(v);
    }

    // Execute queued multiprocess jobs.
    function runMp() external {
        mp.run();
    }

    // Only push when not executing in a deferred context.
    function deferrablePush(uint256 v) external {
        if (!Runtime.isInDeferred()) {
            u256Array.push(v);
        }
    }

     // Only get when not executing in a deferred context.
    function deferrableGet(uint256 v) external returns (uint256){
        if (Runtime.isInDeferred()) {
           uint256 value;
           (value, ) = u256Array.get(v);
           return value;
        }
        return 0;
    }

    // Return the value and presence flag at index.
    function get(uint256 index) external returns (uint256, bool) {
        return u256Array.get(index);
    }

    // Return the full length of the U256 array.
    function length() external returns (uint256) {
        return u256Array.fullLength();
    }
}
