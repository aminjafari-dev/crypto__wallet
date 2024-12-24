import { isMetaMaskInstalled } from "./utils.js";

const switchChainButton = document.getElementById("switchChainButton");
const currentChain = document.getElementById("currentChain");

switchChainButton.addEventListener("click", async () => {
  if (isMetaMaskInstalled()) {
    try {
      const BASE_CHAIN_PARAMS = {
        chainId: "0x2105", // Base Mainnet chain ID in hexadecimal (8453 in decimal)
        chainName: "Base Mainnet",
        nativeCurrency: {
          name: "Base",
          symbol: "ETH",
          decimals: 18,
        },
        rpcUrls: ["https://mainnet.base.org"],
        blockExplorerUrls: ["https://basescan.org/"],
      };
      // Get the current chain ID
      const chainId = await window.ethereum.request({ method: "eth_chainId" });
      if (chainId === "0x1") {
        // If currently Ethereum Mainnet, switch to Base
        await window.ethereum.request({
          method: "wallet_switchEthereumChain",
          params: [BASE_CHAIN_PARAMS], // Base Chain ID
        });
        currentChain.innerText = "Switched to Base";
      } else if (chainId === "0x2105") {
        // If currently Base, switch to Ethereum Mainnet
        await window.ethereum.request({
          method: "wallet_switchEthereumChain",
          params: [{ chainId: "0x1" }], // Ethereum Mainnet Chain ID
        });
        currentChain.innerText = "Switched to Ethereum Mainnet";
      } else {
        currentChain.innerText = "Unknown chain. Unable to switch.";
      }
    } catch (error) {
      currentChain.innerText = "Failed to switch chains. Please try again.";
      console.error(error);
    }
  } else {
    currentChain.innerText =
      "MetaMask is not installed. Please install it to use this feature.";
  }
});