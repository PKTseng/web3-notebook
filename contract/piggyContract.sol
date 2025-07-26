// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract test {
  uint256 public cash;
  uint256 public depositAmount;
  uint256 public unfreezeTime;

  address private owner;
  uint256 private constant freezeTime = 2 minutes;

  constructor() {
    owner = msg.sender;
    unfreezeTime = block.timestamp + freezeTime;
  }

  function deposit() external payable {
    require(msg.sender == owner, "not owner");
    require(msg.value > 0, "need more eth");

    uint256 amount = msg.value;
    uint256 splitAmount = amount / 2;

    depositAmount += splitAmount;
    cash += splitAmount;
  }

  function withdrawCash(uint256 amount) external {
    require(msg.sender == owner, "not owner");
    require(cash >= amount, "cash is not enough");

    cash -= amount;
    payable(msg.sender).transfer(amount);
  }

  function withdrawDeposit(uint256 amount) external {
    require(msg.sender == owner, "not owner");
    require(block.timestamp > unfreezeTime, "time is not ready");
    require(depositAmount >= amount, "cash is not enough");

    depositAmount -= amount;
    payable(msg.sender).transfer(amount);
  }

  function currentDt() external view returns (uint256) {
    return block.timestamp;
  }
}
