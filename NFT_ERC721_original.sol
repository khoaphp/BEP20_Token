// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract HeroNFT is ERC721{
    
    using Strings for uint256;
    string private domain;
    address owner;
    uint private price_per_hero;  // BNB
   
    constructor(string memory name, string memory symbol, string memory domainName, uint price_1_hero) ERC721(name, symbol){
        owner = msg.sender;
        domain = domainName;            // 
        price_per_hero = price_1_hero;  // 10000000000000000; // 0.01 eth
    }
   
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory){
        require(_exists(tokenId)==false, "[0] Token Id is not availble!");
        if(bytes(domain).length>0){
            return string(abi.encodePacked(domain, tokenId.toString()));
        }else{ return ""; }
    }
   
    modifier isAdmin{
        require(msg.sender==owner, "[1] You are not allowed to process.");
        _;
    }
   
    // BNB
    function mint_Hero(uint256 tokenId) external payable{
        require(_exists(tokenId)==false, "[0] Token Id is not availble!");
        require(msg.value>=price_per_hero, "[2] We're sorry, not enough eth to mint heros.");
        _mint(msg.sender, tokenId);
    }
   
    // BNB
    function update_Hero_price(uint newPrice) public isAdmin{
        require(newPrice>0, "[5] Price must be bigger than 0");
        price_per_hero = newPrice;
    }

    // BNB
    function withdraw_Balance() public isAdmin{
        require(address(this).balance>0, "Sorry, balance now is Zero");
        payable(owner).transfer(address(this).balance);
    }
   
}

