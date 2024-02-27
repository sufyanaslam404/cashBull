

pragma solidity ^0.8.17;
pragma experimental ABIEncoderV2;

// SPDX-License-Identifier:MIT

interface IBEP20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
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

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address payable private _owner;
    address payable private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _owner = payable(0x74C1F2bEA2686c38933Ddf5D7BDEF243455b6D4A); //main
        // _owner = payable(0x1bF99f349eFdEa693e622792A3D70833979E2854);//test
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = payable(address(0));
    }

    function transferOwnership(address payable newOwner)
        public
        virtual
        onlyOwner
    {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IDEXFactory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

interface IDEXPair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface IDEXRouter01 {
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

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

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

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

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

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
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

interface IDEXRouter02 is IDEXRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

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
}

contract WBTOKEN is Context, IBEP20, Ownable {
    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private _isExcluded;

    address[] private _excluded;

    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal = 70_000_000 * 10**8;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;

    string private _name = "WB TOKEN"; // token name
    string private _symbol = "WB"; // token ticker
    uint8 private _decimals = 8; // token decimals

    IDEXRouter02 public DEXRouter;
    address public DEXPair;
    address public DEXPair2;
    IBEP20 public BUSD = IBEP20(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56); // BUSD address mainnet
    // IBEP20 public BUSD = IBEP20(0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7); // BUSD address testnet

    address payable public marketWallet =
        payable(0x92266AA18C33Ed0bA981552f9F9894f1535525E5);
    address public burnAddress = 0x000000000000000000000000000000000000dEaD;
    uint256 minTokenNumberToSell = _tTotal / 1000; // 0.1% of total supply
    uint256 public maxFee = 100; // 10% max fees limit per transaction
    bool public swapAndLiquifyEnabled = false; // should be true to turn on to liquidate the pool
    bool inSwapAndLiquify = false;
    uint256 divider = 1000;

    // buy tax fee
    uint256 public redistributionFeeOnBuying;
    uint256 public liquidityFeeOnBuying;
    uint256 public marketingwalletFeeOnBuying;

    // sell tax fee
    uint256 public redistributionFeeOnSelling;
    uint256 public liquidityFeeOnSelling;
    uint256 public marketingwalletFeeOnSelling;

    // normal tax fee
    uint256 public redistributionFee;
    uint256 public liquidityFee;
    uint256 public marketingwalletFee;

    // for smart contract use
    uint256 private _currentRedistributionFee;
    uint256 private _currentLiquidityFee;
    uint256 private _currentmarketingwalletFee;

    bool public tradingOpen = false;

    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );

    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    constructor() {
        _rOwned[owner()] = _rTotal;

        // IDEXRouter02 _DEXRouter = IDEXRouter02(
        //     0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3
        // ); //test
        IDEXRouter02 _DEXRouter = IDEXRouter02(
            0x10ED43C718714eb63d5aA57B78B54704E256024E
        ); //main
        // Create a DEX pair for this new token
        DEXPair = IDEXFactory(_DEXRouter.factory()).createPair(
            address(this),
            _DEXRouter.WETH()
        );
        DEXPair2 = IDEXFactory(_DEXRouter.factory()).createPair(
            address(this),
            address(BUSD)
        );

        // set the rest of the contract variables
        DEXRouter = _DEXRouter;

        //exclude owner and this contract from fee
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[0xaC343A4ab22c7880Dfb24b74F04B79E20d2D1989] = true; //presale wallet
        _isExcludedFromFee[marketWallet] = true;
        _isExcludedFromFee[address(this)] = true;

        emit Transfer(address(0), owner(), _tTotal);
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() external view returns (uint8) {
        return _decimals;
    }

    function totalSupply() external view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address _owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[_owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()] - (amount)
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + (addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] - (subtractedValue)
        );
        return true;
    }

    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    function deliver(uint256 tAmount) public {
        address sender = _msgSender();
        require(
            !_isExcluded[sender],
            "Excluded addresses cannot call this function"
        );
        uint256 rAmount = tAmount * (_getRate());
        _rOwned[sender] = _rOwned[sender] - (rAmount);
        _rTotal = _rTotal - (rAmount);
        _tFeeTotal = _tFeeTotal + (tAmount);
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
        public
        view
        returns (uint256)
    {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            uint256 rAmount = tAmount * (_getRate());
            return rAmount;
        } else {
            uint256 rAmount = tAmount * (_getRate());
            uint256 rTransferAmount = rAmount -
                (totalFeePerTx(tAmount) * (_getRate()));
            return rTransferAmount;
        }
    }

    function tokenFromReflection(uint256 rAmount)
        public
        view
        returns (uint256)
    {
        require(
            rAmount <= _rTotal,
            "Amount must be less than total reflections"
        );
        uint256 currentRate = _getRate();
        return rAmount / (currentRate);
    }

    function excludeFromReward(address account) public onlyOwner {
        require(!_isExcluded[account], "Account is already excluded");
        if (_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    function includeInReward(address account) external onlyOwner {
        require(_isExcluded[account], "Account is already excluded");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _rOwned[account] = _tOwned[account] * (_getRate());
                _tOwned[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
    }

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }

    function setMinTokenNumberToSell(uint256 _amount) public onlyOwner {
        minTokenNumberToSell = _amount;
    }

    function setSwapAndLiquifyEnabled(bool _state) public onlyOwner {
        swapAndLiquifyEnabled = _state;
        emit SwapAndLiquifyEnabledUpdated(_state);
    }

    function setmarketWallet(address payable _marketWallet) external onlyOwner {
        require(
            _marketWallet != address(0),
            "Market wallet cannot be address zero"
        );
        marketWallet = _marketWallet;
    }

    function setRoute(
        IDEXRouter02 _router,
        address _pair,
        address _pairBUSD
    ) external onlyOwner {
        require(
            address(_router) != address(0),
            "Router adress cannot be address zero"
        );
        require(_pair != address(0), "Pair adress cannot be address zero");
        DEXRouter = _router;
        DEXPair = _pair;
        DEXPair2 = _pairBUSD;
    }

    function withdrawBNB(uint256 _amount) external onlyOwner {
        require(address(this).balance >= _amount, "Invalid Amount");
        payable(msg.sender).transfer(_amount);
    }

    function withdrawToken(IBEP20 _token, uint256 _amount) external onlyOwner {
        require(_token.balanceOf(address(this)) >= _amount, "Invalid Amount");
        _token.transfer(msg.sender, _amount);
    }

    //to receive BNB from DEXRouter when swapping
    receive() external payable {}

    function totalFeePerTx(uint256 tAmount) internal view returns (uint256) {
        uint256 percentage = (tAmount *
            (_currentRedistributionFee +
                (_currentLiquidityFee) +
                (_currentmarketingwalletFee))) / (divider);
        return percentage;
    }

    function _reflectFee(uint256 tAmount) private {
        uint256 tFee = (tAmount * (_currentRedistributionFee)) / (divider);
        uint256 rFee = tFee * (_getRate());
        _rTotal = _rTotal - (rFee);
        _tFeeTotal = _tFeeTotal + (tFee);
    }

    function _getRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply / (tSupply);
    }

    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (
                _rOwned[_excluded[i]] > rSupply ||
                _tOwned[_excluded[i]] > tSupply
            ) return (_rTotal, _tTotal);
            rSupply = rSupply - (_rOwned[_excluded[i]]);
            tSupply = tSupply - (_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotal / (_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function _takeLiquidityPoolFee(uint256 tAmount, uint256 currentRate)
        internal
    {
        uint256 tPoolFee = (tAmount * (_currentLiquidityFee)) / (divider);
        uint256 rPoolFee = tPoolFee * (currentRate);
        _rOwned[address(this)] = _rOwned[address(this)] + (rPoolFee);
        if (_isExcluded[address(this)])
            _tOwned[address(this)] = _tOwned[address(this)] + (tPoolFee);
        emit Transfer(_msgSender(), address(this), tPoolFee);
    }

    function _takeMarketFee(uint256 tAmount, uint256 currentRate) internal {
        uint256 tCharityFee = (tAmount * (_currentmarketingwalletFee)) /
            (divider);
        uint256 rCharityFee = tCharityFee * (currentRate);
        _rOwned[marketWallet] = _rOwned[marketWallet] + (rCharityFee);
        if (_isExcluded[marketWallet])
            _tOwned[marketWallet] = _tOwned[marketWallet] + (tCharityFee);
        emit Transfer(_msgSender(), marketWallet, tCharityFee);
    }

    function removeAllFee() private {
        _currentRedistributionFee = 0;
        _currentLiquidityFee = 0;
        _currentmarketingwalletFee = 0;
    }

    function setBuyFee() private {
        _currentRedistributionFee = redistributionFeeOnBuying;
        _currentLiquidityFee = liquidityFeeOnBuying;
        _currentmarketingwalletFee = marketingwalletFeeOnBuying;
    }

    function setSellFee() private {
        _currentRedistributionFee = redistributionFeeOnSelling;
        _currentLiquidityFee = liquidityFeeOnSelling;
        _currentmarketingwalletFee = marketingwalletFeeOnSelling;
    }

    function setNormalFee() private {
        _currentRedistributionFee = redistributionFee;
        _currentLiquidityFee = liquidityFee;
        _currentmarketingwalletFee = marketingwalletFee;
    }

    function StartTrading() external onlyOwner {
        require(!tradingOpen, "Trading is already open");
        tradingOpen = true;
        // buy tax fee
        redistributionFeeOnBuying = 0; // 0% will be distributed among holder as token divideneds
        liquidityFeeOnBuying = 40; // 4% will be added to the liquidity pool
        marketingwalletFeeOnBuying = 60; // 6% will go to the marketingwallet address

        // sell tax fee
        redistributionFeeOnSelling = 0; // 0% will be distributed among holder as token divideneds
        liquidityFeeOnSelling = 40; // 4% will be added to the liquidity pool
        marketingwalletFeeOnSelling = 60; // 6% will go to the market address

        // normal tax fee
        redistributionFee = 0; // 0% will be distributed among holder as token divideneds
        liquidityFee = 40; // 4% will be added to the liquidity pool
        marketingwalletFee = 60; // 6% will go to the market address
    }

    function setmarketingwalletFee(
        uint256 _buy,
        uint256 _sell,
        uint256 _normal
    ) external onlyOwner {
        require(
            _buy + redistributionFeeOnBuying + liquidityFeeOnBuying <= maxFee,
            " Buy Fee cannot be more than 10%"
        );
        require(
            _sell + redistributionFeeOnSelling + liquidityFeeOnSelling <=
                maxFee,
            " Sell Fee cannot be more than 10%"
        );
        require(
            _normal + redistributionFee + liquidityFee <= maxFee,
            " Normal Fee cannot be more than 10%"
        );
        marketingwalletFeeOnBuying = _buy;
        marketingwalletFeeOnSelling = _sell;
        marketingwalletFee = _normal;
    }

    function setRedistributionFee(
        uint256 _buy,
        uint256 _sell,
        uint256 _normal
    ) external onlyOwner {
        require(
            _buy + marketingwalletFeeOnBuying + liquidityFeeOnBuying <= maxFee,
            " Buy Fee cannot be more than 10%"
        );
        require(
            _sell + marketingwalletFeeOnSelling + liquidityFeeOnSelling <=
                maxFee,
            " Sell Fee cannot be more than 10%"
        );
        require(
            _normal + marketingwalletFee + liquidityFee <= maxFee,
            " Normal Fee cannot be more than 10%"
        );
        redistributionFeeOnBuying = _buy;
        redistributionFeeOnSelling = _sell;
        redistributionFee = _normal;
    }

    function setLiquidityFee(
        uint256 _buy,
        uint256 _sell,
        uint256 _normal
    ) external onlyOwner {
        require(
            _buy + marketingwalletFeeOnBuying + redistributionFeeOnBuying <=
                maxFee,
            " Buy Fee cannot be more than 10%"
        );
        require(
            _sell + marketingwalletFeeOnSelling + redistributionFeeOnSelling <=
                maxFee,
            " Sell Fee cannot be more than 10%"
        );
        require(
            _normal + marketingwalletFee + redistributionFee <= maxFee,
            " Normal Fee cannot be more than 10%"
        );
        liquidityFeeOnBuying = _buy;
        liquidityFeeOnSelling = _sell;
        liquidityFee = _normal;
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(
        address _owner,
        address spender,
        uint256 amount
    ) private {
        require(_owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[_owner][spender] = amount;
        emit Approval(_owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "BEP20: transfer from the zero address");
        require(to != address(0), "BEP20: transfer to the zero address");
        require(amount > 0, "BEP20: Transfer amount must be greater than zero");

        // swap and liquify
        swapAndLiquify(from, to);

        //indicates if fee should be deducted from transfer
        bool takeFee = true;

        //if any account belongs to _isExcludedFromFee account then remove the fee
        if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
            takeFee = false;
        }
        if (!takeFee) {
            removeAllFee();
        }
        // buying handler
        else if (from == DEXPair || from == DEXPair2) {
            setBuyFee();
        }
        // selling handler
        else if (to == DEXPair || to == DEXPair2) {
            if (from != owner()) {
                require(tradingOpen, "Trading is not enabled yet");
            }
            setSellFee();
        }
        // normal transaction handler
        else {
            setNormalFee();
        }

        //transfer amount, it will take tax, burn, liquidity fee
        _tokenTransfer(from, to, amount);
    }

    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        if (_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferFromExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
            _transferToExcluded(sender, recipient, amount);
        } else if (_isExcluded[sender] && _isExcluded[recipient]) {
            _transferBothExcluded(sender, recipient, amount);
        } else {
            _transferStandard(sender, recipient, amount);
        }
    }

    function _transferStandard(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        uint256 currentRate = _getRate();
        uint256 tTransferAmount = tAmount - (totalFeePerTx(tAmount));
        uint256 rAmount = tAmount * (currentRate);
        uint256 rTransferAmount = rAmount -
            (totalFeePerTx(tAmount) * (currentRate));
        _rOwned[sender] = _rOwned[sender] - (rAmount);
        _rOwned[recipient] = _rOwned[recipient] + (rTransferAmount);
        if (_currentLiquidityFee > 0) {
            _takeLiquidityPoolFee(tAmount, currentRate);
        }
        if (_currentRedistributionFee > 0) {
            _reflectFee(tAmount);
        }
        if (_currentmarketingwalletFee > 0) {
            _takeMarketFee(tAmount, currentRate);
        }
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferToExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        uint256 currentRate = _getRate();
        uint256 tTransferAmount = tAmount - (totalFeePerTx(tAmount));
        uint256 rAmount = tAmount * (currentRate);
        uint256 rTransferAmount = rAmount -
            (totalFeePerTx(tAmount) * (currentRate));
        _rOwned[sender] = _rOwned[sender] - (rAmount);
        _tOwned[recipient] = _tOwned[recipient] + (tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient] + (rTransferAmount);
        if (_currentLiquidityFee > 0) {
            _takeLiquidityPoolFee(tAmount, currentRate);
        }
        if (_currentRedistributionFee > 0) {
            _reflectFee(tAmount);
        }
        if (_currentmarketingwalletFee > 0) {
            _takeMarketFee(tAmount, currentRate);
        }
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferFromExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        uint256 currentRate = _getRate();
        uint256 tTransferAmount = tAmount - (totalFeePerTx(tAmount));
        uint256 rAmount = tAmount * (currentRate);
        uint256 rTransferAmount = rAmount -
            (totalFeePerTx(tAmount) * (currentRate));
        _tOwned[sender] = _tOwned[sender] - (tAmount);
        _rOwned[sender] = _rOwned[sender] - (rAmount);
        _rOwned[recipient] = _rOwned[recipient] + (rTransferAmount);
        if (_currentLiquidityFee > 0) {
            _takeLiquidityPoolFee(tAmount, currentRate);
        }
        if (_currentRedistributionFee > 0) {
            _reflectFee(tAmount);
        }
        if (_currentmarketingwalletFee > 0) {
            _takeMarketFee(tAmount, currentRate);
        }
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferBothExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        uint256 currentRate = _getRate();
        uint256 tTransferAmount = tAmount - (totalFeePerTx(tAmount));
        uint256 rAmount = tAmount * (currentRate);
        uint256 rTransferAmount = rAmount -
            (totalFeePerTx(tAmount) * (currentRate));
        _tOwned[sender] = _tOwned[sender] - (tAmount);
        _rOwned[sender] = _rOwned[sender] - (rAmount);
        _tOwned[recipient] = _tOwned[recipient] + (tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient] + (rTransferAmount);
        if (_currentLiquidityFee > 0) {
            _takeLiquidityPoolFee(tAmount, currentRate);
        }
        if (_currentRedistributionFee > 0) {
            _reflectFee(tAmount);
        }
        if (_currentmarketingwalletFee > 0) {
            _takeMarketFee(tAmount, currentRate);
        }
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function swapAndLiquify(address from, address to) private {
        // is the token balance of this contract address over the min number of
        // tokens that we need to initiate a swap + liquidity lock?
        // also, don't get caught in a circular liquidity event.
        // also, don't swap & liquify if sender is DEX pair.
        uint256 contractTokenBalance = balanceOf(address(this));

        bool shouldSell = contractTokenBalance >= minTokenNumberToSell;

        if (
            !inSwapAndLiquify &&
            shouldSell &&
            from != DEXPair &&
            swapAndLiquifyEnabled &&
            !(from == address(this) &&
                (to == address(DEXPair) || to == address(DEXPair2))) // swap 1 time
        ) {
            // only sell for minTokenNumberToSell, decouple from _maxTxAmount
            // split the contract balance into 4 pieces

            contractTokenBalance = minTokenNumberToSell;
            // approve contract
            _approve(address(this), address(DEXRouter), contractTokenBalance);

            // add liquidity
            // split the contract balance into 2 pieces

            uint256 otherPiece = contractTokenBalance / (2);
            uint256 tokenAmountToBeSwapped = contractTokenBalance -
                (otherPiece);

            uint256 initialBalance = address(this).balance;

            // now is to lock into staking pool
            Utils.swapTokensForEth(address(DEXRouter), tokenAmountToBeSwapped);

            // how much BNB did we just swap into?

            // capture the contract's current BNB balance.
            // this is so that we can capture exactly the amount of BNB that the
            // swap creates, and not make the liquidity event include any BNB that
            // has been manually sent to the contract

            uint256 bnbToBeAddedToLiquidity = address(this).balance -
                (initialBalance);

            // add liquidity to DEX
            Utils.addLiquidity(
                address(DEXRouter),
                owner(),
                otherPiece,
                bnbToBeAddedToLiquidity
            );

            emit SwapAndLiquify(
                tokenAmountToBeSwapped,
                bnbToBeAddedToLiquidity,
                otherPiece
            );
        }
    }
}

library Utils {
    function swapTokensForEth(address routerAddress, uint256 tokenAmount)
        internal
    {
        IDEXRouter02 DEXRouter = IDEXRouter02(routerAddress);

        // generate the DEX pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = DEXRouter.WETH();

        // make the swap
        DEXRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of BNB
            path,
            address(this),
            block.timestamp + 300
        );
    }

    function swapETHForTokens(
        address routerAddress,
        address recipient,
        uint256 ethAmount
    ) internal {
        IDEXRouter02 DEXRouter = IDEXRouter02(routerAddress);

        // generate the DEX pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = DEXRouter.WETH();
        path[1] = address(this);

        // make the swap
        DEXRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{
            value: ethAmount
        }(
            0, // accept any amount of BNB
            path,
            address(recipient),
            block.timestamp + 300
        );
    }

    function addLiquidity(
        address routerAddress,
        address owner,
        uint256 tokenAmount,
        uint256 ethAmount
    ) internal {
        IDEXRouter02 DEXRouter = IDEXRouter02(routerAddress);

        // add the liquidity
        DEXRouter.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner,
            block.timestamp + 300
        );
    }
}