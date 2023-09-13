// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.17;

import "./interfaces/IBookKeeper.sol";

contract BookKeeperHack is IBookKeeper {
    function addCollateral(
        bytes32 collateralPoolId,
        address ownerAddress,
        int256 amount // [wad]
    ) external {
        revert();
    }

    function movePosition(bytes32 collateralPoolId, address src, address dst, int256 collateralAmount, int256 debtShare) external {
        revert();
    }

    function adjustPosition(
        bytes32 collateralPoolId,
        address positionAddress,
        address collateralOwner,
        address stablecoinOwner,
        int256 collateralValue,
        int256 debtShare
    ) external {
        revert();
    }

    function totalStablecoinIssued() external returns (uint256) {
        return 1;
    }

    function moveStablecoin(
        address src,
        address dst,
        uint256 value // [rad]
    ) external {
        revert();
    }

    function moveCollateral(
        bytes32 collateralPoolId,
        address src,
        address dst,
        uint256 amount // [wad]
    ) external {
        revert();
    }

    function confiscatePosition(
        bytes32 collateralPoolId,
        address positionAddress,
        address collateralCreditor,
        address stablecoinDebtor,
        int256 collateralAmount, // [wad]
        int256 debtShare // [wad]
    ) external {
        revert();
    }

    function mintUnbackedStablecoin(
        address from,
        address to,
        uint256 value // [rad]
    ) external {
        revert();
    }

    function accrueStabilityFee(
        bytes32 collateralPoolId,
        address stabilityFeeRecipient,
        int256 debtAccumulatedRate // [ray]
    ) external {
        revert();
    }

    function settleSystemBadDebt(uint256 value) external {
        revert();
    }

    function whitelist(address toBeWhitelistedAddress) external {
        revert();
    }

    function blacklist(address toBeBlacklistedAddress) external {
        revert();
    }

    function collateralToken(bytes32 collateralPoolId, address ownerAddress) external view returns (uint256) {
        revert();
    }

    function positionWhitelist(address positionAddress, address whitelistedAddress) external view returns (uint256) {
        revert();
    }

    function stablecoin(address ownerAddress) external view returns (uint256) {
        revert();
    }

    function positions(
        bytes32 collateralPoolId,
        address positionAddress
    )
        external
        view
        returns (
            uint256 lockedCollateral, // [wad]
            uint256 debtShare // [wad]
        ) {
        revert();
    }

    function systemBadDebt(address ownerAddress) external view returns (uint256) {
        revert();
    }

    function poolStablecoinIssued(bytes32 collateralPoolId) external view returns (uint256) {
        revert();
    }

    function collateralPoolConfig() external view returns (address) {
        revert();
    }

    function accessControlConfig() external view returns (address) {
        revert();
    }
}