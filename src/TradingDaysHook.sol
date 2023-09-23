// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import { Hooks } from "v4-core/libraries/Hooks.sol";
import { BaseHook } from "periphery-next/BaseHook.sol";
import { IPoolManager } from "v4-core/interfaces/IPoolManager.sol";
import { TradingDays, LibDateTime, HolidayCalendar, DaylightSavingsCalendar } from "./TradingDays.sol";
import { PoolKey } from "v4-core/types/PoolKey.sol";
import { VolLib } from "VolLib.sol";

/// @title TradingDaysHook
/// @author horsefacts <horsefacts@terminally.online>
/// @notice Need a break from the 24/7 crypto markets? This Uniswap v4 hook
///         reverts when markets are closed in New York, the greatest city in
///         the world and the only place where financial markets exist.
contract TradingDaysHook is BaseHook, TradingDays {
    using LibDateTime for uint256;

    /// @notice Ring the opening bell.
    event DingDingDing(address indexed ringer);

    VolLib volLib;

    /// @notice Year/month/day mapping recording whether the market opened.
    mapping(uint256 => mapping(uint256 => mapping(uint256 => bool))) public
        marketOpened;

    constructor(IPoolManager _poolManager, HolidayCalendar _holidays, DaylightSavingsCalendar _dst, address volLibAddress)
        BaseHook(_poolManager)
        TradingDays(_holidays, _dst)
    { volLib = VolLib(volLibAddress);}

    function getHooksCalls()
        public
        pure
        override
        returns (Hooks.Calls memory)
    {
        return Hooks.Calls({
            beforeInitialize: false,
            afterInitialize: false,
            beforeModifyPosition: false,
            afterModifyPosition: false,
            beforeSwap: true,
            afterSwap: false,
            beforeDonate: false,
            afterDonate: false
        });
    }

    function beforeSwap(
        address sender,
        IPoolManager.PoolKey calldata,
        IPoolManager.SwapParams calldata
    ) external returns (bytes4) {
        State s = state();

        if (s == State.OPEN) {
            _ringOpeningBell(sender);
        } else if (s == State.HOLIDAY) {
            revert ClosedForHoliday(getHoliday());
        } else if (s == State.WEEKEND) {
            revert ClosedForWeekend();
        } else if (s == State.AFTER_HOURS) {
            revert AfterHours();
        }

        uint volatility = VolLib.getVolByHours(PoolKey.poolAddress, 24);

        poolManager.getSlot0(IPoolManager.PoolKey);
        uint upperRange = volatility * //volatility * price
        uint lowerRange = volatility *
        uint balanceDelta = modifyPosition();

        return BaseHook.beforeSwap.selector;
    }

    /// @dev The first swap of the trading day rings the opening bell.
    function _ringOpeningBell(address ringer) internal {
        (uint256 year, uint256 month, uint256 day) = time().timestampToDate();
        // If the market already opened today, don't ring the bell again.
        if (marketOpened[year][month][day]) return;

        // Wow! You get to ring the opening bell!
        marketOpened[year][month][day] = true;
        emit DingDingDing(ringer);
    }

    function modifyPosition(PoolKey memory key, IPoolManager.ModifyPositionParams memory params) internal
    returns (BalanceDelta delta)
    {
        delta = abi.decode(poolManager.lock(abi.encode(CallbackData(msg.sender, key, params))), (BalanceDelta));
    }
}
