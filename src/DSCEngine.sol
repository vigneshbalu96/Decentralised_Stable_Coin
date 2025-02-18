// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title DSC Engine
 * @author Vignesh Balusamy
 * @notice This system is designed to be as minimal as possible, and have the tokens maintain a 1 token == $ 1 peg.
 * @notice This Stablecoin has the following properties -
 * 1. Dollar pegged
 * 2. Exogenous Collateral
 * 3. Algorithmically stable
 * Our DSC system is always wanted to be "Overcollateralized", at no point the value of all collateral <= the $ backed value of all the DSC
 * @notice It is similar to DAI, if DAI had no governance, no fees and was only backed by wETH & wBTC.
 * @notice This contract is the core of the DSC system. It handles all the logic for minting and redeeming DSC, as well as depositing and withdrawing crypto collateral
 * @notice This contract is very loosely based on the MakerDAO DSS (DAI) system.
 */
contract DSCEngine is ReentrancyGuard {
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error DSCEngine__NeedsMoreThanZero();
    error DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSame();
    error DSCEngine__NotAllowedToken();
    error DSCEngine__TransferFailed();

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    mapping(address token => address priceFeed) private s_priceFeeds;
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;
    mapping(address user => uint256 amountDscMinted) private s_DSCMinted;

    address[] private s_collateralTokens;

    DecentralizedStableCoin private immutable i_dsc;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event CollateralDeposited(address indexed user, address indexed token, uint256 indexed amount);
    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert DSCEngine__NeedsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) {
            revert DSCEngine__NotAllowedToken();
        }
        _;
    }
    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        // USD Price Feeds
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSame();
        }
        // For Eg: ETH/USD, BTC/USD, MKR/USD
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    /*//////////////////////////////////////////////////////////////
                                EXTERNALFUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function depositCollateralAndMintDSC() external {}

    /**
     * @notice Follows CEI pattern
     * @param tokenCollateralAddress The adddress of the Token to deposit as collateral
     * @param amountCollateral The amount of collateral to deposit
     */
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);
        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);
        if (!success) {
            revert DSCEngine__TransferFailed();
        }
    }

    function redeemCollateralForDSC() external {}

    function redeemcollateral() external {}

    // Check if the Collateral value  > DSC amount, which involves priceFeeds, checking values and other stuffs.
    /**
     * @notice follows CEI
     * @param amountDscToMint - The amount of DSC required to mint for the collateral deposited.
     * @notice they must have more collateral value then the minimum threshold.
     */
    function mintDSC(uint256 amountDscToMint) external moreThanZero(amountDscToMint) nonReentrant {
        s_DSCMinted[msg.sender] += amountDscToMint;
    }

    function burnDSC() external {}

    function getHealthFactor() external {}

    function liquidate() external {}

    /*//////////////////////////////////////////////////////////////
                     PRIVATE AND INTERNAL VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function _getAccountInformation(address user)
        private
        view
        returns (uint256 totalDscMinted, uint256 collateralValueInUsd)
    {
        totalDscMinted = s_DSCMinted[user];
        collateralValueInUsd = getAccountCollateralValue(user);
    }
    /**
     * Returns how close a user is to get Liquidated.
     * If a user goes below 1 then they can get liquidated.
     */

    function _healthFactor() private view returns (uint256) {
        // Total DSC value
        // Total Collateral Value
        (uint256 totalDscMinted, uint256 collateralValueInUsd) = _getAccountInformation(user);
    }

    function revertIfHealthFactorIsBroken(address user) internal view {
        // 1. Check Health Factor (Do they have enough collateral?)
        // 2. Revert If they don't have a good health factor.
        // HF = summation of collateral in ETH * Liquidation Threshold / Total Borrows in ETH.
    }

    /*//////////////////////////////////////////////////////////////
                     PUBLIC AND EXTERNAL VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function getAccountCollateralValue(address user) public view returns (uint256) {
        // loop through each collateral token and get the amount they have deposited and map it to the price t get the USD value
    }
}
