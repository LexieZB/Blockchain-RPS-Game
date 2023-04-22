pragma solidity ^0.5.0;

import "./Hand.sol";



contract HandMachineBattle {
    Hand public handContract;

    uint256 public winner = uint256(-1);
    address payable public ownerofContract;
    uint public showHand1;
    uint public showHand2;
    uint256 public Bet;
    uint256 public commissionFee = 1000000000000000000;
    //uint256 private nonce1 = 1;


    constructor(Hand handAddress) public payable{
        handContract = handAddress;
        ownerofContract=msg.sender;
    }

    function random(uint number) public view returns(uint){
        return ((uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % number)%3+1);
    }


    function putHandinBattle(uint256 hand) public payable{
        // commission fee fixed
        require(msg.value >= 20000000000000000,"Not enough token (comissionFee=1, bet>=1");
        require(msg.sender == handContract.getHandOwner(hand),"You are not the owner.");
        require(handContract.getHandNumber(hand)!=uint(0),"You must have show hand.");
        
        Bet = msg.value-commissionFee;
        handContract.setHandBet(hand,Bet);
        //require(Bet>=10000000000000000,"You need to set the bet to be more than 1 ether.");
        require(msg.value >= commissionFee+Bet,"Not enought token");
        handContract.setBattleStatetoIn(hand);
    }

    function handBattle(uint256 hand1) public payable{
        require(handContract.getBattleState(hand1) == uint(1),"You haven't put the hand into battle!");
        showHand1 = handContract.getHandNumber(hand1);
        //showHand2 = generateRandomNumber(nonce1);
        //generateRandomNumber(nonce1);
        showHand2 = random(4);
        //nonce1++;
        address payable hand1Address = address(uint160(handContract.getHandOwner(hand1)));

        if (showHand1==showHand2){
            winner = uint256(-1);
        } else if (showHand1==1&&showHand2==3 ||
        showHand1==2&&showHand2==1||
        showHand1==3&&showHand2==2){
            winner = hand1;
            Bet = handContract.getBet(hand1);
            // hand1Address.transfer(Bet);
            // Bet = handContract.getBet(hand1);
            hand1Address.transfer(Bet);
        } else{
        }
    }
    function withdraw() public payable onlyContractOwner{
        ownerofContract.transfer(commissionFee*2);
    }
}