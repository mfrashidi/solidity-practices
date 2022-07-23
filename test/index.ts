import { expect } from "chai";
import { ethers } from "hardhat";

//Ramz Rial Token Unit-Test

describe("Ramz Rial", function () {
  it("Deployment should assign the total supply of tokens to the owner", async function () {
    const [owner] = await ethers.getSigners();

    const RialToken = await ethers.getContractFactory("RialToken");
    const rialToken = await RialToken.deploy("Rial Token", "RamzRial", "20000000000000000000");
    await rialToken.deployed();

    const ownerBalance = await rialToken.balanceOf(owner.address);
    expect(await rialToken.totalSupply()).to.equal(ownerBalance);
  });
});