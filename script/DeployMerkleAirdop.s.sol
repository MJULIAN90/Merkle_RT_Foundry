//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import { MerkleAirdrop, IERC20 } from "../src/MerkleAirdrop.sol";
import { Script } from "forge-std/Script.sol";
import { RocketToken } from "../src/RocketToken.sol";
import { console } from "forge-std/console.sol";

contract DeployMerkleAirdrop is Script {
  bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;

  uint256 public AMOUNT_TO_TRANSFER = 4 * (25 * 1e18);

  function deployMerkleAirdrop() public returns (MerkleAirdrop, RocketToken) {
    vm.startBroadcast();

    RocketToken rockeToken = new RocketToken();
    MerkleAirdrop airdrop = new MerkleAirdrop(ROOT, IERC20(rockeToken));

    rockeToken.mint(rockeToken.owner(), AMOUNT_TO_TRANSFER);
    IERC20(rockeToken).transfer(address(airdrop), AMOUNT_TO_TRANSFER);

    vm.stopBroadcast();

    return (airdrop, rockeToken);
  }

  function run() external returns (MerkleAirdrop, RocketToken) {
    return deployMerkleAirdrop();
  }
}