pragma solidity 0.5.17;

contract Version {
    function version() external pure returns (bytes3) {
        // version 3.0.4
        return "304";
    }
}

// SFC storage layout (inherited slots, linearized C3 order):
//   Initializable:      slots 0-50    (2 bools packed in slot 0 + 50 gap = 51 slots)
//   Ownable:            slots 51-101  (_owner + _pendingOwner + _pendingOwnerDeadline + 48 gap = 51 slots)
//   StakersConstants:   0 slots       (pure functions only, no storage)
//   Version:            0 slots       (pure function only, no storage)
//   SFC own storage:    starts at slot 102
//
// PROXY UPGRADE COMPATIBILITY:
//   - ReentrancyGuard is NOT inherited (would insert 50 slots). Instead, _reentrancyGuardCounter
//     is an SFC-own variable at the end of storage. nonReentrant modifier is implemented inline.
//   - Original Ownable had: _owner (1 slot) + 50 gap = 51 slots.
//     Fixed Ownable uses:   _owner (1) + _pendingOwner (1) + _pendingOwnerDeadline (1) + 48 gap = 51 slots.
//     The 2 new Ownable vars consume 2 of the original 50-slot gap. Safe.
//   - Original SFC slot 104 was `address public genesisValidator` — preserved as `_legacyGenesisValidator`.
//     New `isGenesisValidator` mapping is added at the end of storage (gap slot).
//   - All new SFC variables (corruptedEpochs, correctedEpochRewardRate, isEpochCorrected,
//     correctionReasonHash, maxCorrectionDelta, pendingCorrections, pending* timelocks,
//     usedPubkeyHash, isGenesisValidator, _reentrancyGuardCounter) are appended AFTER
