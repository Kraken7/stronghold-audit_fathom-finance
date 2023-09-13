// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.17;

import "./interfaces/ICollateralPoolConfig.sol";

/**
 * @title CollateralPoolConfig
 * @notice A contract can add collateral pool type to the protocol and also manage settings for a specific pool type.
 */

contract CollateralPoolConfigHack is ICollateralPoolConfig {
    function setPriceWithSafetyMargin(bytes32 _collateralPoolId, uint256 _priceWithSafetyMargin) external override {
        revert('hack');
    }

    function setDebtCeiling(bytes32 _collateralPoolId, uint256 _debtCeiling) external {
        revert('hack');
    }

    function setDebtFloor(bytes32 _collateralPoolId, uint256 _debtFloor) external {
        revert('hack');
    }

    function setPositionDebtCeiling(bytes32 _collateralPoolId, uint256 _positionDebtCeiling) external override {
        revert('hack');
    }

    function setPriceFeed(bytes32 _poolId, address _priceFeed) external {
        revert('hack');
    }

    function setLiquidationRatio(bytes32 _poolId, uint256 _liquidationRatio) external {
        revert('hack');
    }

    function setStabilityFeeRate(bytes32 _collateralPool, uint256 _stabilityFeeRate) external {
        revert('hack');
    }

    function setAdapter(bytes32 _collateralPoolId, address _adapter) external {
        revert('hack');
    }

    function setCloseFactorBps(bytes32 _collateralPoolId, uint256 _closeFactorBps) external {
        revert('hack');
    }

    function setLiquidatorIncentiveBps(bytes32 _collateralPoolId, uint256 _liquidatorIncentiveBps) external {
        revert('hack');
    }

    function setTreasuryFeesBps(bytes32 _collateralPoolId, uint256 _treasuryFeesBps) external {
        revert('hack');
    }

    function setDebtAccumulatedRate(bytes32 _collateralPoolId, uint256 _debtAccumulatedRate) external override {
        revert('hack');
    }

    function setStrategy(bytes32 _collateralPoolId, address _strategy) external {
        revert('hack');
    }

    function updateLastAccumulationTime(bytes32 _collateralPoolId) external override {
        revert('hack');
    }

    function collateralPools(bytes32 _collateralPoolId) external view override returns (ICollateralPoolConfig.CollateralPool memory) {
        revert('hack');
    }

    function getTotalDebtShare(bytes32 _collateralPoolId) external view override returns (uint256) {
        revert('hack');
    }

    function getDebtAccumulatedRate(bytes32 _collateralPoolId) external view override returns (uint256) {
        revert('hack');
    }

    function getPriceWithSafetyMargin(bytes32 _collateralPoolId) external view override returns (uint256) {
        revert('hack');
    }

    function getDebtCeiling(bytes32 _collateralPoolId) external view override returns (uint256) {
        revert('hack');
    }

    function getPositionDebtCeiling(bytes32 _collateralPoolId) external view override returns (uint256) {
        revert('hack');
    }

    function getDebtFloor(bytes32 _collateralPoolId) external view override returns (uint256) {
        revert('hack');
    }

    function getPriceFeed(bytes32 _collateralPoolId) external view override returns (address) {
        revert('hack');
    }

    function getLiquidationRatio(bytes32 _collateralPoolId) external view override returns (uint256) {
        revert('hack');
    }

    function getStabilityFeeRate(bytes32 _collateralPoolId) external view override returns (uint256) {
        revert('hack');
    }

    function getLastAccumulationTime(bytes32 _collateralPoolId) external view override returns (uint256) {
        revert('hack');
    }

    function getAdapter(bytes32 _collateralPoolId) external view override returns (address) {
        revert('hack');
    }

    function getCloseFactorBps(bytes32 _collateralPoolId) external view override returns (uint256) {
        revert('hack');
    }

    function getLiquidatorIncentiveBps(bytes32 _collateralPoolId) external view override returns (uint256) {
        revert('hack');
    }

    function getTreasuryFeesBps(bytes32 _collateralPoolId) external view override returns (uint256) {
        revert('hack');
    }

    function getStrategy(bytes32 _collateralPoolId) external view override returns (address) {
        revert('hack');
    }

    function setTotalDebtShare(bytes32 _collateralPoolId, uint256 _totalDebtShare) external override {
        revert('hack');
    }

    function getCollateralPoolInfo(bytes32 _collateralPoolId) external view override returns (CollateralPoolInfo memory _info) {
        revert('hack');
    }
}
