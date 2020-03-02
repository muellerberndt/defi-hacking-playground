pragma solidity ^0.5.0;

// ETH loans 200% collateralized with JesusToken

import 'openzeppelin-solidity/contracts/token/ERC20/IERC20.sol';
import 'openzeppelin-solidity/contracts/math/SafeMath.sol';

import "./IMiniSwapExchange.sol";

contract DefiLoans {

    using SafeMath for uint256;

    mapping(address => uint) public balances;
    mapping(address => uint) public loans;

    IMiniSwapExchange exchange;
    IERC20 token;

    constructor(address _exchange, address _token) public {
        exchange = IMiniSwapExchange(_exchange);
        token = IERC20(_token);
    }

    function lockCollateral(uint256 amount) public {
        require(token.transferFrom(msg.sender, address(this), amount));
        balances[msg.sender] = balances[msg.sender].add(amount);
    }
    function withdrawCollateral(uint256 amount) public {
        require(isCollateralSufficient(loans[msg.sender], balances[msg.sender].sub(amount)));
        token.transfer(msg.sender, amount);
    }
    
    function borrowEther(uint256 amount) public {
        loans[msg.sender] = loans[msg.sender].add(amount);
        require(isCollateralSufficient(loans[msg.sender], balances[msg.sender]));
        
        msg.sender.transfer(amount);
    }

    function repayEther() public payable {
        loans[msg.sender] = loans[msg.sender].sub(msg.value);
    }

    function minCollateral(uint256 eth_borrow) internal view returns (uint256) {
        // Minimum collateralization is 200%!
        return exchange.getTokenToEthOutputPrice(eth_borrow).mul(2);
    }    
    
    function isCollateralSufficient(uint256 eth_borrow, uint256 tokens) internal view returns (bool) {
        return (tokens >= minCollateral(eth_borrow));
    }

}
