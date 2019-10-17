import Web3 from "web3";

let web3;

if (typeof window !== "undefined" && window.web3 !== "undefined") {
  // We are in the browser and metamask is running...
  window.ethereum.enable();
  web3 = new Web3(window.web3.currentProvider);
} else {
  // We are on the server or the user is not running metamask
  const provider = new Web3.providers.HttpProvider(
    "https://rinkeby.infura.io/v3/e64d1124995d4e8c885a9db573fb16f7"
  );
  web3 = new Web3(provider);
}

export default web3;
