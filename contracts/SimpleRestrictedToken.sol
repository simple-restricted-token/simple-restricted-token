pragma solidity 0.4.24;

import "zeppelin-solidity/contracts/tokens/ERC20/StandardToken.sol";

contract SimpleRestrictedToken is StandardToken {
    mapping (uint => string) public restrictions;
    
    constructor () public {
        restrictions[0] = 'SUCCESS';
    }
    
    function detectTransferRestriction (address to, address from, uint value)
        public
        constant
        returns (uint restrictionCode)
    {
        restrictionCode = 0;
    }
    
    function transfer (address to, uint value)
        public
        returns (bool success)
    {
        require(detectTransferRestriction(to, msg.sender, value) == 0);
        success = super.transfer(to, value);
    }

    function transferFrom (address to, address from, uint value)
        public
        returns (bool success)
    {
        require(detectTransferRestriction(to, from, value) == 0);
        success = super.transferFrom(to, from, value);
    }
}