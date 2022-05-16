const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ERC721", () => {
  let nftAddress, erc721;

  before(async () => {
    let ERC721 = await hre.ethers.getContractFactory("ERC721");
    erc721 = await ERC721.deploy("Polygon NFT", "PNFT");

    await erc721.deployed();

    nftAddress = erc721.address;
    console.log("ERC721 deployed to:", nftAddress);

    await erc721.mint("0x70997970c51812dc3a010c7d01b50e0d17dc79c8", 1);
    await erc721.mint("0x70997970c51812dc3a010c7d01b50e0d17dc79c8", 2);
    await erc721.mint("0x70997970c51812dc3a010c7d01b50e0d17dc79c8", 3);
    await erc721.mint("0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc", 4);
    await erc721.mint("0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc", 5);
  });

  it("Should assign correct Name and Symbol to NFT", async () => {
    const nftName = await erc721.name();
    const nftSymbol = await erc721.symbol();

    expect(nftName).to.equal("Polygon NFT");
    expect(nftSymbol).to.equal("PNFT");
  });

  it("Should Show the correct owner", async () => {
    const ownerAddress = await erc721._owners(1);

    expect(ownerAddress).to.equal("0x70997970c51812dc3a010c7d01b50e0d17dc79c8");
  });
});
