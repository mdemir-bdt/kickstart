import web3 from "./web3";
import CampaignFactory from "./build/CampaignFactory.json";

const instance = new web3.eth.Contract(
  CampaignFactory.abi,
  "0x68d33dc94f4c45a2fd54da8d3eeed6a4877c112c"
);

export default instance;
