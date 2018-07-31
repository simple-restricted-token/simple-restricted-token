pragma solidity ^0.4.24;
import "./Managed.sol";

contract ManagedWhitelist is Managed {
    mapping (address => bool) public sendAllowed;
    mapping (address => bool) public receiveAllowed;

    modifier onlySendAllowed {
        require(sendAllowed[msg.sender]);
        _;
    }

    modifier onlyReceiveAllowed {
        require(receiveAllowed[msg.sender]);
        _;
    }

    function addToSendAllowed (address operator) public onlyManagerOrOwner {
        sendAllowed[operator] = true;
    }

    function addToReceiveAllowed (address operator) public onlyManagerOrOwner {
        receiveAllowed[operator] = true;
    }

    function addToBothSendAndReceiveAllowed (address operator) public onlyManagerOrOwner {
        addToSendAllowed(operator);
        addToReceiveAllowed(operator);
    }

    function removeFromSendAllowed (address operator) public onlyManagerOrOwner {
        sendAllowed[operator] = false;
    }

    function removeFromReceiveAllowed (address operator) public onlyManagerOrOwner {
        receiveAllowed[operator] = false;
    }

    function removeFromBothSendAndReceiveAllowed (address operator) public onlyManagerOrOwner {
        removeFromSendAllowed(operator);
        removeFromReceiveAllowed(operator);
    }
}