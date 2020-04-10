pragma solidity ^0.5.0;

interface IFixedPriceTrader {

    function tokenWeiPrice() external view returns (uint256);
    function token() external view returns (address);
    function buyTokens() external payable;
    function sellTokens(uint256 numTokens) external;

}