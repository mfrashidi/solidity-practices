import { expect } from "chai";
import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

//Ramz Rial Token Unit-Test

describe("Ramz Rial unit tests", function () {
  async function deployTokenFixture() {
    const [owner, addr1, addr2] = await ethers.getSigners();

    const RialToken = await ethers.getContractFactory("RialToken");
    const rialToken = await RialToken.deploy("Rial Token", "RamzRial", "20000000000000000000");
    await rialToken.deployed();

    return { RialToken, rialToken, owner, addr1, addr2 };
  }

  it("Token deployment", async function () {
    const { rialToken, owner } = await loadFixture(deployTokenFixture);

    const ownerBalance = await rialToken.balanceOf(owner.address);
    expect(await rialToken.totalSupply()).to.equal(ownerBalance);
  });

  it("Token transfer", async function () {
    const { rialToken, addr1, addr2 } = await loadFixture(deployTokenFixture);

    await rialToken.transfer(addr1.address, 50);
    expect(await rialToken.balanceOf(addr1.address)).to.equal(50);

    await rialToken.connect(addr1).transfer(addr2.address, 50);
    expect(await rialToken.balanceOf(addr2.address)).to.equal(50);
  });
});