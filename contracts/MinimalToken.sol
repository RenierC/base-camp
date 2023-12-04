// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract UnburnableToken {
    mapping(address => uint) public balances;
    mapping(address => bool) private claims;
    uint public totalSupply;
    uint public totalClaimed;
    error UnsafeTransfer(address);
    error TokensClaimed();
    error AllTokensClaimed();

    constructor() {
        totalSupply = 100_000_000;
    }

    function claim() public {
        if (claims[msg.sender]) {
            revert TokensClaimed();
        }

        if (totalClaimed >= totalSupply) {
            revert AllTokensClaimed();
        }

        balances[msg.sender] += 1000;
        claims[msg.sender] = true;
        totalClaimed += 1000;
    }

    function safeTransfer(address _to, uint _amount) public {
        if (_to == address(0) || _to.balance <= 0) {
            revert UnsafeTransfer(_to);
        }
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
