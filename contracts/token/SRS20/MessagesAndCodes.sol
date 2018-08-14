pragma solidity ^0.4.24;

library MessagesAndCodes {
    struct Data {
        mapping (uint8 => string) messages;
        uint8[] codes;
    }

    function messageIsEmpty (string _message)
        internal
        pure
        returns (bool isEmpty)
    {
        isEmpty = bytes(_message).length == 0;
    }

    function messageExists (Data storage self, uint8 _code)
        internal
        view
        returns (bool exists)
    {
        exists = bytes(self.messages[_code]).length > 0;
    }

    function addMessage (Data storage self, uint8 _code, string _message)
        public
        returns (uint8 code)
    {
        require(!messageIsEmpty(_message), "Message is empty");
        require(!messageExists(self, _code), "Code already points to a message");

        // enter message at code and push code onto storage
        self.messages[_code] = _message;
        self.codes.push(_code);
        code = _code;
    }

    function removeMessage (Data storage self, uint8 _code)
        public
        returns (uint8 code)
    {
        require(messageExists(self, _code), "Code does not point to a message");

        // find index of code
        uint8 indexOfCode = 0;
        while (self.codes[indexOfCode] != _code) {
            indexOfCode++;
        }

        // remove code from storage by shifting codes in array
        for (uint8 i = indexOfCode; i < self.codes.length - 1; i++) {
            self.codes[i] = self.codes[i + 1];
        }
        self.codes.length--;

        // remove message from storage
        self.messages[_code] = "";
        code = _code;
    }

    function updateMessage (Data storage self, uint8 _code, string _message)
        public
        returns (uint8 code)
    {
        require(!messageIsEmpty(_message), "Message is empty");
        require(messageExists(self, _code), "Code does not point to a message");

        // update message at code
        self.messages[_code] = _message;
        code = _code;
    }
}