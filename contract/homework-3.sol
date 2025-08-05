// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract SimpleDAO {
  address admin;
  address member;

  enum ProposalStatus {
    Voting,
    Approved,
    Rejected,
    Executed
  }

  struct Proposal {
    uint256 id;
    address addr;
    string descript;
    bool proposalCurrentStatus;
    uint256 vote;
    uint256 noVote;
  }
}
