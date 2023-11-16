//SPDX-License-Identifier: MIT

pragma abicoder v2;
pragma solidity ^0.8.0;

interface IPulseXRouter02 {
    function factory() external pure returns (address);

    function WPLS() external pure returns (address);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    function getAmountOut(
        uint amountIn,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountOut);

    function getAmountIn(
        uint amountOut,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountIn);

    function getAmountsOut(
        uint amountIn,
        address[] calldata path
    ) external view returns (uint[] memory amounts);

    function getAmountsIn(
        uint amountOut,
        address[] calldata path
    ) external view returns (uint[] memory amounts);
}

interface IERC20 {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

interface IWPLS {
    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256) external;
}

contract FeeChecker {
    IPulseXRouter02 public router;
    uint256 approveInfinity =
        115792089237316195423570985008687907853269984665640564039457584007913129639935;

    struct HoneyResponse {
        uint256 buyResult;
        uint256 tokenBalance2;
        uint256 sellResult;
        uint256 buyCost;
        uint256 sellCost;
        uint256 expectedAmount;
    }

    constructor() {}

    function honeyCheck(
        address targetTokenAddress,
        address idexRouterAddres
    ) external payable returns (HoneyResponse memory response) {
        router = IPulseXRouter02(idexRouterAddres);

        IERC20 wCoin = IERC20(router.WPLS()); // WPLS
        IERC20 targetToken = IERC20(targetTokenAddress); //Test Token

        address[] memory buyPath = new address[](2);
        buyPath[0] = router.WPLS();
        buyPath[1] = targetTokenAddress;

        address[] memory sellPath = new address[](2);
        sellPath[0] = targetTokenAddress;
        sellPath[1] = router.WPLS();

        uint256[] memory amounts = router.getAmountsOut(msg.value, buyPath);

        uint256 expectedAmount = amounts[1];

        IWPLS(router.WPLS()).deposit{value: msg.value}();

        wCoin.approve(idexRouterAddres, approveInfinity);

        uint256 wCoinBalance = wCoin.balanceOf(address(this));

        uint256 startBuyGas = gasleft();

        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            wCoinBalance,
            1,
            buyPath,
            address(this),
            block.timestamp + 10
        );

        uint256 buyResult = targetToken.balanceOf(address(this));

        uint256 finishBuyGas = gasleft();

        targetToken.approve(idexRouterAddres, approveInfinity);

        uint256 startSellGas = gasleft();

        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            buyResult,
            1,
            sellPath,
            address(this),
            block.timestamp + 10
        );

        uint256 finishSellGas = gasleft();

        uint256 tokenBalance2 = targetToken.balanceOf(address(this));

        uint256 sellResult = wCoin.balanceOf(address(this));

        response = HoneyResponse(
            buyResult,
            tokenBalance2,
            sellResult,
            startBuyGas - finishBuyGas,
            startSellGas - finishSellGas,
            expectedAmount
        );

        return response;
    }
}
