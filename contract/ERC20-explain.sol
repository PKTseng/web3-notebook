// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 抽象合約 - 定義基本結構但不能直接部署
abstract contract Animal {
  string public name;

  constructor(string memory _name) {
    name = _name;
  }

  // virtual 函數 - 可以被重寫
  function makeSound() public view virtual returns (string memory) {
    return "Some generic animal sound";
  }

  // virtual 函數 - 提供默認實現
  function sleep() public pure virtual returns (string memory) {
    return "ZZZ...";
  }

  // 純虛函數 - 子合約必須實現
  function getSpecies() public pure virtual returns (string memory);
}

// 具體實現 1
contract Dog is Animal {
  constructor(string memory _name) Animal(_name) {}

  // 重寫 virtual 函數
  function makeSound() public pure override returns (string memory) {
    return "Woof! Woof!";
  }

  // 實現抽象函數
  function getSpecies() public pure override returns (string memory) {
    return "Canis lupus";
  }

  // sleep() 繼承默認實現，不需要重寫
}

// 具體實現 2
contract Cat is Animal {
  constructor(string memory _name) Animal(_name) {}

  // 重寫 virtual 函數
  function makeSound() public pure override returns (string memory) {
    return "Meow~";
  }

  // 重寫 virtual 函數，提供自定義實現
  function sleep() public pure override returns (string memory) {
    return "Purr... ZZZ...";
  }

  // 實現抽象函數
  function getSpecies() public pure override returns (string memory) {
    return "Felis catus";
  }
}

// ERC20 代幣的實際例子
abstract contract BaseToken {
  mapping(address => uint256) internal _balances;
  uint256 internal _totalSupply;
  string internal _name;
  string internal _symbol;

  constructor(string memory name_, string memory symbol_) {
    _name = name_;
    _symbol = symbol_;
  }

  // virtual 函數 - 子合約可以自定義小數位數
  function decimals() public view virtual returns (uint8) {
    return 18;
  }

  // virtual 函數 - 可以自定義轉帳邏輯
  function _transfer(address from, address to, uint256 amount) internal virtual {
    require(from != address(0), "Transfer from zero address");
    require(to != address(0), "Transfer to zero address");
    require(_balances[from] >= amount, "Insufficient balance");

    _balances[from] -= amount;
    _balances[to] += amount;
  }

  // 抽象函數 - 子合約必須實現
  function totalSupply() public view virtual returns (uint256);
}

// 具體的代幣實現
contract MyCustomToken is BaseToken {
  constructor() BaseToken("MyCustomToken", "MCT") {
    _totalSupply = 1000000 * 10 ** decimals();
    _balances[msg.sender] = _totalSupply;
  }

  // 自定義小數位數
  function decimals() public pure override returns (uint8) {
    return 6; // 使用 6 位小數而不是默認的 18 位
  }

  // 實現抽象函數
  function totalSupply() public view override returns (uint256) {
    return _totalSupply;
  }

  // 自定義轉帳邏輯 - 加入手續費
  function _transfer(address from, address to, uint256 amount) internal override {
    // 調用父合約的轉帳邏輯
    super._transfer(from, to, amount);

    // 額外的自定義邏輯
    // 例如：記錄轉帳事件、收取手續費等
  }
}
