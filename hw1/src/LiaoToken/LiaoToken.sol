// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    // internal: 合約內可以呼叫，不能從外部呼叫，繼承了這個合約的合約也能呼叫。
    // external: 合約內不能呼叫，只能從外部呼叫。
    // view: 只能讀取資料，而不能寫資料到鏈上
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// 一個 function 是 virtual 代表這個 function 可以在被繼承後改寫（override）。
// 一個 contract 如果包含了 virtual function，則必須被宣告為 abstract。
// 一個 function 是 override 代表這個 function 改寫了某個繼承下來的 virtual function。

contract LiaoToken is IERC20 {
    // private: 只有這個合約可以呼叫，繼承了這個合約的合約不能呼叫。
    mapping(address => uint256) private _balances;
    mapping(address => bool) private isClaim;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

// event 的功用是記錄事件的發生，以方便之後搜尋這些事件。
// 例如 ERC721 token 有定義 Transfer 這個 event，每當有人轉移 token，
// 合約就會發出一個 Transfer 記錄這次轉移的 from, to, tokenId，
// 日後只要收集全部的 Transfer event 記錄就能知道每個 token 過去的流向。

    event Claim(address indexed user, uint256 indexed amount);

    constructor(string memory name_, string memory symbol_) payable {
        _name = name_;
        _symbol = symbol_;
    }
    // public: 合約內可以呼叫，也能從外部呼叫，繼承了這個合約的合約也能呼叫。
    function decimals() public pure returns (uint8) {
        return 18;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function claim() external returns (bool) {
        if (isClaim[msg.sender]) revert();
        _balances[msg.sender] += 1 ether;
        _totalSupply += 1 ether;
        emit Claim(msg.sender, 1 ether);
        return true;
    }

    function transfer(address to, uint256 amount) external override returns (bool) {
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external override returns (bool) {
        uint allowance = _allowances[from][msg.sender];
        require(allowance >= value, "ERC20: transfer amount exceeds allowance");
        require(_balances[from] >= value, "ERC20: transfer amount exceeds balance");
        
        _balances[from] -= value;
        _balances[to] += value;
        _allowances[from][msg.sender] -= value;

        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }
}

// reference to https://hackmd.io/@rogerwutw/BJ3CoxkTK, chatgpt, gemini