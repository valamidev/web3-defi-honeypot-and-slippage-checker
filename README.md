# web3-defi-honeypot-and-slippage-checker

Cross-chain deployed Smart-contract to detect Honeypot and Slippage for DeFi tokens.

### How it works:

There is no magic only EVM(Ethereum Virtual Machine) features are involved.
The contract simulate a **buy/approve/sell** execution in a single transaction and evaluate the results. Work with any UniSwap2 Router interface.

### Which chain it is already available?

```
  Cronos chain => '0xb5BAA7d906b985C1A1eF0e2dAd19825EbAb5E9fc'
  Fantom Chain => '0x4208B737e8f3075fD2dCB9cE3358689452f98dCf'
  Polygon Chain => '0xc817b3a104B7d48e3B9C4fbfd624e5D5F03757e0'
  Avax - wait for deploy fund
  Arbitrum - wait for deploy fund
  Harmony - wait for deploy fund
  Aurora - wait for deploy fund
  SBC - wait for deploy fund
  Moonbeam - wait for deploy fund
  Hoo Smart Chain - wait for deploy fund
```

### How to get this deployed to a new chain?

To get this deployed we need some native/gas currency to deploy the smart contract

```
Fund address: 0x4030D79d04eE9c437A6B0470e7dcbB40aE796780
```

or you can deploy the contract ByteCode.

### Why the contract is not open-source?

The ByteCode and the ABI is. The full source will be, once it is deployed majority of the chains.

### How to use?

There is a TypeScript code snippet (example/index.ts)

```
const RunHoneyContract = async (
  from: string, // Any existing address on the blockchain e.g. 0x573fbc5996bfb18b3f9b9f8e96b774905bcdc8b6 (find one from the Top Accounts https://cronoscan.com/accounts)
  to: string, // The Honeypot checker contract Address e.g. 0xb5BAA7d906b985C1A1eF0e2dAd19825EbAb5E9fc
  token: string, // the address of the token e.g. 0x062E66477Faf219F25D27dCED647BF57C3107d52 (wBTC)
  router: string, // the DEX router address e.g.  0x145677fc4d9b8f19b5d56d1820c48e0443049a30 (MMfinance router on Cronos)
  rcpAddress: string // Provide your EVM node e.g. https://evm-cronos.crypto.org
)

Result:
{
  buyTax: 0,
  sellTax: 0.3, // Passed 0.3% Tax detected
  buyGasCost: 0,
  sellGasCost: 0,
  isHoneypot: 0
}
```

### My contract is failing on the Honeypot check why?

1. Required to have a native currency trading pair available (wETH,wBNB,wCro...). Why? because it make no sense to support route like WrappedCoin -> USDT -> AnyToken.
2. The available liquidity is lower than your simulation required
3. The Contract is broken or not satisfy the Uniswap2 de facto requirement. (Whitelisting, Blacklisting, Trade Disable, MaxTx, MaxWallet...)

### Is this safe?

1. Slippage calculation it is tested over 20.000 different Token pair.
2. Honeypot checking could be bypassed it is still blockchain, but the aim here is to decrease risk.
