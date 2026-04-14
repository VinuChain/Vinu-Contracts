pragma experimental ABIEncoderV2;
pragma solidity 0.5.17;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "../common/Initializable.sol";

contract Ownable is Initializable {
    using SafeMath for uint256;

    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function initialize(address sender) internal initializer {
        _owner = sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    // Override renounceOwnership to prevent accidental loss of admin access
    function renounceOwnership() public onlyOwner {
        revert("renounce ownership is disabled");
    }

    address private _pendingOwner;
    uint256 private _pendingOwnerDeadline;

    uint256 internal constant OWNERSHIP_TRANSFER_WINDOW = 7 days;

    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        // Prevent overwriting a live pending transfer: the pending new owner could
        // front-run the overwrite by calling acceptOwnership() before it lands,
        // taking control with an address the current owner intended to cancel.
        require(
            _pendingOwner == address(0) || block.timestamp > _pendingOwnerDeadline,
            "Ownable: pending transfer still active; wait for expiry"
        );
        _pendingOwner = newOwner;
        _pendingOwnerDeadline = block.timestamp.add(OWNERSHIP_TRANSFER_WINDOW);
        emit OwnershipTransferStarted(_owner, newOwner);
    }

    function acceptOwnership() public {
        require(msg.sender == _pendingOwner, "Ownable: caller is not the pending owner");
        require(block.timestamp <= _pendingOwnerDeadline, "Ownable: transfer expired");
        emit OwnershipTransferred(_owner, _pendingOwner);
        _owner = _pendingOwner;
        _pendingOwner = address(0);
        _pendingOwnerDeadline = 0;
    }

    function pendingOwner() public view returns (address) {
        if (block.timestamp > _pendingOwnerDeadline) {
            return address(0);
        }
        return _pendingOwner;
    }

    function pendingOwnerDeadline() public view returns (uint256) {
        return _pendingOwnerDeadline;
    }

    // Storage layout: _owner (1 slot) + _pendingOwner (1 slot) + _pendingOwnerDeadline (1 slot) + 48 gap = 51 slots
    // Note: inherits Initializable's 51 slots (slots 0-50), Ownable starts at slot 51
    uint256[48] private __gap;
}

// ReentrancyGuard is NOT a standalone contract — it is implemented inline within SFC
// to avoid inserting 50 storage slots into the inheritance chain, which would break
// proxy upgrades. See SFC._reentrancyGuardCounter and SFC.nonReentrant().
