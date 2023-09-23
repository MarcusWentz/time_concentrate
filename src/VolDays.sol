// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {TradingDaysHook} from "./TradingDaysHook.sol";

contract VolDays is TradingDaysHook{

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
  ) external override returns (bytes4) {
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
      //todo else if its bot rebalancing time

      //

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

      //todo: or if its bots rebalancing time
  }

  //todo: implementation of getting volitility from oracle or other source.
  function getVol() internal returns(uint){
    return 5;
  }
}
