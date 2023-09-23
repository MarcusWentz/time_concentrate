// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { TradingDaysHook, HolidayCalendar, DaylightSavingsCalendar } from "../TradingDaysHook.sol";

import { BaseHook } from "periphery-next/BaseHook.sol";
import { IPoolManager } from
    "v4-core/interfaces/IPoolManager.sol";
import { Hooks } from "v4-core/libraries/Hooks.sol";

contract TradingDaysImplementation is TradingDaysHook {
    constructor(
        IPoolManager poolManager,
        HolidayCalendar calendar,
        DaylightSavingsCalendar dst,
        TradingDaysHook addressToEtch
    ) TradingDaysHook(poolManager, calendar, dst) {
        Hooks.validateHookAddress(addressToEtch, getHooksCalls());
    }

    // make this a no-op in testing
    function validateHookAddress(BaseHook _this) internal pure override { }
}
