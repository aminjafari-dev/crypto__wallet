import { getCurrentChain } from './getCurrentMainChain.js';



const fetchTokensButton = document.getElementById('fetchTokensButton');
const tokenList = document.getElementById('tokenList');

// Your Moralis API key
const MORALIS_API_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub25jZSI6IjM1ODk2MzhkLTZlZGMtNDQ1NC1hOGY3LWUyODRlZjhjM2VjMyIsIm9yZ0lkIjoiNDIxMTE4IiwidXNlcklkIjoiNDMzMDc1IiwidHlwZUlkIjoiMzQzNDM5YWMtNzQ0OC00ZDk1LWExNDYtNGFjOTgxZWYyNjM3IiwidHlwZSI6IlBST0pFQ1QiLCJpYXQiOjE3MzQzNjA4NzMsImV4cCI6NDg5MDEyMDg3M30.8w20tEesuYfspdLDhpTer47uV-Lz-uQ_BpLJAnC7aX0';

fetchTokensButton.addEventListener('click', async () => {
  const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
  const walletAddress = accounts[0]; // Get connected wallet address

  // Fetch tokens dynamically
  const tokens = await fetchTokens(walletAddress);

  // Display tokens on the page
  displayTokenBalances(tokens);
});

async function fetchTokenBalances(walletAddress) {
  const balances = [];

  for (const token of tokenContracts) {
    try {
      console.log(`Fetching balance for ${token.name}...`);

      // Fetch `decimals`
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
      console.log(`${token.name} decimals: ${tokenDecimals}`);

      // Fetch `balanceOf`
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
      console.log(`${token.name} raw balance: ${balance}`);

      // Convert balance to formatted value
      const formattedBalance = parseInt(balance, 16) / Math.pow(10, tokenDecimals);
      console.log(`${token.name} formatted balance: ${formattedBalance}`);

      balances.push({
        name: token.name,
        symbol: token.symbol,
        balance: formattedBalance.toFixed(6),
      });
    } catch (error) {
      console.warn(`Failed to fetch balance for ${token.name}:`, error);
    }
  }

  return balances;
}


function displayTokenBalances(tokens) {
  tokenList.innerHTML = '';

  if (tokens.length === 0) {
    const li = document.createElement('li');
    li.textContent = 'No tokens found in your wallet.';
    tokenList.appendChild(li);
    return;
  }

  tokens.forEach((token) => {
    const li = document.createElement('li');
    li.textContent = `${token.name} (${token.symbol}): ${(token.balance / Math.pow(10, token.decimals)).toFixed(6)}`;
    tokenList.appendChild(li);
  });
}
