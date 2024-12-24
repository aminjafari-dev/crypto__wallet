// Map MetaMask chain IDs to Moralis chain names
const chainIdToChainName = {
  '0x1': 'eth',         // Ethereum Mainnet
  '0x38': 'bsc',        // Binance Smart Chain
  '0x89': 'polygon',    // Polygon Mainnet
  '0xa86a': 'avalanche',// Avalanche Mainnet
  '0x2105': 'base',     // Base Mainnet
};

  
  export async function getCurrentChain() {
    try {
      const chainId = await window.ethereum.request({ method: 'eth_chainId' });
  
      // Check if the chain ID is supported
      if (chainIdToChainName[chainId]) {
        return chainIdToChainName[chainId];
      } else {
        throw new Error(`Unsupported chain ID: ${chainId}`);
      }
    } catch (error) {
      console.error('Error retrieving chain ID:', error);
      return null;
    }
  }
  