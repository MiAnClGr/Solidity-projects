// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;


interface ERC20Interface {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint);
    function totalSupply() external view returns (uint);

    function balanceOf(address tokenOwner) external view returns (uint balance);
    function transfer(address to, uint tokens) external returns (bool success);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract simpleToken is ERC20Interface {

    string override public name;
    string override public symbol;

    uint override public decimals;
    uint override public totalSupply;

    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowed;

    address public owner;

    constructor() {
        name = 'simpleToken';
        symbol = 'SIMPLE';
        decimals = 0;
        totalSupply = 1000000;
        owner = msg.sender;
        balances[msg.sender] = totalSupply;
    }


    function balanceOf(address tokenOwner) override public view returns(uint) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) override public returns(bool) {
        require(balances[msg.sender] >= tokens);

        balances[msg.sender] -= tokens;
        balances[to] += tokens;

        emit Transfer(msg.sender, to, tokens);

        return true;
    }

    function allowance(address tokenOwner, address spender) override public view returns(uint){
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) override public returns(bool) {
        require(balances[spender] >= tokens);

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;
    }

    function transferFrom(address from, address to, uint tokens) override public returns(bool) {
        require(balances[from] >= tokens);
        require(allowed[from][to] >= tokens);

        balances[from] -= tokens;
        balances[to] += tokens;
        allowed[from][to] -= tokens;

        emit Transfer(from, to, tokens);

        return true;


    }
    




    
}
