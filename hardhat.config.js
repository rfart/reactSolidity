require("@nomicfoundation/hardhat-toolbox");
const secret = require("./secret.json");


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.0",
      },
      {
        version: "0.8.4",
      }
    ]
  },
  networks: {
    goerly: {
      url: secret.url,
      accounts: [secret.key]
    }
  },
  etherscan: {
    apiKey: "NMBFP2N1IUP1ZGXDFWFE4DR2RH7TCP7363"
  },
};