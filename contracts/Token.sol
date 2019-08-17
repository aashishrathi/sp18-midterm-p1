pragma solidity ^0.5.0;

import './interfaces/ERC20Interface.sol';
import './utils/SafeMath.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {
      mapping(address => uint256) private balances;
      mapping(address => mapping(address => uint256)) private allowances;

      function balanceOf(address _owner) view public returns (uint256 balance){
        balance = balances[_owner];
      }

      function transfer(address _to, uint256 _value) public returns (bool success){
        require(_to != address(0));
        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
        balances[_to] = SafeMath.add(balances[_to], _value);
        Transfer(msg.sender, _to, _value);
        return true;
      }

      function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(_from != address(0) && _to != address(0));
        allowances[msg.sender][_from] = SafeMath.sub(allowances[msg.sender][_from], _value);
        balances[_from] = SafeMath.sub(balances[_from], _value);
        balances[_to] = SafeMath.add(balances[_to], _value);
        Transfer(_from, _to, _value);
        return true;
      }

      function approve(address _spender, uint256 _value) public returns (bool success){
        require(_spender != address(0));
        allowances[_spender][msg.sender] = _value;
        Approval(msg.sender, _spender, _value);
      }

      function allowance(address _owner, address _spender) view public returns (uint256 remaining){
        remaining = allowances[_spender][_owner];
      }

      event Transfer(address indexed _from, address indexed _to, uint256 _value);
      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
