// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract RocketToken is ERC20, Ownable {
  constructor() ERC20("Rocket Token", "RT") Ownable(msg.sender){}

  function mint(address _account, uint256 _amount) external onlyOwner {
    _mint(_account, _amount);
  }
}