// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// 在一定的時間內投資人要投資金額，在一定時間內達標的話項目方可以拿到金額，如果沒達標的話投資人可以自行取款

contract MilestoneBasedCrowdfunding {
  uint256 constant MINI_VALUE = 100 * 10 ** 18;
  mapping(address => uint256) public foundersToAmount;
  address projecter; // 項目方
  uint256 balance;

  uint256 deploymentTimestamp;
  uint256 lockTimestamp;

  constructor(address _projecter, uint256 _lockTimestamp) {
    projecter = _projecter;
    deploymentTimestamp = block.timestamp;
    lockTimestamp = _lockTimestamp;
  }

  modifier deadlineTime() {
    require(block.timestamp > deploymentTimestamp + lockTimestamp, unicode"時間未到");
    _;
  }

  // 投資
  function fund() public payable {
    require(msg.value > 0, "send more ETH");
    require(block.timestamp <= deploymentTimestamp + lockTimestamp, "time is end");
    require(balance < MINI_VALUE, unicode"已達標");

    foundersToAmount[msg.sender] = foundersToAmount[msg.sender] + msg.value;
    balance += msg.value;
  }

  // 退款
  function refund() public deadlineTime {
    require(balance < MINI_VALUE, "need more eth");

    (bool success, ) = payable(msg.sender).call{value: foundersToAmount[msg.sender]}("");
    require(success, "transfer fail");

    balance -= foundersToAmount[msg.sender];
    foundersToAmount[msg.sender] = 0;
  }

  // 提現
  function withdraw() public deadlineTime {
    require(balance >= MINI_VALUE, unicode"投資金額沒達標");
    require(msg.sender == projecter, "only projecter");

    (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
    require(success, "transfer fail");

    balance = 0; // 因為已經一次提完了所以是0
  }
}
