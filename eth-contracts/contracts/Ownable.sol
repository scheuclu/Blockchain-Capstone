// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.12;

import "openzeppelin-solidity/contracts/utils/Address.sol";

contract Ownable {
    //  [DONE]'s
    //  1) create a private '_owner' variable of type address with a public getter function [DONE]
    //  2) create an internal constructor that sets the _owner var to the creater of the contract [DONE]
    //  3) create an 'onlyOwner' modifier that throws if called by any account other than the owner. [DONE]
    //  4) fill out the transferOwnership function [DONE]
    //  5) create an event that emits anytime ownerShip is transfered (including in the constructor) [DONE]

    address _owner;
    event OwnershipTransferred(address from, address to);

    constructor() {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    function getOwner() public view returns (address) {
        return _owner;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        // TODO add functionality to transfer control of the contract to a newOwner.
        // make sure the new owner is a real address
        require(
            Address.isContract(newOwner) == false,
            "Cannot transfer ownership to a contract"
        );
        address oldOwner = _owner;
        _owner = newOwner;

        emit OwnershipTransferred(oldOwner, _owner);
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Caller is not contract owner");
        _;
    }
}
