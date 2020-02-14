pragma solidity >=0.4.25 <0.7.0;

import "./ConvertLib.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

/*
smart contract déployé sur Ropsten : 0x31bfffe6a87f318127e8898a059fdda18613088e
*/

contract Token
{
    function totalSupply() public view returns (uint256 supply){}
    function balanceOf(address _owner) public view returns (uint256 balance){}
    function transfer(address _to, uint256 _value) public returns (bool success){}
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){}
    function approve(address _spender, uint256 _value) public returns (bool success){}
    function allowance(address _owner, address _spender) public view returns (uint256 remaining){}
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract StandardToken is Token
{
    function transfer(address _to, uint256 _value) public returns (bool success)
	{
        if(balances[msg.sender] >= _value && _value > 0)
		{
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
		else
		{
			return false;
		}
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
	{
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0)
		{
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);
            return true;
        }
		else
		{
			return false;
		}
    }

    function balanceOf(address _owner) public view returns (uint256 balance)
	{
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success)
	{
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining)
	{
      return allowed[_owner][_spender];
    }

	function totalSupply() public view returns (uint256 supply)
	{
		return totalSupply_;
	}

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256 public totalSupply_;
}

contract MetaCoin is StandardToken
{
	string public name;
    uint8 public decimals;
    string public symbol;
    string public version = 'v1.0';


    constructor() public
	{
        balances[msg.sender] = 1234567;
        totalSupply_ = 7654321;
        name = "MetaCoin";
        decimals = 0;
        symbol = "MTC";
    }

	function getBalanceInEth(address addr) public view returns(uint)
	{
		return ConvertLib.convert(balanceOf(addr),2);
	}
}
