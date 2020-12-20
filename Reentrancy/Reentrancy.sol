pragma solidity ^0.5.5;

contract kingOfCountry {
    address payable  public king;
    uint256 public price;
    constructor() public{
        price=1;
    }
    function becomeking() payable public {
        require(msg.value > 0);
        
        require(msg.value > price); // 付錢當國王
        king.transfer(price);   // 給前任補償
        king = msg.sender;      // 加冕新國王
        price = msg.value * 2;           // 付兩倍的錢當新國王
    }
}
