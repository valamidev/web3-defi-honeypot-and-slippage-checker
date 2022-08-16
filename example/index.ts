import BigNumber from "bignumber.js";
import Web3 from "web3";

const contractAbi = [
  {
    inputs: [],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "targetTokenAddress",
        type: "address",
      },
      {
        internalType: "address",
        name: "idexRouterAddres",
        type: "address",
      },
    ],
    name: "honeyCheck",
    outputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "buyResult",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "tokenBalance2",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "sellResult",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "buyCost",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "sellCost",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "expectedAmount",
            type: "uint256",
          },
        ],
        internalType: "struct honeyCheckerV5.HoneyResponse",
        name: "response",
        type: "tuple",
      },
    ],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [],
    name: "router",
    outputs: [
      {
        internalType: "contract IDEXRouter",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

const TEST_AMOUNT = 10 ** 17 * 5; // Equal with 0.5 wETH, 2 wBNB, 2 wCRO...
const GAS_LIMIT = "4500000"; // 4.5 million Gas should be enough

const RunHoneyContract = async (
  from: string,
  honeyCheckerAddress: string,
  token: string,
  router: string,
  rcpAddress: string
) => {
  let buyTax = 0;
  let sellTax = 0;
  let buyGasCost = 0;
  let sellGasCost = 0;
  let isHoneypot = 0;

  const web3 = new Web3(rcpAddress);
  const gasPrice = await web3.eth.getGasPrice();

  const honeyCheck = new web3.eth.Contract(contractAbi as any);

  const data = honeyCheck.methods.honeyCheck(token, router).encodeABI();

  let honeyTxResult: any;

  try {
    honeyTxResult = await web3.eth.call({
      // this could be provider.addresses[0] if it exists
      from,
      // target address, this could be a smart contract address
      to: honeyCheckerAddress,
      // optional if you want to specify the gas limit
      gas: GAS_LIMIT,
      gasPrice: Math.floor(Number(gasPrice) * 1.2).toString(),
      // optional if you are invoking say a payable function
      value: TEST_AMOUNT,
      // nonce
      nonce: undefined,
      // this encodes the ABI of the method and the arguements
      data,
    });
  } catch (error) {
    return {
      buyTax: -1,
      sellTax: -1,
      isHoneypot: 1,
      error: error,
    };
  }

  const decoded = web3.eth.abi.decodeParameter(
    "tuple(uint256,uint256,uint256,uint256,uint256,uint256)",
    honeyTxResult
  );

  buyGasCost = decoded[3];
  sellGasCost = decoded[4];

  const res = {
    buyResult: decoded[0],
    leftOver: decoded[1],
    sellResult: decoded[2],
    expectedAmount: decoded[5],
  };

  buyTax =
    (1 -
      new BigNumber(res.buyResult)
        .dividedBy(new BigNumber(res.expectedAmount))
        .toNumber()) *
    100;
  sellTax =
    (1 -
      new BigNumber(res.sellResult)
        .dividedBy(new BigNumber(TEST_AMOUNT))
        .toNumber()) *
      100 -
    buyTax;

  return {
    buyTax,
    sellTax,
    buyGasCost,
    sellGasCost,
    isHoneypot,
  };
};

/**
  from: string,
  honeyCheckAddress: string,
  token: string,
  router: string,
  rcpAddress: string
 */

//BSC
RunHoneyContract(
  "0x21d45650db732ce5df77685d6021d7d5d1da807f",
  "0x385826FBd70DfBB0a7188eE790A36E1fe4f6fc34",
  "0x3f203c1403ce39d4d42c4667287a7fb2b1db1066",
  "0x10ed43c718714eb63d5aa57b78b54704e256024e",
  "https://bsc-dataseed3.ninicoin.io/"
)
  .catch()
  .then((e) => console.log("BSC MainNet", e));

//Avax
RunHoneyContract(
  "0x765ccb180f15ead17bbffc38de4478d26214312b",
  "0x2B30ddE904B22c0Bba6019543231c857e0Be1DfB",
  "0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664",
  "0x60aE616a2155Ee3d9A68541Ba4544862310933d4",
  "https://rpc.ankr.com/avalanche"
)
  .catch()
  .then((e) => console.log("Avax", e));

// Cronos

RunHoneyContract(
  "0x573fbc5996bfb18b3f9b9f8e96b774905bcdc8b6",
  "0xb5BAA7d906b985C1A1eF0e2dAd19825EbAb5E9fc",
  "0x062E66477Faf219F25D27dCED647BF57C3107d52",
  "0x145677fc4d9b8f19b5d56d1820c48e0443049a30",
  "https://evm-cronos.crypto.org"
)
  .catch()
  .then((e) => console.log("Cronos", e));

// Binance TestNet

RunHoneyContract(
  "0x1dc1217732192ac66145b674e3271533b9e1b93d",
  "0xcf8eafad86d6490e1a6ba0fdfd09c71608214426",
  "0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7",
  "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3",
  "https://data-seed-prebsc-2-s1.binance.org:8545/"
)
  .catch()
  .then((e) => console.log("Bsc Testnet", e));

RunHoneyContract(
  "0x2772fcbf3e6d9128bccec98d5138ab63c712cb7b",
  "0xF662d39558F57031F2Caa45dEaFCD5341D5c7C1E",
  "0x989095a456c502503d23e139f1a10f2e64034246",
  "0xa4ee06ce40cb7e8c04e127c1f7d3dfb7f7039c81",
  "https://rpc03-sg.dogechain.dog"
)
  .catch()
  .then((e) => console.log("DogeChain", e));
