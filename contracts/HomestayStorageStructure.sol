// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MakanStorageStructure {
    address public logic;
    
    address public owner;
    IERC20 public ramzRial;

    uint public rentingDuration = 24 hours;
    uint public feePercentage = 2;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner.");
        _;
    }

    struct Room {
        uint id;
        uint agreementID;
        string telegramID;
        bool isVacant;
        address landLord;
        address renter;
        uint rentPerDay;
        uint collateral;
        bool isExisted;
    }

    struct Agreement {
        uint id;
        uint roomID;
        string telegramID;
        bool isActive;
        address landLord;
        address renter;
        uint rentPerDay;
        uint collateral;
        uint startingTime;
        bool isExisted;
    }

    uint currentRoomID = 0;
    mapping(uint => Room) public roomsByID;

    uint currentAgreementID = 0;
    mapping(uint => Agreement) public agreementsByID;
}