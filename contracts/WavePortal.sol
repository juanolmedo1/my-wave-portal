// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    event NewWave(address indexed from, uint256 timestamp, string message);
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    uint256 totalWaves;
    Wave[] waves;
    mapping(address => uint256) public countOfWaves;

    constructor() {
        console.log("Yo yo, I am a contract and I am smart");
    }

    function wave(string memory _message) public {
        totalWaves++;
        countOfWaves[msg.sender]++;
        waves.push(Wave(msg.sender, _message, block.timestamp));
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        return totalWaves;
    }
}