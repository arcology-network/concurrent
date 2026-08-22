// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../../../contracts/multiprocess/Multiprocess.sol";

// The test runner submits test functions in source order with consecutive
// enclosing transaction nonces. Internal jobs must not consume those nonces.
contract MultiprocessNonceIsolationTest {
    function test01InternalJobsDoNotConsumeSenderNonce() public {
        Multiprocess mp = new Multiprocess(2);
        mp.addJob(500000, 0, address(this), abi.encodeWithSignature("noOp()"));
        mp.addJob(500000, 0, address(this), abi.encodeWithSignature("noOp()"));

        (bool success, ) = mp.run();
        require(success);
    }

    // This enclosing transaction uses the nonce immediately following test01.
    // It fails pre-check if either internal job incremented the sender nonce.
    function test02FollowingTransactionUsesNextNonce() public {}

    function noOp() public {}
}
