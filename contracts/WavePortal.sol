// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WavePortal is Ownable {

    event NewWave(address indexed from, uint256 timestamp, string message);
    event NewWinner(address indexed from, uint256 timestamp, uint256 amount);

    struct Wave {
        address waver; 
        string message;
        uint256 timestamp;
    }

    uint256 public totalWaves;
    uint256 private seed;
    uint256 private cooldownTime = 30 seconds;
    uint256 private winProbability = 40;
    uint256 private priceAmount = 0.001 ether;
    mapping(address => uint256) public lastWavedAt;
    Wave[] public waves;

    constructor() payable {
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function randomNumber() private view returns (uint256) {
        return (block.difficulty + block.timestamp + seed) % 100;
    }

    function wave(string memory _message) public {
        require(lastWavedAt[msg.sender] + cooldownTime < block.timestamp, "Wait 30 sec.");
        totalWaves++;
        waves.push(Wave(msg.sender, _message, block.timestamp));
        seed = randomNumber();
        lastWavedAt[msg.sender] = block.timestamp;
        if (seed <= winProbability) {
            require(priceAmount <= address(this).balance, "Trying to withdraw more money than the contract has.");
            (bool success, ) = (msg.sender).call{value: priceAmount}("");
            require(success, "Failed to withdraw money from contract.");
            emit NewWinner(msg.sender, block.timestamp, priceAmount);
        }
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        return totalWaves;
    }

    function updateCooldownTime(uint256 _newCooldownTime) public onlyOwner {
        cooldownTime = _newCooldownTime;
    }
    
    function updateWinProbability(uint256 _newWinProbability) public onlyOwner {
        winProbability = _newWinProbability;
    }

    function updatePriceAmount(uint256 _newPriceAmount) public onlyOwner {
        priceAmount = _newPriceAmount;
    }
}