Time-Locked Vault Smart Contract
📄 Description
Time-Locked Vault is a smart contract developed for the Ethereum blockchain that functions as a time-locked vault. It allows a user to deposit Ether, which can only be withdrawn by the same user after a predetermined date and time set upon the contract's creation.

This project serves as a practical demonstration of fundamental concepts in Solidity development, with a special emphasis on security, fund management, and time-based logic.

✨ Features
Secure Ether Deposits: Any user can deposit ETH into the vault.

Time-Locked Withdrawals: Only the contract owner can withdraw the funds, and only after the lock-up period has expired.

Enhanced Security: Implements the Checks-Effects-Interactions pattern to prevent re-entrancy attacks, one of the most critical vulnerabilities in smart contracts.

Event Emission: The contract emits events for deposits and withdrawals, allowing for transparent and efficient on-chain activity tracking.

Immutable Ownership: The owner's address is set as immutable, which is a gas optimization and a security best practice.

🛠️ Tech Stack
This project was built using a modern Web3 development stack:

Contract Language: 

Blockchain:  (EVM-compatible)

Development Environment: 

Testing & Scripting Language: 

Testing Frameworks: , , 

Deployment: 

🚀 Getting Started
Follow the steps below to clone, install dependencies, and interact with the project in a local environment.

Prerequisites
 (v18 or higher)


Installation
Clone the repository:

Navigate to the project directory:

Install dependencies:

Compiling the Contract
To compile the smart contracts and generate TypeChain bindings, run:

Running Tests
This project includes a comprehensive test suite to ensure the security and expected behavior of the contract. To run the tests, execute:

Deploying to a Local Network
You can deploy the contract to a local Hardhat network to interact with it.

Start the local node (in one terminal):

This command will start a local blockchain instance and provide a list of test accounts.

Deploy the contract (in a second terminal):
Use the Hardhat Ignition module to deploy the contract to the local network.

Upon completion, the terminal will display the deployed contract's address.

📄 License
This project is licensed under the MIT License. See the  file for more details.

👨‍💻 Author
Jose Ronaldo Pereira (0xcf02)

LinkedIn: www.linkedin.com/in/ronaldo-pereira-b1b700175

GitHub: www.github.com/0xcf02# time-locked-vault
