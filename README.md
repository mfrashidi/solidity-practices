
# Solidity Practices

This repository contains the Homestay and the Ramz Rial token contracts.

## Contracts
**`Homestay.sol`**

 - It's the non-upgradable version of the Homestay contract (Unlike the upgradable version, this contract consists the needed variables and function in itself). It allows the user to add and rent rooms for a period of time which is editable by the owner of the contract.

**`HomestayStorageStructure.sol`** 
 - Storage structure of the Homestay contract that containts the needed variables.
 
**`HomestayLogic.sol`**
 - It's the logic of the Homestay contract that containts the needed functions. This contract can be updated and you can write a new logic and give its contract address to the proxy.

**`HomestayProxy.sol`**
 - It's the proxy of the Homestay contract that inherits the HomestayStorageStructure. The constructor gives the logic and token contract address.

**`RamzRialToken.sol`**
 - The token contract that allows users to pay for the rooms. It's an implementation of a ERC20 token.

## Unit Tests

You can find some unit tests for the Ramz Rial token and Homestay contract in the [test/index.tx](https://github.com/mfrashidi/solidity-practices/blob/master/test/index.ts).
