// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract VolLib {

  /// @notice Gets the standdevation given specified hours range from now
  /// @param _pool address of the pool
  /// @param _hoursToNow number of hours to calculate the volatility
  function getVolByHours(address _pool, uint32 _hoursToNow) public view returns (uint256 standardDeviation) {

    return 2;
  }
}
