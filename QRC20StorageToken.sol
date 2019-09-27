pragma solidity ^0.4.18;

/* taking ideas from FirstBlood token */
contract SafeMath {

    function SafeMath() {
    }

    function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
        uint256 z = _x + _y;
        assert(z >= _x);
        return z;
    }

    function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
        assert(_x >= _y);
        return _x - _y;
    }

    function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
        uint256 z = _x * _y;
        assert(_x == 0 || z / _x == _y);
        return z;
    }

}

/**
    QRC20StorageToken Standard Token implementation
*/
contract QRC20StorageToken is SafeMath {
    string public constant standard = 'Token 0.1';
    uint8 public constant decimals = 8; // it's recommended to set decimals to 8 in QTUM

    // you need change the following three values
    // string public constant name = 'QRC TEST';
    string public name;
    // string public constant symbol = 'QTC';
    string public symbol;
    //Default assumes totalSupply can't be over max (2^256 - 1).
    //you need multiply 10^decimals by your real total supply.
    // uint256 public totalSupply = 10**9 * 10**uint256(decimals);
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    mapping (uint256 => mapping(uint256 => uint256)) data;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function QRC20StorageToken(string _symbol, string _name, uint _initTotalSupply) public {
        name = _name;
        symbol = _symbol;
        totalSupply = _initTotalSupply * 10**uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    // validates an address - currently only checks that it isn't null
    modifier validAddress(address _address) {
        require(_address != 0x0);
        _;
    }

    function transfer(address _to, uint256 _value)
    public
    validAddress(_to)
    returns (bool success)
    {
        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
        balanceOf[_to] = safeAdd(balanceOf[_to], _value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value)
    public
    validAddress(_from)
    validAddress(_to)
    returns (bool success)
    {
        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
        balanceOf[_from] = safeSub(balanceOf[_from], _value);
        balanceOf[_to] = safeAdd(balanceOf[_to], _value);
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value)
    public
    validAddress(_spender)
    returns (bool success)
    {
        // To change the approve amount you first have to reduce the addresses`
        //  allowance to zero by calling `approve(_spender, 0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        require(_value == 0 || allowance[msg.sender][_spender] == 0);
        allowance[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    // disable pay QTUM to this contract
    function () public payable {
        revert();
    }

    function setData(uint256 key, 
                    uint256 value1, uint256 value2, uint256 value3, uint256 value4, 
                    uint256 value5, uint256 value6, uint256 value7, uint256 value8, 
                    uint256 value9, uint256 value10, uint256 value11
                    ) public returns (bool) {
        
        data[key][0] = value1; data[key][1] = value2;
        data[key][2] = value3; data[key][3] = value4;
        data[key][4] = value5; data[key][5] = value6;
        data[key][6] = value7; data[key][7] = value8;
        data[key][8] = value9; data[key][9] = value10;
        data[key][10] = value11; 
        
        return true;
    }
    
    function getData(uint256 key) public returns (uint256[11]) {
        
        uint256[11] memory array = [data[key][0], data[key][1], data[key][2], data[key][3], 
                                    data[key][4], data[key][5], data[key][6], data[key][7], 
                                    data[key][8], data[key][9], data[key][10]];
        return array;
    }
}