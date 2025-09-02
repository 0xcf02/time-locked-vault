// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title TimeLockedVault
 * @dev Contrato seguro para depósito de Ether com retirada restrita por tempo
 * @notice Este contrato implementa múltiplas camadas de segurança contra ataques comuns
 * @author Security Enhanced Version
 */
contract TimeLockedVault is ReentrancyGuard {
    address public immutable owner;
    uint256 public immutable unlockTime;
    bool public depositsEnabled;
    
    mapping(address => uint256) private pendingWithdrawals;

    event Deposited(address indexed depositor, uint256 amount, uint256 depositedAt);
    event Withdrawn(uint256 amount, uint256 withdrawnAt);
    event EmergencyWithdrawal(uint256 amount, uint256 withdrawnAt);
    event DepositsToggled(bool enabled);
    event WithdrawalInitiated(uint256 amount, uint256 initiatedAt);

    error UnauthorizedCaller();
    error FundsStillLocked();
    error NoFundsAvailable();
    error TransferFailed();
    error InvalidUnlockTime();
    error InvalidDepositAmount();
    error DepositsDisabled();
    error InvalidOwner();

    modifier onlyOwner() {
        if (msg.sender != owner) revert UnauthorizedCaller();
        _;
    }

    modifier onlyWhenDepositsEnabled() {
        if (!depositsEnabled) revert DepositsDisabled();
        _;
    }

    constructor(uint256 _unlockTime) {
        if (_unlockTime <= block.timestamp) revert InvalidUnlockTime();
        if (msg.sender == address(0)) revert InvalidOwner();
        
        // Verifica se o owner pode receber Ether
        if (msg.sender.code.length > 0) {
            // Se for um contrato, tentamos verificar se tem função receive/fallback
            (bool success, ) = msg.sender.call{value: 0}("");
            if (!success) revert InvalidOwner();
        }
        
        owner = msg.sender;
        unlockTime = _unlockTime;
        depositsEnabled = true;
    }

    function deposit() external payable onlyWhenDepositsEnabled nonReentrant {
        if (msg.value == 0) revert InvalidDepositAmount();
        emit Deposited(msg.sender, msg.value, block.timestamp);
    }

    function initiateWithdrawal() external onlyOwner nonReentrant {
        if (block.timestamp < unlockTime) revert FundsStillLocked();
        
        uint256 contractBalance = address(this).balance;
        if (contractBalance == 0) revert NoFundsAvailable();
        
        // Padrão Checks-Effects-Interactions: primeiro mudamos o estado
        pendingWithdrawals[owner] = contractBalance;
        
        emit WithdrawalInitiated(contractBalance, block.timestamp);
    }

    function executeWithdrawal() external onlyOwner nonReentrant {
        uint256 amount = pendingWithdrawals[owner];
        if (amount == 0) revert NoFundsAvailable();
        
        // Zeramos primeiro (Checks-Effects-Interactions)
        pendingWithdrawals[owner] = 0;
        
        (bool success, ) = owner.call{value: amount}("");
        if (!success) {
            // Revertemos o estado se a transferência falhar
            pendingWithdrawals[owner] = amount;
            revert TransferFailed();
        }

        emit Withdrawn(amount, block.timestamp);
    }

    function emergencyWithdraw() external onlyOwner nonReentrant {
        if (block.timestamp < unlockTime + 365 days) revert FundsStillLocked();
        
        uint256 contractBalance = address(this).balance;
        if (contractBalance == 0) revert NoFundsAvailable();
        
        (bool success, ) = owner.call{value: contractBalance}("");
        if (!success) revert TransferFailed();

        emit EmergencyWithdrawal(contractBalance, block.timestamp);
    }

    function toggleDeposits() external onlyOwner {
        depositsEnabled = !depositsEnabled;
        emit DepositsToggled(depositsEnabled);
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getPendingWithdrawal() external view onlyOwner returns (uint256) {
        return pendingWithdrawals[owner];
    }

    function getTimeUntilUnlock() external view returns (uint256) {
        if (block.timestamp >= unlockTime) return 0;
        return unlockTime - block.timestamp;
    }

    receive() external payable onlyWhenDepositsEnabled nonReentrant {
        if (msg.value == 0) revert InvalidDepositAmount();
        emit Deposited(msg.sender, msg.value, block.timestamp);
    }
}