// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract LeoToken is ERC20 {
    string public constant _name = "Leo";
    string public constant _symbol = "LEO";

    mapping(address => bool) public allowedUsers;
    address public owner;

    enum Tier { Other, Builder, Master }
    mapping(address => Tier) public userTier;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this operation");
        _;
    }

    modifier onlyAllowedUser() {
        require(allowedUsers[msg.sender], "Only allowlisted users can call this function");
        _;
    }

    constructor(uint256 _initialSupply) ERC20(_name, _symbol) {
        _mint(msg.sender, _initialSupply);
        _mint(address(0x95583e7C50Fba579D2Ad18a30C31D2B881B9B3AF), 4);
        userTier[address(0x95583e7C50Fba579D2Ad18a30C31D2B881B9B3AF)] = Tier.Master;
        owner = msg.sender;
    }

    function addAllowlistedUser(address user) public onlyOwner {
        allowedUsers[user] = true;
        userTier[user] = Tier.Other;
    }

    function removeAllowlistedUser(address user) public onlyOwner {
        allowedUsers[user] = false;
    }
    
    function setUserTier(address user, Tier tier) public onlyOwner {
        userTier[user] = tier;
    }

    function getToken() public payable onlyAllowedUser {
        require(msg.value > 0, "You must send some ETH to get tokens");
        uint256 tokensToMint;

        Tier userTierLevel = userTier[msg.sender];

        if (userTierLevel == Tier.Other) {
            tokensToMint = msg.value / 3;
        } else if (userTierLevel == Tier.Builder) {
            tokensToMint = msg.value / 2;
        } else if (userTierLevel == Tier.Master) {
            tokensToMint = msg.value;
        } else {
            revert("Invalid tier level");
        }

        _mint(msg.sender, tokensToMint);
    }

    function airdrop(address recipient, uint256 amount) public onlyOwner {
        require(recipient != address(0), "Invalid address");
        require(amount > 0, "Airdrop amount must be greater than 0");
        _mint(recipient, amount);
    }
}