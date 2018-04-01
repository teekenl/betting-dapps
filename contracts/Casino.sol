pragma solidity ^0.4.20;

contract Casino {
   address public owner;
   uint256 public minimumBet;
   uint256 public totalBet;
   uint256 public numberOfBets;
   uint256 public randomNumber;
   uint256 public maxAmountOfBets = 10;
   address[] public players;
   
   struct Player {
     uint256 amountBet;
     uint256 numberSelected;
   }
   
   mapping(address => Player) playerInfo;
   
   function Casino(uint256 _minimumBet, uint256 _maxAmountOfBets) {
      owner = msg.sender;
      if (_minimumBet != 0) minimumBet = _minimumBet;
      if (_maxAmountOfBets != 0)maxAmountOfBets = _maxAmountOfBets;
   }
   
   function kill() public {
      if(msg.sender == owner) selfdestruct(owner);
   }
   
   function checkPlayerExists(address player) returns(bool) {
     for(uint256 i = 0;  i < players.length; i++) {
        if (players[i] == player) return true;
     }
     return false;
   }
   
   function bet(uint256 numberSelected) payable {
      require(!checkPlayerExists(msg.sender));
      require(numberSelected >= 1 && numberSelected <= 10);
      require(msg.value >= minimumBet);
      
      playerInfo[msg.sender].amountBet = msg.value;
      playerInfo[msg.sender].numberSelected = numberSelected;
      numberOfBets++;
      players.push(msg.sender);
      totalBet += msg.value;
      
      if (numberOfBets >= maxAmountOfBets) generatedWinner();
   }
   
   function generatedWinner() {
      randomNumber = block.number % 10 + 1;
      givePrize();
   }
   
   function givePrize() {
      address[100] memory winners;
      uint256 count = 0;
      
      for (uint256 i = 0; i < players.length; i++) {
        if (playerInfo[players[i]].numberSelected == randomNumber) {
          winners[count] = players[i];
        }
        delete playerInfo[players[i]];
      }
      
      players.length = 0;
      uint256 winningEthAmount = totalBet / winners.length;
      
      for (uint256 j = 0; j < count; j++) {
        if(winners[j] != address(0)) {
          winners[j].transfer(winningEthAmount);
        }
      }
      
      resetGame();
   }
   
   function resetGame() {
     players.length = 0;
     totalBet = 0;
     numberOfBets = 0;
   }
}