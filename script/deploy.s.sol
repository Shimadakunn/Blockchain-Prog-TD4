// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "../lib/forge-std/src/Script.sol";
import {LeoToken} from "src/LeoToken.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        LeoToken leo = new LeoToken(9752623010);
        vm.stopBroadcast();
    }
}
