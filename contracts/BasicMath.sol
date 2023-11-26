// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

contract BasicMath {
    function adder(
        uint256 _a,
        uint256 _b
    ) external pure returns (uint256 sum, bool error) {
        unchecked {
            sum = _a + _b;

            if (sum >= _a) {
                error = false;
            } else {
                sum = 0;
                error = true;
            }
        }
    }

    function subtractor(
        uint256 _a,
        uint256 _b
    ) external pure returns (uint256 difference, bool error) {
        if (_a >= _b) {
            difference = _a - _b;
            error = false;
        } else {
            difference = 0;
            error = true;
        }
    }
}
