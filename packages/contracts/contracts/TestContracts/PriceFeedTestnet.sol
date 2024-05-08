// SPDX-License-Identifier: MIT

pragma solidity 0.6.11;

import "../Interfaces/IPriceFeed.sol";
import "../Dependencies/Ownable.sol";
import "../Dependencies/IPriceRouter.sol";
import "../Dependencies/CheckContract.sol";


/*
 * PriceFeed placeholder for testnet and development. The price is simply set manually and saved in a state
 * variable. The contract does not connect to a live Chainlink price feed.
 */
contract PriceFeedTestnet is IPriceFeed,CheckContract, Ownable {
    uint public lastGoodPrice;
    IPriceRouter public priceRouter;  // Mainnet Chainlink aggregator

     function setAddresses(
        address _priceRouterAddress
    )
        external
        onlyOwner
    {
        checkContract(_priceRouterAddress);
        priceRouter = IPriceRouter(_priceRouterAddress);
        _renounceOwnership();
    }

    // --- Functions ---

    function _storePrice(uint _currentPrice) internal {
        lastGoodPrice = _currentPrice;
        emit LastGoodPriceUpdated(_currentPrice);
    }

    // // View price getter for simplicity in tests
    function getPrice() external view returns (uint256) {
        return lastGoodPrice;
    }

    function fetchPrice() external override returns (uint256) {
        //Fetch the price and store it 
        uint price=priceRouter.getPrice();
        _storePrice(price);
        return price;
    }

    function setPrice(uint256 price) external returns (bool) {
        // lastGoodPrice = price;
        return true;
    }


    /*==============for testing==============*/

    // uint256 private _price = 200 * 1e18;
    // function getPrice() external view returns (uint256) {
    //     return _price;
    // }
    // function fetchPrice() external override returns (uint256) {
    //     emit LastGoodPriceUpdated(_price);
    //     return _price;
    // }
    // function setPrice(uint256 price) external returns (bool) {
    //     _price = price;
    //     return true;
    // }



}
