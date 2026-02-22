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
        mp.addJob(100000, 0, address(this), abi.encodeWithSignature("testAssign(uint256)", 1)); // Only one will go through
        mp.addJob(100000, 0, address(this), abi.encodeWithSignature("testAssign(uint256)", 2)); // Only one will go through
        mp.run();
        require(data == 1);
    }

    function testAssign(uint256 v) public { 
        data = v;
    } 
}

contract ParaFixedLengthWithConflictRollbackTest {
    Bool container = new Bool();
    uint256[2] results;
    function testCall() public {
        Multiprocess mp = new Multiprocess(2);
        mp.addJob(9999999, 0, address(this), abi.encodeWithSignature("worker(uint256)", 1)); // Only one will go through
        mp.addJob(9999999, 0, address(this), abi.encodeWithSignature("worker(uint256)", 2)); // Only one will go through
        mp.run();
        require(container.nonNilCount() == 1);

        appender();
        require(container.nonNilCount() == 2);
    } 

    function worker(uint256 v) public { 
        Multiprocess mp2 = new Multiprocess{salt: bytes32(v)}(2); 
        mp2.addJob(1999999, 0, address(this), abi.encodeWithSignature("appender()"));
        mp2.run();   
       
        // This line will cause a conflict if both workers get 
        // executed, so only one will succeed.
        results[0] = 1; 
        results[1] = 1;
    }   

    function appender() public { 
        container.push(true);
    }  
}

contract ParentChildBranchConflictTest {
    Bool container = new Bool();
    uint256[2] results0;
    uint256[2] results1;
    function testCall() public {
        Multiprocess mp = new Multiprocess(2);
        mp.addJob(9999999, 0, address(this), abi.encodeWithSignature("testWorker0()")); // Only one will go through
        mp.addJob(9999999, 0, address(this), abi.encodeWithSignature("testWorker1()")); // Only one will go through
        mp.run();
        require(container.nonNilCount() == 1);
        require(results0[0] == 2);
    } 

    function testWorker0() public { 
        results0[0] = 2;
        Multiprocess mp2 = new Multiprocess(2); 
        mp2.run();   
        
        container.push(true);
    }   

    function testWorker1() public { 
        Multiprocess mp2 = new Multiprocess(2); 
        mp2.addJob(1999999, 0, address(this), abi.encodeWithSignature("testAppender10()"));
        mp2.run();   
        
        container.push(true);
    }   

    function testAppender10() public { 
        container.push(true);
        results0[0] = 1;
    }  
}


contract ParaSubbranchConflictTest {
    Bool container = new Bool();
    uint256[2] results0;
    uint256[2] results1;
    function testCall() public {
        Multiprocess mp = new Multiprocess(2);
        mp.addJob(9999999, 0, address(this), abi.encodeWithSignature("worker0(uint256)", 1)); // Only one will go through
        mp.addJob(9999999, 0, address(this), abi.encodeWithSignature("worker1(uint256)", 2)); // Only one will go through
        mp.run();
        require(container.nonNilCount() == 4);
    } 

    function worker0(uint256 v) public { 
        Multiprocess mp2 = new Multiprocess{salt: bytes32(v)}(2); 
        mp2.addJob(1999999, 0, address(this), abi.encodeWithSignature("appender00()"));
        mp2.addJob(1999999, 0, address(this), abi.encodeWithSignature("appender01()"));
        mp2.run();   
        
        container.push(true);
    }   

    function appender00() public { 
        container.push(true);
        results0[0] = 1;
    }  

    function appender01() public { 
        container.push(true);
        results0[0] = 1;
    }  

    // The second worker will conflict with the first worker because they both write to results0[0], 
    //so only one of them will succeed.
    function worker1(uint256 v) public { 
        Multiprocess mp2 = new Multiprocess{salt: bytes32(v)}(2); 
        mp2.addJob(1999999, 0, address(this), abi.encodeWithSignature("appender10()"));
        mp2.addJob(1999999, 0, address(this), abi.encodeWithSignature("appender11()"));
        mp2.run();   
        
        container.push(true);
    }   

    function appender10() public { 
        container.push(true);
        results1[0] = 1;
    }  

    function appender11() public { 
        container.push(true);
        uint256 a = results1[0];
    }  
}

