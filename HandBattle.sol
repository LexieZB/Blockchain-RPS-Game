pragma solidity ^0.5.0;

import "./Hand.sol";



contract HandBattle {
    Hand public handContract;
    mapping(address => address) battle_pair;
    
    // address payable public contractaddress;
    // address public _contractaddress;
    uint256 public winner = uint256(-1);
    address payable public ownerofContract;
    uint8 public showHand1;
    uint8 public showHand2;
    uint256 public Bet;
    uint256 public commissionFee = 1000000000000000000;
    // address _contractaddress;
    // address payable contractaddress;

    constructor(Hand handAddress) public payable{
        handContract = handAddress;
        //_contractaddress = address(this);
        //contractaddress=address(uint160(_contractaddress));
        ownerofContract=msg.sender;
    }

    modifier onlyContractOwner(){
        require(msg.sender == ownerofContract,"Only the contract owner can call this function");
        _;
    }


    function setBattlePair(address enemy) public {
        // Require that only prev owner can allow an enemy
        require(msg.sender!=enemy,"You can't choose yourself as enemy!");
        battle_pair[msg.sender]=enemy;
        battle_pair[enemy]=msg.sender;
        // Each player can only select one enemy

    }

    function putHandinBattle(uint256 hand) public payable{
        // commission fee fixed
        require(msg.value >= 2000000000000000000,"Not enough token (comissionFee=1, bet>=1)");
        require(msg.sender == handContract.getHandOwner(hand),"You are not the owner.");
        require(handContract.getHandNumber(hand)!=uint(0),"You must have show hand.");
        
        Bet = msg.value-commissionFee;
        handContract.setHandBet(hand,Bet);
        //require(Bet>=10000000000000000,"You need to set the bet to be more than 1 ether.");
        require(msg.value >= commissionFee+Bet,"Not enought token");
        handContract.setBattleStatetoIn(hand);

        // number is 1 of 2 of 3, rock or paper or scissor
        
        //handContract.transferFrom(hand,msg.sender,contractaddress);
        //ownerofContract.transfer(commissionFee);
        
        // payBet = handContract.getBet(hand);
        // address _contractaddress = address(this);
        // address payable contractaddress = address(uint160(_contractaddress));
        //contractaddress.transfer(payBet);
    }

    function handBattle(uint256 hand1, uint256 hand2) public payable{
        
        require(handContract.getBattleState(hand1) == uint(1),"You haven't put the hand into battle!");
        require(handContract.getBattleState(hand2) == uint(1),"You haven't put the hand into battle!");
        require(battle_pair[handContract.getHandOwner(hand1)] == handContract.getHandOwner(hand2),"You haven't select enemy as your enemy!");
        require(battle_pair[handContract.getHandOwner(hand2)]==handContract.getHandOwner(hand1),"Your enemy hasn't choose you as enemy!");
        showHand1 = handContract.getHandNumber(hand1);
        showHand2 = handContract.getHandNumber(hand2);
        address payable hand1Address = address(uint160(handContract.getHandOwner(hand1)));
        //hand1Address = address(uint160(_hand1Address));
        //_hand2Address = handContract.getHandOwner(hand2);
        address payable hand2Address = address(uint160(handContract.getHandOwner(hand2)));
        //hand2Address = address(uint160(_hand2Address));
        if (showHand1==showHand2){
            winner = uint256(-1);
        } else if (showHand1==1&&showHand2==3 ||
        showHand1==2&&showHand2==1||
        showHand1==3&&showHand2==2){
            winner = hand1;
            Bet = handContract.getBet(hand2);
            hand1Address.transfer(Bet);
            Bet = handContract.getBet(hand1);
            hand1Address.transfer(Bet);
        } else{
            winner = hand2;
            Bet =handContract.getBet(hand1);
            hand2Address.transfer(Bet);
            Bet =handContract.getBet(hand2);
            hand2Address.transfer(Bet);
        }
        handContract.setBattleStatetoOut(hand1);
        handContract.setBattleStatetoOut(hand2);
        battle_pair[handContract.getHandOwner(hand1)]=address(0);
        battle_pair[handContract.getHandOwner(hand2)]=address(0);

    }

    function withdraw() public payable onlyContractOwner{
        ownerofContract.transfer(commissionFee*2);
    }
    
}