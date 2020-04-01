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
        require(token.transferFrom(msg.sender, address(this), amount), "lockCollateral: Call to transferFrom failed");
        balances[msg.sender] = balances[msg.sender].add(amount);
    }
    function withdrawCollateral(uint256 amount) public {
        require(isCollateralSufficient(loans[msg.sender], balances[msg.sender].sub(amount)), "withdrawCollateral: Insufficient collateral");
        token.transfer(msg.sender, amount);
    }

    function borrowEther(uint256 amount) public {
        loans[msg.sender] = loans[msg.sender].add(amount);
        require(isCollateralSufficient(loans[msg.sender], balances[msg.sender]),  "borrowEther: Insufficient collateral");

        msg.sender.transfer(amount);
    }

    function repayEther() public payable {
        loans[msg.sender] = loans[msg.sender].sub(msg.value);
    }

    function minCollateral(uint256 eth_borrowed) internal view returns (uint256) {
        /* Minimum collateralization is 200%!
        * We'll use the Exchange swap price function to determine how much ETH we would get
        * for the user's collateral.
        */
        return exchange.getTokenToEthOutputPrice(eth_borrowed).mul(2);
    }
    function isCollateralSufficient(uint256 eth_borrowed, uint256 borrower_token_balance) internal view returns (bool) {
        return (borrower_token_balance >= minCollateral(eth_borrowed));
    }

}
