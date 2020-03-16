# Defi Hacking Playground

This is a collection of DeFi legos that can be used to build test scenarios for multi-contract arbitrage and bug detection.

## All the legos

- [JesusCoin ERC20 token](contracts/JesusCoin.sol)
- [MiniSwap: ETH/token exchange that uses the constant product pricing model](contracts/MiniSwapExchange.sol)
  - [Interface](contracts/IMiniSwapExchange.sol)
- [DefiLoans: Broken zero-interest collaterlised loans](contracts/DefiLoans.sol)

## Usage

Use [Truffle scripts](https://www.trufflesuite.com/docs/truffle/getting-started/writing-external-scripts) to set up test scenarios.
