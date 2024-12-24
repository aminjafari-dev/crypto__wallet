import { isMetaMaskInstalled } from './utils.js';

// Example token contracts (replace with your tokens or fetch dynamically)
const tokenContracts = [
  { name: 'USDT', symbol: 'USDT', address: '0xdac17f958d2ee523a2206206994597c13d831ec7' },
  { name: 'DAI', symbol: 'DAI', address: '0x6b175474e89094c44da98b954eedeac495271d0f' },
  { name: 'UNI', symbol: 'UNI', address: '0x1f98380fddc15c8e23d3a594b6b7ea45f65f7d5a' },
  { name: 'AERO', symbol: 'Aero', address: '0x940181a94A35A4569E4529A3CDfB74e38FD98631' },
  { name: 'USDC', symbol: 'Usdc', address: '0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913' },
];

const exportTokensButton = document.getElementById('exportTokensButton');
const tokenList = document.getElementById('tokenList');

exportTokensButton.addEventListener('click', async () => {
  if (!isMetaMaskInstalled()) {
    alert('MetaMask is not installed. Please install it first.');
    return;
  }

  try {
    // Prompt MetaMask connection if not connected
    const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
    const userAddress = accounts[0];

    const tokenBalances = await fetchTokenBalances(userAddress);
    displayTokenBalances(tokenBalances);
  } catch (error) {
    console.error('Failed to fetch tokens:', error);
  }
});

async function fetchTokenBalances(walletAddress) {
  const balances = [];

  for (const token of tokenContracts) {
    try {
      // Fetch `decimals` for the token
      const decimals = await window.ethereum.request({
        method: 'eth_call',
        params: [
          {
            to: token.address,
            data: '0x313ce567', // `decimals()` function signature
          },
          'latest',
        ],
      });

      const tokenDecimals = parseInt(decimals, 16);

      // Fetch balance using `balanceOf`
      const balance = await window.ethereum.request({
        method: 'eth_call',
        params: [
          {
            to: token.address,
            data: `0x70a08231000000000000000000000000${walletAddress.slice(2)}`, // `balanceOf` function signature
          },
          'latest',
        ],
      });

      // Convert balance from hex and format using tokenDecimals
      const formattedBalance = parseInt(balance, 16) / Math.pow(10, tokenDecimals);
      balances.push({
        name: token.name,
        symbol: token.symbol,
        balance: formattedBalance.toFixed(6),
      });
    } catch (error) {
      console.warn(`Failed to fetch balance for ${token.symbol}:`, error);
    }
  }

  return balances;
}

function displayTokenBalances(balances) {
  // Clear existing tokens
  tokenList.innerHTML = '';

  // Add each token to the list
  balances.forEach((token) => {
    const li = document.createElement('li');
    li.textContent = `${token.name} (${token.symbol}): ${token.balance}`;
    tokenList.appendChild(li);
  });

  // If no balances were found
  if (balances.length === 0) {
    const li = document.createElement('li');
    li.textContent = 'No tokens found in your wallet.';
    tokenList.appendChild(li);
  }
}
