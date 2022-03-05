// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.12;

import "./Ownable.sol";

//  TODO's: Create a Pausable contract that inherits from the Ownable contract
//  1) create a private '_paused' variable of type bool [DONE]
//  2) create a public setter using the inherited onlyOwner modifier  [DONE]
//  3) create an internal constructor that sets the _paused variable to false [DONE]
//  4) create 'whenNotPaused' & 'paused' modifier that throws in the appropriate situation
//  5) create a Paused & Unpaused event that emits the address that triggered the event [DONE]
contract Pausable is Ownable {
    bool _paused;

    event Paused(address triggerAddress);
    event UnPaused(address triggerAddress);

    modifier IsPaused() {
        require(_paused, "Contract must be paused");
        _;
    }
    modifier IsUnpaused() {
        require(!_paused, "Contract must be unpaused");
        _;
    }

    function setPaused(bool paused) public onlyOwner {
        _paused = paused;

        if (paused) {
            emit Paused(msg.sender);
        } else {
            emit UnPaused(msg.sender);
        }
    }

    constructor() {
        _paused = false;

        emit UnPaused(msg.sender);
    }
}
