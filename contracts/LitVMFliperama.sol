// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LitVMFliperama {
    struct Record {
        string nickname;
        uint256 score;
        address player;
        string message;
        uint256 timestamp;
    }

    Record[] public globalLeaderboard;
    mapping(address => string) public playerNicknames;
    
    uint256 public constant ENTRY_FEE = 0.0001 ether; // 0.0001 zkLTC
    address public owner;

    event PlayerRegistered(address indexed player, string nickname);
    event ScoreSubmitted(address indexed player, string nickname, uint256 score, string message);

    constructor() {
        owner = msg.sender;
    }

    function registerPlayer(string calldata _nickname) external payable {
        require(msg.value == ENTRY_FEE, "Required: Exactly 0.0001 zkLTC entry fee");
        require(bytes(_nickname).length > 0 && bytes(_nickname).length <= 15, "Nickname must be 1-15 chars");
        
        playerNicknames[msg.sender] = _nickname;
        emit PlayerRegistered(msg.sender, _nickname);
    }

    function submitScore(uint256 _score, string calldata _message) external {
        string memory nick = playerNicknames[msg.sender];
        require(bytes(nick).length > 0, "Must register your pilot nickname first");
        require(bytes(_message).length <= 50, "Message max length is 50 characters");

        globalLeaderboard.push(Record({
            nickname: nick,
            score: _score,
            player: msg.sender,
            message: _message,
            timestamp: block.timestamp
        }));

        emit ScoreSubmitted(msg.sender, nick, _score, _message);
    }

    function getLeaderboard() external view returns (Record[] memory) {
        return globalLeaderboard;
    }

    function withdrawFees() external {
        require(msg.sender == owner, "Only command center can withdraw");
        payable(owner).transfer(address(this).balance);
    }
}
