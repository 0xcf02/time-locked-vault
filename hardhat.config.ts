import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.20",
  networks: {
    // Rede para testes rápidos que não requer um terminal separado.
    // É uma instância temporária da Hardhat Network.
    hardhat: {
      // Configurações padrão são suficientes.
    },
    // Rede para conectar ao nó local persistente (npx hardhat node).
    localhost: {
      url: "http://127.0.0.1:8545",
    },
  },
};

export default config;