pragma solidity ^0.5.0;

interface IFixedPriceTrader {

    function buyTokens() external payable;
    function sellTokens(uint256 numTokens) external;

}