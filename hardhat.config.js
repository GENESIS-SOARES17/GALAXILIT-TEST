require("@nomicfoundation/hardhat-toolbox");

const PRIVATE_KEY = process.env.PRIVATE_KEY;

if (!PRIVATE_KEY || PRIVATE_KEY === "SUA_CHAVE_PRIVADA_REAL_AQUI") {
  console.error("ERRO: Configure sua PRIVATE_KEY!");
  process.exit(1);
}

module.exports = {
  solidity: "0.8.20",
  networks: {
    liteforge: {
      url: "https://liteforge.rpc.caldera.xyz/http",
      chainId: 4441,
      accounts: [PRIVATE_KEY]
    }
  }
};
