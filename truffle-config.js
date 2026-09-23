const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require('fs');
const privateKey = fs.readFileSync(".secret").toString().trim();

module.exports = {
    networks: {
        // Другие настройки сетей
        private: {
            provider: () => new HDWalletProvider(privateKey, `https://testnet-rpc.vinuchain.org`),
            network_id: 206,
            // Другие параметры сети
        }
    },
    // Другие конфигурации
};