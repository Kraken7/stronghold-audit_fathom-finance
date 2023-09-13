FATHOM_FINANCE
=============

Project overview
------------------------

Algorithmic stackablecoin based on credit policy. The user creates a wallet through which he can create CDPs. He can create collateral in XDC and borrow stablecoins FXD. After using stablecoins, he can repay the debt and return his collateral. The user is charged a fee ( percents) for the use of stablecoins.

Finding Severity breakdown
--------------------------

All vulnerabilities discovered during the audit are classified based on their potential severity and have the following classification:

Severity | Description
--- | ---
Critical | Bugs leading to assets theft, fund access locking, or any other loss funds to be transferred to any party.
High     | Bugs that can trigger a contract failure. Further recovery is possible only by manual modification of the contract state or replacement.
Medium   | Bugs that can break the intended contract logic or expose it to DoS attacks, but do not cause direct loss funds.
Low      | Bugs that do not significantly affect the protocol operation and can be easily fixed. These are mostly recommendations for code improvement.

Severity | # of Findings
--- | ---
CRITICAL| 4
HIGH    | 3
MEDIUM  | 2
LOW | 20

Findings
------------

### Critical

#### C-1 OWNER_CAN_CHANGE_BOOK_KEEPER_TO_CRASH_SYSTEM
##### Description
The owner can change the bookKeeper in the PositionManager to any other contract. For example a contract with opcode `revert` which will ddos the system.

https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/managers/PositionManager.sol#L330

A possible flow:
1. Create BookKeeperHack contract with `revert()` in a body every functions. The function `totalStablecoinIssued` has to return 1.
2. Deploy this hack contract.
3. The owner (a user with OWNER_ROLE) sets this hack contract by calling `PositionManager.setBookKeeper(BookKeeperHack)`.
4. All actions with CDP now fail.

##### Recommendation
Remove this function or use an access modifier for GOV_ROLE only. But BookKeeper should be one for all contracts and migration of assets from the old BookKeeper to the new one should be implemented. No data should be lost.

#### C-2 OWNER_CAN_CHANGE_PRICEO_RACLE_TO_CRASH_SYSTEM
##### Description
The owner can change the priceOracle in the PositionManager to any other contract. For example a contract with opcode `revert` which will ddos the system. In a less critical case, a empty contract which will to prices obsolescence.

https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/managers/PositionManager.sol#L325

A possible flow:
1. Create PriceOracleHack contract with `revert()` in a body every functions. The function `stableCoinReferencePrice` has to return 1.
2. Deploy this hack contract.
3. The owner (a user with OWNER_ROLE) sets this hack contract by calling `PositionManager.setPriceOracle(PriceOracleHack)`.
4. All actions with function `PositionManager.adjustPosition()` now fail.

##### Recommendation
Use an access modifier for GOV_ROLE only.

#### C-3 OWNER_CAN_CHANGE_ACCESS_CONTROL_CONFIG_TO_WITHDRAW_ASSETS
##### Description
The owner can change the accessControlConfig in the BookKeeper to any other contract. For example a contract will contain roles for the owner only. This will give the owner access to any role in the contracts. The owner will be able to call `BookKeeper.mintUnbackedStablecoin()` and then withdraw the stablecoins to himself.

https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/BookKeeper.sol#L152

A possible flow:
1. Create AccessControlConfigHack contract and set each role to `DEFAULT_ADMIN_ROLE`.
2. Deploy this hack contract.
3. The owner (a user with OWNER_ROLE) sets this hack contract by calling `BookKeeper.setAccessControlConfig(AccessControlConfigHack)`.
4. The owner (a user with OWNER_ROLE) mints stablecoins (e.g. 1.000.000.000) on himself address by calling `BookKeeper.mintUnbackedStablecoin()`. At this point, it is the value in the bookKeeper.
5. The owner (a user with OWNER_ROLE) mints this stablecoins from bookKeeper to ERC-20 on himself address by calling `StablecoinAdapter.withdraw()`.

Owner minted a lot of stablecoins to himself.
Every integrated contract has lost access which caused ddos the system. 

##### Recommendation
Remove this function or use an access modifier for GOV_ROLE only. But AccessControlConfig should be one for all contracts.

#### C-4 OWNER_CAN_CHANGE_COLLATERAL_POOL_CONFIG_TO_CRASH_SYSTEM
##### Description
The owner can change the collateralPoolConfig in the BookKeeper to any other contract. For example a contract with opcode `revert` which will ddos the system. Or in other case, contract will contain bad data (e.g. big fee) to caused a lost users assets.

https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/BookKeeper.sol#L164

A possible flow:
1. Create CollateralPoolConfigHack contract with `revert()` in a body every functions.
2. Deploy this hack contract.
3. The owner (a user with OWNER_ROLE) sets this hack contract by calling `BookKeeper.setCollateralPoolConfig(collateralPoolConfigHack)`.
4. All actions with CDP now fail.

##### Recommendation
Remove this function or use an access modifier for GOV_ROLE only. But CollateralPoolConfig should be one for all contracts and migration of data from the old CollateralPoolConfig to the new one should be implemented. No data should be lost.

### High

#### H-1 OWNER_HAS_MANY_ACCESS
##### Description
The `onlyOwner` and `onlyOwnerOrGov` modifiers give the owner too many rights to control the system.

The owner can kill the system at any time.<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/adapters/CollateralTokenAdapter/CollateralTokenAdapter.sol#L112<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/BookKeeper.sol#L173

The owner can manage whitelist of the contract `CollateralTokenAdapter`.<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/adapters/CollateralTokenAdapter/CollateralTokenAdapter.sol#L99<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/adapters/CollateralTokenAdapter/CollateralTokenAdapter.sol#L107

The owner can pause or unpause the system.<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/adapters/CollateralTokenAdapter/CollateralTokenAdapter.sol#L119<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/adapters/CollateralTokenAdapter/CollateralTokenAdapter.sol#L123<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/managers/PositionManager.sol#L335<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/managers/PositionManager.sol#L339<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/BookKeeper.sol#L182<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/BookKeeper.sol#L186

The owner can set total debt ceiling.<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/BookKeeper.sol#L146

##### Recommendation
Change modifiers `onlyOwner`, `onlyOwnerOrGov`, `onlyOwnerOrShowStopper` of these functions to `onlyGov`, `onlyGov`, `onlyShowStopper`. One EOA should not have access to change the state of the system. Access should be through governance.

#### H-2 UNPAID_STABILITY_FEE
##### Description
The user pays the fee only when borrowing the debt himself by calling the `FathomStablecoinProxyActions.adjustPosition` function.

A possible flow with the payment of a fee:
1. The user call `FathomStablecoinProxyActions.openLockXDCAndDraw`. Debt is got.
2. The user call `FathomStablecoinProxyActions.wipeAllAndUnlockXDC`. Debt is wiped.

A possible flow without the payment of a fee:
1. The user call `FathomStablecoinProxyActions.open`. Position is opened.
2. The user call `FathomStablecoinProxyActions.xdcAdapterDeposit`. Deposit is made.
3. The user call `FathomStablecoinProxyActions.adjustPosition`. Collateral is locked.
4. The user call `FathomStablecoinProxyActions.draw`. Debt is got.
5. The user call `FathomStablecoinProxyActions.wipeAllAndUnlockXDC`. Debt is wiped.

Why is this happening?<br>
The `lockXDCAndDraw`, `draw`, `lockTokenAndDraw`, `wipeAndUnlockXDC`, `wipeAndUnlockToken` functions call `_getDrawDebtShare` to get the processed `amount` for the `adjustPosition` function.

On this line, the fee is updated<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L448

For example function `wipeAllAndUnlockXDC` not call this function and the fee is not updated. Therefore, the fee was not paid.

##### Recommendation
Update fee in `BookKeeper.adjustPosition`.<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/BookKeeper.sol#L293

#### H-3 ASSETS_CAN_BE_LOST
##### Description
All actions with assets of CDP goes through position address. If you put a collateral on the not position address it will be lost. All functions (e.g. `adjustPosition`, `draw`, `moveCollateral`, `moveStablecoin`) works with a positionId and will not get these assets. These assets will not be available to anyone.<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L201<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L212<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L184

##### Recommendation
These functions has to take position id instead of position address. In this case, all assets of CDP will go through position address.

### Medium

#### M-1 DEPOSIT_RETURN_WITH_FEE
##### Description
Once a user has made a deposit, it cannot be withdrawn back. It is necessary to lock it first and get stablecoins. Only then can it be withdrawn. But in this case, the user will already pay the stability fee. The user loses the money. He did not want to use this service.

A possible flow:
1. The user call `FathomStablecoinProxyActions.open` and `FathomStablecoinProxyActions.xdcAdapterDeposit`
2. The user wants their deposit back. But it can't be done.
3. The user call `FathomStablecoinProxyActions.adjustPosition` and `FathomStablecoinProxyActions.draw` and `FathomStablecoinProxyActions.wipeAllAndUnlockXDC`
4. The user got his deposit back. But he paid the stability fee.

https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L237<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L201C16-L201C16<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L245<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L67<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L144

##### Recommendation
Make a deposit withdrawal function.

#### M-2 FRONTRUNNING_INITIALIZE_PROXY
##### Description
Proxy initialization can be intercepted and executed with malicious parameters. After the contract is deployed, anyone can initialize it with their own parameters. This applies to all proxy contracts of project.

https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/managers/PositionManager.sol#L75<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/BookKeeper.sol#L128<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/adapters/CollateralTokenAdapter/CollateralTokenAdapter.sol#L74

##### Recommendation
Deploy and initialize in one transaction or set modifier `onlyOwner` on `initialize` function.

### Low

#### L-1 COMPARES_TO_A_BOOLEAN_CONSTANT
##### Description
In the `require` function, there is no need to compare to bool.

https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/ShowStopper.sol#L140<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/tests/mocks/MockCollateralTokenAdapter.sol#L166<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/adapters/CollateralTokenAdapter/CollateralTokenAdapter.sol#L128<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/StableSwapModule.sol#L142<br>

##### Recommendation
Write `require(_priceFeed.isPriceOk(), ...)` instead of `require(_priceFeed.isPriceOk() == true, ...)`.

#### L-2 FUNCTION_ORDER_IS_INCORRECT
##### Description
Function order is incorrect, state variable declaration can not go after event definition

https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L27

##### Recommendation
`address immutable internal self = address(this);` move above the events.

#### L-3 LOST_MODIFIER
##### Description
Lost modifier `onlyDelegateCall`.<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L42

##### Recommendation
Add this modifier.

#### L-4 USELESS_CHECK
##### Description
`safeLockXDC` function take `_owner` parameter which makes the `require` check useless.<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L62

##### Recommendation
Remove `_owner` parameter. Compare with `address(this)`.

#### L-5 FUNCTIONS_FOR_TOKENS_LIKE_FOR_XDC
##### Description
There are functions `lockXDC`, `SafeLockXDC`. But there are no functions `lockToken`, `SafeLockToken`.<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L62<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L274

##### Recommendation
Add these functions.

#### L-6 STATE_CACHING
##### Description
To optimize the gas, you should cache the state variables in a memory to use them later.

https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L325<br>
`address _positionAddress = IManager(_manager).positions(_positionId);`<br>
`address _bookKeeper = IManager(_manager).bookKeeper();`

https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L387<br>
`address _bookKeeper = IManager(_manager).bookKeeper();`

https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L417<br>
`address _bookKeeper = IManager(_manager).bookKeeper();`

https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/managers/PositionManager.sol#L221<br>
`collateralPools[_positionId] = _collateralPoolId`

##### Recommendation
You should cache the state variables. For example https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L289

#### L-7 IDENTICAL_PARAMETER_VALUES_IN_A_FUNCTION
##### Description
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/BookKeeper.sol#L283<br>
This function contains 3 parameters that are always the same.<br>
`_positionAddress` = `_collateralOwner` = `_stablecoinOwner`

##### Recommendation
Make one parameter `_positionAddress`.

#### L-8 CHECK_ZERO_VALUES
##### Description
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/BookKeeper.sol#L283<br>
If `_collateralValue` and `_debtShare` are 0 then the function is meaningless.

##### Recommendation
Check these both parameters for zero.

#### L-9 MODIFIER_INSTEAD_OF_FUNCTION
##### Description
It is common to use modifiers to check access before starting a function<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/BookKeeper.sol#L491

##### Recommendation
Use a modifier.

#### L-10 BOOLEAN_COMPARISON
##### Description
Used `assembly` for logical comparisons. This makes the code unreadable.<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/utils/CommonMath.sol#L71<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/utils/CommonMath.sol#L77

##### Recommendation
Use standard logical operators such as `&&` and `||`. Do not use these functions.

#### L-11 COMMON_MATH_IS_LIBRARY
##### Description
`CommonMath` contains only internal pure functions.  It may be a library.<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/utils/CommonMath.sol#L4

##### Recommendation
Make `CommonMath' a library

#### L-12 UNUSED_CODE
##### Description
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/adapters/CollateralTokenAdapter/CollateralTokenAdapter.sol#L68<br>
This modifier is not used.

https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/managers/PositionManager.sol#L9<br>
This interface is not used.

##### Recommendation
Remove unused code.

#### L-13 CHECK_FEE_TOKEN
##### Description
Before and after sending tokens, you need to compare balances. If the balance changes are greater than expected, then it is a fee token and it is necessary to revert the transaction. There is no such check.

https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/adapters/CollateralTokenAdapter/CollateralTokenAdapter.sol#L173<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/adapters/CollateralTokenAdapter/CollateralTokenAdapter.sol#L189<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/adapters/CollateralTokenAdapter/CollateralTokenAdapter.sol#L214

##### Recommendation
Make this checking.

#### L-14 SPAM_EVENTS_WITH_ZERO_VALUES
##### Description
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/adapters/CollateralTokenAdapter/CollateralTokenAdapter.sol#L216<br>
This event is emit when the value is zero.

##### Recommendation
Include this line in the condition above.

#### L-15 ANYONE_CAN_CREATE_A_POSITION_FOR_ANYONE
##### Description
When managing your positions, it can be inconvenient when someone else creates new positions for you. In addition, if a frontend of positions output is implemented, it will be a big inconvenience for the user.<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/managers/PositionManager.sol#L110

##### Recommendation
Use `msg.sender` instead of `_user`.

#### L-16 CHECK_ZERO_ADDRESS
##### Description
`_src` and `_dst`<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/BookKeeper.sol#L367

`_to`<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/adapters/CollateralTokenAdapter/CollateralTokenAdapter.sol#L161

`_usr`<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/adapters/CollateralTokenAdapter/CollateralTokenAdapter.sol#L205

##### Recommendation
Make a check for a zero address.

#### L-17 INCORRECT_NAME
##### Description
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/BookKeeper.sol#L25<br>
debtShare is not share. It is amount a debt stablecoins of CDP.

https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/adapters/CollateralTokenAdapter/CollateralTokenAdapter.sol#L208<br>
In this case, this function removes the collateral.

https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/utils/CommonMath.sol#L134<br>
This function converts WAD to RAD. But not simple number to RAY.

##### Recommendation
Rename `debtShare` to `debtAmount`.<br>
Add `removeCollateral` function.<br>
Rename `toRad` to `wadToRad`

#### L-18 SNAKE_CASE_FOR_IMMUTABLE_VARIABLES
##### Description
Immutable variables name are set to be in capitalized SNAKE_CASE<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/proxy-actions/FathomStablecoinProxyActions.sol#L27<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/Vault.sol#L18<br>
https://github.com/Into-the-Fathom/fathom-stablecoin-smart-contracts/blob/a7d2ff13fde5beab1a677bfc7171641b4023d9c8/contracts/main/stablecoin-core/Vault.sol#L19<br>

##### Recommendation
Rename these variables to the snake case style.

#### L-19 OLD_SOLIDITY_VERSION
##### Description
Version 0.8.17 is used.

##### Recommendation
Use now version - 0.8.22

#### L-20 OLD_OPENZEPPELIN_VERSION
##### Description
Version 4.7.3 is used.

##### Recommendation
Use now version - 4.9.3