export function isMetaMaskInstalled() {
    console.log('Called isMetaMaskInstalled')
    return typeof window.ethereum !== 'undefined';
  }
  