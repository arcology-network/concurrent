// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../contracts/runtime/Gateway.sol";
import "../../../contracts/runtime/Runtime.sol";
import "../../../contracts/runtime/Debug.sol";
import "../../../contracts/crdt/array/Bytes.sol";

contract ConcurrentGatewayTest {
    Gateway container = new Gateway(Const.BYTES, Const.CONTAINER_ADDR, false);    

    constructor() {       
        bytes memory elem1 = '0x1111111';
        bytes memory elem2 = '0x2222222';

        (bool success, bytes memory data) = container.eval(abi.encodeWithSignature("setByKey(bytes,bytes)", Runtime.uuid(), elem1)); 
        require(success, "Failed to set element");
        container.eval(abi.encodeWithSignature("setByKey(bytes,bytes)", Runtime.uuid(), elem2)); 

        (success, data) = container.eval(abi.encodeWithSignature("getByIndex(uint256)", 0)); 
        require(success, "Failed to get element");
        require(keccak256(data) == keccak256(elem1)); 

        (success, data) = container.eval(abi.encodeWithSignature("getByIndex(uint256)", 1)); 
        require(success, "Failed to get element");
        require(keccak256(data) == keccak256(elem2)); 
    }
}

contract ContainerClearTest {
    Bytes container = new Bytes();    

    constructor() {    
        bytes memory arr1 = '0x1000000000000000000000000000000000000000000000000000000000000001';
        container.push(arr1);      
        container.clear();
        require(container.nonNilCount() == 0); 
    }
}
