// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 初學者版本的 FundMe 合約
// 1.創建一個收款函數
// 2.記錄投資人並且查看
// 3.在鎖定期內，達到目標值，生產商可以提款
// 4.在鎖定期內，沒有達到目標值，投資人在鎖定以後退款

contract FundMe_Beginner {
  // 基本狀態變數
  address public owner; // 合約擁有者(生產商)
  uint public targetAmount; // 目標金額 (用 uint 簡化，等同於 uint256)
  uint public deadline; // 截止時間
  uint public totalRaised; // 已募集金額
  bool public fundingClosed; // 募資是否結束

  // 記錄每個投資人投了多少錢
  mapping(address => uint) public contributions;

  // 儲存所有投資人地址
  address[] public investors;

  // 建構函數 - 部署合約時執行
  constructor(uint _targetAmount, uint _durationInDays) {
    owner = msg.sender; // 部署合約的人就是擁有者
    targetAmount = _targetAmount;
    deadline = block.timestamp + (_durationInDays * 1 days); // 設定截止時間
    fundingClosed = false;
  }

  // 1. 收款函數 - 投資人調用此函數投錢
  function fund() public payable {
    // 檢查條件
    require(msg.value > 0, "Must send some money"); // 必須發送一些錢
    require(block.timestamp < deadline, "Funding period ended"); // 還沒到截止時間
    require(!fundingClosed, "Funding is closed"); // 募資還沒關閉

    // 如果是第一次投資，加入投資人列表
    if (contributions[msg.sender] == 0) {
      investors.push(msg.sender);
    }

    // 記錄投資金額
    contributions[msg.sender] += msg.value;
    totalRaised += msg.value;
  }

  // 2. 查看投資人資訊
  function getMyContribution() public view returns (uint) {
    return contributions[msg.sender]; // 查看自己投了多少錢
  }

  function getInvestorCount() public view returns (uint) {
    return investors.length; // 總投資人數量
  }

  function checkGoalReached() public view returns (bool) {
    return totalRaised >= targetAmount; // 檢查是否達到目標
  }

  function getTimeLeft() public view returns (uint) {
    if (block.timestamp >= deadline) {
      return 0; // 時間已到
    }
    return deadline - block.timestamp; // 剩餘時間(秒)
  }

  // 3. 生產商提款函數（達到目標時）
  function withdraw() public {
    require(msg.sender == owner, "Only owner can withdraw"); // 只有合約擁有者可以提款
    require(totalRaised >= targetAmount, "Goal not reached"); // 必須達到目標
    require(address(this).balance > 0, "No money to withdraw"); // 合約裡要有錢

    fundingClosed = true; // 關閉募資

    // 把所有錢都轉給合約擁有者
    payable(owner).transfer(address(this).balance);
  }

  // 4. 投資人退款函數（未達到目標時）
  function refund() public {
    require(block.timestamp >= deadline, "Funding period not ended"); // 募資期必須結束
    require(totalRaised < targetAmount, "Goal was reached, no refund"); // 必須沒達到目標
    require(contributions[msg.sender] > 0, "You didn't contribute"); // 必須有投資過

    uint refundAmount = contributions[msg.sender]; // 計算退款金額
    contributions[msg.sender] = 0; // 先設為0，避免重複提款

    // 退款給投資人
    payable(msg.sender).transfer(refundAmount);
  }

  // 輔助函數 - 查看合約餘額
  function getContractBalance() public view returns (uint) {
    return address(this).balance;
  }

  // 輔助函數 - 查看合約基本資訊
  function getContractInfo()
    public
    view
    returns (
      uint _targetAmount,
      uint _totalRaised,
      uint _deadline,
      uint _timeLeft,
      bool _goalReached,
      bool _fundingClosed
    )
  {
    return (targetAmount, totalRaised, deadline, getTimeLeft(), checkGoalReached(), fundingClosed);
  }

  // 允許直接向合約轉帳時自動調用 fund() 函數
  receive() external payable {
    fund();
  }
}
