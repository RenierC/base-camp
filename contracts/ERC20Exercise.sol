// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WeightedVoting is ERC20 {
    uint maxSupply = 1_000_000;
    uint issuesCreated;
    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint quorumAmount);
    error AlreadyVoted();
    error VotingClosed();
    mapping(address => bool) private claims;

    using EnumerableSet for EnumerableSet.AddressSet;

    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint votesFor;
        uint votesAgainst;
        uint votesAbstain;
        uint totalVotes;
        uint quorum;
        bool isPassed;
        bool isClosed;
    }

    struct IssueView {
        address[] voters;
        string issueDesc;
        uint votesFor;
        uint votesAgainst;
        uint votesAbstain;
        uint totalVotes;
        uint quorum;
        bool isPassed;
        bool isClosed;
    }

    Issue[] private issues;

    enum Votes {
        AGAINST,
        FOR,
        ABSTAIN
    }

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) {
        Issue storage newIssue = issues.push();

        newIssue.issueDesc = "burnt";
        newIssue.votesFor = 0;
        newIssue.votesAgainst = 0;
        newIssue.votesAbstain = 0;
        newIssue.totalVotes = 0;
        newIssue.quorum = 0;
        newIssue.isPassed = false;
        newIssue.isClosed = true;
    }

    function claim() public {
        if (claims[msg.sender]) {
            revert TokensClaimed();
        }
        if (totalSupply() >= maxSupply) {
            revert AllTokensClaimed();
        }
        claims[msg.sender] = true;
        _mint(msg.sender, 100);
    }

    function createIssue(
        string calldata _description,
        uint _quorum
    ) public returns (uint) {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }
        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(_quorum);
        }

        Issue storage newIssue = issues.push();
        newIssue.issueDesc = _description;
        newIssue.quorum = _quorum;

        issuesCreated++;
        return issuesCreated;
    }

    function getIssue(uint _id) public view returns (IssueView memory) {
        Issue storage issue = issues[_id];
        return
            IssueView({
                voters: issue.voters.values(),
                issueDesc: issue.issueDesc,
                quorum: issue.quorum,
                totalVotes: issue.totalVotes,
                votesFor: issue.votesFor,
                votesAgainst: issue.votesAgainst,
                votesAbstain: issue.votesAbstain,
                isPassed: issue.isPassed,
                isClosed: issue.isClosed
            });
    }

    function vote(uint _issueId, Votes _vote) public {
        Issue storage issue = issues[_issueId];

        if (issue.isClosed) {
            revert VotingClosed();
        }
        if (issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }

        uint votingPower = balanceOf(msg.sender);

        if (_vote == Votes.AGAINST) {
            issue.votesAgainst += votingPower;
        }
        if (_vote == Votes.FOR) {
            issue.votesFor += votingPower;
        }
        if (_vote == Votes.ABSTAIN) {
            issue.votesAbstain += votingPower;
        }

        issue.voters.add(msg.sender);
        issue.totalVotes += votingPower;

        if (issue.totalVotes >= issue.quorum) {
            issue.isClosed = true;
            if (issue.votesFor > issue.votesAgainst) {
                issue.isPassed = true;
            }
        }
    }
}
