// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract SimpleEscrow {
  address public buyer;
  address public seller;
  address public arbiter;

  constructor(address _seller, address _arbiter) {
    buyer = msg.sender;
    seller = _seller;
    arbiter = _arbiter;
  }

  function deposit() public payable {
    require(buyer == msg.sender, "only buyer");
    require(msg.value >= 0, unicode"請存錢");
    require(address(this).balance == 0, unicode"合約不能有錢");
  }

  function confirmReceived() public {
    require(buyer == msg.sender, "only buyer");

    (bool success, ) = payable(seller).call{value: address(this).balance}("");
    require(success, "transfer fail");
  }

  function dispute(bool _returnToBuyer) public {
    require(arbiter == msg.sender, "only arbiter");
    address recipient = _returnToBuyer ? buyer : seller;

    (bool success, ) = payable(recipient).call{value: address(this).balance}("");
    require(success, "transfer fail");

    // if (_returnToBuyer) {
    //   (bool success, ) = payable(buyer).call{value: address(this).balance}("");
    //   require(success, "transfer fail");
    // } else {
    //   (bool success, ) = payable(seller).call{value: address(this).balance}("");
    //   require(success, "transfer fail");
    // }
  }
}
