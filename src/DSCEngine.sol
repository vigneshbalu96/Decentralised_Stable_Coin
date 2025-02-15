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
contract DSCEngine {
    function depositCollateralAndMintDSC() external {}

    function depositCollateral() external {}

    function redeemCollateralForDSC() external {}

    function redeemcollateral() external {}

    function mintDSC() external {}

    function burnDSC() external {}

    function getHealthFactor() external {}

    function liquidate() external {}
}
