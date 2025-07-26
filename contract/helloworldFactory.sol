// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {HelloWorld} from "./test.sol";

contract HelloWorldFactory {
  HelloWorld hw;
  HelloWorld[] hwList;

  function createHelloWorld() public {
    hw = new HelloWorld();
    hwList.push(hw);
  }

  function getHelloWorldsByIndex(
    uint256 _index
  ) public view returns (HelloWorld) {
    return hwList[_index];
  }
}
