pragma solidity ^0.5.0;

interface IMiniSwapExchange {
    // Address of ERC20 token sold on this exchange
    function tokenAddress() external view returns (address token);
    // Provide Liquidity
    function addLiquidity(uint256 min_liquidity, uint256 max_tokens) external payable returns (uint256);
    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens) external returns (uint256, uint256);
    // Get Prices
    function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256);
    function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256);
    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256);
    function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256);
    // Trade ETH to ERC20
    function ethToTokenSwapInput(uint256 min_tokens) external payable returns (uint256);
    function ethToTokenSwapOutput(uint256 tokens_bought) external payable returns (uint256);
    // Trade ERC20 to ETH
    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth) external returns (uint256);
    function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens) external returns (uint256);

    function balanceOf(address _owner) external view returns (uint256);
    function totalSupply() external view returns (uint256);
}