const MaxNumShareHoldersTokenMock = artifacts.require('MaxNumShareHoldersTokenMock')

contract('MaxNumShareholdersToken', ([owner, sh2, sh3, sh4, ...accounts]) => {
  const initialAccount = owner
  const transferValue = '100000000000000000'
  const initialBalance = '100000000000000000000'
  const maxNumShareholders = '3' // shareholders maximum

  let token
  let tokenTotalSupply
  let sender = owner
  let SUCCESS_CODE;
  let SUCCESS_MESSAGE;
  let MAX_NUM_SHAREHOLDERS_CODE;
  let MAX_NUM_SHAREHOLDERS_ERROR;
  before(async () => {
    token = await MaxNumShareHoldersTokenMock.new(initialAccount, initialBalance, maxNumShareholders)
    SUCCESS_CODE = await token.SUCCESS_CODE()
    SUCCESS_MESSAGE = await token.SUCCESS_MESSAGE()
    MAX_NUM_SHAREHOLDERS_CODE = await token.MAX_NUM_SHAREHOLDERS_CODE()
    MAX_NUM_SHAREHOLDERS_ERROR = await token.MAX_NUM_SHAREHOLDERS_ERROR()
  })

  let numShareholders
  beforeEach(async () => {
    numShareholders = await token.numShareholders()
  })

  it('should allow for shareholders to be added via transfer', async () => {
    const code = await token.detectTransferRestriction(sender, sh2, transferValue)
    const message = await token.messageForTransferRestriction(code)
    await token.transfer(sh2, transferValue, { from: sender });
    numShareholders = await token.numShareholders()
    expect(numShareholders.eq(2))
    await token.transfer(sh3, transferValue, { from: sender });
    expect(numShareholders.eq(3))
  })

  it('should allow for shareholders to be replaced via full account transfer', async () => {
    await token.transfer(sh4, transferValue, { from: sh3 });
    numShareholders = await token.numShareholders()
    expect(numShareholders.eq(3))
  })

  it('should revert if transfer adds a shareholder above the maximum', async () => {
    let revertedTransfer = false
    try {
      await token.transfer(sh3, transferValue, { from: sender })
    } catch (err) {
      revertedTransfer = true
    }
    numShareholders = await token.numShareholders()
    
    expect(revertedTransfer)
    expect(numShareholders.eq(3))
  })

  it('should allow owner to increase the max number of shareholders', async () => {
    await token.changeMaxNumShareholders(4)
    await token.transfer(sh3, transferValue, { from: sender })

    expect(numShareholders.eq(4))
  })
})