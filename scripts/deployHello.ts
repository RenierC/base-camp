import { ethers } from "hardhat";
require("dotenv").config();

async function main() {
  const contractName = process.argv[2];
  const contract = await ethers.deployContract(contractName);
  await contract.waitForDeployment();

  const blockExplorerUrl = `https://goerli.basescan.org/address/${contract.target}`;
  console.log(`Contract ${contractName} deployed at ${blockExplorerUrl}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
