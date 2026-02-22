// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../contracts/multiprocess/Multiprocess.sol";
import "../../../contracts/crdt/array/Bool.sol";
import "../../../contracts/crdt/array/U256.sol";
import "../../../contracts/crdt/scalar/U256Cum.sol";
import "../../../contracts/crdt/map/StringUint256.sol";
import "../../../contracts/crdt/map/AddressU256Cum.sol";

contract MaxRecursiveDepth4Test {
    Bool container = new Bool();

    function testCall() public {
        // container.push(true);       
        Multiprocess mp = new Multiprocess(1);
        mp.addJob(99999999, 0, address(this), abi.encodeWithSignature("add(uint256)", 0)); // Only one will go through
        mp.addJob(99999999, 0, address(this), abi.encodeWithSignature("add(uint256)", 1)); // Only one will go through
        mp.run();

        // require(container.nonNilCount() == 6); 
        require(container.nonNilCount() == 14);       
    } 

    function add(uint256 v) public { 
        bytes32 salt = keccak256(abi.encode(v)); 
        Multiprocess mp2 = new Multiprocess{salt: salt}(1); 
        mp2.addJob(41111111, 0, address(this), abi.encodeWithSignature("add2(uint256)", 10 +v));
        mp2.addJob(41111111, 0, address(this), abi.encodeWithSignature("add2(uint256)", 21 +v));
        mp2.run();
        container.push(true);              
    } 

    function add2(uint256 v) public { 
        bytes32 salt = keccak256(abi.encode(v)); 
        Multiprocess mp2 = new Multiprocess{salt: salt}(1); 
        mp2.addJob(21111111, 0, address(this), abi.encodeWithSignature("add3(uint256)", v));
        mp2.addJob(21111111, 0, address(this), abi.encodeWithSignature("add3(uint256)", v));
        mp2.run();
        container.push(true);              
    } 

    function add3(uint256 v) public { 
        container.push(true);              
    } 
}

contract MaxSelfRecursiveDepth4Test {
    Bool container = new Bool();

    Multiprocess mp;
    function testCall() public {
        // container.push(true);       
        mp = new Multiprocess(1);
        mp.addJob(99999999, 0, address(this), abi.encodeWithSignature("add(uint256)", 1)); // Only one will go through
        mp.addJob(99999999, 0, address(this), abi.encodeWithSignature("add(uint256)", 2)); // Only one will go through
        mp.run();
        require(container.nonNilCount() == 30); // 2 + 4 + 8 + 16
    } 

    function add(uint256 v) public { 
        Multiprocess mp2 = new Multiprocess{salt: bytes32(v)}(1); 
        mp2.addJob(21111111, 0, address(this), abi.encodeWithSignature("add(uint256)", v + 13));
        mp2.addJob(21111111, 0, address(this), abi.encodeWithSignature("add(uint256)", v * 10));
        mp2.run();
        container.push(true);              
    }     
}

contract MaxRecursiveDepthOffLimitTest {
    Bool container = new Bool();
    U256Cumulative cumulative = new U256Cumulative(0, 200);  

    Multiprocess mp;
    function testCall() public {
        cumulative.add(2);
        // require(cumulative.get() == 10);

        container.push(true);       
        mp = new Multiprocess(1);
        mp.addJob(9999999, 0, address(this), abi.encodeWithSignature("add(uint256)", 1));
        mp.addJob(9999999, 0, address(this), abi.encodeWithSignature("add(uint256)", 2)); 
        mp.run();
  
        require(container.nonNilCount() == 31); // 1 + (2 + 4 + 8 + 16) 
        require(cumulative.get() == 62);
    } 

    function add(uint256 v) public { 
        cumulative.add(2);
        Multiprocess mp2 = new Multiprocess{salt: bytes32(v)}(1); 
        mp2.addJob(41111111, 0, address(this), abi.encodeWithSignature("add(uint256)", v + 3));
        mp2.addJob(41111111, 0, address(this), abi.encodeWithSignature("add(uint256)", v * 20));
        mp2.run();
        container.push(true);              
    }    
}

contract MixedRecursiveMultiprocessTest {
    Bool container = new Bool();
    uint256[2] results;
    U256Cumulative cumulative = new U256Cumulative(0, 100);  
    U256Cumulative cumulative2 = new U256Cumulative(50, 80);  

    Multiprocess mp;
    function testCall() public {
		mp = new Multiprocess(1);
        cumulative.add(50);
        container.push(true);
        mp.addJob(9999999, 0, address(this), abi.encodeWithSignature("odd(uint256)", 1)); // Only one will go through
        mp.addJob(9999999, 0, address(this), abi.encodeWithSignature("odd(uint256)", 2)); // Only one will go through
        mp.run();
        require(container.nonNilCount() == 3);

        require(results[0] == 11);
        require(results[1] == 12);
        require(container.nonNilCount() == 3);
        require(cumulative.get() == 55);
        require(cumulative2.get() == 70); 
    } 

    function odd(uint256 v) public { 
        cumulative.add(10);
        Multiprocess mp2 = new Multiprocess{salt: bytes32(v)}(1); 
        mp2.addJob(11111111, 0, address(this), abi.encodeWithSignature("even()"));
        mp2.run();
        container.push(true);              
    }  

    function even() public {
        cumulative.sub(5);
        cumulative2.add(70);
        results[0] = 11;
        results[1] = 12;
        container.push(true);
    }  
}
