import { execSync } from "child_process";

const contractName = process.argv[2];
execSync(`npx hardhat run scripts/deployHello.ts ${contractName}`, {
  stdio: "inherit",
});
