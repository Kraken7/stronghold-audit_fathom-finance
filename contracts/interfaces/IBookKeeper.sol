// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.17;

interface IBookKeeper {
    function addCollateral(
        bytes32 collateralPoolId,
        address ownerAddress,
        int256 amount // [wad]
    ) external;

    function movePosition(bytes32 collateralPoolId, address src, address dst, int256 collateralAmount, int256 debtShare) external;

    function adjustPosition(
        bytes32 collateralPoolId,
        address positionAddress,
        address collateralOwner,
        address stablecoinOwner,
        int256 collateralValue,
        int256 debtShare
    ) external;

    function totalStablecoinIssued() external returns (uint256);

    function moveStablecoin(
        address src,
        address dst,
        uint256 value // [rad]
    ) external;

    function moveCollateral(
        bytes32 collateralPoolId,
        address src,
        address dst,
        uint256 amount // [wad]
    ) external;

    function confiscatePosition(
        bytes32 collateralPoolId,
        address positionAddress,
        address collateralCreditor,
        address stablecoinDebtor,
        int256 collateralAmount, // [wad]
        int256 debtShare // [wad]
    ) external;

    function mintUnbackedStablecoin(
        address from,
        address to,
        uint256 value // [rad]
    ) external;

    function accrueStabilityFee(
        bytes32 collateralPoolId,
        address stabilityFeeRecipient,
        int256 debtAccumulatedRate // [ray]
    ) external;

    function settleSystemBadDebt(uint256 value) external; // [rad]

    function whitelist(address toBeWhitelistedAddress) external;

    function blacklist(address toBeBlacklistedAddress) external;

    function collateralToken(bytes32 collateralPoolId, address ownerAddress) external view returns (uint256);

    function positionWhitelist(address positionAddress, address whitelistedAddress) external view returns (uint256);

    function stablecoin(address ownerAddress) external view returns (uint256);

    function positions(
        bytes32 collateralPoolId,
        address positionAddress
    )
        external
        view
        returns (
            uint256 lockedCollateral, // [wad]
            uint256 debtShare // [wad]
        );

    function systemBadDebt(address ownerAddress) external view returns (uint256); // [rad]

    function poolStablecoinIssued(bytes32 collateralPoolId) external view returns (uint256); // [rad]

    function collateralPoolConfig() external view returns (address);

    function accessControlConfig() external view returns (address);
}