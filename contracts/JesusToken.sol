pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

contract JesusToken is ERC20, ERC20Detailed {

  constructor()
    ERC20Detailed("JesusToken", "HOLY", 18)
    public
  {
      _mint(msg.sender, 100000000);
  }
}