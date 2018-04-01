pragma solidity 0.4.20;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract Casino {
   address public owner;
   uint256 public minimumBet;
   uint256 public totalBet;
   uint256 public numberOfBets;
   uint256 public maxAmountOfBets = 100;
   address[] public players;
   
   struct Player {
     uint256 amountBet;
     uint256 numberSelected;
   }
   
   mapping(address => Player) public playerInfo;
   
   function Casino(uint256 _minimumBet) public {
      owner = msg.sender;
      if (_minimumBet != 0) minimumBet = _minimumBet;
   }
   
   function kill() public {
      if(msg.sender == owner) selfdestruct(owner);
   }
   
   function checkPlayerExists(address Player) {
     for(uint256 i = 0;  i < players.length; i++) {
        if (players[i] == player) return true;
     }
     return false;
   }
   
   function bet(uint256 numberSelected) public payable {
      require(!checkPlayerExists(msg.sender));
      require(numberSelected >= 1 && numberSelected <= 10);
      require(msg.value >= minimumBet);
      
      playerInfo[msg.sender].amountBet = msg.value;
      playerInfo[msg.sender].numberSelected = numberSelected;
      numberOfBets++;
      players.push(msg.sender);
      totalBet += msg.value;
   }
   
   function generatedWinner() public {
      uint256 randomNumber = block.number % 10 + 1;
      givePrize(randomNumber);
   }
   
   function givePrize(uint256 randomNumnber) {
      address[100] memory winners;
      uint256 count = 0;
      
      for (uint256 i = 0; i < players.length; i++) {
        if (playerInfo[players[i]].numberSelected == randomNumnber) {
          winners[count] = players[i];
        }
        delete playerInfo[players[i]];
      }
      
      players.length = 0;
      uint256 winningEthAmount = totalBet / winners.length;
      
      for (uint256 j = 0; j < count; j++) {
        if(winners[j] != address(0)) {
          winners[j].transfer(winnerEthAmount);
        }
      }
      
   }
}