// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/// @title Minimal ERC-20 Token (improved)
/// @notice Simple ERC-20 implementation for learning / assignment
contract MyERC20 {
    // ERC-20 state
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /// @notice Constructor mints `initialSupply * 10**decimals` tokens to deployer
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;

        totalSupply = _initialSupply * (10 ** uint256(decimals));
        balanceOf[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    /// @notice Internal transfer function to reduce code repetition
    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0), "transfer to zero address");
        require(balanceOf[_from] >= _value, "insufficient balance");

        unchecked {
            balanceOf[_from] -= _value;
            balanceOf[_to] += _value;
        }

        emit Transfer(_from, _to, _value);
    }

    /// @notice Transfer tokens to another address
    function transfer(address _to, uint256 _value) public returns (bool) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    /// @notice Approve `_spender` to spend `_value` on behalf of msg.sender
    function approve(address _spender, uint256 _value) public returns (bool) {
        require(_spender != address(0), "approve to zero address");
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /// @notice Safely increase allowance
    function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
        require(_spender != address(0), "increaseAllowance to zero address");
        allowance[msg.sender][_spender] += _addedValue;
        emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
        return true;
    }

    /// @notice Safely decrease allowance
    function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
        require(_spender != address(0), "decreaseAllowance to zero address");
        uint256 currentAllowance = allowance[msg.sender][_spender];
        require(currentAllowance >= _subtractedValue, "decreased allowance below zero");
        unchecked {
            allowance[msg.sender][_spender] -= _subtractedValue;
        }
        emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
        return true;
    }

    /// @notice Transfer from `_from` to `_to` using allowance mechanism
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(allowance[_from][msg.sender] >= _value, "allowance exceeded");
        unchecked {
            allowance[_from][msg.sender] -= _value;
        }
        _transfer(_from, _to, _value);
        return true;
    }
}
