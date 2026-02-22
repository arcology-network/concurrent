// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../contracts/runtime/Runtime.sol";
import "../../../contracts/multiprocess/Multiprocess.sol";
import "../../../contracts/crdt/scalar/U256Cum.sol";

contract DeferredTest  {
    U256Cumulative value = new U256Cumulative(1, 100);

    constructor () payable {
        Runtime.defer("testInit()", 500222);  
    }

    function testInit() public view{
        require(!Runtime.isInDeferred());
    }
}

contract SequentializerTest  {
    address addr1 = 0x1111111110123456789012345678901234567890;
    address addr2 = 0x2222222220123456789012345678901234567890;
    address addr3 = 0x3333337890123456789012345678901234567890;
    address addr4 = 0x4444444890123456789012345678901234567890;
    bool private parallelismOk;
    bool private deferOk;

    constructor () {
        bytes4[] memory otherFuncs = new bytes4[](3);
        otherFuncs[0] = 0x01010101;
        otherFuncs[1] = 0x02020202;   
        otherFuncs[2] = 0x03030303;       

        // The testInit() function of the current contract cannot be called in parallel with 
        // the otherFuncs functions of the addr1 contract.
        parallelismOk = Runtime.setSequentialOnly("testInit()", addr1, otherFuncs);
        deferOk = Runtime.defer("testInit()", 600000);
    }

    function testSetup() public view{
        require(parallelismOk);
        require(deferOk);
    }

    function testInit() public {}

    function testSeq() public {}

    function testDef() public {}
}

contract ParallizerTest  {
    address addr1 = 0x1111111110123456789012345678901234567890;
    address addr2 = 0x2222222220123456789012345678901234567890;
    address addr3 = 0x3333337890123456789012345678901234567890;
    address addr4 = 0x4444444890123456789012345678901234567890;
    bool private parallelismOk;
    bool private deferOk;

    constructor () {
        bytes4[] memory otherFuncs = new bytes4[](3);
        otherFuncs[0] = 0x01010101;
        otherFuncs[1] = 0x02020202;   
        otherFuncs[2] = 0x03030303;       

        // The testInit() function of the current contract cannot be called in parallel with the others.
        parallelismOk = Runtime.setSequentialOnly("testInit()", addr1, otherFuncs);
        deferOk = Runtime.defer("testDef()", 111);
    }

    function testSetup() public view{
        require(parallelismOk);
        require(deferOk);
    }

    function testInit() public {}

    function testSeq() public {}

    function testDef() public {}
}
