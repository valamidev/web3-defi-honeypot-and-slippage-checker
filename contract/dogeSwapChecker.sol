//SPDX-License-Identifier: MIT

pragma abicoder v2;
pragma solidity ^0.8.7;

interface IBEP20 {
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function getOwner() external view returns (address);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address _owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256) external;
}

interface IDogeSwapV2Router01 {
    function factory() external view returns (address);

    function WWDOGE() external view returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityWDOGE(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountWDOGEMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountWDOGE,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityWDOGE(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountWDOGEMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountWDOGE);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityWDOGEWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountWDOGEMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountWDOGE);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactWDOGEForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactWDOGE(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForWDOGE(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapWDOGEForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IDogeSwapV2Router02 is IDogeSwapV2Router01 {
    function removeLiquidityWDOGESupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountWDOGEMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountWDOGE);

    function removeLiquidityWDOGEWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountWDOGEMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountWDOGE);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactWDOGEForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForWDOGESupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

interface IDEXRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

contract honeyCheckerDogeSwap {
    IDogeSwapV2Router02 public router;
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

    function honeyCheck(address targetTokenAddress, address idexRouterAddres)
        external
        payable
        returns (HoneyResponse memory response)
    {
        router = IDogeSwapV2Router02(idexRouterAddres);

        IBEP20 wCoin = IBEP20(router.WWDOGE()); // wETH
        IBEP20 targetToken = IBEP20(targetTokenAddress); //Test Token

        address[] memory buyPath = new address[](2);
        buyPath[0] = router.WWDOGE();
        buyPath[1] = targetTokenAddress;

        address[] memory sellPath = new address[](2);
        sellPath[0] = targetTokenAddress;
        sellPath[1] = router.WWDOGE();

        uint256[] memory amounts = router.getAmountsOut(msg.value, buyPath);

        uint256 expectedAmount = amounts[1];

        IWETH(router.WWDOGE()).deposit{value: msg.value}();

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

        // uint256 buyCost = startBuyGas - finishBuyGas;
        // uint256 sellCost = startSellGas - finishSellGas;

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
