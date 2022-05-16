const hre = require("hardhat");

async function main() {

  const ERC721 = await hre.ethers.getContractFactory("ERC721");
  const erc721 = await ERC721.deploy("Polygon NFT", "PNFT");

  await erc721.deployed();

  console.log("ERC721 deployed to:", erc721.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
