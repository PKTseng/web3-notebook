// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract MilestoneBasedCrowdfunding {
  address manager;
  address contributor;

  struct Milestone {
    string description;
    uint256 amount;
    bool alreadyPay;
    uint256 votes;
  }

  Milestone[] milestoneList;
  mapping(uint256 => mapping(address => bool)) public milestoneVotes;

  uint256 deploymentTimestamp;
  uint256 lockTime;

  constructor(uint256 _lockTime) {
    lockTime = _lockTime;
  }

  modifier onlyManager() {
    require(msg.sender == manager, "only manager");
    _;
  }

  function addMilestone() public view onlyManager {
    // milestoneVotes.push()
  }

  function contribute() public payable {
    require(block.timestamp > deploymentTimestamp + lockTime, unicode"尚未到截止時間");
  }

  function requestWithdrawal() public view onlyManager {}

  function voteForMilestone() public view {
    require(msg.sender == contributor, "only contribute");
  }

  function executeWithdrawal() public view onlyManager {}
}
