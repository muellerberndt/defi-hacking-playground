pragma solidity ^0.5.0;

interface IDefiLoans {

    function lockCollateral(uint256 amount) external;
    function withdrawCollateral(uint256 amount) external;
    function borrowEther(uint256 amount) external;
    function repayEther() external payable;

}
