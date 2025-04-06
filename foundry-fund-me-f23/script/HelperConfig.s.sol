//SPDX-License-Identifier: MIT


//1. Deploy mocks when we are on a local anvil chain
// 2. Keep track of contract address across chains
// Sepolia ETH/USD
// Mainnet ETH/USD

pragma solidity ^0.8.18;

import{Script} from "forge-std/Script.sol";
import{MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

abstract contract CodeConstants {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    /*//////////////////////////////////////////////////////////////
                               CHAIN IDS
    //////////////////////////////////////////////////////////////*/
    uint256 public constant SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant ETHEREUM_CHAIN_ID = 1;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
}

contract HelperConfig is CodeConstants, Script {

    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error HelperConfig__InvalidChainId();

    /*//////////////////////////////////////////////////////////////
                                 TYPES
    //////////////////////////////////////////////////////////////*/
    struct NetworkConfig {
        address priceFeed;
        uint256 callbackGasLimit;
    }
    // If we are on a local anvil chain, we deploy mocks
    // otherwise grab existing addressed

    NetworkConfig public activeNetworkConfig;
    mapping(uint256 chainId => NetworkConfig) public networkConfig;


    constructor() {
        networkConfig[SEPOLIA_CHAIN_ID] = getSepoliaEthConfig();
        networkConfig[ETHEREUM_CHAIN_ID] = getMainnetEthConfig();
        // Note: We skip doing the local config
    }



    function getConfigByChainId(uint256 chainId) public returns (NetworkConfig memory) {
        if (networkConfig[chainId].priceFeed != address(0)) {
            return networkConfig[chainId];
        } else if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateAnvilEthConfig();
        } else {
            revert HelperConfig__InvalidChainId();
        }
    }

    function getMainnetEthConfig() public pure returns(NetworkConfig memory) {
        //price feed address
        return NetworkConfig({
            priceFeed: 0x72AFAECF99C9d9C8215fF44C77B94B99C28741e8, callbackGasLimit: 500000 // ETH / USD
        });
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory) {
        // price feed address
        return NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306, callbackGasLimit: 500000 // ETH / USD
        });
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // price feed address
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();

        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);

        vm.stopBroadcast();

        activeNetworkConfig = NetworkConfig({priceFeed: address(mockPriceFeed), callbackGasLimit: 500000});
        return activeNetworkConfig;
    }
}