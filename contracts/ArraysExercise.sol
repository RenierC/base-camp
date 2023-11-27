// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

contract ArraysExercise {
    uint[] public numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    address[] public senders;
    uint[] public timestamps;

    function getNumbers() public view returns (uint[] memory fullArr) {
        fullArr = numbers;
    }

    function resetNumbers() public {
        numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    }

    function appendToNumbers(uint[] calldata _toAppend) public {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    function saveTimestamp(uint _unixTimestamp) public {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    function afterY2K() public view returns (uint[] memory, address[] memory) {
        uint count = 0;
        uint[] memory tempStamps = new uint[](timestamps.length);
        address[] memory tempSenders = new address[](timestamps.length);

        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > 946702800) {
                tempStamps[count] = timestamps[i];
                tempSenders[count] = senders[i];
                count++;
            }
        }

        uint[] memory filteredStamps = new uint[](count);
        address[] memory filteredSenders = new address[](count);

        for (uint i = 0; i < count; i++) {
            filteredSenders[i] = tempSenders[i];
            filteredStamps[i] = tempStamps[i];
        }

        return (filteredStamps, filteredSenders);
    }

    function resetSenders() public {
        delete senders;
    }

    function resetTimestamps() public {
        delete senders;
    }
}
