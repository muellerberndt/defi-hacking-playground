pragma solidity ^0.5.0;

import './MiniSwapExchange.sol';

contract MiniSwapFactory {

  event ExchangeCreated(address addr);

  address[] public exchanges;

  // deploy a new contract

  function deploy(address _token) public returns(address)
  {
    address exchange = address(new MiniSwapExchange(_token));
    exchanges.push(exchange);
    emit ExchangeCreated(exchange);
    return exchange;
  }
}
