// SPDX-License-Identifier: MIT

pragma solidity 0.6.11;

import "./Dependencies/IPriceRouter.sol";
import "./Interfaces/IPriceFeed.sol";
import "./Interfaces/ITellorCaller.sol";
import "./Dependencies/AggregatorV3Interface.sol";
import "./Dependencies/SafeMath.sol";
import "./Dependencies/Ownable.sol";
import "./Dependencies/CheckContract.sol";
import "./Dependencies/BaseMath.sol";
import "./Dependencies/LiquityMath.sol";
import "./Dependencies/console.sol";
/*
 * PriceFeed placeholder for testnet and development. The price is simply set manually and saved in a state
 * variable. The contract does not connect to a live Chainlink price feed.
 */
contract PriceFeed is IPriceFeed,CheckContract,BaseMath, Ownable {
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


    function fetchPrice() external override returns (uint256) {
        //Fetch the price and store it 
        uint price=priceRouter.getPrice();//always return price in 18 decimals
        _storePrice(price);
        return price;
    }

}
