import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

import { task } from "hardhat/config";
require("dotenv").config();

task("deploy", "Deploys a contract")
  .addParam("contract", "The name of the contract")
  .addOptionalVariadicPositionalParam("args", "The constructor arguments")
  .setAction(async (taskArgs, hre) => {
    const { ethers } = hre;
    await hre.run("compile");
    const factory = await ethers.getContractFactory(taskArgs.contract);
    const args = taskArgs.args || []; // Add a default value for args
    const contract = await factory.deploy(...args);
    await contract.waitForDeployment();
    return contract.target;
  });

task("verifyContract", "Verifies a contract")
  .addParam("contract", "The name of the contract")
  .addParam("address", "The address of the deployed contract")
  .addOptionalVariadicPositionalParam("args", "The constructor arguments")
  .setAction(async (taskArgs, hre) => {
    await hre.run("verify:verify", {
      address: taskArgs.address,
      constructorArguments: taskArgs.args,
    });
    console.log(`Contract verified: ${taskArgs.address}`);
  });

task("deployAndVerify", "Deploys and verifies a contract")
  .addParam("contract", "The name of the contract")
  .addOptionalVariadicPositionalParam("args", "The constructor arguments")
  .setAction(async (taskArgs, hre) => {
    const contractAddress = await hre.run("deploy", {
      contract: taskArgs.contract,
      args: taskArgs.args,
    });
    await new Promise((resolve) => setTimeout(resolve, 10000));
    await hre.run("verifyContract", {
      contract: taskArgs.contract,
      address: contractAddress,
      args: taskArgs.args,
    });
  });

// custom script to deploy the inheretance exercise
task("deployInheritance", "Deploys inheritance contracts").setAction(
  async (taskArgs, hre) => {
    const salespersonAddress = await hre.run("deploy", {
      contract: "contracts/Inheritance.sol:Salesperson",
      args: ["55555", "12345", "20"],
    });
    const engineeringManagerAddress = await hre.run("deploy", {
      contract: "contracts/Inheritance.sol:EngineeringManager",
      args: ["54321", "11111", "200000"],
    });
    const inheritanceSubmissionAddress = await hre.run("deploy", {
      contract: "contracts/Inheritance.sol:InheritanceSubmission",
      args: [salespersonAddress, engineeringManagerAddress],
    });
    console.log("Salesperson deployed at:", salespersonAddress);
    console.log("EngineeringManager deployed at:", engineeringManagerAddress);
    console.log(
      "InheritanceSubmission deployed at:",
      inheritanceSubmissionAddress
    );
  }
);

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.17",
      },
      {
        version: "0.8.20",
      },
    ],
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
