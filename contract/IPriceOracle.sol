// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// 1. 定义一个价格预言机的“接口”// 我们只关心它有一个叫 getLatestPrice 的函数，不关心它内部如何实现
interface IPriceOracle {
  function getLatestPrice() external view returns (uint);
}

// 2. 定义一个基础的、可被继承的“资产”合约// 它标记为 abstract，因为它有一个未实现的功能
abstract contract Asset {
  address public priceOracleAddress;

  constructor(address _oracleAddress) {
    priceOracleAddress = _oracleAddress;
  }

  // 这是一个已实现的功能，任何继承它的合约都可以用
  function getAssetPriceInUSD() public view returns (uint) {
    // 通过接口，我们可以安全地与外部预言机合约交互
    IPriceOracle oracle = IPriceOracle(priceOracleAddress);
    return oracle.getLatestPrice();
  }

  // 这是一个未实现的功能，留给子合约去定义
  function getAssetType() external pure virtual returns (string memory);
}

// 3. 创建一个具体的“以太币”合约，继承自 Asset
contract EtherAsset is Asset {
  // 子合约的构造函数需要调用父合约的构造函数
  constructor(address _oracleAddress) Asset(_oracleAddress) {}

  // 4. “重写”父合约中未实现的函数
  function getAssetType() external pure override returns (string memory) {
    return "Cryptocurrency - ETH";
  }
}
