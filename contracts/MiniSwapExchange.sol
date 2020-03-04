pragma solidity ^0.5.0;

import 'openzeppelin-solidity/contracts/token/ERC20/IERC20.sol';
import 'openzeppelin-solidity/contracts/math/SafeMath.sol';

contract MiniSwapExchange {

    using SafeMath for uint256;
    
    address public token_address;   // address of the IERC20 token traded
    address public token;   // address of the ERC20 token traded

    uint256 private _totalSupply;
    mapping(address => uint) public balances;

    constructor(address token_addr) public {
        token = token_addr;
    }

    function tokenAddress() external view returns (address) {
        return token;
    }
    
    /*
    # @notice Deposit ETH and Tokens (self.token) at current ratio to mint UNI tokens.
    # @dev min_liquidity does nothing when total UNI supply is 0.
    # @param min_liquidity Minimum number of UNI sender will mint if total UNI supply is greater than 0.
    # @param max_tokens Maximum number of tokens deposited. Deposits max amount if total UNI supply is 0.
    */

    function addLiquidity(uint256 min_liquidity, uint256 max_tokens) external payable returns (uint256) {
        require(max_tokens > 0 && msg.value > 0);
        
        uint256 total_liquidity = _totalSupply;
        
        if (total_liquidity > 0) {
            require(min_liquidity > 0);
            uint256 eth_reserve = address(this).balance.sub(msg.value);
            uint256 token_reserve = IERC20(token).balanceOf(address(this));
            uint256 token_amount = msg.value.mul(token_reserve).div(eth_reserve).add(1);
            uint256 liquidity_minted = msg.value.mul(total_liquidity).div(eth_reserve);
            require(max_tokens >= token_amount && liquidity_minted >= min_liquidity);
            balances[msg.sender] += liquidity_minted;
            total_liquidity = total_liquidity + liquidity_minted;
            require(IERC20(token).transferFrom(msg.sender, address(this), token_amount));
            return liquidity_minted;
        } else {
            require(msg.value >= 1000000000);
            uint256 token_amount = max_tokens;
            uint256 initial_liquidity = address(this).balance;
            _totalSupply = initial_liquidity;
            balances[msg.sender] = initial_liquidity;
            require(IERC20(token).transferFrom(msg.sender, address(this), token_amount));
            return initial_liquidity;
        }
    }

    /*
    # @dev Burn UNI tokens to withdraw ETH and Tokens at current ratio.
    # @param amount Amount of UNI burned.
    # @param min_eth Minimum ETH withdrawn.
    # @param min_tokens Minimum Tokens withdrawn.
    # @param deadline Time after which this transaction can no longer be executed.
    # @return The amount of ETH and Tokens withdrawn.
    */

    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens) external returns (uint256, uint256) {
        uint256 total_liquidity = _totalSupply;
        require(total_liquidity > 0);
        uint256 token_reserve = IERC20(token).balanceOf(address(this));
        uint256 eth_amount = amount.mul(address(this).balance).div(total_liquidity);
        uint256 token_amount = amount.mul(token_reserve).div(total_liquidity);
        require(eth_amount >= min_eth && token_amount >= min_tokens);
        balances[msg.sender].sub(amount);
        _totalSupply = total_liquidity.sub(amount);
        msg.sender.transfer(eth_amount);
        require(IERC20(token).transfer(msg.sender, token_amount));
        return (eth_amount, token_amount);
    }

    function getInputPrice(uint256 input_amount, uint256 input_reserve, uint256 output_reserve) private pure returns (uint256) {
        require(input_reserve > 0 && output_reserve > 0);
        uint256 input_amount_with_fee = input_amount.mul(997);
        uint256 numerator = input_amount_with_fee.mul(output_reserve);
        uint256 denominator = (input_reserve.mul(1000)).add(input_amount_with_fee);
        return numerator / denominator;
    }

    /* @dev Pricing function for converting between ETH and Tokens.
    # @param output_amount Amount of ETH or Tokens being bought.
    # @param input_reserve Amount of ETH or Tokens (input type) in exchange reserves.
    # @param output_reserve Amount of ETH or Tokens (output type) in exchange reserves.
    # @return Amount of ETH or Tokens sold.
    */ 

    function getOutputPrice(uint256 output_amount, uint256 input_reserve, uint256 output_reserve) private pure returns (uint256) {
        require(input_reserve > 0 && output_reserve > 0);
        uint256 numerator = input_reserve.mul(output_amount).mul(1000);
        uint256 denominator = (output_reserve.sub(output_amount)).mul(997);
        return numerator.div(denominator);
    }

    function ethToTokenInput(uint256 eth_sold, uint256 min_tokens, address recipient) private returns (uint256) {
        require(eth_sold > 0 && min_tokens > 0);
        uint256 token_reserve = IERC20(token).balanceOf(address(this));
        uint256 tokens_bought = getInputPrice(eth_sold, address(this).balance.sub(eth_sold), token_reserve);
        require(tokens_bought >= min_tokens);
        require(IERC20(token).transfer(recipient, tokens_bought));
        return tokens_bought;
    }

    /*
    # @notice Convert ETH to Tokens.
    # @dev User specifies exact input (msg.value) and minimum output.
    # @param min_tokens Minimum Tokens bought.
    # @return Amount of Tokens bought.
    */
    function ethToTokenSwapInput(uint256 min_tokens) external payable returns (uint256) {
        return ethToTokenInput(msg.value, min_tokens, msg.sender);
    }
    
    function ethToTokenOutput(uint256 tokens_bought, uint256 max_eth, address payable buyer, address recipient) private returns (uint256) {
        require (tokens_bought > 0 && max_eth > 0);
        uint256 token_reserve = IERC20(token).balanceOf(address(this));
        uint256 eth_sold = getOutputPrice(tokens_bought, address(this).balance.sub(max_eth), token_reserve);
        // Throws if eth_sold > max_eth
        uint256 eth_refund = max_eth.sub(eth_sold, 'wei');
        if (eth_refund > 0) {
            buyer.transfer(eth_refund);
        }
        require(IERC20(token).transfer(recipient, tokens_bought));
        return eth_sold;
    }

    /*
    # @notice Convert ETH to Tokens.
    # @dev User specifies maximum input (msg.value) and exact output.
    # @param tokens_bought Amount of tokens bought.
    # @param deadline Time after which this transaction can no longer be executed.
    # @return Amount of ETH sold.
    */

    function ethToTokenSwapOutput(uint256 tokens_bought) external payable returns (uint256) {
        return ethToTokenOutput(tokens_bought, msg.value, msg.sender, msg.sender);
    }

    function tokenToEthInput(uint256 tokens_sold, uint256 min_eth, address buyer, address payable recipient) private returns (uint256) {
        require(tokens_sold > 0 && min_eth > 0);
        uint256 token_reserve = IERC20(token).balanceOf(address(this));
        uint256 eth_bought = getInputPrice(tokens_sold, token_reserve, address(this).balance);
        require(eth_bought >= min_eth);
        recipient.transfer(eth_bought);
        require(IERC20(token).transferFrom(buyer, address(this), tokens_sold));
        return eth_bought;
    }

    /*
    # @notice Convert Tokens to ETH.
    # @dev User specifies exact input and minimum output.
    # @param tokens_sold Amount of Tokens sold.
    # @param min_eth Minimum ETH purchased.
    # @param deadline Time after which this transaction can no longer be executed.
    # @return Amount of ETH bought.
    */

    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth) external returns (uint256) {
        return tokenToEthInput(tokens_sold, min_eth, msg.sender, msg.sender);
    }
    
    function tokenToEthOutput(uint256 eth_bought, uint256 max_tokens, address buyer, address payable recipient) private returns (uint256) {
        require(eth_bought > 0);
        uint256 token_reserve = IERC20(token).balanceOf(address(this));
        uint256 tokens_sold = getOutputPrice(eth_bought, token_reserve, address(this).balance);
        // tokens sold is always > 0
        require(max_tokens >= tokens_sold);
        recipient.transfer(eth_bought);
        require(IERC20(token).transferFrom(buyer, address(this), tokens_sold));
        return tokens_sold;
    }

    /*
    # @notice Convert Tokens to ETH.
    # @dev User specifies maximum input and exact output.
    # @param eth_bought Amount of ETH purchased.
    # @param max_tokens Maximum Tokens sold.
    # @param deadline Time after which this transaction can no longer be executed.
    # @return Amount of Tokens sold.
    */

    function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens) external returns (uint256) {
        return tokenToEthOutput(eth_bought, max_tokens, msg.sender, msg.sender);
    }
    
    /*
    # @notice Public price function for ETH to Token trades with an exact input.
    # @param eth_sold Amount of ETH sold.
    # @return Amount of Tokens that can be bought with input ETH.
    */

    function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256) {
        require(eth_sold > 0);
        uint256 token_reserve = IERC20(token).balanceOf(address(this));
        return getInputPrice(eth_sold, address(this).balance, token_reserve);
    }
    
    /*
    # @notice Public price function for ETH to Token trades with an exact output.
    # @param tokens_bought Amount of Tokens bought.
    # @return Amount of ETH needed to buy output Tokens.
    */
    
    function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256) {
        require(tokens_bought > 0);
        uint256 token_reserve = IERC20(token).balanceOf(address(this));
        uint256 eth_sold = getOutputPrice(tokens_bought, address(this).balance, token_reserve);
        return eth_sold;
    }

    /*
    # @notice Public price function for Token to ETH trades with an exact input.
    # @param tokens_sold Amount of Tokens sold.
    # @return Amount of ETH that can be bought with input Tokens.
    */

    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256) {
        require(tokens_sold > 0);
        uint256 token_reserve = IERC20(token).balanceOf(address(this));
        uint256 eth_bought = getInputPrice(tokens_sold, token_reserve, address(this).balance);
        return eth_bought;
    }

    /*
    # @notice Public price function for Token to ETH trades with an exact output.
    # @param eth_bought Amount of output ETH.
    # @return Amount of Tokens needed to buy output ETH.
    */
    
    function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256) {
        require(eth_bought > 0);
        uint256 token_reserve = IERC20(token).balanceOf(address(this));
        getOutputPrice(eth_bought, token_reserve, address(this).balance);
    }
    


    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }
        
    /* 
    # @notice Convert ETH to Tokens.
    # @dev User specifies exact input (msg.value).
    # @dev User cannot specify minimum output or deadline.
    */

    function balanceOf(address _owner) external view returns (uint256) {
        return balances[_owner];
    }
    
    function () payable external {
        ethToTokenInput(msg.value, 1, msg.sender);
    }
    
}

