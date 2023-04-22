pragma solidity ^0.5.0;

contract Hand {
    
    //enum handState { stationary, played}
    enum battleState {out_battle,in_battle}
    
    struct hand {
        uint8 number;
        //handState state;
        battleState bstate;
        uint256 creationValue;
        uint256 bet;
        address owner;
        address prevOwner;
        //uint256 luckyTimes;
    }

    //event rolling (uint256 diceId);
    event played (uint256 handId, uint8 number);
    event luckytimesEvent(uint handId,uint256 luckyTimes);
    uint256 public numHands = 0;
    mapping(uint256 => hand) public hands;

    //function to create a new hand, and add to 'dices' map. requires at least 0.01ETH to create
    function add(

    ) public payable returns(uint256) {
        require(msg.value > 0.01 ether, "at least 0.01 ETH is needed to get chance to play");
        //new dice object
        hand memory newHand = hand(
            0,
            //handState.stationary,
            battleState.out_battle,
            msg.value,
            0,
            msg.sender,  //owner
            address(0)
            //0
        );
        uint256 newHandId = numHands++;
        hands[newHandId] = newHand; //commit to state variable
        return newHandId;   //return new diceId
    }

    //modifier to ensure a function is callable only by its owner    
    modifier ownerOnly(uint256 handId) {
        require(hands[handId].owner == msg.sender);
        _;
    }
    
    modifier validHandId(uint256 handId) {
        require(handId < numHands);
        _;
    }

    //owner can roll a dice    
    function showHand(uint256 handId, uint8 number) public ownerOnly(handId) validHandId(handId) {
            // hands[handId].state = handState.played;    
            hands[handId].number = number;    //number will become 0 while rolling
            // emit played(handId, number); //emit rolled
    }

    function setBattleStatetoIn(uint256 handId) public validHandId(handId) {
            hands[handId].bstate = battleState.in_battle;    
    }

    function setBattleStatetoOut(uint256 handId) public validHandId(handId) {
            hands[handId].bstate = battleState.out_battle;    
    }
    function getBattleState(uint256 handId) public view validHandId(handId) returns (uint8){
            if(hands[handId].bstate == battleState.in_battle){
                return uint8(1);
            }else{
                return uint8(0);
            }
    }

    function setHandBet(uint256 handId, uint256 bet) public validHandId(handId) {
            //require(hands[handId].state == handState.stationary,"You can only set the bet of stationary hand");
            hands[handId].bet = bet;    //number will become 0 while rolling
    }
    
    //transfer ownership to new owner
    // function transfer(uint256 handId, address newOwner) public {
    //     require(hands[handId].owner == msg.sender,"You are not the owner.");
    //     // maybe because it was the contract that called this transfer.
    //     require(handId < numHands,"Your id is not valid.");
    //     hands[handId].prevOwner = hands[handId].owner;
    //     hands[handId].owner = newOwner;
    // }

    // function transferFrom(uint256 diceId, address oldOwner, address newOwner) public payable{
    //     dices[diceId].prevOwner = oldOwner;
    //     dices[diceId].owner = newOwner;
    // }

    //get number of sides of dice    
    function getHandNumber(uint256 handId) public view validHandId(handId) returns (uint8) {
        return hands[handId].number;
    }

    //get ether put in during creation
    function getHandValue(uint256 handId) public view validHandId(handId) returns (uint256) {
        return hands[handId].creationValue;
    }
    // function getluckyTimes(uint256 handId) public view validHandId(handId) returns (uint256){
    //     return hands[handId].luckyTimes;
    // }
    function destoryHand(uint handId) public ownerOnly(handId) validHandId(handId){
        address payable owner = address(uint160(hands[handId].owner));
        uint256 value = hands[handId].creationValue;
        delete hands[handId];
        numHands--;
        owner.transfer(value);
        // return ether to owner
    }
    // function transferFrom(uint256 handId, address oldOwner, address newOwner) public {
    //     hands[handId].prevOwner = oldOwner;
    //     hands[handId].owner = newOwner;
    // }
    function getHandOwner(uint256 handId) public view validHandId(handId) returns (address) {
        return hands[handId].owner;
    }
    function getPrevOwner(uint256 handId) public view validHandId(handId) returns (address) {
        return hands[handId].prevOwner;
    }
    function getBet(uint256 handId) public view validHandId(handId) returns (uint256) {
        return hands[handId].bet;
    }


}
