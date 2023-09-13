// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/AccessControl.sol";

interface IAccessControlConfig {
    function OWNER_ROLE() external view returns (bytes32);

    function GOV_ROLE() external view returns (bytes32);

    function PRICE_ORACLE_ROLE() external view returns (bytes32);

    function ADAPTER_ROLE() external view returns (bytes32);

    function LIQUIDATION_ENGINE_ROLE() external view returns (bytes32);

    function STABILITY_FEE_COLLECTOR_ROLE() external view returns (bytes32);

    function SHOW_STOPPER_ROLE() external view returns (bytes32);

    function POSITION_MANAGER_ROLE() external view returns (bytes32);

    function MINTABLE_ROLE() external view returns (bytes32);

    function BOOK_KEEPER_ROLE() external view returns (bytes32);

    function COLLATERAL_MANAGER_ROLE() external view returns (bytes32);
}

contract AccessControlConfigHack is IAccessControlConfig, AccessControl {
    bytes32 public override immutable OWNER_ROLE = DEFAULT_ADMIN_ROLE;
    bytes32 public override immutable GOV_ROLE = DEFAULT_ADMIN_ROLE;
    bytes32 public override immutable PRICE_ORACLE_ROLE = DEFAULT_ADMIN_ROLE;
    bytes32 public override immutable ADAPTER_ROLE = DEFAULT_ADMIN_ROLE;
    bytes32 public override immutable LIQUIDATION_ENGINE_ROLE = DEFAULT_ADMIN_ROLE;
    bytes32 public override immutable STABILITY_FEE_COLLECTOR_ROLE = DEFAULT_ADMIN_ROLE;
    bytes32 public override immutable SHOW_STOPPER_ROLE = DEFAULT_ADMIN_ROLE;
    bytes32 public override immutable POSITION_MANAGER_ROLE = DEFAULT_ADMIN_ROLE;
    bytes32 public override immutable MINTABLE_ROLE = DEFAULT_ADMIN_ROLE;
    bytes32 public override immutable BOOK_KEEPER_ROLE = DEFAULT_ADMIN_ROLE;
    bytes32 public override immutable COLLATERAL_MANAGER_ROLE = DEFAULT_ADMIN_ROLE;

    constructor () {
        _setupRole(OWNER_ROLE, msg.sender);
    }
}
