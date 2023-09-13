import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import './tasks/poc';

const config: HardhatUserConfig = {
  solidity: {
    version:  "0.8.17",
    settings: {
      viaIR: true,
      optimizer: {
        enabled: true,
        runs: 2000,
        details: {
          yul: true,
          yulDetails: {
            stackAllocation: true,
            optimizerSteps: "u"
          }
        }
      }
    },
  },
  defaultNetwork: "localhost",
  networks: {
    hardhat: {
      chainId: 1337
    }
  },
};

export default config;
