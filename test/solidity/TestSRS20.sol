pragma solidity ^0.4.24;
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/mocks/SRS20Mock.sol";

contract TestSRS20 {
    function testInitialBalanceUsingDeployedSRS20Mock() public {
        uint expected = 100000000000000000000;
        SRS20Mock mockToken = SRS20Mock(DeployedAddresses.SRS20Mock());

        Assert.equal(
          expected,
          mockToken.balanceOf(tx.origin),
          "Owner should have total supply of tokens initally"
        );
    }

    function testInitialBalanceWithNewSRS20Mock() public {
        uint initialBalance = 100000000000000000000;
        SRS20Mock mockToken = new SRS20Mock(tx.origin, initialBalance);

        Assert.equal(
          initialBalance,
          mockToken.balanceOf(tx.origin),
          "Owner should have total supply of tokens initally"
        );
    }
}