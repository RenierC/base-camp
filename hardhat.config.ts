import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

import { task } from "hardhat/config";
require("dotenv").config();

task("deploy", "Deploys a contract")
  .addParam("contract", "The name of the contract")
  .setAction(async (taskArgs, hre) => {
    const { ethers } = hre;
    await hre.run("compile");
    const factory = await ethers.getContractFactory(taskArgs.contract);
    const contract = await factory.deploy();
    await contract.waitForDeployment();

    const blockExplorerUrl = `https://goerli.basescan.org/address/${contract.target}`;

    console.log(`Contract ${contract.target}`);
    console.log(`Deployed at ${blockExplorerUrl}`);
    return contract.target;
  });

task("verifyContract", "Verifies a contract")
  .addParam("contract", "The name of the contract")
  .addParam("address", "The address of the deployed contract")
  .setAction(async (taskArgs, hre) => {
    await hre.run("verify:verify", {
      address: taskArgs.address,
      constructorArguments: [], // Add your constructor arguments here
    });

    console.log(`Contract verified: ${taskArgs.address}`);
  });

task("deployAndVerify", "Deploys and verifies a contract")
  .addParam("contract", "The name of the contract")
  .setAction(async (taskArgs, hre) => {
    const contractAddress = await hre.run("deploy", {
      contract: taskArgs.contract,
    });
    await new Promise((resolve) => setTimeout(resolve, 10000));
    await hre.run("verifyContract", {
      contract: taskArgs.contract,
      address: contractAddress,
    });
  });

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.17",
  },
  networks: {
    // for mainnet
    "base-mainnet": {
      url: "https://mainnet.base.org",
      accounts: [process.env.WALLET_KEY as string],
      gasPrice: 1000000000,
    },
    // for testnet
    "base-goerli": {
      url: "https://goerli.base.org",
      accounts: [process.env.WALLET_KEY as string],
      gasPrice: 1000000000,
    },
    // for local dev environment
    "base-local": {
      url: "http://localhost:8545",
      accounts: [process.env.WALLET_KEY as string],
      gasPrice: 1000000000,
    },
  },
  defaultNetwork: "base-goerli",
  etherscan: {
    apiKey: {
      "base-goerli": "PLACEHOLDER_STRING",
    },
    customChains: [
      {
        network: "base-goerli",
        chainId: 84531,
        urls: {
          apiURL: "https://api-goerli.basescan.org/api",
          browserURL: "https://goerli.basescan.org",
        },
      },
    ],
  },
};

export default config;
