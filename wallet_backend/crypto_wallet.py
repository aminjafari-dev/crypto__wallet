try:
    from web3 import Web3
    from eth_account import Account
    from bip_utils import Bip39MnemonicGenerator, Bip39SeedGenerator, Bip44, Bip44Coins, Bip44Changes
except ModuleNotFoundError as e:
    raise ModuleNotFoundError(f"Required module is not installed: {e}. Please install it using 'pip install web3 bip-utils'.")

class CryptoWallet:
    def __init__(self, rpc_url):
        """Initialize the wallet with a base chain RPC URL."""
        self.web3 = Web3(Web3.HTTPProvider(rpc_url))
        if not self.web3.is_connected():
            print("Debug: Connection to RPC failed.")
            raise ConnectionError("Unable to connect to the blockchain.")
        print("Debug: Successfully connected to the blockchain.")

    def create_wallet(self):
        """Create a new wallet with a private key, address, and seed phrase."""
        # Generate a BIP-39 mnemonic seed phrase
        mnemonic = Bip39MnemonicGenerator().FromWordsNumber(12).ToStr()
        # Generate the seed from the mnemonic
        seed = Bip39SeedGenerator(mnemonic).Generate()
        # Derive the account using BIP-44 (Ethereum path: m/44'/60'/0'/0/0)
        bip44_mst = Bip44.FromSeed(seed, Bip44Coins.ETHEREUM)
        bip44_acc = bip44_mst.Purpose().Coin().Account(0).Change(Bip44Changes.CHAIN_EXT).AddressIndex(0)
        # Extract private key and address
        private_key = bip44_acc.PrivateKey().Raw().ToHex()
        address = bip44_acc.PublicKey().ToAddress()
        print("Debug: Wallet created with address", address)
        return {
            'private_key': private_key,
            'address': address,
            'seed_phrase': mnemonic
        }

    def get_balance(self, address):
        """Retrieve the token balance of a given wallet address."""
        try:
            balance = self.web3.eth.get_balance(address)
            print(f"Debug: Balance for {address} retrieved successfully.")
            return self.web3.from_wei(balance, 'ether')
        except Exception as e:
            print(f"Debug: Error fetching balance for {address} - {str(e)}")
            raise ValueError(f"Failed to fetch balance: {str(e)}")

    def send_tokens(self, private_key, to_address, amount):
        """Send tokens from one wallet to another."""
        try:
            # Get the sender's account details
            account = self.web3.eth.account.privateKeyToAccount(private_key)
            from_address = account.address

            # Get the nonce for the transaction
            nonce = self.web3.eth.getTransactionCount(from_address)

            # Create the transaction object
            transaction = {
                'to': to_address,
                'value': self.web3.to_wei(amount, 'ether'),
                'gas': 21000,  # Standard gas limit for Ether transfers
                'gasPrice': self.web3.eth.gas_price,
                'nonce': nonce,
                'chainId': self.web3.eth.chain_id,
            }

            # Sign the transaction
            signed_txn = self.web3.eth.account.signTransaction(transaction, private_key)

            # Send the transaction
            txn_hash = self.web3.eth.sendRawTransaction(signed_txn.rawTransaction)
            print(f"Debug: Transaction sent. Hash: {self.web3.toHex(txn_hash)}")
            return self.web3.toHex(txn_hash)

        except Exception as e:
            print(f"Debug: Transaction failed - {str(e)}")
            raise ValueError(f"Transaction failed: {str(e)}")
        
        

# # Example usage
# if __name__ == "__main__":
#     rpc_url = "https://base-mainnet.g.alchemy.com/v2/kDPMGfNynLb-uJDyPm2qEclRiZ5IM40g"  # Alchemy Base Mainnet RPC URL
#     print("Debug: Initializing CryptoWallet with RPC URL.")
#     wallet = CryptoWallet(rpc_url)

#     # Create a new wallet
#     print("Debug: Creating a new wallet.")
#     new_wallet = wallet.create_wallet()
#     print("New Wallet:", new_wallet)

#     # Check balance
#     print(f"Debug: Checking balance for address {new_wallet['address']}.")
#     address = new_wallet['address']
#     balance = wallet.get_balance(address)
#     print(f"Balance for {address}: {balance} ETH")

#     # Send tokens (example - replace with actual private key and recipient address)
#     # print("Debug: Sending tokens.")
#     # txn_hash = wallet.send_tokens(new_wallet['private_key'], "RECIPIENT_ADDRESS", 0.01)
#     # print("Transaction Hash:", txn_hash)
