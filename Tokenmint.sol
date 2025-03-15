// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Token {
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowance;
    uint public totalSupply = 0;  // Começa com zero moedas
    uint public immutable maxSupply = 10000 * 10 ** 18; // Limite máximo de 10.000 tokens
    string public name = "Nome do Token";
    string public symbol = "TKN";
    uint public decimals = 18;
    address public owner;

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Apenas o dono pode executar essa acao");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function balanceOf(address account) public view returns (uint) {
        return balances[account];
    }

    function transfer(address to, uint value) public returns (bool) {
        require(balances[msg.sender] >= value, "Saldo insuficiente");
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) public returns (bool) {
        require(balances[from] >= value, "Saldo insuficiente");
        require(allowance[from][msg.sender] >= value, "Sem permissao suficiente");

        balances[from] -= value;
        balances[to] += value;
        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    // Permite mintar até o máximo de maxSupply
    function mint(uint amount) public onlyOwner {
        uint amountInWei = amount * (10 ** decimals);
        require(totalSupply + amountInWei <= maxSupply, "Max Supply atingido");

        totalSupply += amountInWei;
        balances[owner] += amountInWei;
        emit Transfer(address(0), owner, amountInWei);
    }
}
