// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;
library ToUint {
    function toUint(string memory _str) external pure returns(uint256 res, bool err) {
      for (uint256 i = 0; i < bytes(_str).length; i++) {
          if ((uint8(bytes(_str)[i]) - 48) < 0 || (uint8(bytes(_str)[i]) - 48) > 9) {
              return (0, true);
          }
          res += (uint8(bytes(_str)[i]) - 48) * 10**(bytes(_str).length - i - 1);
      }
      return (res, false);
  }
}

