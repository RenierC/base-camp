// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AddressBook is Ownable {
    constructor(address _owner) Ownable(_owner) {}

    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }
    mapping(uint => Contact) public contacts;
    uint[] public contactIds;
    uint currId;
    error ContactNotFound(uint _id);

    function addContact(
        string calldata _firstName,
        string calldata _lastName,
        uint[] calldata _phoneNumbers
    ) external onlyOwner {
        contacts[currId] = Contact(
            currId,
            _firstName,
            _lastName,
            _phoneNumbers
        );
        contactIds.push(currId);
        currId++;
    }

    function deleteContact(uint _id) external onlyOwner {
        if (contacts[_id].phoneNumbers.length == 0) {
            revert ContactNotFound(_id);
        }

        delete contacts[_id];

        for (uint i = 0; i < contactIds.length; i++) {
            if (contactIds[i] == _id) {
                if (i != contactIds.length - 1) {
                    contactIds[i] = contactIds[contactIds.length - 1];
                }
                contactIds.pop();
                break;
            }
        }
    }

    function getContact(uint _id) external view returns (Contact memory) {
        if (contacts[_id].phoneNumbers.length == 0) {
            revert ContactNotFound(_id);
        }
        return contacts[_id];
    }

    function getAllContacts() external view returns (Contact[] memory) {
        Contact[] memory _tempContacts = new Contact[](contactIds.length);

        for (uint i = 0; i < contactIds.length; i++) {
            _tempContacts[i] = contacts[contactIds[i]];
        }
        return _tempContacts;
    }
}

contract AddressBookFactory {
    function deploy() public returns (address) {
        return address(new AddressBook(msg.sender));
    }
}
