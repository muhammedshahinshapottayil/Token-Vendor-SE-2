pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";
error Err__Transaction__Failed(uint256  time);
error Err__Insufficient__Balance(address owner);
error Err__Sell__Token__Failed(address owner);
error Err__Sell__Token__Transfer__Failed(address owner);

contract Vendor is Ownable {
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);
  YourToken public yourToken;
  // uint256 public constant tokensPerEth = 100;
  uint256 public immutable tokensPerEth;


  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
   tokensPerEth = (yourToken.totalSupply() / 1e18) / 10;
  }

  // ToDo: create a payable buyTokens() function:
function buyTokens() public payable {
        uint256 tokenAmount = msg.value * tokensPerEth;
        yourToken.transfer(msg.sender, tokenAmount);
        emit BuyTokens(msg.sender, msg.value, tokenAmount);
}

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
function withdraw() public onlyOwner {
 (bool success,)= payable(address(owner())).call{value:address(this).balance}("");
 if (!success)  revert Err__Transaction__Failed(block.timestamp); 
}

  // ToDo: create a sellTokens(uint256 _amount) function:
function sellTokens(uint256 _amount) public  {
  uint256 amount = yourToken.allowance(msg.sender, address(this));
  uint256 ethAmount = amount / tokensPerEth;
  if (amount > 0) {

 (bool status) = yourToken.transferFrom(msg.sender, address(this), _amount);
  if(!status)
  revert Err__Sell__Token__Transfer__Failed(msg.sender);

  (bool success,) = payable(address(msg.sender)).call{value : ethAmount}("");
  if(!success)
  revert Err__Sell__Token__Failed(msg.sender);

  emit SellTokens(msg.sender, amount, ethAmount);

  } else revert Err__Insufficient__Balance(msg.sender);
}







}
