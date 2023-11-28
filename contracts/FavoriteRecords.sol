// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

contract FavoriteRecords {
    mapping(string => bool) public approvedRecords;
    mapping(address => mapping(string => bool)) public userFavorites;
    error NotApproved(string _albumName);

    string[] public approvedAlbums = [
        "Thriller",
        "Back in Black",
        "The Bodyguard",
        "The Dark Side of the Moon",
        "Their Greatest Hits (1971-1975)",
        "Hotel California",
        "Come On Over",
        "Rumours",
        "Saturday Night Fever"
    ];

    constructor() {
        for (uint i = 0; i < approvedAlbums.length; i++) {
            approvedRecords[approvedAlbums[i]] = true;
        }
    }

    function getApprovedRecords() public view returns (string[] memory) {
        string[] memory _tempAlbums = new string[](approvedAlbums.length);

        for (uint i = 0; i < approvedAlbums.length; i++) {
            if (approvedRecords[approvedAlbums[i]]) {
                _tempAlbums[i] = approvedAlbums[i];
            }
        }
        return _tempAlbums;
    }

    function addRecord(string calldata _albumName) public {
        if (approvedRecords[_albumName]) {
            userFavorites[msg.sender][_albumName] = true;
        } else {
            revert NotApproved(_albumName);
        }
    }

    function getUserFavorites(
        address _user
    ) public view returns (string[] memory) {
        uint8 count = 0;

        for (uint i = 0; i < approvedAlbums.length; i++) {
            if (userFavorites[_user][approvedAlbums[i]]) {
                count++;
            }
        }

        string[] memory _userFaves = new string[](count);

        uint8 filterCount = 0;
        for (uint i = 0; i < approvedAlbums.length; i++) {
            if (userFavorites[_user][approvedAlbums[i]]) {
                _userFaves[filterCount] = approvedAlbums[i];
                filterCount++;
            }
        }

        return _userFaves;
    }

    function resetUserFavorites() external {
        for (uint i = 0; i < approvedAlbums.length; i++) {
            userFavorites[msg.sender][approvedAlbums[i]] = false;
        }
    }
}
