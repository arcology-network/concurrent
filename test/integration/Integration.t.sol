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

    constructor() {
        number = 11;
        Runtime.defer("deferrablePush(uint256)", 100000);  
    }

    function testMultiprocess() external {
        mp.addJob(4000000, 0, address(this), abi.encodeWithSignature("push(uint256)", 0)); // Will require about 1.5M gas
        mp.addJob(4000000, 0, address(this), abi.encodeWithSignature("push(uint256)", 1));
        mp.run();

        require(u256Array.fullLength() == 2);     
        require(u256Array.get(1) == 0);    
        require(u256Array.get(0) == 1);    
    }

    function testMultiprocessClear() external {
        mp.addJob(4000000, 0, address(this), abi.encodeWithSignature("clearMp()")); // Will require about 1.5M gas
        mp.addJob(4000000, 0, address(this), abi.encodeWithSignature("clearMp()"));
        mp.run(); 
        
    }    

    function testMultiprocessRun() external {
        mp.addJob(4000000, 0, address(this), abi.encodeWithSignature("runMp()")); // Will require about 1.5M gas
        mp.addJob(4000000, 0, address(this), abi.encodeWithSignature("runMp()"));
        mp.run(); 
    }  

    function addConst(uint256 x) external pure returns (uint256) {
        return x + 42;
    }

    function addNum(uint256 x) external returns (uint256) {
        number = number + x;
        return number;
    }

    function set(uint256 x) external {
        number = x;
    }

    function getNum() external view returns (uint256) {
        return number;
    }

    function push(uint256 v) external {
        u256Array.push(v);
    }

    function clearMp() external {
        mp.clear();
    }

    function runMp() external {
        mp.run();
    }

    function deferrablePush(uint256 v) external {
        if (!Runtime.isInDeferred()) {
            u256Array.push(v);
        }
    }

    function get(uint256 index) external returns (uint256) {
        return u256Array.get(index);
    }

    function length() external returns (uint256) {
        return u256Array.fullLength();
    }
}
