//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {MerkleAirdrop} from "../../src/MerkleAirdrop.sol";
import {RocketToken} from "../../src/RocketToken.sol";
import {Test} from "forge-std/Test.sol";
import {DeployMerkleAirdrop} from "../../script/DeployMerkleAirdop.s.sol";
import { console } from "forge-std/console.sol";

contract MerkleAirdropTest is Test {
    MerkleAirdrop airdrop;
    RocketToken token;
    address gasPayer;
    address user;
    uint256 userPrivKey;

    bytes32 merkleRoot = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 amountToCollect = (25 * 1e18); // 25.000000
    uint256 amountToSend = amountToCollect * 4;

    bytes32 proofOne = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] proof = [proofOne, proofTwo];

    function setUp() public {
      DeployMerkleAirdrop deployer = new DeployMerkleAirdrop();
      (airdrop, token) = deployer.deployMerkleAirdrop();

      gasPayer = makeAddr("gasPayer");
      (user, userPrivKey) = makeAddrAndKey("user");
    }

    function signMessage(uint256 _privKey, address _account) public view returns (uint8 v, bytes32 r, bytes32 s) {
      bytes32 hashedmessage = airdrop.getMessageHash(_account, amountToCollect);
      (v, r, s) = vm.sign(_privKey, hashedmessage);
    }

    function testuserCanClaim() public {
      uint256 startingBalance = token.balanceOf(user);

      vm.startPrank(user);
      (uint8 v, bytes32 r, bytes32 s) = signMessage(userPrivKey, user);
      vm.stopPrank();

      // payer claims the tokens for the user

      vm.prank(gasPayer);

      airdrop.claim(user, amountToCollect, proof, v, r, s);

      uint256 endingBalance = token.balanceOf(user);

      assertEq(endingBalance - startingBalance, amountToCollect);
    }
}
