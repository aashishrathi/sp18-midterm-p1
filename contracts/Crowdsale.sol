pragma solidity ^0.5.0;

import './Queue.sol';
import './Token.sol';

import './utils/SafeMath.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {
  address payable owner;
  uint256 startTime;
  uint256 endTime;
  uint256 totalSupply;
  uint256 tokensPerWei;
  uint256 tokensSold;

  Token private token;

  constructor (
    uint256 _startTime,
    uint256 _endTime,
    uint256 _initialSupply,
    uint256 _tokensPerWei
  ) public {
    owner = msg.sender;
    startTime = _startTime;
    endTime = _endTime;
    totalSupply = _initialSupply;
    tokensPerWei = _tokensPerWei;
    tokensSold = 0;

  }

  event TokensPurchased(address buyer, uint256 amount);
  event TokensRefunded(address buyer, uint256 amount);

  modifier ownerOnly() {
    require(msg.sender == owner);
    _;
  }

  modifier saleActive() {
    require(now >= startTime && now <= endTime);
    _;
  }

  function mintTokens(uint256 newAmount) public ownerOnly() {
    totalSupply = SafeMath.add(totalSupply, newAmount);
  }

  function burnTokens(uint256 burnAmount) public ownerOnly() {
    require(SafeMath.add(burnAmount, tokensSold) <= totalSupply);
    totalSupply = SafeMath.sub(totalSupply, burnAmount);
  }

  //TODO: Consider this vs selfdestruct
  function forwardFunds() public ownerOnly() {
    require(now > endTime){
      owner.transfer(address(this).balance);
    }
  }

  function buyTokens() external payable {
    require(msg.value > 0);
    uint256 tokens = msg.value * tokensPerWei;
    
    // Change balance in Token
    // update number of tokens sold
  }

  function refundTokens(uint256 amount) external {
    // Change balance in tokens
    // update refunds mapping
  }

  function withdrawRefund(uint256 amount) public {
    if(refunds[msg.sender] <= amount){
      require(msg.sender.transfer(amount));
      refunds[msg.sender] -= amount;
    }
  }



}
