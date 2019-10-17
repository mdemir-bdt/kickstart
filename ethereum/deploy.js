const HDWalletProvider = require("@truffle/hdwallet-provider");
const Web3 = require("web3");
const campiledFactory = require("./build/CampaignFactory.json");

const provider = new HDWalletProvider(
  "gospel fashion hospital pyramid throw boat daring jealous orange suggest kitten chapter",
  "https://rinkeby.infura.io/v3/e64d1124995d4e8c885a9db573fb16f7"
);

const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();

  console.log("Attemping to deploy from account", accounts[0]);

  const result = await new web3.eth.Contract(campiledFactory.abi)
    .deploy({
      data: "0x" + campiledFactory["evm"]["bytecode"]["object"]
    })
    .send({ from: accounts[0] });
  console.log("contract deployed to", result.options.address);
};

deploy();
