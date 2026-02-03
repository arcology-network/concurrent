// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "./Const.sol";

/**
 * @author Arcology Network
 * @title Debug Library
 * @dev The Library provides a set of functions for debugging and logging information to the console.
 */

library Debug {
    function _print(bytes memory payload) private returns(bool) {
        (bool successful,) = Const.RUNTIME_ADDR.call(abi.encodeWithSignature("print(bytes)", payload));
        return successful;
    }

    /**
     * @notice print a string to the console.
     * @param info The string to print.
     * @return The number of concurrent instances.
     */
    function print(bytes memory info) public returns(bool) {
        return _print(info);
    }

    function print(uint256 info) public returns(bool) {
        return _print(abi.encode(info));
    }

    function print(address info) public returns(bool) {
        return _print(abi.encode(info));
    }
}
