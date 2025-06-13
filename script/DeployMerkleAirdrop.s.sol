// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {MerkleAirdrop, IERC20} from "../src/Merkle-Airdrop.sol";
import {Script} from "forge-std/Script.sol";
import {LegacyToken} from "../../src/LegacyToken.sol";
import {console} from "forge-std/console.sol";

contract DeployMerkleAirdrop is Script {
    bytes32 public ROOT =
        0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    // 4 users, 25 Legacy tokens each
    uint256 public AMOUNT_TO_TRANSFER = 4 * (25 * 1e18);

    // Deploy the airdrop contract and legacy token contract
    function deployMerkleAirdrop() public returns (MerkleAirdrop, LegacyToken) {
        vm.startBroadcast();
        LegacyToken legacyToken = new LegacyToken();
        MerkleAirdrop airdrop = new MerkleAirdrop(ROOT, IERC20(legacyToken));
        // Send Legacy tokens -> Merkle Air Drop contract
        legacyToken.mint(legacyToken.owner(), AMOUNT_TO_TRANSFER);
        IERC20(legacyToken).transfer(address(airdrop), AMOUNT_TO_TRANSFER);
        vm.stopBroadcast();
        return (airdrop, legacyToken);
    }

    function run() external returns (MerkleAirdrop, LegacyToken) {
        return deployMerkleAirdrop();
    }
}
