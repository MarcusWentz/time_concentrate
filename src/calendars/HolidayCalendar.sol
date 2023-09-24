// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.15;

// /// @notice Data contract encoding NYSE holidays from 2023 to 2123. Each 13-byte
// ///         block encodes one year, consisting of 11 9-bit values, each
// ///         representing a month and day. Use HolidaysLibrary to decode.
// contract HolidayCalendar {
//     constructor() {
//         bytes memory data = (
//             hex"00" // STOP opcode
//             hex"0088605443af5a6e4925df3200" // 2023
//             hex"00845e533eaeda6e4915f33200" // 2024
//             hex"00846851492e9a6e490def3200" // 2025
//             hex"0084665041ae5a6e393deb3200" // 2026
//             hex"0084644f3d2fda4e5935e7319f" // 2027
//             hex"00006255472f5a6e4925df3200" // 2028
//             hex"00845e533f2f1a6e491ddb3200" // 2029
//             hex"00846a5249aeda6e4915f33200" // 2030
//             // 2031 - 2040
//             hex"0084685145ae9a6e490def3200008466503d2fda4e5935e7319f"
//             hex"0000625547af9a8e492de334000088605443af5a6e4925df3200"
//             hex"00845e533baf1a6e491ddb320000846a5245ae9a6e490def3200"
//             hex"0084665041ae5a6e393deb32000084644f4bafda4e5935e7319f"
//             hex"00006255442f9a8e492de33400008860543f2f1a6e491ddb3200"
//             // 2041 - 2050
//             hex"00846a5249aeda6e4915f3320000846851422e9a6e490def3200"
//             hex"008466503dae5a6e393deb32000084644f47af9a8e492de33400"
//             hex"0088605443af5a6e4925df320000845e533baf1a6e491ddb3200"
//             hex"00846a52462eda6e4915f332000084685141ae5a6e393deb3200"
//             hex"0084644f482fda4e5935e7319f00006255442f9a8e492de33400"
//             // 2051 - 2060
//             hex"008860543faf5a6e4925df320000845e5349aeda6e4915f33200"
//             hex"00846851422e9a6e490def3200008466503dae5a6e393deb3200"
//             hex"0084644f482fda4e5935e7319f000062553faf5a6e4925df3200"
//             hex"00845e534a2f1a6e491ddb320000846a52462eda6e4915f33200"
//             hex"008468513e2e9a6e490def320000846650482fda4e5935e7319f"
//             // 2061 - 2070
//             hex"00006255442f9a8e492de33400008860543c2f5a6e4925df3200"
//             hex"00845e5346af1a6e491ddb320000846a52422e9a6e490def3200"
//             hex"008466503dae5a6e393deb32000084644f44afda4e5935e7319f"
//             hex"0000625540af9a8e492de33400008860544a2f1a6e491ddb3200"
//             hex"00846a52462eda6e4915f33200008468513e2e9a6e490def3200"
//             // 2071 - 2080
//             hex"0084665048ae5a6e393deb32000084644f442f9a8e492de33400"
//             hex"008860543c2f5a6e4925df320000845e5346af1a6e491ddb3200"
//             hex"00846a5242aeda6e4915f332000084685148ae5a6e393deb3200"
//             hex"0084644f44afda4e5935e7319f0000625540af9a8e492de33400"
//             hex"008860544aaf5a6e4925df320000845e5342aeda6e4915f33200"
//             // 2081 - 2090
//             hex"008468513e2e9a6e490def32000084665048ae5a6e393deb3200"
//             hex"0084644f412fda4e5935e7319f000062553c2f5a6e4925df3200"
//             hex"00845e5346af1a6e491ddb320000846a523eaeda6e4915f33200"
//             hex"00846851492e9a6e490def32000084665044afda4e5935e7319f"
//             hex"0000625540af9a8e492de3340000886054472f5a6e4925df3200"
//             // 2091 - 2100
//             hex"00845e53432f1a6e491ddb320000846a523e2e9a6e490def3200"
//             hex"00846650452e5a6e393deb32000084644f412fda4e5935e7319f"
//             hex"000062554b2f9a8e492de334000088605446af1a6e491ddb3200"
//             hex"00846a523eaeda6e4915f3320000846851492e9a6e490def3200"
//             hex"00846650452e5a6e393deb32000084644f3d2fda4e5935e7319f"
//             // 2101 - 2110
//             hex"0000625547af9a8e492de334000088605443af5a6e4925df3200"
//             hex"00845e533baf1a6e491ddb320000846a5245ae9a6e490def3200"
//             hex"0084665041ae5a6e393deb32000084644f482fda4e5935e7319f"
//             hex"00006255442f9a8e492de33400008860543f2f1a6e491ddb3200"
//             hex"00846a5249aeda6e4915f3320000846851422e9a6e490def3200"
//             // 2111 - 2120
//             hex"008466503dae5a6e393deb32000084644f47af9a8e492de33400"
//             hex"008860543faf5a6e4925df320000845e534a2f1a6e491ddb3200"
//             hex"00846a52462eda6e4915f33200008468513dae5a6e393deb3200"
//             hex"0084644f482fda4e5935e7319f00006255442f9a8e492de33400"
//             hex"008860543c2f5a6e4925df320000845e53462eda6e4915f33200"
//             // 2121 - 2123
//             hex"00846851422e9a6e490def3200008466503dae5a6e393deb3200"
//             hex"0084644f44afda4e5935e7319f"
//         );
//         assembly {
//             return(add(data, 0x20), mload(data))
//         }
//     }
// }
