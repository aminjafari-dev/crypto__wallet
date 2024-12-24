import { isMetaMaskInstalled } from './utils.js';

const connectButton = document.getElementById('connectButton');
const walletAddress = document.getElementById('walletAddress');

connectButton.addEventListener('click', async () => {
  console.log('Called Coonect Wallet')
  if (isMetaMaskInstalled()) {
    try {
      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
      walletAddress.innerText = `Connected wallet: ${accounts[0]}`;
    } catch (error) {
      walletAddress.innerText = 'Connection failed. Please try again.';
      console.error(error);
    }
  } else {
    walletAddress.innerText = 'MetaMask is not installed. Please install it to use this feature.';
  }
});
