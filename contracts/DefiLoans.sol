pragma solidity ^0.5.0;

// ETH loans 200% collateralized with JesusToken

import 'openzeppelin-solidity/contracts/token/ERC20/IERC20.sol';
import 'openzeppelin-solidity/contracts/math/SafeMath.sol';

import "./IMiniSwapExchange.sol";

contract DefiLoans {

    IMiniSwapExchange exchange;
    IERC20 token;

    mapping(address => uint) public vaults;

    constructor(address _exchange, address _token) public {
        exchange = IMiniSwapExchange(_exchange);
        token = IERC20(_token);
    }
    
    /*
    function minCollateral(uint256 eth_borrow) internal view returns (uint256) {
        // Minimum collateralization is 200%!
        return _exchange.getTokenToEthOutputPrice(eth_borrow).mul(2);
    }    
    
    function hasSufficientCollateral(uint256 eth_borrow, address borrower) internal view returns (bool) {
        return (token_balances[borrower] >= minCollateral(eth_borrow));
    }

    function depositCollateral(uint256 amount) public {
        
        ether_balances[msg.sender] = ether_balances[msg.sender].add(eth_borrow);
    }

    function takeLoan(uint256 eth_borrow) public {
        require(hasEnoughCollateral(eth_borrow, msg.sender));
        
        ether_balances[msg.sender] = ether_balances[msg.sender].add(eth_borrow);
    }
    */
}
