// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract HaikuNFT is ERC721 {
    uint public counter;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        counter = 1;
    }

    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    Haiku[] public haikus;
    mapping(address => uint[]) public sharedHaikus;
    mapping(string => bool) private usedLines;

    error HaikuNotUnique();
    error NotYourHaiku(uint id);
    error NoHaikusShared();

    function mintHaiku(
        string calldata _line1,
        string calldata _line2,
        string calldata _line3
    ) external {
        if (usedLines[_line1] || usedLines[_line2] || usedLines[_line3]) {
            revert HaikuNotUnique();
        }

        usedLines[_line1] = true;
        usedLines[_line2] = true;
        usedLines[_line3] = true;

        haikus.push(Haiku(msg.sender, _line1, _line2, _line3));

        _safeMint(msg.sender, counter);
        counter++;
    }

    function shareHaiku(uint _id, address _to) public {
        if (ownerOf(_id) != msg.sender) {
            revert NotYourHaiku(_id);
        }
        sharedHaikus[_to].push(_id);
    }

    function getMySharedHaikus() public view returns (Haiku[] memory) {
        uint[] memory sharedIds = sharedHaikus[msg.sender];

        if (sharedIds.length == 0) {
            revert NoHaikusShared();
        }

        Haiku[] memory filteredArr = new Haiku[](sharedIds.length);

        for (uint i = 0; i < sharedIds.length; i++) {
            filteredArr[i] = haikus[sharedIds[i] - 1];
        }
        return filteredArr;
    }
}
