# 🪙 Fund Me (Foundry)

A minimal **FundMe smart contract** built with [Foundry](https://book.getfoundry.sh/).  
Users can fund the contract in **ETH**, with a minimum amount based on **USD value (via Chainlink price feeds)**.  
The contract owner can withdraw funds securely.

---

## 🚀 Features
- Accepts ETH donations (denominated in USD)  
- Uses **Chainlink Price Feeds** for ETH/USD  
- Tracks funders  
- Owner-only withdraw function  
- Includes **Unit & Forked tests**  

---

## ⚡ Quickstart
```bash
# Clone & Install
git clone https://github.com/yourusername/foundry-fund-me
cd foundry-fund-me
make

# Run tests
forge test
forge test --fork-url $SEPOLIA_RPC_URL


🌐 Deploy

Add a .env file with:

PRIVATE_KEY=your_private_key
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/your_api_key
ETHERSCAN_API_KEY=your_etherscan_key


Deploy to Sepolia:

forge script script/DeployFundMe.s.sol \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --verify \
  --etherscan-api-key $ETHERSCAN_API_KEY

📜 Interactions

Fund contract:

cast send <FUNDME_CONTRACT_ADDRESS> "fund()" --value 0.1ether --private-key $PRIVATE_KEY


Withdraw:

cast send <FUNDME_CONTRACT_ADDRESS> "withdraw()" --private-key $PRIVATE_KEY

✅ Tech Stack

Solidity

Foundry (Forge, Cast, Anvil)

Chainlink Price Feeds