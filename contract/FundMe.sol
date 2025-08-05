// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 1.創建一個收款函數
// 2.記錄投資人並且查看
// 3.在鎖定期內，達到目標值，生產商可以提款
// 4.在鎖定期內，沒有達到目標值，投資人在鎖定以後退款

contract FundMe {
  // 狀態變數
  address public owner; // 生產商(合約擁有者)
  uint256 public targetAmount; // 目標金額
  uint256 public lockTime; // 鎖定時間
  uint256 public deployTime; // 合約部署時間
  uint256 public totalFunded; // 總募資金額
  bool public goalReached; // 是否達到目標
  bool public fundingClosed; // 募資是否結束

  // 記錄投資人及其投資金額
  mapping(address => uint256) public funders;
  address[] public fundersList; // 投資人列表

  // 事件
  event FundReceived(address indexed funder, uint256 amount);
  event GoalReached(uint256 totalAmount);
  event WithdrawByOwner(uint256 amount);
  event RefundToFunder(address indexed funder, uint256 amount);

  // 修飾符
  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }

  modifier withinLockTime() {
    require(block.timestamp <= deployTime + lockTime, "Lock time has passed");
    _;
  }

  modifier afterLockTime() {
    require(block.timestamp > deployTime + lockTime, "Still within lock time");
    _;
  }

  modifier fundingActive() {
    require(!fundingClosed, "Funding is closed");
    _;
  }

  // 建構函數
  constructor(uint256 _targetAmount, uint256 _lockTimeInDays) {
    owner = msg.sender;
    targetAmount = _targetAmount;
    lockTime = _lockTimeInDays * 1 days; // 轉換為秒
    deployTime = block.timestamp;
    goalReached = false;
    fundingClosed = false;
  }

  // 1. 創建一個收款函數
  function fund() public payable fundingActive withinLockTime {
    require(msg.value > 0, "Must send some ETH");

    // 如果是新投資人，加入列表
    if (funders[msg.sender] == 0) {
      fundersList.push(msg.sender);
    }

    // 記錄投資金額
    funders[msg.sender] += msg.value;
    totalFunded += msg.value;

    emit FundReceived(msg.sender, msg.value);

    // 檢查是否達到目標
    if (totalFunded >= targetAmount && !goalReached) {
      goalReached = true;
      emit GoalReached(totalFunded);
    }
  }

  // 2. 記錄投資人並且查看
  function getFunderAmount(address _funder) public view returns (uint256) {
    return funders[_funder];
  }

  function getFundersCount() public view returns (uint256) {
    return fundersList.length;
  }

  function getAllFunders()
    public
    view
    returns (address[] memory, uint256[] memory)
  {
    uint256[] memory amounts = new uint256[](fundersList.length);
    for (uint256 i = 0; i < fundersList.length; i++) {
      amounts[i] = funders[fundersList[i]];
    }
    return (fundersList, amounts);
  }

  function getContractInfo()
    public
    view
    returns (
      uint256 _targetAmount,
      uint256 _totalFunded,
      uint256 _lockTime,
      uint256 _timeLeft,
      bool _goalReached,
      bool _fundingClosed
    )
  {
    uint256 timeLeft = 0;
    if (block.timestamp <= deployTime + lockTime) {
      timeLeft = deployTime + lockTime - block.timestamp;
    }

    return (
      targetAmount,
      totalFunded,
      lockTime,
      timeLeft,
      goalReached,
      fundingClosed
    );
  }

  // 3. 在鎖定期內，達到目標值，生產商可以提款
  function withdrawByOwner() public onlyOwner withinLockTime {
    require(goalReached, "Goal not reached yet");
    require(address(this).balance > 0, "No funds to withdraw");

    uint256 amount = address(this).balance;
    fundingClosed = true;

    // 轉帳給生產商
    (bool success, ) = payable(owner).call{value: amount}("");
    require(success, "Transfer failed");

    emit WithdrawByOwner(amount);
  }

  // 4. 在鎖定期內，沒有達到目標值，投資人在鎖定以後退款
  function refund() public afterLockTime {
    require(!goalReached, "Goal was reached, no refund available");
    require(funders[msg.sender] > 0, "No funds to refund");

    uint256 refundAmount = funders[msg.sender];
    funders[msg.sender] = 0; // 防止重複提款

    // 轉帳給投資人
    (bool success, ) = payable(msg.sender).call{value: refundAmount}("");
    require(success, "Refund failed");

    emit RefundToFunder(msg.sender, refundAmount);
  }

  // 生產商也可以批量退款給所有投資人（在未達標情況下）
  function refundAll() public onlyOwner afterLockTime {
    require(!goalReached, "Goal was reached, no refund available");

    for (uint256 i = 0; i < fundersList.length; i++) {
      address funder = fundersList[i];
      uint256 refundAmount = funders[funder];

      if (refundAmount > 0) {
        funders[funder] = 0;
        (bool success, ) = payable(funder).call{value: refundAmount}("");
        if (success) {
          emit RefundToFunder(funder, refundAmount);
        }
      }
    }

    fundingClosed = true;
  }

  // 緊急函數：生產商可以暫停募資
  function emergencyStop() public onlyOwner {
    fundingClosed = true;
  }

  // 查看合約餘額
  function getContractBalance() public view returns (uint256) {
    return address(this).balance;
  }

  // 允許合約接收ETH
  receive() external payable {
    fund();
  }

  fallback() external payable {
    fund();
  }
}
