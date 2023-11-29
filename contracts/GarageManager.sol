// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

contract GarageManager {
    struct Car {
        string make;
        string model;
        string color;
        uint256 numberOfDoors;
    }

    mapping(address => Car[]) public garage;
    error BadCarIndex(uint _carIndex);

    function addCar(
        string calldata _make,
        string calldata _model,
        string calldata _color,
        uint256 _numberOfDoors
    ) external {
        Car memory newCar = Car(_make, _model, _color, _numberOfDoors);
        garage[msg.sender].push(newCar);
    }

    function getMyCars() external view returns (Car[] memory) {
        return garage[msg.sender];
    }

    function getUserCars(address _user) external view returns (Car[] memory) {
        return garage[_user];
    }

    function updateCar(
        uint _carIndex,
        string calldata _make,
        string calldata _model,
        string calldata _color,
        uint256 _numberOfDoors
    ) external {
        if (_carIndex >= garage[msg.sender].length) {
            revert BadCarIndex(_carIndex);
        }

        Car memory updatedCar = Car(_make, _model, _color, _numberOfDoors);
        garage[msg.sender][_carIndex] = updatedCar;
    }

    function resetMyGarage() external {
        delete garage[msg.sender];
    }
}
