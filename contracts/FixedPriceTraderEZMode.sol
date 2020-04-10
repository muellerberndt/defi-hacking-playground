pragma solidity ^0.5.0;

// Buys and sells tokens for a fixed price!

import 'openzeppelin-solidity/contracts/token/ERC20/IERC20.sol';
import 'openzeppelin-solidity/contracts/math/SafeMath.sol';
import './IFixedPriceTrader.sol';

contract FixedPriceTraderEZMode is IFixedPriceTrader {

    using SafeMath for uint256;

    IERC20 public token;
    uint256 public tokenWeiPrice;
    uint256 private totalPrice;

    constructor(address _token, uint256 _tokenWeiPrice) public payable {
    	token = IERC20(_token);
 
        tokenWeiPrice = _tokenWeiPrice;
    	totalPrice = 1000 * _tokenWeiPrice;
    }

    function buyTokens() external payable {
    	require(msg.value == totalPrice, "Incorrect wei amount for purchase");

    	require(token.transfer(msg.sender, 1000), "Token transfer failed");
    }

    function sellTokens(uint256 numTokens) external {
        require(numTokens == 1000, "Invalid number of tokens");
    	require(token.transferFrom(msg.sender, address(this), 1000), "Token retrieval via transferFrom failed.");
    	msg.sender.transfer(totalPrice);
    }

    function () external payable {
    }

}