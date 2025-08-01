// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract SimpleEscrow {
  address buyer;
  address seller;
  address arbiter;

  constructor(address _seller, address _arbiter) {
    buyer = msg.sender;
    seller = _seller;
    arbiter = _arbiter;
  }

  modifier onlyBuyer() {
    require(buyer == msg.sender, "only buyer");
    _;
  }

  function deposit() public payable onlyBuyer {
    require(msg.value > 0, "send more eth");
    require(address(this).balance == msg.value, "clear contract eth");
  }

  function confirmReceived() public onlyBuyer {
    (bool success, ) = payable(seller).call{value: address(this).balance}("");
    require(success, "transfer fail");
  }

  function dispute(bool _refundToBuyer) public {
    require(arbiter == msg.sender, "only arbiter");
    address recipient = _refundToBuyer ? buyer : seller;

    (bool success, ) = payable(recipient).call{value: address(this).balance}("");
    require(success, "transfer fail");
  }
}
