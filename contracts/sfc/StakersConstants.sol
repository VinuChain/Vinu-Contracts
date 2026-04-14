pragma experimental ABIEncoderV2;
pragma solidity 0.5.17;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "../common/Decimal.sol";

contract StakersConstants {
    using SafeMath for uint256;

    uint256 internal constant OK_STATUS = 0;
    uint256 internal constant WITHDRAWN_BIT = 1;
    uint256 internal constant OFFLINE_BIT = 1 << 3;
    uint256 internal constant DOUBLESIGN_BIT = 1 << 7;
    uint256 internal constant CHEATER_MASK = DOUBLESIGN_BIT;

    function minSelfStake() public pure returns (uint256) {
        // 200000 VC
        return 200000 * 1e18;
    }

    function maxDelegatedRatio() public pure returns (uint256) {
        // 1600%
        return 16 * Decimal.unit();
    }

    function validatorCommission() public pure returns (uint256) {
        // 15%
        return Decimal.unit() * 15 / 100;
    }

    function contractCommission() public pure returns (uint256) {
        // 30% — protocol fee on tx rewards (independent of unlockedRewardRatio)
        return (30 * Decimal.unit()) / 100;
    }

    function unlockedRewardRatio() public pure returns (uint256) {
        // 30% — portion of base reward paid to unlocked stake (independent of contractCommission)
        return (30 * Decimal.unit()) / 100;
    }

    function minLockupDuration() public pure returns (uint256) {
        return 86400 * 14;
    }

    function maxLockupDuration() public pure returns (uint256) {
        return 86400 * 365;
    }

    function withdrawalPeriodEpochs() public pure returns (uint256) {
        return 6;
    }

    function withdrawalPeriodTime() public pure returns (uint256) {
        // 1 day
        return 60 * 60 * 24;
    }

    function withdrawalPeriodEpochsValidator() public pure returns (uint256) {
        return 6 * 30;
    }

    function withdrawalPeriodTimeValidator() public pure returns (uint256) {
        // 3 day
        return 86400 * 3;
    }

    function minDelegation() public pure returns (uint256) {
        // 0.01 VC
        return 1e16;
    }
}
