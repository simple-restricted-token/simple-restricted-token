pragma solidity ^0.4.24;

library MessagesAndCodes {
    struct Data {
        mapping (uint => string) messages;
        uint[] codes;
    }

    function messages (Data storage self, uint _code)
        public
        pure
        returns (string message)
    {
        message = self[_code];
    } 

    function codes (Data storage self)
        public
        pure
        returns (uint[] codes)
    {
        codes = self.codes
    }

    function addMessage (Data storage self, uint _code, string _message)
        public
        returns (uint code)
    {
        require(_message.length > 0); // new message being passed
        require(self.messages[_code].length == 0); // message not set for code
        self.messages[_code] = message;
        self.codes.push(_code);
        code = _code;
    }

    function removeMessage (Data storage self, uint _code)
        public
        returns (uint code)
    {
        require(self.messages[_code].length > 0); // message for code exists
        
        // find index of code
        uint indexOfCode = 0;
        while (self.codes[indexOfCode] != _code) {
            indexOfCode++;
        }
        
        // remove code from storage by shifting codes in array
        for (uint i = indexOfCode; i < self.codes.length - 1; i++){
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
      require(_message.length > 0); // new message being passed
      require(self.messages[_code].length > 0); // message for code exists
      self.messages[_code] = _message;
      code = _code;
  }
}