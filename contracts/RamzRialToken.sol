// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RialToken is ERC20 {
    address public owner;
    struct Minter {
        bool canMint;
        uint256 allowance;
    }
    mapping(address => Minter) minters;

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner.");
        _;
    }

    modifier onlyMinters() {
        require(minters[msg.sender].canMint == true, "Only minters can call this function");
        _;
    }

    constructor(
       string memory name,
       string memory symbol,
       uint256 initialSupply
   ) ERC20(name, symbol) {
        owner = msg.sender;
        minters[owner].canMint = true;
        _mint(msg.sender, initialSupply);
   }

   function mint(address account, uint256 amount) public onlyMinters {
       require(minters[msg.sender].allowance >= amount && msg.sender != owner, "You don't have allowance to mint this much.");
        _mint(account, amount);
        minters[msg.sender].allowance -= amount;
    }

    function addMinter(address minterAddress, uint256 allowance) public onlyOwner {
        require(minters[minterAddress].canMint == false, "This minter is already exists.");
        minters[minterAddress].canMint = true;
        minters[minterAddress].allowance = allowance;
    }

    function removeMinter(address minterAddress) public onlyOwner {
        require(minterAddress != owner, "Owner can't be removed from the minters.");
        require(minters[minterAddress].canMint == true, "This minter doesn't exist.");
        minters[minterAddress].canMint = false;
        minters[minterAddress].allowance = 0;
    }

    function setMintAllowance(address minterAddress, uint256 allowance) public onlyOwner {
        require(minters[minterAddress].canMint == true, "This minter doesn't exist.");
        minters[minterAddress].allowance = allowance;
    }
}