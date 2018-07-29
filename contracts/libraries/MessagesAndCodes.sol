pragma solidity ^0.4.24;

library MessagesAndCodes {
    struct Data {
        mapping (uint => string) messages;
        uint[] codes;
    }

    function messageIsEmpty (string _message)
        internal
        pure
        returns (bool isEmpty)
    {
        isEmpty = bytes(_message).length == 0;
    }

    function messageExists (Data storage self, uint _code)
        internal
        view
        returns (bool exists)
    {
        exists = bytes(self.messages[_code]).length > 0;
    }

    function addMessage (Data storage self, uint _code, string _message)
        public
        returns (uint code)
    {
        require(!messageIsEmpty(_message));
        require(!messageExists(self, _code));

        // enter message at code and push code onto storage
        self.messages[_code] = _message;
        self.codes.push(_code);
        code = _code;
    }

    function removeMessage (Data storage self, uint _code)
        public
        returns (uint code)
    {
        require(messageExists(self, _code));

        // find index of code
        uint indexOfCode = 0;
        while (self.codes[indexOfCode] != _code) {
            indexOfCode++;
        }

        // remove code from storage by shifting codes in array
        for (uint i = indexOfCode; i < self.codes.length - 1; i++) {
            self.codes[i] = self.codes[i + 1];
        }
        self.codes.length--;

        // remove message from storage
        self.messages[_code] = "";
        code = _code;
    }

    function updateMessage (Data storage self, uint _code, string _message)
        public
        returns (uint code)
    {
        require(!messageIsEmpty(_message));
        require(messageExists(self, _code));

        // update message at code
        self.messages[_code] = _message;
        code = _code;
    }
}