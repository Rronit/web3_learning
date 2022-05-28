const { ethers } = require("hardhat");

async function main() {
  /*
  A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
  so whitelistContract here is a factory for instances of our Whitelist contract.
  */
  const whiteListContract = await ethers.getContractFactory("whitelist");
  const deployedWhiteListContract = await whiteListContract.deploy(10);
  const deployedWhiteListResp = await deployedWhiteListContract.deployed();
  console.log("Whitelist Contract Address:", deployedWhiteListResp.address);
}

main()
  .then(() => process.exit(0))
  .catch(e => {
    console.log(e);
    process.exit(1);
  });
