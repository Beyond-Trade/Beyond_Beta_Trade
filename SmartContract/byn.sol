pragma solidity ^0.5.17;

library SafeMath
{
  function add(uint256 a, uint256 b) internal pure returns (uint256)
  {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Variable
{
  string public name;
  string public symbol;
  uint256 public decimals;
  uint256 public totalSupply;
  address public owner;

  uint256 internal _decimals;
  bool internal transferLock;
  
  mapping (address => bool) public allowedAddress;
  mapping (address => bool) public blockedAddress;

  mapping (address => uint256) public balanceOf;

  constructor() public
  {
    name = "Beyond Finance";
    symbol = "BYN";
    decimals = 18;
    _decimals = 10 ** uint256(decimals);
    totalSupply = _decimals * 100000000;
    transferLock = true;
    owner =  msg.sender;
    balanceOf[owner] = totalSupply;
    allowedAddress[owner] = true;
  }
}

contract Modifiers is Variable
{
  modifier isOwner
  {
    assert(owner == msg.sender);
    _;
  }
}

contract Event
{
  event Transfer(address indexed from, address indexed to, uint256 value);
  event TokenBurn(address indexed from, uint256 value);
  event TokenAdd(address indexed from, uint256 value);
  event Deposit(address _sender, uint256 amount);
}

contract manageAddress is Variable, Modifiers, Event
{
  function add_allowedAddress(address _address) public isOwner
  {
    allowedAddress[_address] = true;
  }
  function delete_allowedAddress(address _address) public isOwner
  {
    require(_address != owner);
    allowedAddress[_address] = false;
  }
  function add_blockedAddress(address _address) public isOwner
  {
    require(_address != owner);
    blockedAddress[_address] = true;
  }
  function delete_blockedAddress(address _address) public isOwner
  {
    blockedAddress[_address] = false;
  }
}
contract Admin is Variable, Modifiers, Event
{
  function admin_tokenBurn(uint256 _value) public isOwner returns(bool success)
  {
    require(balanceOf[msg.sender] >= _value);
    balanceOf[msg.sender] -= _value;
    totalSupply -= _value;
    emit TokenBurn(msg.sender, _value);
    return true;
  }
  function admin_tokenAdd(uint256 _value) public isOwner returns(bool success)
  {
    balanceOf[msg.sender] += _value;
    totalSupply += _value;
    emit TokenAdd(msg.sender, _value);
    return true;
  }
}
contract Get is Variable, Modifiers
{
  function get_transferLock() public view returns(bool)
  {
    return transferLock;
  }
  function get_blockedAddress(address _address) public view returns(bool)
  {
    return blockedAddress[_address];
  }
}

contract Set is Variable, Modifiers, Event
{
  function setTransferLock(bool _transferLock) public isOwner returns(bool success)
  {
    transferLock = _transferLock;
    return true;
  }
}

contract BYN is Variable, Event, Get, Set, Admin, manageAddress
{
  using SafeMath for uint256;

  function() external payable
  {
    emit Deposit(msg.sender, msg.value);
  }
    
  function withdraw() public isOwner
  {
    msg.sender.transfer(address(this).balance);
  }
  
  function transfer(address _to, uint256 _value) public
  {
    require(allowedAddress[msg.sender] || transferLock == false);
    require(!blockedAddress[msg.sender] && !blockedAddress[_to]);
    require(balanceOf[msg.sender] >= _value && _value > 0);
    require((balanceOf[_to].add(_value)) >= balanceOf[_to] );
    
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
  }
}