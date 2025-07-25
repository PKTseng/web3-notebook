// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.12;

contract HelloWorld {
  string strVar = "default Hello world";
  struct Info {
    string phrase;
    uint256 id;
    address addr;
  }

  Info[] infos;
  mapping(uint256 id => Info info) infoMapping;

  function sayHello(uint256 _id) public view returns (string memory) {
    if (infoMapping[_id].addr == address(0x0)) {
      return addInfo(strVar);
    } else {
      return addInfo(infoMapping[_id].phrase);
    }
  }

  function setHelloWorld(string memory newString, uint256 _id) public {
    Info memory info = Info(newString, _id, msg.sender);
    infoMapping[_id] = info;
  }

  function addInfo(
    string memory helloWorldStr
  ) internal pure returns (string memory) {
    return string.concat(helloWorldStr, " from ken contract");
  }
}
